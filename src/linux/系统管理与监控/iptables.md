---
title: iptables命令-传统防火墙指南
category:
  - Linux
  - 系统管理与监控
tag:
  - iptables
  - 防火墙
  - 网络安全
  - netfilter
date: 2022-09-06

---

# iptables命令-Linux传统防火墙配置指南

iptables 是 Linux 系统中的网络防火墙管理工具，用于配置内核的 netfilter 框架。它允许系统管理员定义规则来控制网络流量的进出，实现包过滤、网络地址转换（NAT）、端口转发等功能。

## iptables 基本概念

iptables 通过表（tables）和链（chains）来组织规则。主要包含四个表：
- **filter表**：默认表，用于包过滤（允许/拒绝）
- **nat表**：用于网络地址转换
- **mangle表**：用于修改数据包
- **raw表**：用于配置数据包，使其免于被连接跟踪系统处理

每个表包含多个预定义链，如 INPUT、OUTPUT、FORWARD 等，用户也可以创建自定义链。

## 基本语法

```bash
iptables [-t table] command [chain] [rule-specification] [target]
```

常用命令示例：
```bash
# 查看规则
iptables -L

# 允许特定端口
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 拒绝特定IP
iptables -A INPUT -s 192.168.1.100 -j DROP

# 保存规则
iptables-save > /etc/iptables/rules.v4


# 查询防火墙状态：
service iptables status

# 停止防火墙：
service iptables stop

# 启动防火墙：
service iptables start

# 重启防火墙：
service iptables restart

# 永久关闭防火墙：
chkconfig iptables off

# 永久关闭后启用：
chkconfig iptables on

# 查看防火墙配置文件：
cat /etc/sysconfig/iptables

# 编辑防火墙配置文件：
vi /etc/sysconfig/iptables

```

[](../_resources/centos6_防火墙操作命令.resources/unknown_filename.jpeg)

## 各系统安装与兼容性对比

### iptables 各系统安装与兼容性对比

| 系统 | 默认安装 | 安装命令 | 默认版本 | 配置文件位置 | 服务管理 | 兼容性 | 备注 |
|------|----------|----------|----------|-------------|----------|--------|------|
| **Ubuntu/Debian** | ✅ | `apt install iptables` | 1.8.x | `/etc/iptables/` | `systemctl enable/start netfilter-persistent` | 完全兼容 | 新版本默认使用 nftables 后端 |
| **CentOS/RHEL 7** | ✅ | `yum install iptables-services` | 1.4.x | `/etc/sysconfig/iptables` | `systemctl enable/start iptables` | 完全兼容 | 传统 iptables 实现 |
| **CentOS/RHEL 8+** | ❌ | `dnf install iptables-services` | 1.8.x | `/etc/sysconfig/iptables` | `systemctl disable firewalld && systemctl enable iptables` | 兼容性问题 | 默认使用 firewalld，需要切换 |
| **Fedora** | ❌ | `dnf install iptables-services` | 1.8.x | `/etc/sysconfig/iptables` | `systemctl disable firewalld && systemctl enable iptables` | 兼容性问题 | 默认使用 firewalld |
| **openSUSE** | ❌ | `zypper install iptables` | 1.8.x | `/etc/sysconfig/SuSEfirewall2` | `systemctl enable/start SuSEfirewall2` | 部分兼容 | 推荐使用 SuSEfirewall2 |
| **Arch Linux** | ❌ | `pacman -S iptables` | 1.8.x | `/etc/iptables/` | `systemctl enable/start iptables` | 完全兼容 | 需要手动配置 |
| **Alpine Linux** | ❌ | `apk add iptables` | 1.8.x | `/etc/iptables/` | `rc-update add iptables` | 完全兼容 | 轻量级发行版 |
| **Amazon Linux 2** | ✅ | `yum install iptables-services` | 1.4.x | `/etc/sysconfig/iptables` | `systemctl enable/start iptables` | 完全兼容 | 基于 RHEL 7 |
| **FreeBSD** | ❌ | `pkg install iptables` | 1.8.x | `/usr/local/etc/` | 手动配置 | 限制兼容 | 需要 Linux 兼容层 |
| **macOS** | ❌ | `brew install iptables` | 1.8.x | - | - | 不兼容 | 仅作为工具使用，无法实际配置防火墙 |

### 现代替代方案对比

| 系统 | 传统工具 | 现代替代 | 状态 | 推荐使用 |
|------|----------|----------|------|----------|
| **Ubuntu 20.04+** | iptables | nftables | 共存 | nftables |
| **CentOS/RHEL 8+** | iptables | firewalld/nftables | 替代 | firewalld |
| **Fedora** | iptables | firewalld | 替代 | firewalld |
| **Debian 10+** | iptables | nftables | 共存 | nftables |
| **openSUSE** | iptables | firewalld | 替代 | firewalld |

### 版本兼容性说明

#### iptables 1.4.x (传统版本)
- 使用传统的内核接口
- 在 CentOS/RHEL 7 及更早版本中使用
- 性能较低，但兼容性最好

#### iptables 1.8.x (现代版本)
- 默认使用 nftables 后端
- 向后兼容传统 iptables 语法
- 性能更好，推荐使用

### 迁移建议

1. **新系统**：直接使用系统默认的防火墙工具（firewalld 或 nftables）
2. **旧系统**：可以继续使用 iptables，但建议逐步迁移
3. **容器环境**：优先使用 iptables 或 nftables，避免使用 systemd 服务
4. **云环境**：考虑使用云提供商的安全组功能配合 iptables 使用

在实际部署时，建议先在测试环境中验证配置的兼容性和功能完整性。
