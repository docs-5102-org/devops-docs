---
title: df命令-查看磁盘空间使用情况
category:
  - Linux
  - 磁盘管理
tag:
  - 磁盘管理
  - Linux命令
  - 系统管理
date: 2022-08-27

---

# Linux 磁盘空间查看命令完整指南

## df 命令

`df` 命令来自英文词组 "report file system disk space usage" 的缩写，用于显示系统上磁盘空间的使用量情况。df命令显示的磁盘使用量信息包含可用空间、已用空间及使用率等，默认单位为KB。

### 语法格式
```bash
df [参数] [对象磁盘/分区]
```

### 常用选项

| 参数 | 说明 |
|------|------|
| `-h` | 以人类可读的格式显示（KB、MB、GB等） |
| `-i` | 使用 i-nodes 显示结果 |
| `-B` | 显示文件大小 |
| `-k` | 使用 KB 显示结果 |
| `-m` | 使用 MB 显示结果 |
| `-g` | 使用 GB 显示结果，例如：`df -BG` |
| `-t` | 显示指定文件系统类型的磁盘分区 |
| `-T` | 显示文件系统类型 |
| `-a` | 显示所有文件系统（包括虚拟文件系统） |
| `-l` | 只显示本地文件系统 |

### 实用示例

#### 1. 显示系统全部磁盘的使用量情况（推荐）
```bash
[root@linuxcool ~]# df -h
Filesystem              Size  Used Avail Use% Mounted on
devtmpfs                969M     0  969M   0% /dev
tmpfs                   984M     0  984M   0% /dev/shm
tmpfs                   984M  9.6M  974M   1% /run
tmpfs                   984M     0  984M   0% /sys/fs/cgroup
/dev/mapper/rhel-root    17G  3.9G   14G  23% /
/dev/sr0                6.7G  6.7G     0 100% /media/cdrom
/dev/sda1              1014M  152M  863M  15% /boot
tmpfs                   197M   16K  197M   1% /run/user/42
tmpfs                   197M  3.5M  194M   2% /run/user/0
```

#### 2. 显示指定磁盘分区的使用量情况
```bash
[root@linuxcool ~]# df -h /boot
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1      1014M  152M  863M  15% /boot
```

#### 3. 显示指定文件系统类型的磁盘分区
```bash
[root@linuxcool ~]# df -t xfs
Filesystem           1K-blocks    Used Available Use% Mounted on
/dev/mapper/rhel-root  17811456 4041320  13770136  23% /
/dev/sda1               1038336  155556    882780  15% /boot
```

#### 4. 显示 inode 使用情况
```bash
df -i
```

#### 5. 显示文件系统类型
```bash
df -T
```


## 总结

- 使用 `df -h` 快速查看整体磁盘使用情况
- 使用 `du -sh` 查看特定目录的大小
- 结合 `sort` 和 `head` 命令可以快速找到占用空间最大的目录
- 定期监控磁盘使用情况，避免磁盘空间不足导致系统问题
