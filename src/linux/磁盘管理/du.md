---
title: du命令-查询磁盘使用空间
category:
  - Linux
  - 磁盘管理
tag:
  - 磁盘管理
  - Linux命令
  - du命令
date: 2022-08-29

---

# Linux du 命令详细指南

## 概述

`du` 命令用于查询文件或目录的磁盘使用空间。与 `df` 不同的是，Linux du 命令是对文件和目录磁盘使用空间的查看，统计的是文件和目录实际占用的磁盘空间。

## 语法格式
```bash
du [参数] [目录/文件]
```

## 常用选项

| 参数 | 说明 |
|------|------|
| `-a` | 显示全部目录和其次目录下的每个文件所占的磁盘空间 |
| `-b` | 大小用 bytes 来表示（默认值为 k bytes） |
| `-c` | 最后再加上总计（默认值） |
| `-h` | 以人类可读的格式显示大小（K、M、G） |
| `-s` | 只显示各文件大小的总合，不显示子目录 |
| `-x` | 只计算同属同一个文件系统的文件 |
| `-L` | 计算所有的文件大小 |
| `-d N` | 显示目录深度为 N 层 |
| `--max-depth=N` | 同 `-d N` |

## 实用示例

### 1. 基本用法 - 以KB为单位显示
```bash
du -s
```

### 2. 人类可读格式 - 以M为单位显示
```bash
du -s -h
```

### 3. 显示指定目录的详细信息
```bash
du -h /etc
```
输出示例：
```
104K /etc/defaults
6.0K /etc/X11
8.0K /etc/bluetooth
4.0K /etc/gnats
52K /etc/isdn
388K /etc/mail
68K /etc/mtree
2.0K /etc/ntp
38K /etc/pam.d
44K /etc/periodic/daily
6.0K /etc/periodic/monthly
42K /etc/periodic/security
16K /etc/periodic/weekly
110K /etc/periodic
6.0K /etc/ppp
318K /etc/rc.d
2.0K /etc/skel
130K /etc/ssh
10K /etc/ssl
1.7M /etc
```

### 4. 只显示目录总计大小
```bash
du -sh /etc
```
输出：`1.7M /etc`

### 5. 显示当前目录的总大小
```bash
du -sh .
```

### 6. 显示目录下各子目录的大小
```bash
du -h --max-depth=1 /var
```

### 7. 显示所有文件的大小
```bash
du -a /home/user
```

### 8. 按大小排序查看目录使用情况
```bash
du /etc | sort -nr | more
```
输出示例：
```
1746 /etc
388 /etc/mail
318 /etc/rc.d
130 /etc/ssh
110 /etc/periodic
104 /etc/defaults
68 /etc/mtree
52 /etc/isdn
44 /etc/periodic/daily
42 /etc/periodic/security
38 /etc/pam.d
16 /etc/periodic/weekly
10 /etc/ssl
8 /etc/bluetooth
6 /etc/ppp
6 /etc/periodic/monthly
6 /etc/X11
4 /etc/gnats
2 /etc/skel
2 /etc/ntp
```

> **注意**：使用 `sort -nr` 参数表示以数字排序法进行反向排序。由于需要对目录大小进行排序，不能使用 `-h` 参数（human-readable 格式），否则输出中的 K、M 等字符会造成排序不正确。

## 常用组合命令

### 1. 查找占用空间最大的目录（推荐方法）
```bash
du -h --max-depth=1 / | sort -hr | head -10
```

### 2. 查找占用空间最大的目录（数字排序）
```bash
du --max-depth=1 / | sort -nr | head -10
```

### 3. 查找大于指定大小的文件
```bash
find / -type f -size +100M -exec du -h {} \; 2>/dev/null
```

### 4. 查看目录下文件数量
```bash
find /path/to/directory -type f | wc -l
```

### 5. 实时监控目录大小变化
```bash
watch -n 2 "du -sh /var/log"
```

## 高级应用技巧

### 1. 排除特定目录
```bash
du -h --max-depth=1 --exclude="*.log" /var
```

### 2. 只统计特定类型文件
```bash
du -ch --max-depth=1 /home/user/*.txt
```

### 3. 按修改时间过滤文件
```bash
find /var/log -name "*.log" -mtime +7 -exec du -ch {} \;
```

### 4. 生成磁盘使用报告
```bash
du -h /home | sort -hr > disk_usage_report.txt
```

## 注意事项

1. **性能考虑**：在大型文件系统上使用 `du` 命令可能需要较长时间，建议在系统负载较低时执行。

2. **权限问题**：某些系统目录可能需要 root 权限才能查看完整信息。

3. **单位换算**：建议使用 `-h` 参数进行单位换算，135MB 比 138240KB 更容易阅读。

4. **排序注意事项**：
   - 使用 `sort -hr` 可以对带有 K、M、G 单位的输出进行正确排序
   - 使用 `sort -nr` 适用于纯数字的排序，不能与 `-h` 参数同时使用
   - 要按大小排序时，选择合适的排序方式很重要

5. **与 df 的区别**：du 统计文件和目录的实际使用空间，而 df 显示文件系统级别的空间使用情况。已删除但仍被进程占用的文件会在 df 中显示占用空间，但在 du 中不会显示。

## 常见问题解决

### 问题1：du 和 df 显示结果不一致
**原因**：可能存在已删除但仍被进程占用的文件
**解决**：使用 `lsof +L1` 查看被删除但仍打开的文件

### 问题2：du 命令运行很慢
**原因**：目录层级深或文件数量多
**解决**：使用 `--max-depth` 限制深度，或在系统负载低时运行

### 问题3：权限不足无法查看某些目录
**原因**：普通用户权限不够
**解决**：使用 `sudo` 或切换到 root 用户

## 总结

du 命令是 Linux 系统管理中不可或缺的工具，通过合理使用各种参数和组合命令，可以有效地监控和管理磁盘空间使用情况。掌握 du 命令的各种用法，对于系统维护和故障排查都有重要意义。
