---
title: netstat命令-网络监控
category:
  - Linux命令
tag:
  - 网络工具
  - 系统监控
  - 网络诊断
  - 查看端口
date: 2022-09-12

---

# netstat命令-网络监控

## 简介

Netstat 命令是 Linux 系统中最重要的网络监测工具之一，用于显示各种网络相关信息，如网络连接、路由表、接口状态（Interface Statistics）、masquerade 连接、多播成员（Multicast Memberships）等。对于网络管理员和系统运维人员来说，掌握 netstat 命令是必不可少的技能。

## 输出信息含义

执行 netstat 后，其输出结果为：

```bash
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      2 210.34.6.89:telnet     210.34.6.96:2873        ESTABLISHED
tcp      296      0 210.34.6.89:1165       210.34.6.84:netbios-ssn ESTABLISHED
tcp        0      0 localhost.localdom:9001 localhost.localdom:1162 ESTABLISHED
tcp        0      0 localhost.localdom:1162 localhost.localdom:9001 ESTABLISHED
tcp        0     80 210.34.6.89:1161       210.34.6.10:netbios-ssn CLOSE

Active UNIX domain sockets (w/o servers)
Proto RefCnt Flags       Type       State         I-Node   Path
unix       1 [ ]         STREAM     CONNECTED     16178    @000000dd
unix       1 [ ]         STREAM     CONNECTED     16176    @000000dc
unix       9 [ ]         DGRAM      5292          /dev/log
unix       1 [ ]         STREAM     CONNECTED     16182    @000000df
```

从整体上看，netstat 的输出结果可以分为两个部分：

### Internet 连接部分

**Active Internet connections**：称为有源 TCP 连接

- **Proto**：显示连接使用的协议（TCP、UDP）
- **Recv-Q**：接收队列中的字节数
- **Send-Q**：发送队列中的字节数
- **Local Address**：本地地址和端口号
- **Foreign Address**：远程地址和端口号  
- **State**：连接状态（LISTEN、ESTABLISHED、CLOSE_WAIT 等）

> **注意**：Recv-Q 和 Send-Q 这些数字一般都应该是 0。如果不是则表示数据包正在队列中堆积，可能存在网络问题。

### UNIX 域套接字部分

**Active UNIX domain sockets**：称为有源 Unix 域套接字（用于本机进程间通信，性能比网络套接字高一倍）

- **Proto**：显示连接使用的协议
- **RefCnt**：表示连接到本套接字上的进程号
- **Flags**：显示套接字的标志
- **Type**：显示套接字的类型（STREAM、DGRAM）
- **State**：显示套接字当前的状态
- **I-Node**：套接字的 inode 号
- **Path**：表示连接到套接字的其它进程使用的路径名

## 常用参数详解

| 参数 | 说明 |
|------|------|
| **-a** | (all) 显示所有选项，包括 LISTEN 和非 LISTEN 状态 |
| **-t** | (tcp) 仅显示 TCP 相关选项 |
| **-u** | (udp) 仅显示 UDP 相关选项 |
| **-n** | 拒绝显示别名，能显示数字的全部转化成数字（禁用域名解析） |
| **-l** | 仅列出有在 Listen（监听）的服务状态 |
| **-p** | 显示建立相关连接的程序名和进程 ID |
| **-r** | 显示路由信息，路由表 |
| **-e** | 显示扩展信息，例如 uid 等 |
| **-s** | 按各个协议进行统计 |
| **-c** | 每隔一个固定时间，执行该 netstat 命令 |
| **-i** | 显示网络接口列表 |
| **-g** | 显示多播组信息 |

> **提示**：LISTEN 和 LISTENING 的状态只有用 -a 或者 -l 才能看到

## 实用命令实例

### 1. 列出所有连接

**列出所有端口（包括监听和未监听的）**

```bash
netstat -a
```

输出示例：
```bash
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 enlightened:domain      *:*                     LISTEN     
tcp        0      0 localhost:ipp           *:*                     LISTEN     
tcp        0      0 enlightened.local:54750 li240-5.members.li:http ESTABLISHED
tcp        0      0 enlightened.local:49980 del01s07-in-f14.1:https ESTABLISHED
tcp6       0      0 ip6-localhost:ipp       [::]:*                  LISTEN     
udp        0      0 enlightened:domain      *:*                                
udp        0      0 *:bootpc                *:*                                
udp        0      0 enlightened.local:ntp   *:*                                
```

