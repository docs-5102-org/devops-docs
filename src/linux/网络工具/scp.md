---
title: scp命令-文件传输
category:
  - Linux命令
tag:
  - 文件传输
  - SSH
  - 远程操作
date: 2022-09-14

---

# scp命令-文件传输

## 简介

`scp`命令是Linux系统下基于SSH协议的安全远程文件复制工具，其名称来源于"secure copy"的缩写。它可以在本地主机和远程主机之间，或者两个远程主机之间安全地传输文件。与普通的`cp`命令不同，`scp`命令可以跨越不同的主机进行文件传输，并且所有传输都是加密的。

## 基本语法

```bash
scp [选项] 源文件 目标文件
```

其中，源文件和目标文件的格式为：

```
[[用户名@]主机名:]文件路径
```

## 常用选项

| 选项 | 说明 |
| --- | --- |
| -P port | 指定SSH连接端口，默认是22 |
| -p | 保留原文件的修改时间、访问时间和访问权限 |
| -r | 递归复制整个目录 |
| -q | 静默模式，不显示进度信息 |
| -C | 压缩传输，适合网络带宽有限的情况 |
| -v | 详细模式，显示详细的连接、认证和传输信息 |
| -4 | 强制使用IPv4地址 |
| -6 | 强制使用IPv6地址 |
| -l limit | 限制带宽，以Kbit/s为单位 |

## 常用场景

### 1. 从远程服务器下载文件到本地

将远程服务器上的文件下载到本地：

```bash
scp username@remote_host:/path/to/remote/file /path/to/local/file
```

例如：

```bash
scp root@192.168.1.100:/var/www/file.txt /home/user/Downloads/
```

### 2. 从远程服务器下载整个目录到本地

使用`-r`选项递归地复制整个目录：

```bash
scp -r username@remote_host:/path/to/remote/directory /path/to/local/directory
```

例如：

```bash
scp -r root@192.168.1.100:/var/www/html/ /home/user/backup/
```

### 3. 从本地上传文件到远程服务器

将本地文件上传到远程服务器：

```bash
scp /path/to/local/file username@remote_host:/path/to/remote/file
```

例如：

```bash
scp /home/user/Documents/file.txt root@192.168.1.100:/var/www/
```

### 4. 从本地上传整个目录到远程服务器

使用`-r`选项递归地复制整个目录：

```bash
scp -r /path/to/local/directory username@remote_host:/path/to/remote/directory
```

例如：

```bash
scp -r /home/user/Projects/website/ root@192.168.1.100:/var/www/
```

### 5. 在两个远程服务器之间复制文件

从一个远程服务器复制到另一个远程服务器：

```bash
scp username1@remote_host1:/path/to/file username2@remote_host2:/path/to/destination
```

例如：

```bash
scp root@192.168.1.100:/var/www/file.txt admin@192.168.1.200:/backup/
```

## 高级用法

### 使用非标准SSH端口

如果远程服务器使用非标准SSH端口（不是22），可以使用`-P`选项指定端口：

```bash
scp -P 2222 /path/to/local/file username@remote_host:/path/to/remote/file
```

### 压缩传输

使用`-C`选项可以在传输过程中压缩数据，适合在低带宽网络中使用：

```bash
scp -C /path/to/local/file username@remote_host:/path/to/remote/file
```

### 保留文件属性

使用`-p`选项可以保留源文件的修改时间、访问时间和权限：

```bash
scp -p /path/to/local/file username@remote_host:/path/to/remote/file
```

### 限制传输带宽

使用`-l`选项可以限制传输带宽（以Kbit/s为单位）：

```bash
scp -l 1000 /path/to/local/file username@remote_host:/path/to/remote/file
```

### 使用详细模式

使用`-v`选项可以显示详细的连接和传输信息，对调试连接问题很有帮助：

```bash
scp -v /path/to/local/file username@remote_host:/path/to/remote/file
```

## 使用技巧

### 使用SSH密钥认证

为了避免每次使用scp时都输入密码，可以设置SSH密钥认证：

```bash
# 生成SSH密钥对
ssh-keygen -t rsa

# 将公钥复制到远程服务器
ssh-copy-id username@remote_host
```

设置好SSH密钥认证后，就可以无密码使用scp命令了。

### 使用通配符

scp支持使用通配符传输多个文件：

```bash
scp /path/to/local/directory/*.txt username@remote_host:/path/to/remote/directory/
```

### 结合其他命令使用

可以结合其他命令，如`find`、`tar`等，实现更复杂的文件传输需求：

```bash
# 先压缩再传输
tar czf - /path/to/local/directory | ssh username@remote_host "cat > /path/to/remote/archive.tar.gz"

# 传输后解压
scp archive.tar.gz username@remote_host:/tmp/ && ssh username@remote_host "tar xzf /tmp/archive.tar.gz -C /destination"
```

## 常见问题

### 权限问题

如果遇到权限拒绝的问题，请确保：
- 你有源文件的读取权限
- 你有目标目录的写入权限
- 远程用户有相应的权限

### 连接问题

如果无法连接到远程主机，请检查：
- 远程主机是否开启SSH服务
- 防火墙是否允许SSH连接
- 使用的端口是否正确
- 网络连接是否正常

### 速度问题

如果传输速度较慢，可以尝试：
- 使用`-C`选项压缩传输
- 检查网络带宽和延迟
- 如果文件较大，考虑使用`rsync`命令替代

## 相关命令

- `ssh` - 安全Shell客户端
- `sftp` - 安全文件传输协议客户端
- `rsync` - 远程文件同步工具
- `cp` - 本地文件复制

## 参考资料

- [Linux man pages: scp(1)](https://linux.die.net/man/1/scp)
- [OpenSSH Documentation](https://www.openssh.com/manual.html) 
