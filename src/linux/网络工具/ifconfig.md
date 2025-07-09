---
title: ifconfig命令-显示网络
category:
  - Linux命令
tag:
  - 网络工具
  - 网络配置
  - 接口管理
date: 2022-09-11

---

# ifconfig命令-显示网络

### 命令概述
`ifconfig` 命令来自英文词组 "network interfaces configuring" 的缩写，其功能是显示或设置网络设备参数信息。在 Windows 系统中，与之类似的命令为 `ipconfig`。

⚠️ **注意事项**：通常不建议使用 ifconfig 命令配置网络设备的参数信息，因为一旦服务器重启，配置过的参数会自动失效，因此还是编写到配置文件中更稳妥。

### 语法格式
```bash
ifconfig [参数] [网卡名] [动作]
```

### 常用参数
| 参数 | 功能 |
|------|------|
| -a | 显示所有网卡状态 |
| -v | 显示执行过程详细信息 |
| -s | 显示简短状态列表 |

### 常用动作
| 动作 | 功能 |
|------|------|
| add | 设置网络设备的IP地址 |
| del | 删除网络设备的IP地址 |
| up | 启动指定的网络设备 |
| down | 关闭指定的网络设备 |

### 基本使用示例

#### 1. 显示系统网络设备信息
```bash
[root@linuxcool ~]# ifconfig
```

#### 2. 显示指定网卡信息
```bash
[root@linuxcool ~]# ifconfig eth0
```

#### 3. 启动/关闭网卡
```bash
# 关闭网卡
[root@linuxcool ~]# ifconfig ens160 down

# 启动网卡
[root@linuxcool ~]# ifconfig ens160 up
```