**列出所有 TCP 端口**

```bash
netstat -at
```

**列出所有 UDP 端口**

```bash
netstat -au
```

### 2. 只列出 TCP 或 UDP 协议的连接

**使用 -t 选项列出 TCP 协议的连接：**

```bash
netstat -at
```

输出示例：
```bash
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 enlightened:domain      *:*                     LISTEN     
tcp        0      0 localhost:ipp           *:*                     LISTEN     
tcp        0      0 enlightened.local:36310 del01s07-in-f24.1:https ESTABLISHED
tcp        0      0 enlightened.local:45038 a96-17-181-10.depl:http ESTABLISHED
```

**使用 -u 选项列出 UDP 协议的连接：**

```bash
netstat -au
```

### 3. 禁用反向域名解析，加快查询速度

默认情况下 netstat 会通过反向域名解析技术查找每个 IP 地址对应的主机名。这会降低查找速度。如果你觉得 IP 地址已经足够，而没有必要知道主机名，就使用 **-n** 选项禁用域名解析功能。

```bash
netstat -ant
```

输出示例：
```bash
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 127.0.1.1:53            0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
tcp        0      0 192.168.1.2:49058       173.255.230.5:80        ESTABLISHED
tcp        0      0 192.168.1.2:33324       173.194.36.117:443      ESTABLISHED
tcp6       0      0 ::1:631                 :::*                    LISTEN
```

### 4. 只列出监听中的连接

任何网络服务的后台进程都会打开一个端口，用于监听接入的请求。这些正在监听的套接字也和连接的套接字一样，也能被 netstat 列出来。使用 **-l** 选项列出正在监听的套接字。

```bash
netstat -tnl
```

输出示例：
```bash
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 127.0.1.1:53            0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
tcp6       0      0 ::1:631                 :::*                    LISTEN
```

**只列出所有监听 TCP 端口**

```bash
netstat -lt
```

**只列出所有监听 UDP 端口**

```bash
netstat -lu
```

**只列出所有监听 UNIX 端口**

```bash
netstat -lx
```

> **注意**：不要使用 **-a** 选项，否则 netstat 会列出所有连接，而不仅仅是监听端口。

### 5. 获取进程名、进程号以及用户 ID

查看端口和连接的信息时，能查看到它们对应的进程名和进程号对系统管理员来说是非常有帮助的。举个例子，Apache 的 httpd 服务开启 80 端口，如果你要查看 http 服务是否已经启动，或者 http 服务是由 apache 还是 nginx 启动的，这时候你可以看看进程名。

**使用 -p 选项查看进程信息：**

```bash
sudo netstat -nlpt
```

输出示例：
```bash
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.1.1:53            0.0.0.0:*               LISTEN      1144/dnsmasq    
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      661/cupsd       
tcp6       0      0 ::1:631                 :::*                    LISTEN      661/cupsd
```

**查看进程名和用户名：**

使用 **-ep** 选项可以同时查看进程名和用户名。

```bash
sudo netstat -ltpe
```

输出示例：
```bash
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode       PID/Program name
tcp        0      0 enlightened:domain      *:*                     LISTEN      root       11090       1144/dnsmasq    
tcp        0      0 localhost:ipp           *:*                     LISTEN      root       9755        661/cupsd       
tcp6       0      0 ip6-localhost:ipp       [::]:*                  LISTEN      root       9754        661/cupsd
```

> **重要提示**：使用 **-p** 选项时，netstat 必须运行在 root 权限之下，不然它就不能得到运行在 root 权限下的进程名，而很多服务包括 http 和 ftp 都运行在 root 权限之下。

> **注意**：假如你将 **-n** 和 **-e** 选项一起使用，User 列的属性就是用户的 ID 号，而不是用户名。

### 6. 显示每个协议的统计信息

netstat 可以打印出网络统计数据，包括某个协议下的收发包数量。

**显示所有端口的统计信息**

```bash
netstat -s
```

