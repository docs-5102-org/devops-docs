---
title: firewalld命令-防火墙管理指南
category:
  - Linux
  - 系统管理与监控
tag:
  - firewalld
  - 防火墙
  - 网络安全
  - 端口管理
date: 2022-09-05

---

# Firewalld 防火墙管理完整指南

## 1. Firewalld 服务管理

### 基本操作
```bash
# 启动防火墙
systemctl start firewalld

# 停止防火墙
systemctl stop firewalld

# 重启防火墙
systemctl restart firewalld

# 查看防火墙状态
systemctl status firewalld

# 设置开机自启
systemctl enable firewalld

# 禁用开机自启
systemctl disable firewalld
```

### 服务状态查询
```bash
# 查看服务是否开机启动
systemctl is-enabled firewalld

# 查看所有已启用的服务
systemctl list-unit-files | grep enabled

# 查看启动失败的服务
systemctl --failed
```

## 2. Firewall-cmd 命令使用

### 基础信息查询
```bash
# 查看版本
firewall-cmd --version

# 查看帮助
firewall-cmd --help

# 显示防火墙状态
firewall-cmd --state

# 查看当前活动区域
firewall-cmd --get-active-zones

# 查看指定网卡所属区域
firewall-cmd --get-zone-of-interface=eth0
```

### 端口管理

#### 查看端口
```bash
# 查看所有开放端口
firewall-cmd --zone=public --list-ports

# 查看指定端口状态
firewall-cmd --zone=public --query-port=80/tcp
```

#### 开放端口
```bash
# 临时开放端口（重启后失效）
firewall-cmd --zone=public --add-port=80/tcp

# 永久开放端口
firewall-cmd --zone=public --add-port=80/tcp --permanent

# 开放端口范围
firewall-cmd --zone=public --add-port=8080-8090/tcp --permanent
```

#### 关闭端口
```bash
# 临时关闭端口
firewall-cmd --zone=public --remove-port=80/tcp

# 永久关闭端口
firewall-cmd --zone=public --remove-port=80/tcp --permanent
```

#### 重新加载配置
```bash
# 重新加载防火墙规则（使永久配置生效）
firewall-cmd --reload
```

## 3. 服务管理

### 开放服务
```bash
# 查看所有可用服务
firewall-cmd --get-services

# 查看当前开放的服务
firewall-cmd --zone=public --list-services

# 临时开放服务
firewall-cmd --zone=public --add-service=http

# 永久开放服务
firewall-cmd --zone=public --add-service=http --permanent
```

### 关闭服务
```bash
# 临时关闭服务
firewall-cmd --zone=public --remove-service=http

# 永久关闭服务
firewall-cmd --zone=public --remove-service=http --permanent
```

## 4. 紧急模式

```bash
# 启用紧急模式（拒绝所有网络连接）
firewall-cmd --panic-on

# 关闭紧急模式
firewall-cmd --panic-off

# 查看紧急模式状态
firewall-cmd --query-panic
```

## 5. 常用示例

### 开放常见端口
```bash
# 开放 HTTP 服务（80端口）
firewall-cmd --zone=public --add-port=80/tcp --permanent

# 开放 HTTPS 服务（443端口）
firewall-cmd --zone=public --add-port=443/tcp --permanent

# 开放 SSH 服务（22端口）
firewall-cmd --zone=public --add-port=22/tcp --permanent

# 开放 MySQL 服务（3306端口）
firewall-cmd --zone=public --add-port=3306/tcp --permanent

# 重新加载配置
firewall-cmd --reload
```

### 批量管理端口
```bash
# 开放多个端口
firewall-cmd --zone=public --add-port={80/tcp,443/tcp,22/tcp} --permanent

# 开放端口段
firewall-cmd --zone=public --add-port=8000-9000/tcp --permanent
```

## 6. 重要提醒

- **--permanent 参数**：添加此参数表示永久生效，不加则重启后失效
- **重新加载**：使用 `--permanent` 参数后，需执行 `firewall-cmd --reload` 使配置生效
- **区域概念**：默认使用 `public` 区域，可根据需要选择其他区域
- **安全建议**：生产环境中谨慎开放端口，遵循最小权限原则


## firewalld 系统兼容性

firewalld 主要支持基于 systemd 的 Linux 发行版，以下是详细情况：

### 原生支持的系统

**Red Hat 系列**
- RHEL 7+ (默认防火墙)
- CentOS 7+ (默认防火墙)
- Fedora 18+ (默认防火墙)
- Rocky Linux 8+
- AlmaLinux 8+

**SUSE 系列**
- openSUSE Leap 15+
- SUSE Linux Enterprise 15+

### 可安装但非默认的系统

**Debian 系列**
- Ubuntu 16.04+ (需手动安装)
- Debian 9+ (需手动安装)
- Linux Mint 18+ (需手动安装)

**Arch 系列**
- Arch Linux (需手动安装)
- Manjaro (需手动安装)

## 各系统安装命令

### Red Hat/CentOS/Fedora 系列
```bash
# RHEL/CentOS 7+
sudo yum install firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld

# Fedora/RHEL 8+
sudo dnf install firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

### Ubuntu/Debian 系列
```bash
# 安装
sudo apt update
sudo apt install firewalld

# 启用服务
sudo systemctl enable firewalld
sudo systemctl start firewalld

# 注意：可能需要先禁用 ufw
sudo ufw disable
```

### SUSE 系列
```bash
# openSUSE
sudo zypper install firewalld
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

### Arch Linux 系列
```bash
# 安装
sudo pacman -S firewalld

# 启用服务
sudo systemctl enable firewalld
sudo systemctl start firewalld
```

## 系统兼容性注意事项

### 完全兼容
- **RHEL/CentOS 7+**: 最佳支持，默认防火墙
- **Fedora**: 完全集成，功能齐全
- **openSUSE**: 良好支持

### 部分兼容
- **Ubuntu/Debian**: 可正常使用，但可能与 ufw 冲突
- **Arch Linux**: 功能完整，需手动配置

### 限制和冲突

**与其他防火墙工具的冲突**
```bash
# Ubuntu 系统可能需要
sudo ufw disable

# 某些系统可能需要停用 iptables 服务
sudo systemctl stop iptables
sudo systemctl disable iptables
```

**依赖要求**
- Python 3.6+
- systemd
- iptables/nftables
- D-Bus

## 功能兼容性对比

| 系统 | 默认支持 | Zone 功能 | Rich Rules | 直接规则 | GUI 工具 |
|------|----------|-----------|------------|----------|----------|
| RHEL/CentOS | ✅ | ✅ | ✅ | ✅ | ✅ |
| Fedora | ✅ | ✅ | ✅ | ✅ | ✅ |
| Ubuntu | ⚠️ | ✅ | ✅ | ✅ | ✅ |
| Debian | ⚠️ | ✅ | ✅ | ✅ | ✅ |
| openSUSE | ✅ | ✅ | ✅ | ✅ | ✅ |
| Arch | ⚠️ | ✅ | ✅ | ✅ | ✅ |

## 版本兼容性

**稳定版本**
- firewalld 1.0+: 支持 nftables 后端
- firewalld 0.9+: Rich Rules 增强
- firewalld 0.8+: 基础功能稳定

**推荐版本**
- RHEL 8/9: firewalld 0.9+
- Ubuntu 20.04+: firewalld 0.8+
- 最新发行版: firewalld 1.0+

firewalld 在 Red Hat 系列系统中表现最佳，在其他系统中虽然可以使用，但可能需要额外配置和注意潜在冲突。
