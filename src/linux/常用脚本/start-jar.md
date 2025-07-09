---
title: jar包开机自启动Shell脚本
category:
  - Linux
  - Shell编程
tag:
  - Shell脚本
  - 参数处理
date: 2022-07-21

---

# Linux下jar包开机自启动Shell脚本配置指南

## 概述

本文档介绍如何通过Shell脚本实现Linux系统下jar包的开机自启动功能，包括脚本编写、配置和验证等完整流程。

## 环境准备

在开始之前，请确保系统已安装Java环境（JDK）。可以通过以下命令验证：

```bash
java -version
javac -version
```

## 脚本编写

### 方法一：完整环境变量配置

创建启动脚本 `MessageForwarding.sh`：

```bash
#!/bin/bash
# jar包开机自启动脚本
# 设置Java环境变量
export JAVA_HOME=/usr/java/jdk1.8.0_112
export JRE_HOME=/usr/java/jdk1.8.0_112/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:.
export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

# 后台启动jar包，并输出日志到指定文件
nohup java -jar /root/java/MessageForwarding.jar > /root/java/message.log 2>&1 &
```

### 方法二：利用系统环境变量（推荐）

```bash
#!/bin/bash
# jar包开机自启动脚本（简化版）
# 前提：系统已配置好Java环境变量

# 切换到jar包所在目录
cd /opt

# 后台启动jar包
nohup java -jar aars.jar > /dev/null 2>&1 &

# 可选：等待几秒确保服务启动
sleep 3

echo "jar包启动完成"
```

### 方法三：Spring Boot应用启动

```bash
#!/bin/bash
# Spring Boot应用启动脚本

# 启动主应用
nohup java -jar artron-ise-1.1.jar --spring.profiles.active=online > /var/log/artron-ise.log 2>&1 &

# 等待主应用启动
sleep 5

# 启动服务应用
nohup java -jar artron-ise-service-1.1.jar --spring.profiles.active=online > /var/log/artron-ise-service.log 2>&1 &

echo "Spring Boot应用启动完成"
```

## 脚本权限设置

为脚本添加执行权限：

```bash
chmod +x MessageForwarding.sh
```

## 开机自启动配置

### 方法一：使用 rc.local

1. 编辑 `/etc/rc.local` 文件：

```bash
sudo vi /etc/rc.local
```

2. 在文件末尾添加脚本路径（在 `exit 0` 之前）：

```bash
#!/bin/bash
# 其他系统启动命令...

# 启动jar包
/root/java/MessageForwarding.sh

exit 0
```

3. 确保 rc.local 文件有执行权限：

```bash
sudo chmod +x /etc/rc.local
```

### 方法二：使用 systemd 服务（推荐）

创建服务文件：

```bash
sudo vi /etc/systemd/system/myapp.service
```

服务文件内容：

```ini
[Unit]
Description=MyApp Java Application
After=network.target

[Service]
Type=forking
User=root
ExecStart=/root/java/MessageForwarding.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

启用服务：

```bash
sudo systemctl enable myapp.service
sudo systemctl start myapp.service
```

## 验证和测试

### 1. 手动测试脚本

```bash
# 执行脚本
./MessageForwarding.sh

# 检查进程是否启动
ps -ef | grep java
```

### 2. 检查服务状态

```bash
# 查看systemd服务状态
sudo systemctl status myapp.service

# 查看服务日志
sudo journalctl -u myapp.service -f
```

### 3. 重启测试

```bash
# 重启系统验证开机自启动
sudo reboot

# 重启后检查进程
ps -ef | grep java
```

## 常见问题解决

### 1. 权限问题

- 确保脚本文件有执行权限
- 确保jar包文件有读取权限
- 检查日志文件目录的写入权限

### 2. 环境变量问题

- 在脚本中显式设置JAVA_HOME
- 使用绝对路径执行java命令
- 检查PATH环境变量是否正确

### 3. 进程管理

停止服务：

```bash
# 使用systemctl停止
sudo systemctl stop myapp.service

# 手动停止进程
pkill -f "java -jar"
```

## 最佳实践

1. **日志管理**：将日志输出到专门的日志文件，便于问题排查
2. **错误处理**：在脚本中添加错误检查和处理逻辑
3. **进程监控**：使用systemd等工具监控进程状态，自动重启异常进程
4. **资源限制**：在生产环境中设置JVM内存参数，避免内存溢出

## 示例完整脚本

```bash
#!/bin/bash
# 生产环境jar包启动脚本

# 设置变量
APP_NAME="MessageForwarding"
APP_PATH="/root/java"
JAR_FILE="$APP_PATH/MessageForwarding.jar"
LOG_FILE="$APP_PATH/logs/app.log"
PID_FILE="$APP_PATH/$APP_NAME.pid"

# 创建日志目录
mkdir -p "$APP_PATH/logs"

# 检查jar文件是否存在
if [ ! -f "$JAR_FILE" ]; then
    echo "错误：jar文件不存在：$JAR_FILE"
    exit 1
fi

# 检查进程是否已存在
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null; then
        echo "应用已在运行，PID：$PID"
        exit 0
    fi
fi

# 启动应用
echo "正在启动 $APP_NAME..."
nohup java -Xms512m -Xmx1024m -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

# 保存PID
echo $! > "$PID_FILE"

echo "$APP_NAME 启动完成，PID：$(cat $PID_FILE)"
```

通过以上配置，您可以实现Linux系统下jar包的可靠开机自启动功能。