输出示例：
```bash
Ip:
    32797 total packets received
    0 forwarded
    0 incoming packets discarded
    32795 incoming packets delivered
    29115 requests sent out
    60 outgoing packets dropped
Icmp:
    125 ICMP messages received
    0 input ICMP message failed.
    ICMP input histogram:
        destination unreachable: 125
    125 ICMP messages sent
    0 ICMP messages failed
    ICMP output histogram:
        destination unreachable: 125
... OUTPUT TRUNCATED ...
```

**显示 TCP 或 UDP 端口的统计信息**

如果想只打印出 TCP 或 UDP 协议的统计数据，只要加上对应的选项（**-t** 和 **-u**）即可。

```bash
netstat -st   # TCP 统计信息
netstat -su   # UDP 统计信息
```

### 7. 显示内核路由信息

使用 **-r** 选项打印内核路由信息。打印出来的信息与 route 命令输出的信息一样。我们也可以使用 **-n** 选项禁止域名解析。

```bash
netstat -rn
```

输出示例：
```bash
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         192.168.1.1     0.0.0.0         UG        0 0          0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth0
```

### 8. 显示网络接口信息

netstat 也能打印网络接口信息，**-i** 选项就是为这个功能而生。

```bash
netstat -i
```

输出示例：
```bash
Kernel Interface table
Iface   MTU Met   RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0       1500 0     31611      0      0 0         27503      0      0      0 BMRU
lo        65536 0      2913      0      0 0          2913      0      0      0 LRU
```

**显示详细的接口信息：**

我们将 **-e** 选项和 **-i** 选项搭配使用，可以输出用户友好的信息。

```bash
netstat -ie
```

输出示例：
```bash
Kernel Interface table
eth0      Link encap:Ethernet  HWaddr 00:16:36:f8:b2:64  
          inet addr:192.168.1.2  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::216:36ff:fef8:b264/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:31682 errors:0 dropped:0 overruns:0 frame:0
          TX packets:27573 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:29637117 (29.6 MB)  TX bytes:4590583 (4.5 MB)
          Interrupt:18 Memory:da000000-da020000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:2921 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2921 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:305297 (305.2 KB)  TX bytes:305297 (305.2 KB)
```

上面的输出信息与 ifconfig 输出的信息一样。

### 9. netstat 持续输出

我们可以使用 netstat 的 **-c** 选项持续输出信息。

```bash
netstat -ct
```

这个命令可持续输出 TCP 协议信息，netstat 将每隔一秒输出网络信息。

### 10. 显示多播组信息

选项 **-g** 会输出 IPv4 和 IPv6 的多播组信息。

```bash
netstat -g
```

输出示例：
```bash
IPv6/IPv4 Group Memberships
Interface       RefCnt Group
--------------- ------ ---------------------
lo              1      all-systems.mcast.net
eth0            1      224.0.0.251
eth0            1      all-systems.mcast.net
lo              1      ip6-allnodes
lo              1      ff01::1
eth0            1      ff02::fb
eth0            1      ff02::1:fff8:b264
eth0            1      ip6-allnodes
eth0            1      ff01::1
wlan0           1      ip6-allnodes
wlan0           1      ff01::1
```

## 高级用法和实用技巧

### 查找活动连接

**打印 ESTABLISHED 状态的连接**

active 状态的套接字连接用 "ESTABLISHED" 字段表示，所以我们可以使用 grep 命令获得 active 状态的连接：

```bash
netstat -atnp | grep ESTA
```

输出示例：
```bash
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 192.168.1.2:49156       173.255.230.5:80        ESTABLISHED 1691/chrome     
tcp        0      0 192.168.1.2:33324       173.194.36.117:443      ESTABLISHED 1691/chrome
```

**监视活动连接**

配合 watch 命令监视 active 状态的连接：

```bash
watch -d -n0 "netstat -atnp | grep ESTA"
```

### 查看服务状态

**查看服务是否在运行**

如果你想看看 http、smtp 或 ntp 服务是否在运行，使用 grep。

```bash
sudo netstat -aple | grep ntp
```

