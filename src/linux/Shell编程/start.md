---
title: Linux系统启动脚本详解
category:
  - Linux
  - Shell编程
tag:
  - rc.local
  - rc.d
  - 启动脚本
  - systemd
date: 2022-07-16

---

# Linux系统启动脚本：/etc/rc.local 与 /etc/rc.d/ 详解

## 概述

在Linux系统中，`/etc/rc.local` 和 `/etc/rc.d/` 都是用于管理系统启动时执行脚本的重要组件，但它们在功能、使用场景和管理方式上存在显著差异。

## /etc/rc.local 详解

### 基本概念
`/etc/rc.local` 是一个传统的系统启动脚本，在系统启动过程的最后阶段执行，通常用于运行用户自定义的启动命令。

### 特点
- **执行时机**：在所有系统服务启动完成后执行
- **执行权限**：以root用户身份执行
- **简单易用**：直接编辑文件即可添加启动命令
- **单一文件**：所有自定义启动命令集中在一个文件中

### 文件结构示例
```bash
#!/bin/bash
# /etc/rc.local
# 
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.

# 设置系统参数
echo 'never' > /sys/kernel/mm/transparent_hugepage/enabled

# 启动自定义服务
/usr/local/bin/my-service start

# 设置网络参数
echo 1 > /proc/sys/net/ipv4/ip_forward

# 挂载额外的文件系统
mount /dev/sdb1 /mnt/data

# 必须以exit 0结束
exit 0
```

### 使用步骤
```bash
# 1. 编辑rc.local文件
sudo vim /etc/rc.local

# 2. 确保文件有执行权限
sudo chmod +x /etc/rc.local

# 3. 在systemd系统中启用rc.local服务
sudo systemctl enable rc-local.service
```

## /etc/rc.d/ 详解

### 基本概念
`/etc/rc.d/` 是传统SysV init系统的核心目录，包含了不同运行级别的启动脚本和服务管理脚本。

### 目录结构
```
/etc/rc.d/
├── init.d/          # 服务脚本目录
├── rc0.d/           # 运行级别0（关机）
├── rc1.d/           # 运行级别1（单用户模式）
├── rc2.d/           # 运行级别2（多用户模式，无网络）
├── rc3.d/           # 运行级别3（多用户模式，有网络）
├── rc4.d/           # 运行级别4（用户自定义）
├── rc5.d/           # 运行级别5（图形界面模式）
├── rc6.d/           # 运行级别6（重启）
└── rc.local         # 本地启动脚本
```

### 特点
- **分级管理**：根据不同运行级别组织脚本
- **标准化**：遵循统一的服务脚本规范
- **链接管理**：使用符号链接控制服务启动顺序
- **专业化**：适合复杂的服务管理需求

## 核心区别对比

| 特性 | /etc/rc.local | /etc/rc.d/ |
|------|---------------|------------|
| **复杂度** | 简单，直接编辑 | 复杂，需要遵循规范 |
| **管理方式** | 单一文件 | 多目录、多文件 |
| **执行时机** | 系统启动最后阶段 | 根据运行级别分阶段执行 |
| **服务控制** | 无标准化控制 | 支持start/stop/restart等 |
| **启动顺序** | 固定在最后 | 可通过命名控制顺序 |
| **运行级别** | 不区分运行级别 | 严格按运行级别执行 |
| **现代兼容性** | systemd需要额外配置 | 被systemd逐步替代 |

## 实际应用示例

### 示例1：简单的系统配置（使用rc.local）

```bash
#!/bin/bash
# /etc/rc.local - 简单系统配置

# 设置主机名
hostnamectl set-hostname production-server

# 配置防火墙
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# 启动自定义应用
cd /opt/myapp && ./start.sh &

# 设置系统参数
echo 'performance' > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

exit 0
```

### 示例2：专业服务脚本（使用rc.d）

