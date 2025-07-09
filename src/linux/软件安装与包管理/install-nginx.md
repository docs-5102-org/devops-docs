---
title: nginx安装-Web服务器部署指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - nginx
  - web服务器
  - 服务部署
date: 2022-09-22

---

# Nginx 安装指南

## 概述

Nginx 是一个高性能的 HTTP 和反向代理服务器。本文档提供了两种主要的安装方式：官方包管理器安装（推荐）和源码编译安装。

## 方式一：使用官方包管理器安装（推荐）

### 1. 系统要求

支持以下 Linux 发行版：
- RHEL/CentOS/Oracle Linux 6+
- Debian 8+
- Ubuntu 16.04+
- SLES 12+
- Alpine 3.8+

### 2. 安装步骤

#### RHEL/CentOS/Oracle Linux

```bash
# 1. 安装必要的包
sudo yum install yum-utils

# 2. 添加 Nginx 官方仓库
sudo tee /etc/yum.repos.d/nginx.repo <<EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

# 3. 安装 Nginx
sudo yum install nginx

# 4. 启动并设置开机自启
sudo systemctl start nginx
sudo systemctl enable nginx
```

#### Debian/Ubuntu

```bash
# 1. 安装必要的包
sudo apt install curl gnupg2 ca-certificates lsb-release

# 2. 添加 Nginx 签名密钥
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

# 3. 添加 Nginx 官方仓库
echo "deb http://nginx.org/packages/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list

# 4. 更新包索引并安装
sudo apt update
sudo apt install nginx

# 5. 启动并设置开机自启
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 3. 验证安装

```bash
# 检查 Nginx 状态
sudo systemctl status nginx

# 检查版本
nginx -v

# 测试配置文件
sudo nginx -t
```

## 方式二：源码编译安装

### 1. 准备工作

#### 安装编译依赖

```bash
# CentOS/RHEL
sudo yum groupinstall "Development Tools"
sudo yum install wget zlib-devel

# Debian/Ubuntu
sudo apt update
sudo apt install build-essential wget zlib1g-dev
```

### 2. 下载并安装 PCRE

PCRE 库用于支持正则表达式和 rewrite 模块。

```bash
# 创建工作目录
mkdir -p ~/nginx-build && cd ~/nginx-build

# 下载 PCRE（建议使用最新版本）
wget https://github.com/PhilipHazel/pcre2/releases/download/pcre2-10.42/pcre2-10.42.tar.gz

# 解压
tar -zxvf pcre2-10.42.tar.gz
cd pcre2-10.42

# 配置、编译和安装
./configure
make
sudo make install
```

### 3. 下载并安装 Nginx

```bash
# 返回工作目录
cd ~/nginx-build

# 下载 Nginx（建议使用最新稳定版）
wget http://nginx.org/download/nginx-1.24.0.tar.gz

# 解压
tar -zxvf nginx-1.24.0.tar.gz
cd nginx-1.24.0

# 配置编译选项
./configure \
    --prefix=/usr/local/nginx \
    --with-http_stub_status_module \
    --with-http_realip_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-pcre \
    --with-file-aio \
    --with-http_secure_link_module

# 编译
make

# 安装
sudo make install
```

### 4. 配置系统服务

#### 创建 systemd 服务文件

```bash
sudo tee /etc/systemd/system/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /usr/local/nginx/conf/nginx.conf
ExecStart=/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
```

#### 启动服务

```bash
# 重新加载 systemd
sudo systemctl daemon-reload

# 启动 Nginx
sudo systemctl start nginx

# 设置开机自启
sudo systemctl enable nginx
```

### 5. 验证安装

```bash
# 检查 Nginx 是否正常运行
sudo systemctl status nginx

# 测试配置文件
sudo /usr/local/nginx/sbin/nginx -t

# 检查版本和编译选项
/usr/local/nginx/sbin/nginx -V
```

## 防火墙配置

```bash
# CentOS/RHEL (firewalld)
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

# Ubuntu (ufw)
sudo ufw allow 'Nginx Full'
```

## 访问测试

打开浏览器，访问服务器 IP 地址：
- HTTP: `http://your-server-ip`
- HTTPS: `https://your-server-ip`（如果配置了 SSL）

如果看到 Nginx 欢迎页面，说明安装成功。

## 常用命令

```bash
# 启动 Nginx
sudo systemctl start nginx

# 停止 Nginx
sudo systemctl stop nginx

# 重启 Nginx
sudo systemctl restart nginx

# 重新加载配置（不中断服务）
sudo systemctl reload nginx

# 检查配置文件语法
sudo nginx -t

# 查看 Nginx 进程
ps aux | grep nginx
```

## 配置文件位置

| 安装方式 | 配置文件位置 | 日志位置 |
|----------|-------------|----------|
| 包管理器 | `/etc/nginx/nginx.conf` | `/var/log/nginx/` |
| 源码编译 | `/usr/local/nginx/conf/nginx.conf` | `/usr/local/nginx/logs/` |

## 注意事项

1. **推荐使用官方包管理器安装**：更容易维护和更新
2. **源码编译适用于**：需要特定模块或自定义配置的场景
3. **安全建议**：
   - 定期更新 Nginx 版本
   - 合理配置防火墙规则
   - 使用 SSL/TLS 证书加密传输
4. **性能调优**：根据实际需求调整 `worker_processes` 和 `worker_connections` 等参数

## 常见问题

### Q: 如何卸载 Nginx？

**包管理器安装**：
```bash
# CentOS/RHEL
sudo yum remove nginx

# Debian/Ubuntu
sudo apt remove nginx
```

**源码编译安装**：
```bash
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo rm -rf /usr/local/nginx
sudo rm /etc/systemd/system/nginx.service
sudo systemctl daemon-reload
```

### Q: 如何更新 Nginx？

**包管理器安装**：
```bash
# CentOS/RHEL
sudo yum update nginx

# Debian/Ubuntu
sudo apt update && sudo apt upgrade nginx
```

**源码编译安装**：需要重新下载源码并编译安装。