输出示例：
```bash
udp        0      0 enlightened.local:ntp   *:*                                 root       17430       1789/ntpd       
udp        0      0 localhost:ntp           *:*                                 root       17429       1789/ntpd       
udp        0      0 *:ntp                   *:*                                 root       17422       1789/ntpd       
udp6       0      0 fe80::216:36ff:fef8:ntp [::]:*                              root       17432       1789/ntpd       
udp6       0      0 ip6-localhost:ntp       [::]:*                              root       17431       1789/ntpd       
udp6       0      0 [::]:ntp                [::]:*                              root       17423       1789/ntpd       
unix  2      [ ]         DGRAM                    17418    1789/ntpd
```

从这里可以看到 ntp 服务正在运行。使用 grep 命令你可以查看 http 或 smtp 或其它任何你想查看的服务。

### 端口和进程查询

**找出程序运行的端口**

并不是所有的进程都能找到，没有权限的会不显示，使用 root 权限查看所有的信息。

```bash
netstat -ap | grep ssh
```

**找出运行在指定端口的进程**

```bash
netstat -an | grep ':80'       # 查看 80 端口使用情况
netstat -an | grep ':3306'     # 查看 3306 端口使用情况
```



**查看当前所有监听端口**

```bash
netstat -nlp | grep LISTEN
```

**查看哪些端口被打开**

```bash
netstat -anp
netstat -ltn | grep 23
```

**查看指定端口是否被打开**

```bash
netstat -ltn | grep 23
```

### IP 和 TCP 分析

**查看连接某服务端口最多的 IP 地址**

```bash
netstat -nat | grep "192.168.1.15:22" | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -20
```

**TCP 各种状态列表**

```bash
netstat -nat | awk '{print $6}' | sort | uniq -c | sort -rn
```

**分析 access.log 获得访问前10位的 IP 地址**

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -10
```

## 常见网络状态说明

| 状态 | 描述 |
|------|------|
| **LISTEN** | 侦听来自远方的TCP端口的连接请求 |
| **SYN-SENT** | 再发送连接请求后等待匹配的连接请求 |
| **SYN-RECEIVED** | 再收到和发送一个连接请求后等待对方对连接请求的确认 |
| **ESTABLISHED** | 代表一个打开的连接 |
| **FIN-WAIT-1** | 等待远程TCP连接中断请求，或先前的连接中断请求的确认 |
| **FIN-WAIT-2** | 从远程TCP等待连接中断请求 |
| **CLOSE-WAIT** | 等待从本地用户发来的连接中断请求 |
| **CLOSING** | 等待远程TCP对连接中断的确认 |
| **LAST-ACK** | 等待原来的发向远程TCP的连接中断请求的确认 |
| **TIME-WAIT** | 等待足够的时间以确保远程TCP接收到连接中断请求的确认 |
| **CLOSED** | 没有任何连接状态 |

## 实用组合命令

### 常用的 netstat 命令组合

1. **查看所有TCP连接及进程信息**
   ```bash
   netstat -atnp
   ```

2. **查看所有监听端口及进程信息**
   ```bash
   netstat -lnp
   ```

3. **快速查看某个端口是否被占用**
   ```bash
   netstat -an | grep :端口号
   ```

4. **查看网络统计摘要**
   ```bash
   netstat -s | head -20
   ```

5. **实时监控网络连接**
   ```bash
   watch netstat -ant
   ```

## 注意事项和最佳实践

1. **权限问题**：查看进程信息需要 root 权限，否则显示不完整
2. **性能考虑**：在生产环境中频繁执行 netstat 可能影响性能
3. **域名解析**：使用 -n 参数可以避免域名解析，提高命令执行速度
4. **过滤输出**：合理使用 grep 等工具过滤输出，获取所需信息
5. **现代替代**：在某些现代 Linux 发行版中，可以考虑使用 ss 命令替代 netstat

## 总结

netstat 是 Linux 系统网络诊断和监控的重要工具，掌握其各种参数和用法对于系统管理员和网络工程师来说至关重要。通过本文介绍的各种用法，您可以有效地监控网络连接、诊断网络问题、查看系统资源使用情况等。

在实际使用中，建议根据具体需求选择合适的参数组合，并结合其他工具（如 grep、awk、watch 等）来获得更精确的信息。同时，要注意命令的执行权限和对系统性能的影响。

如果您想了解更多高级功能，建议阅读 netstat 的手册页（man netstat）。