```bash
#!/bin/bash
# /etc/rc.d/init.d/myapp - 专业服务脚本

. /etc/rc.d/init.d/functions

USER="myapp"
DAEMON="myapp"
ROOT_DIR="/opt/myapp"
EXEC_FILE="$ROOT_DIR/bin/myapp"
LOCK_FILE="/var/lock/subsys/myapp"
PID_FILE="/var/run/myapp.pid"

start() {
    if [ -f $LOCK_FILE ]; then
        echo "MyApp is already running."
        return 1
    fi
    
    echo -n "Starting $DAEMON: "
    daemon --user="$USER" --pidfile="$PID_FILE" "$EXEC_FILE"
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch $LOCK_FILE
    return $RETVAL
}

stop() {
    if [ ! -f $LOCK_FILE ]; then
        echo "MyApp is not running."
        return 1
    fi
    
    echo -n "Shutting down $DAEMON: "
    pid=$(ps -aefw | grep "$DAEMON" | grep -v " grep " | awk '{print $2}')
    kill -9 $pid > /dev/null 2>&1
    [ $? -eq 0 ] && echo_success || echo_failure
    echo
    rm -f $LOCK_FILE
    return 0
}

restart() {
    stop
    start
}

status() {
    if [ -f $LOCK_FILE ]; then
        echo "$DAEMON is running."
    else
        echo "$DAEMON is stopped."
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit $?
```

### 示例3：创建服务链接

```bash
#!/bin/bash
# 创建服务启动链接的脚本

SERVICE_NAME="myapp"
INIT_SCRIPT="/etc/rc.d/init.d/$SERVICE_NAME"

# 确保服务脚本存在且可执行
if [ ! -f "$INIT_SCRIPT" ]; then
    echo "错误: 服务脚本 $INIT_SCRIPT 不存在"
    exit 1
fi

chmod +x "$INIT_SCRIPT"

# 创建不同运行级别的链接
# S20 表示启动顺序为20，K80表示关闭顺序为80

ln -sf "$INIT_SCRIPT" "/etc/rc.d/rc3.d/S20$SERVICE_NAME"  # 多用户模式启动
ln -sf "$INIT_SCRIPT" "/etc/rc.d/rc5.d/S20$SERVICE_NAME"  # 图形模式启动
ln -sf "$INIT_SCRIPT" "/etc/rc.d/rc0.d/K80$SERVICE_NAME"  # 关机时停止
ln -sf "$INIT_SCRIPT" "/etc/rc.d/rc1.d/K80$SERVICE_NAME"  # 单用户模式停止
ln -sf "$INIT_SCRIPT" "/etc/rc.d/rc6.d/K80$SERVICE_NAME"  # 重启时停止

echo "服务 $SERVICE_NAME 已成功配置到启动脚本中"
```

## 现代系统中的使用建议

### 在systemd系统中使用rc.local

```bash
# 1. 创建rc.local文件
sudo vim /etc/rc.local

# 2. 添加shebang和内容
#!/bin/bash
# 你的启动命令
exit 0

# 3. 设置执行权限
sudo chmod +x /etc/rc.local

# 4. 创建systemd服务文件
sudo tee /etc/systemd/system/rc-local.service > /dev/null <<EOF
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

# 5. 启用服务
sudo systemctl enable rc-local.service
sudo systemctl start rc-local.service
```

### 迁移到systemd服务

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
User=myapp
ExecStart=/opt/myapp/bin/myapp
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## 最佳实践建议

### 使用rc.local的场景
- 简单的一次性启动任务
- 系统参数设置
- 快速原型和测试
- 传统环境的兼容性需求

### 使用rc.d的场景
- 专业的服务管理
- 需要精确控制启动顺序
- 复杂的依赖关系管理
- 传统SysV init系统

### 现代化建议
- **优先使用systemd**：在现代Linux发行版中优先使用systemd服务
- **避免复杂逻辑**：不要在rc.local中放置复杂的业务逻辑
- **日志管理**：确保启动脚本有适当的日志记录
- **错误处理**：添加适当的错误处理和恢复机制

## 总结

`/etc/rc.local` 适合简单快速的启动任务，而 `/etc/rc.d/` 提供了更专业和规范的服务管理方式。在现代Linux系统中，建议优先使用systemd服务来管理应用程序的启动，同时保留rc.local用于简单的系统配置任务。选择哪种方式取决于你的具体需求、系统环境和管理复杂度要求。
