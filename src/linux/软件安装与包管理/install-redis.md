---
title: Redis 安装与配置
category:
  - Linux
  - 软件安装与包管理
tag:
  - redis
  - 数据库
  - 缓存
date: 2022-09-22
update: 2025-10-14
---

# Redis 安装与配置

## 一、安装参考教程

### 官方文档
- [Redis 官方文档](https://redis.io/docs/getting-started/)
- [Redis 中文网](http://www.redis.cn/)

### 第三方教程
- [菜鸟教程 - Redis 安装](https://www.runoob.com/redis/redis-install.html)
- [Windows 下安装 Redis 服务](https://www.cnblogs.com/xuzhiwei/p/4569315.html)

## 二、Linux 系统安装

### 2.1 通过源码编译安装

#### 下载并解压
```bash
# 下载 Redis 源码包
cd /usr/local/src
wget https://download.redis.io/releases/redis-7.0.12.tar.gz

# 解压
tar -zxvf redis-7.0.12.tar.gz
cd redis-7.0.12
```

#### 编译安装
```bash
# 编译
make

# 安装到指定目录
make PREFIX=/usr/local/redis install

# 复制配置文件
cp redis.conf /usr/local/redis/
```

#### 环境配置
```bash
# 添加环境变量（可选）
echo 'export PATH=$PATH:/usr/local/redis/bin' >> /etc/profile
source /etc/profile
```

### 2.2 通过 yum/apt 安装

**CentOS/RedHat:**
```bash
yum install redis -y
```

**Ubuntu/Debian:**
```bash
apt-get update
apt-get install redis-server -y
```

## 三、Windows 系统安装

### 3.1 下载安装包
- 访问 [Redis Windows 版本](https://github.com/tporadowski/redis/releases)
- 下载最新的 `.zip` 或 `.msi` 安装包

### 3.2 安装步骤
1. 解压到指定目录，如：`D:\Program Files\Redis`
2. 以管理员身份运行命令提示符
3. 进入 Redis 安装目录

### 3.3 注册为 Windows 服务
```cmd
redis-server.exe --service-install redis.windows.conf --loglevel verbose
```

### 3.4 启动/停止服务
```cmd
# 启动服务
redis-server.exe --service-start

# 停止服务
redis-server.exe --service-stop

# 卸载服务
redis-server.exe --service-uninstall
```

## 四、配置说明

### 4.1 项目环境配置

**安装目录：** `/usr/local/redis`

**配置文件：** `/usr/local/redis/redis.conf`

**主要配置项：**
```conf
# 绑定地址（0.0.0.0 允许远程访问）
bind 0.0.0.0

# 端口
port 6278

# 密码
requirepass vHlvVgq9Za

# 后台运行
daemonize yes

# 日志文件
logfile "/usr/local/redis/redis.log"

# 数据目录
dir /usr/local/redis/data

# RDB 持久化
save 900 1
save 300 10
save 60 10000

# AOF 持久化
appendonly yes
appendfilename "appendonly.aof"
```

### 4.2 安全配置建议

```conf
# 设置复杂密码
requirepass your_strong_password_here

# 禁用危险命令
rename-command FLUSHALL ""
rename-command FLUSHDB ""
rename-command CONFIG ""
rename-command KEYS ""

# 限制最大内存
maxmemory 2gb
maxmemory-policy allkeys-lru
```

## 五、常用命令

### 5.1 服务管理

```bash
# 启动 Redis 服务（前台运行）
redis-server /usr/local/redis/redis.conf

# 启动 Redis 服务（后台运行）
redis-server /usr/local/redis/redis.conf &

# 查看 Redis 进程
ps -ef | grep redis

# 停止 Redis 服务
redis-cli -p 6278 -a vHlvVgq9Za shutdown

# 或使用 kill 命令
kill -9 $(ps -ef | grep redis-server | grep -v grep | awk '{print $2}')
```

### 5.2 客户端连接

```bash
# 本地连接（默认端口 6379）
redis-cli

# 指定端口连接
redis-cli -p 6278

# 指定主机和端口
redis-cli -h 127.0.0.1 -p 6278

# 带密码连接
redis-cli -p 6278 -a vHlvVgq9Za

# 或连接后认证
redis-cli -p 6278
AUTH vHlvVgq9Za
```

### 5.3 基本操作命令

```bash
# 测试连接
PING

# 查看服务信息
INFO

# 查看所有键（慎用，生产环境数据量大时会卡）
KEYS *

# 扫描键（推荐）
SCAN 0 MATCH user:* COUNT 100

# 设置键值
SET key value

# 获取值
GET key

# 删除键
DEL key

# 检查键是否存在
EXISTS key

# 设置过期时间（秒）
EXPIRE key 3600

# 查看剩余过期时间
TTL key

# 选择数据库（0-15）
SELECT 0

# 清空当前数据库
FLUSHDB

# 清空所有数据库
FLUSHALL
```

### 5.4 性能测试

```bash
# 基准测试
redis-benchmark -h 127.0.0.1 -p 6278 -a vHlvVgq9Za -c 100 -n 100000

# 测试特定命令
redis-benchmark -h 127.0.0.1 -p 6278 -a vHlvVgq9Za -t set,get -n 100000
```

## 六、开机自启动

### 6.1 使用 systemd（推荐）

创建服务文件：
```bash
vim /etc/systemd/system/redis.service
```

添加以下内容：
```ini
[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/redis/bin/redis-server /usr/local/redis/redis.conf
ExecStop=/usr/local/redis/bin/redis-cli -p 6278 -a vHlvVgq9Za shutdown
Restart=always
User=root

[Install]
WantedBy=multi-user.target
```

启用服务：
```bash
# 重新加载 systemd
systemctl daemon-reload

# 启动服务
systemctl start redis

# 开机自启
systemctl enable redis

# 查看状态
systemctl status redis
```

### 6.2 使用 rc.local

```bash
# 编辑 rc.local
vim /etc/rc.local

# 添加启动命令
/usr/local/redis/bin/redis-server /usr/local/redis/redis.conf &

# 赋予执行权限
chmod +x /etc/rc.local
```

## 七、常见问题

### 7.1 Windows 中文乱码问题

**问题描述：** 使用 `redis-cli` 时中文显示为乱码

**解决方案：**
```cmd
# 1. 使用 --raw 参数
redis-cli -p 6278 -a vHlvVgq9Za --raw

# 2. 设置 CMD 编码为 UTF-8
chcp 65001

# 3. 修改 CMD 字体
# 在命令行标题栏右键 -> 属性 -> 字体
# 选择 "Lucida Console" 或 "新宋体"
```

### 7.2 连接被拒绝

**可能原因：**
1. Redis 未启动
2. 防火墙阻止端口
3. bind 配置仅允许本地访问

**解决方案：**
```bash
# 检查 Redis 是否运行
ps -ef | grep redis

# 检查端口监听
netstat -tunlp | grep 6278

# 开放防火墙端口
firewall-cmd --zone=public --add-port=6278/tcp --permanent
firewall-cmd --reload

# 或关闭防火墙（不推荐）
systemctl stop firewalld
```

### 7.3 内存不足

**问题描述：** Redis 内存占用过高

**解决方案：**
```bash
# 查看内存使用情况
redis-cli -p 6278 -a vHlvVgq9Za INFO memory

# 设置最大内存限制
CONFIG SET maxmemory 2gb

# 设置内存淘汰策略
CONFIG SET maxmemory-policy allkeys-lru
```

### 7.4 持久化失败

**问题描述：** RDB/AOF 持久化失败

**解决方案：**
```bash
# 检查磁盘空间
df -h

# 检查目录权限
ls -la /usr/local/redis/data

# 修改目录权限
chown -R redis:redis /usr/local/redis/data
chmod -R 755 /usr/local/redis/data
```

## 八、性能优化建议

### 8.1 系统参数优化

```bash
# 编辑 sysctl.conf
vim /etc/sysctl.conf

# 添加以下配置
vm.overcommit_memory = 1
net.core.somaxconn = 65535
vm.swappiness = 0

# 使配置生效
sysctl -p
```

### 8.2 透明大页关闭

```bash
# 临时关闭
echo never > /sys/kernel/mm/transparent_hugepage/enabled

# 永久关闭（添加到 rc.local）
echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >> /etc/rc.local
```

### 8.3 文件描述符限制

```bash
# 编辑 limits.conf
vim /etc/security/limits.conf

# 添加配置
* soft nofile 65535
* hard nofile 65535
```

## 九、监控与维护

### 9.1 监控命令

```bash
# 实时监控
redis-cli -p 6278 -a vHlvVgq9Za --stat

# 查看慢查询日志
SLOWLOG GET 10

# 查看客户端连接
CLIENT LIST

# 查看键空间统计
INFO keyspace
```

### 9.2 数据备份

```bash
# 手动触发 RDB 快照
redis-cli -p 6278 -a vHlvVgq9Za BGSAVE

# 备份脚本示例
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/backup/redis
mkdir -p $BACKUP_DIR
cp /usr/local/redis/data/dump.rdb $BACKUP_DIR/dump_$DATE.rdb
# 保留最近 7 天的备份
find $BACKUP_DIR -name "dump_*.rdb" -mtime +7 -delete
```

## 十、相关资源

- **Redis 命令参考：** [https://redis.io/commands/](https://redis.io/commands/)
- **Redis 设计与实现：** [http://redisbook.com/](http://redisbook.com/)
- **Redis 官方 GitHub：** [https://github.com/redis/redis](https://github.com/redis/redis)
