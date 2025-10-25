---
title: UFW命令-防火墙完全指南
category:
  - Linux
  - 系统管理与监控
tag:
  - UFW
  - 防火墙
  - 网络安全
  - 端口管理
date: 2025-10-25

---

# UFW 防火墙完全指南

## 📋 目录
- [UFW 简介](#ufw-简介)
- [支持的系统](#支持的系统)
- [基本操作](#基本操作)
- [端口管理](#端口管理)
- [访问控制](#访问控制)
- [高级配置](#高级配置)
- [实战案例](#实战案例)
- [常见问题](#常见问题)

---

## UFW 简介

**UFW**（Uncomplicated Firewall）是 `iptables` 的简化封装工具，旨在提供简单易用的防火墙管理界面。它通过简洁的命令行语法，让系统管理员无需深入了解复杂的 iptables 规则即可配置防火墙。

### 主要特点
- 🎯 **简单易用**：命令语法直观，学习曲线低
- 🛡️ **功能完善**：支持端口、协议、IP 地址等多维度控制
- ⚡ **即时生效**：规则修改后立即生效
- 📝 **规则持久化**：配置自动保存，重启后依然有效

---

## 支持的系统

UFW 主要支持以下 Linux 发行版：

### ✅ 官方支持
- **Ubuntu**（所有版本，默认预装）
- **Debian**（8.0 Jessie 及以后版本）
- **Linux Mint**
- **Elementary OS**
- **Pop!_OS**

### ✅ 社区支持
- **Arch Linux**（需通过 AUR 安装）
- **Manjaro**
- **Fedora**（需手动安装）
- **CentOS/RHEL**（需手动安装，但推荐使用 firewalld）
- **openSUSE**

### 📦 安装方法

**Ubuntu/Debian 系：**
```bash
sudo apt update
sudo apt install ufw
```

**Arch Linux：**
```bash
sudo pacman -S ufw
```

**Fedora/CentOS：**
```bash
sudo dnf install ufw
# 或
sudo yum install ufw
```

> ⚠️ **注意**：CentOS/RHEL 系统默认使用 `firewalld`，建议优先使用系统默认防火墙工具。

---

## 基本操作

### 启用与禁用

**启用防火墙**
```bash
sudo ufw enable
```

**禁用防火墙**
```bash
sudo ufw disable
```

> ⚠️ **重要提示**：启用防火墙前，务必先放行 SSH 端口（22），否则可能导致远程连接断开！

```bash
sudo ufw allow 22
sudo ufw enable
```

### 查看状态

**基本状态**
```bash
sudo ufw status
```

**详细状态（显示规则编号）**
```bash
sudo ufw status numbered
```

**详细信息（包含默认策略）**
```bash
sudo ufw status verbose
```

### 重载与重置

**重载规则**
```bash
sudo ufw reload
```

**重置所有规则（慎用！）**
```bash
sudo ufw reset
```

---

## 端口管理

### 放行端口

**放行单个端口**
```bash
sudo ufw allow 22        # SSH
sudo ufw allow 80        # HTTP
sudo ufw allow 443       # HTTPS
sudo ufw allow 3306      # MySQL
sudo ufw allow 5432      # PostgreSQL
sudo ufw allow 6379      # Redis
sudo ufw allow 27017     # MongoDB
sudo ufw allow 2375      # Docker API（⚠️ 慎用！）
```

**放行端口范围**
```bash
sudo ufw allow 5000:5100/tcp
sudo ufw allow 60000:61000/udp
```

**按协议放行**
```bash
sudo ufw allow 53/udp           # DNS
sudo ufw allow 123/udp          # NTP
sudo ufw allow 3000/tcp         # 指定 TCP 协议
```

**放行常用服务（按服务名）**
```bash
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow mysql
```

### 拒绝端口

**拒绝访问**
```bash
sudo ufw deny 3306
sudo ufw deny 23/tcp
```

**删除规则**
```bash
sudo ufw delete allow 22
sudo ufw delete deny 3306
```

**按编号删除**
```bash
sudo ufw status numbered        # 查看规则编号
sudo ufw delete 3              # 删除第 3 条规则
```

---

## 访问控制

### IP 地址控制

**允许特定 IP 访问所有端口**
```bash
sudo ufw allow from 192.168.0.60
```

**允许特定 IP 访问指定端口**
```bash
sudo ufw allow from 192.168.0.60 to any port 2375
sudo ufw allow from 10.0.0.100 to any port 3306
```

**允许特定 IP 段访问**
```bash
sudo ufw allow from 192.168.0.0/24
sudo ufw allow from 192.168.0.0/24 to any port 22
```

**拒绝特定 IP 访问**
```bash
sudo ufw deny from 192.168.0.100
sudo ufw deny from 203.0.113.0/24
```

### 网络接口控制

**允许特定网卡接收连接**
```bash
sudo ufw allow in on eth0 to any port 80
sudo ufw allow in on docker0 to any port 8080
```

**允许特定网卡流出**
```bash
sudo ufw allow out on eth1 to any port 443
```

---

## 高级配置

### 默认策略

**设置默认拒绝入站**
```bash
sudo ufw default deny incoming
```

**设置默认允许出站**
```bash
sudo ufw default allow outgoing
```

**设置默认拒绝转发**
```bash
sudo ufw default deny routed
```

### 限速保护（防暴力破解）

**限制连接速率（6 次/30 秒）**
```bash
sudo ufw limit 22/tcp          # 保护 SSH
sudo ufw limit ssh
```

### 日志记录

**启用日志**
```bash
sudo ufw logging on
```

**设置日志级别**
```bash
sudo ufw logging low           # 低
sudo ufw logging medium        # 中
sudo ufw logging high          # 高
sudo ufw logging full          # 完整
```

**查看日志**
```bash
sudo tail -f /var/log/ufw.log
```

---

## 实战案例

### 案例 1：Web 服务器基础配置

```bash
# 设置默认策略
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 允许 SSH（防止被锁）
sudo ufw allow 22/tcp

# 允许 HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 启用防火墙
sudo ufw enable

# 查看状态
sudo ufw status verbose
```

### 案例 2：仅允许局域网访问 Docker API

```bash
# 允许局域网访问 Docker API
sudo ufw allow from 192.168.0.0/24 to any port 2375

# 拒绝其他所有来源
sudo ufw deny 2375

# 重载规则
sudo ufw reload
```

### 案例 3：数据库服务器（仅内网访问）

```bash
# MySQL - 仅允许应用服务器访问
sudo ufw allow from 192.168.1.100 to any port 3306

# Redis - 仅允许本地和特定服务器
sudo ufw allow from 127.0.0.1 to any port 6379
sudo ufw allow from 192.168.1.100 to any port 6379

# 拒绝外部访问数据库端口
sudo ufw deny 3306
sudo ufw deny 6379

sudo ufw enable
```

### 案例 4：完整的生产环境配置脚本

```bash
#!/bin/bash
# UFW 生产环境配置脚本

echo "开始配置防火墙..."

# 重置防火墙（可选）
# sudo ufw --force reset

# 设置默认策略
sudo ufw default deny incoming
sudo ufw default allow outgoing

# SSH（限速防暴力破解）
sudo ufw limit 22/tcp

# Web 服务
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 1Panel 管理面板（仅局域网）
sudo ufw allow from 192.168.0.0/24 to any port 8888

# Docker API（仅局域网）
sudo ufw allow from 192.168.0.0/24 to any port 2375

# MySQL（仅特定 IP）
sudo ufw allow from 192.168.0.60 to any port 3306

# Redis（仅本地）
sudo ufw allow from 127.0.0.1 to any port 6379

# Nginx 管理端口（如有需要）
# sudo ufw allow from 192.168.0.0/24 to any port 8080

# 启用防火墙
sudo ufw --force enable

# 启用日志
sudo ufw logging medium

# 显示配置结果
echo "防火墙配置完成！"
sudo ufw status verbose
```

保存为 `setup_firewall.sh`，执行：
```bash
chmod +x setup_firewall.sh
sudo ./setup_firewall.sh
```

---

## 常见问题

### Q1: 启用 UFW 后无法 SSH 连接？
**A:** 在启用防火墙前，务必先放行 SSH 端口：
```bash
sudo ufw allow 22
sudo ufw enable
```

### Q2: 如何查看规则编号以便删除？
**A:** 使用 `numbered` 参数：
```bash
sudo ufw status numbered
sudo ufw delete 3  # 删除第 3 条规则
```

### Q3: UFW 和 iptables 冲突吗?
**A:** UFW 是 iptables 的前端，两者可以共存，但建议只使用一种工具管理防火墙，避免混淆。

### Q4: 如何备份和恢复 UFW 规则？
**A:** 
```bash
# 备份
sudo cp /etc/ufw/*.rules /backup/

# 恢复
sudo cp /backup/*.rules /etc/ufw/
sudo ufw reload
```

### Q5: Docker 容器无法访问外网？
**A:** Docker 需要配置 UFW 转发规则，编辑 `/etc/default/ufw`：
```bash
DEFAULT_FORWARD_POLICY="ACCEPT"
```
然后重载：
```bash
sudo ufw reload
```

### Q6: 如何临时禁用防火墙测试？
**A:**
```bash
sudo ufw disable
# 测试完成后
sudo ufw enable
```

---

## 📚 参考资源

- [UFW 官方文档](https://help.ubuntu.com/community/UFW)
- [Ubuntu 服务器指南 - UFW](https://ubuntu.com/server/docs/security-firewall)
- [DigitalOcean UFW 教程](https://www.digitalocean.com/community/tutorials/ufw-essentials-common-firewall-rules-and-commands)

---

## 🔖 总结

UFW 是 Linux 系统上非常实用的防火墙管理工具，特别适合 Ubuntu/Debian 系统。通过本文档的命令和案例，你可以快速配置适合自己环境的防火墙规则，保障服务器安全。

**关键要点：**
- ✅ 启用防火墙前先放行 SSH
- ✅ 遵循"最小权限原则"，只开放必要端口
- ✅ 敏感服务（数据库、管理面板）限制 IP 访问
- ✅ 定期检查和审计防火墙规则
- ✅ 启用日志记录便于排查问题

---

**最后更新：** 2025-10-25