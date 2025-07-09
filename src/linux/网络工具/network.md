---
title: 网络配置
category:
  - Linux系统
tag:
  - 网络配置
  - IP地址
  - 网关设置
  - 路由配置
date: 2022-09-13

---
# 网络配置

## 目录

1. [相关网络配置命令](#相关网络配置命令)
2. [临时配置 IP 地址](#临时配置-ip-地址)
3. [永久配置 IP 地址](#永久配置-ip-地址)
4. [图形界面配置方法](#图形界面配置方法)
5. [配置验证和测试](#配置验证和测试)


## 相关网络配置命令

### 基础网络查看命令
网络配置前，需要了解几个重要的查看命令：

1. **查看网卡信息**
   ```bash
   ifconfig
   ```
   - 网卡通常以 eth0~ethN 命名
   - 该命令只在 root 用户下可用，普通用户不能使用

2. **查看路由信息**
   ```bash
   route -n
   ```

3. **查看 DNS 配置**
   ```bash
   cat /etc/resolv.conf
   ```

## 临时配置 IP 地址

### 使用 ifconfig 临时配置
```bash
# 配置 IP 地址和子网掩码
ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# 或者使用完整路径
/sbin/ifconfig eth0 220.195.193.86 netmask 255.255.255.240
```

### 配置网关
```bash
# 添加默认网关
route add default gw 192.168.1.1

# 或者使用完整路径
/sbin/route add default gw 211.91.88.129
```

### 修改 MAC 地址
```bash
ifconfig ens160 hw ether 00:aa:bb:cc:dd:ee
```

### ARP 协议控制
```bash
# 关闭 ARP 协议
ifconfig ens160 -arp

# 开启 ARP 协议
ifconfig ens160 arp
```

## 永久配置 IP 地址

### 方法一：图形界面配置（setup 命令）
```bash
setup
```
操作步骤：
1. 执行 `setup` 命令弹出图形界面
2. 选择 "Network Configuration" → 回车
3. 选择网卡配置或 DNS 配置
4. 配置完成后：TAB 键 → OK → Save → Save & Quit → Quit

### 方法二：编辑配置文件

#### 1. 配置网卡参数
编辑网卡配置文件（以 eth0 为例）：
```bash
vi /etc/sysconfig/network-scripts/ifcfg-eth0
```

配置文件内容示例：
```bash
DEVICE=eth0                    # 网卡设备别名
BOOTPROTO=static              # IP获取方式：static(静态)/dhcp/bootp
BROADCAST=192.168.0.255       # 子网广播地址
HWADDR=00:07:E9:05:E8:B4     # 网卡物理地址(MAC地址)
IPADDR=192.168.0.2           # 静态IP地址
IPV6INIT=no                  # 是否启用IPv6
IPV6_AUTOCONF=no             # IPv6自动配置
NETMASK=255.255.255.0        # 子网掩码
NETWORK=192.168.0.0          # 网络地址
ONBOOT=yes                   # 开机是否启动此网络接口
```

#### 2. 配置网关
编辑网络配置文件：
```bash
vi /etc/sysconfig/network
```

配置文件内容：
```bash
NETWORKING=yes               # 是否使用网络
HOSTNAME=localhost          # 主机名设置
GATEWAY=192.168.1.1         # 默认网关IP地址
```

#### 3. 重启网络服务
```bash
# CentOS 6/RHEL 6
service network restart

# CentOS 7/RHEL 7
systemctl restart network

# 或者重启指定网卡
ifdown eth0 && ifup eth0
```

## 图形界面配置方法

### 使用 netconfig 命令
1. **查找命令路径**
   ```bash
   which netconfig
   which ifconfig
   which route
   ```
   
   预期返回结果：
   ```
   /usr/sbin/netconfig
   /sbin/ifconfig
   /sbin/route
   ```

2. **执行图形配置**
   ```bash
   /usr/sbin/netconfig
   ```
   
3. **操作步骤**
   - 使用键盘进行设置
   - 输入 IP 地址、子网掩码、网关
   - 选择 OK 完成配置

### 通过系统菜单访问
1. 点击左上角的 "Application"
2. 选择 "System Tools" 下拉菜单
3. 点击 "Terminal" 打开命令模式

## 配置验证和测试

### 1. 验证网卡配置
```bash
/sbin/ifconfig
```

成功配置后的输出示例：
```
eth0 Link encap:Ethernet HWaddr 00:18:FE:28:1C:AA
     inet addr:192.168.0.2 Bcast:192.168.0.255 Mask:255.255.255.0
     inet6 addr: fe80::218:feff:fe28:1caa/64 Scope:Link
     UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
     RX packets:3579820 errors:0 dropped:0 overruns:0 frame:0
     TX packets:4311575 errors:0 dropped:0 overruns:0 carrier:0
     collisions:0 txqueuelen:1000
     RX bytes:316306869 (301.6 MiB) TX bytes:1919419606 (1.7 GiB)
     Interrupt:169
```

### 2. 测试网络连通性
```bash
# 测试本地网络
ping 192.168.1.1

# 测试外网连接
ping 202.108.22.5

# 测试域名解析
ping www.baidu.com
```

### 3. 查看路由表
```bash
route -n
```

### 4. 查看 DNS 配置
```bash
cat /etc/resolv.conf
```

## 常见问题和解决方案

### 1. 命令找不到 (command not found)
使用 `which` 命令查找完整路径：
```bash
which ifconfig
which route
which netconfig
```

### 2. 权限不足
确保以 root 用户执行网络配置命令：
```bash
sudo ifconfig
# 或者
su - root
```

### 3. 配置不生效
- 检查配置文件语法是否正确
- 重启网络服务
- 检查网卡是否启用 (ONBOOT=yes)

### 4. 网络不通
- 检查 IP 地址、子网掩码、网关配置
- 确认网线连接正常
- 检查防火墙设置

## 参考

[网络配置](../_resources/Linux_网络配置.resources/第一章网络配置.pdf)

## 总结

Linux 系统提供多种配置 IP 地址的方法：
- **临时配置**：使用 ifconfig 命令，重启后失效
- **永久配置**：修改配置文件，重启后保持
- **图形界面**：使用 setup 或 netconfig 命令

建议在生产环境中使用配置文件的方式进行永久配置，确保系统重启后网络配置依然有效。配置完成后，务必进行网络连通性测试以验证配置是否正确。
