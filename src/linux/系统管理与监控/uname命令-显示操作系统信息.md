
---
title: uname命令-显示操作系统信息
category:
  - Linux
  - 系统管理与监控
tag:
  - uname
  - 系统信息
  - 内核版本
  - 硬件架构
date: 2022-09-10

---

# uname命令

uname命令用于显示操作系统的信息，包括内核名称、版本、架构等。

### 命令格式

```bash
uname [选项]
```

### 常用选项

- `-a`: 显示全部信息
- `-s`: 显示内核名称（默认）
- `-n`: 显示网络主机名
- `-r`: 显示内核发行版本
- `-v`: 显示内核版本
- `-m`: 显示机器硬件架构
- `-p`: 显示处理器类型
- `-o`: 显示操作系统名称

### 基本用法

```bash
# 显示内核名称
uname

# 显示内核版本
uname -r

# 显示所有系统信息
uname -a

# 只显示机器硬件架构
uname -m
```

### 实用示例

查看完整系统信息：
```bash
$ uname -a
Linux hostname 5.4.0-100-generic #113-Ubuntu SMP Thu Feb 3 18:43:29 UTC 2022 x86_64 GNU/Linux
```

查看内核版本：
```bash
$ uname -r
5.4.0-100-generic
```

## 组合使用

这两个命令可以组合使用来获取更全面的系统信息：

```bash
# 查看系统信息并筛选特定硬件信息
uname -a && dmesg | grep -i usb

# 保存系统诊断信息到文件
(uname -a; dmesg) > system_info.txt
```
