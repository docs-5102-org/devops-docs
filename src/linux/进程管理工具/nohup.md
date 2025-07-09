---
title: nohup命令-后台运行程序
category:
  - Linux
  - 命令帮助
tag:
  - nohup
  - 进程管理
  - 后台运行
  - 守护进程
date: 2022-10-06

---

# nohup命令-后台运行程序

## 命令概述

`nohup` 命令来自英文词组 "no hang up" 的缩写，其功能是用于后台运行程序。它可以让程序在用户退出终端后继续运行，忽略挂起信号（SIGHUP）。

## 基本语法

```bash
nohup [参数] [命令] [参数...]
```

## 常用参数

| 参数 | 说明 |
|------|------|
| `--help` | 显示帮助信息 |
| `--version` | 显示版本信息 |

## 核心用法详解

### 1. 基础后台运行

```bash
# 基本用法
nohup command &

# 示例：运行脚本
nohup ./script.sh &
```

### 2. Java 应用后台运行（推荐用法）

```bash
nohup java -jar /path/to/your/app.jar >/dev/null 2>&1 &
```

**命令解析：**
- `nohup`: 忽略挂起信号，让程序在后台持续运行
- `java -jar /path/to/your/app.jar`: 执行 Java 应用
- `>/dev/null`: 将标准输出重定向到 `/dev/null`（"黑洞"设备）
- `2>&1`: 将标准错误重定向到标准输出
- `&`: 在后台运行命令

### 3. 输出重定向详解

#### `/dev/null` - 空设备
`/dev/null` 是一个特殊的虚拟设备文件，类似物理中的黑洞：
- 任何写入的数据都会被丢弃
- 读取时总是返回 EOF
- 常用于丢弃不需要的输出

#### 重定向符号说明
- `>` 或 `1>`: 重定向标准输出（stdout）
- `2>`: 重定向标准错误（stderr）  
- `2>&1`: 将标准错误重定向到标准输出的当前位置

#### 常见重定向组合

```bash
# 1. 保留所有输出到文件
nohup command > output.log 2>&1 &

# 2. 丢弃所有输出（推荐）
nohup command >/dev/null 2>&1 &

# 3. 只保留错误输出
nohup command >/dev/null 2>error.log &

# 4. 分别保存标准输出和错误输出
nohup command >output.log 2>error.log &
```

## 进程管理

### 1. 保存进程 PID

```bash
# 方法一：使用 $! 获取最后一个后台进程的 PID
nohup java -jar app.jar >/dev/null 2>&1 &
echo $! > app_pid.txt

# 方法二：一行命令完成
nohup java -jar app.jar >/dev/null 2>&1 & echo $! > app_pid.txt
```

### 2. 查看和管理进程

```bash
# 查看保存的 PID
cat app_pid.txt

# 检查进程是否还在运行
ps -p `cat app_pid.txt`

# 杀死进程
kill -9 `cat app_pid.txt`

# 或者使用更安全的 TERM 信号
kill -15 `cat app_pid.txt`
```

### 3. 查找相关进程

```bash
# 通过进程名查找
ps aux | grep java
ps aux | grep "app.jar"

# 使用 pgrep 命令
pgrep -f "app.jar"

# 杀死所有匹配的进程
pkill -f "app.jar"
```

## 实际应用场景

### 1. Web 应用部署

```bash
# Spring Boot 应用
nohup java -jar -Xms512m -Xmx1024m app.jar \
  --server.port=8080 \
  --spring.profiles.active=prod \
  >/dev/null 2>&1 &
echo $! > app_pid.txt
```

### 2. 数据处理任务

```bash
# 长时间运行的数据处理脚本
nohup python data_processor.py >/dev/null 2>&1 &
echo $! > processor_pid.txt
```

### 3. 服务监控脚本

```bash
# 监控脚本
nohup ./monitor.sh >monitor.log 2>&1 &
echo $! > monitor_pid.txt
```

## 注意事项与最佳实践

### 1. 输出处理
- **生产环境建议**：使用 `>/dev/null 2>&1` 丢弃输出，避免磁盘空间问题
- **调试环境**：保留日志到文件，便于问题排查
- **注意**：如果不指定输出重定向，默认会在当前目录生成 `nohup.out` 文件

### 2. 进程管理
- 始终保存进程 PID 到文件，便于后续管理
- 使用有意义的 PID 文件名，如 `app_name_pid.txt`
- 定期检查和清理僵死进程

### 3. 权限和安全
- 确保有足够的权限执行命令
- 注意文件路径的权限设置
- 避免在 root 权限下运行不必要的程序

### 4. 监控和日志
```bash
# 创建带时间戳的日志文件
LOG_FILE="app_$(date +%Y%m%d_%H%M%S).log"
nohup java -jar app.jar > $LOG_FILE 2>&1 &
echo $! > app_pid.txt
```

## 故障排查

### 1. 常见问题

**问题：程序没有在后台运行**
```bash
# 检查是否正确使用了 & 符号
nohup command &  # 正确
nohup command    # 错误：缺少 &
```

**问题：找不到 nohup.out 文件**
```bash
# 检查当前目录权限
ls -la nohup.out
# 或者明确指定输出文件
nohup command > my_output.log 2>&1 &
```

### 2. 进程查看

```bash
# 查看所有 nohup 相关进程
ps aux | grep nohup

# 查看特定用户的后台进程
ps -u username

# 查看进程树
pstree -p
```

## 替代方案

对于更复杂的后台任务管理，可以考虑：

1. **systemd** (现代 Linux 发行版)
2. **screen** 或 **tmux** (终端多路复用)
3. **supervisor** (Python 进程管理工具)
4. **pm2** (Node.js 进程管理工具)

## 总结

`nohup` 是一个简单而强大的后台运行工具，特别适合：
- 简单的后台任务
- 服务器应用部署
- 长时间运行的脚本
- 临时的后台处理任务

通过合理使用输出重定向和进程管理，可以有效地控制和监控后台运行的程序。
