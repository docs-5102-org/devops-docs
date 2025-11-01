---
title: MySQL 启动命令大全
category:
  - Linux
  - 软件安装与包管理
tag:
  - MySql
  - 启动命令大全
date: 2022-09-21

---

# MySQL 启动命令大全

## CentOS / RHEL 系统

### CentOS 6 / RHEL 6（SysVinit）
```bash
# 启动
service mysqld start

# 停止
service mysqld stop

# 重启
service mysqld restart

# 查看状态
service mysqld status

# 开机自启
chkconfig mysqld on
chkconfig mysqld off
```

### CentOS 7/8/9 / RHEL 7/8/9（Systemd）
```bash
# 启动
systemctl start mysqld

# 停止
systemctl stop mysqld

# 重启
systemctl restart mysqld

# 查看状态
systemctl status mysqld

# 重新加载配置
systemctl reload mysqld

# 开机自启
systemctl enable mysqld
systemctl disable mysqld

# 查看是否开机自启
systemctl is-enabled mysqld
```

## Ubuntu / Debian 系统

### Ubuntu 14.04 及更早版本（Upstart/SysVinit）
```bash
# 启动
service mysql start
# 或
/etc/init.d/mysql start

# 停止
service mysql stop
# 或
/etc/init.d/mysql stop

# 重启
service mysql restart
# 或
/etc/init.d/mysql restart

# 查看状态
service mysql status

# 开机自启
update-rc.d mysql defaults
update-rc.d mysql remove
```

### Ubuntu 16.04+ / Debian 8+（Systemd）
```bash
# 启动
systemctl start mysql
# 或
sudo service mysql start

# 停止
systemctl stop mysql

# 重启
systemctl restart mysql

# 查看状态
systemctl status mysql

# 重新加载配置
systemctl reload mysql

# 开机自启
systemctl enable mysql
systemctl disable mysql
```

## Docker 容器

### Docker 命令
```bash
# 启动容器
docker start mysql容器名

# 停止容器
docker stop mysql容器名

# 重启容器
docker restart mysql容器名

# 查看容器状态
docker ps -a | grep mysql

# 查看容器日志
docker logs mysql容器名

# 进入容器
docker exec -it mysql容器名 bash

# 在容器内重启 MySQL 服务（如果是 systemd）
docker exec mysql容器名 systemctl restart mysqld
```

### Docker Compose
```bash
# 启动
docker-compose start mysql
# 或启动所有服务
docker-compose up -d

# 停止
docker-compose stop mysql

# 重启
docker-compose restart mysql

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f mysql
```

## macOS 系统

### Homebrew 安装的 MySQL
```bash
# 启动
brew services start mysql

# 停止
brew services stop mysql

# 重启
brew services restart mysql

# 查看状态
brew services list

# 手动启动（前台运行）
mysql.server start
mysql.server stop
mysql.server restart
mysql.server status
```

### 原生 MySQL 安装
```bash
# 使用系统偏好设置中的 MySQL 面板
# 或命令行：
sudo /usr/local/mysql/support-files/mysql.server start
sudo /usr/local/mysql/support-files/mysql.server stop
sudo /usr/local/mysql/support-files/mysql.server restart
```

## Windows 系统

### Windows 服务管理
```cmd
# 启动（以管理员权限运行）
net start MySQL80

# 停止
net stop MySQL80

# 重启（需要先停止再启动）
net stop MySQL80 && net start MySQL80

# 查看服务状态
sc query MySQL80
```

### Windows 服务管理器
```
1. Win + R，输入 services.msc
2. 找到 MySQL 服务
3. 右键选择启动/停止/重启
```

### PowerShell
```powershell
# 启动
Start-Service MySQL80

# 停止
Stop-Service MySQL80

# 重启
Restart-Service MySQL80

# 查看状态
Get-Service MySQL80

# 设置开机自启
Set-Service MySQL80 -StartupType Automatic
Set-Service MySQL80 -StartupType Manual
Set-Service MySQL80 -StartupType Disabled
```

## Alpine Linux

### OpenRC（Alpine 使用的 init 系统）
```bash
# 启动
rc-service mysql start

# 停止
rc-service mysql stop

# 重启
rc-service mysql restart

# 查看状态
rc-service mysql status

# 开机自启
rc-update add mysql default
rc-update del mysql default
```

## FreeBSD

```bash
# 启动
service mysql-server start

# 停止
service mysql-server stop

# 重启
service mysql-server restart

# 查看状态
service mysql-server status

# 开机自启（编辑 /etc/rc.conf）
echo 'mysql_enable="YES"' >> /etc/rc.conf
```

## 直接使用 MySQL 二进制文件

### 手动启动（适用于所有系统）
```bash
# 启动 MySQL 服务器
mysqld --user=mysql &

# 使用指定配置文件启动
mysqld --defaults-file=/etc/my.cnf --user=mysql &

# 安全模式启动（跳过权限验证）
mysqld_safe --skip-grant-tables &

# 关闭 MySQL
mysqladmin -u root -p shutdown

# 检查 MySQL 进程
ps aux | grep mysql
pgrep mysql

# 强制终止 MySQL
pkill mysql
# 或
killall mysql
```

## Kubernetes / K8s

```bash
# 查看 Pod 状态
kubectl get pods -l app=mysql

# 重启 Pod（删除后自动重建）
kubectl delete pod mysql-pod-name

# 进入 Pod
kubectl exec -it mysql-pod-name -- bash

# 在 Pod 内重启 MySQL 服务
kubectl exec mysql-pod-name -- systemctl restart mysqld

# 查看日志
kubectl logs mysql-pod-name -f

# 重启 Deployment
kubectl rollout restart deployment mysql-deployment
```

## 常用检查命令（通用）

```bash
# 检查 MySQL 是否运行
ps aux | grep mysql
pgrep mysql
netstat -tlnp | grep 3306
lsof -i :3306

# 检查 MySQL 监听端口
ss -tlnp | grep 3306

# 测试 MySQL 连接
mysql -u root -p
mysqladmin -u root -p ping
mysqladmin -u root -p status

# 查看 MySQL 错误日志
tail -f /var/log/mysqld.log
tail -f /var/log/mysql/error.log
```

## 注意事项

1. **权限要求**：大多数启动/停止命令需要 root 或 sudo 权限
2. **服务名称**：不同发行版 MySQL 服务名可能不同（mysql、mysqld、mysql80 等）
3. **配置文件**：确认配置文件路径正确（/etc/my.cnf、/etc/mysql/my.cnf 等）
4. **端口占用**：确保 3306 端口未被占用
5. **数据目录权限**：确保 MySQL 用户对数据目录有读写权限