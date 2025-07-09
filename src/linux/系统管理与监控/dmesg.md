---
title: dmesg命令-显示系统启动信息
# icon: terminal
category:
  - Linux
  - 命令帮助
tag:
  - dmesg
  - 系统信息
  - 命令行工具
date: 2022-09-02

---


# dmesg命令-显示Linux系统启动信息

dmesg命令用于显示Linux系统启动信息，可以帮助诊断系统问题和查看硬件信息。

### 命令格式

```bash
dmesg [选项]
```

### 常用选项

- `-c`: 显示信息后清除ring buffer中的内容
- `-l`: 设置显示的日志级别
- `-f`: 只显示指定的设备类型信息
- `-H`: 以人类可读的格式显示
- `-T`: 显示人类可读的时间戳

### 基本用法

```bash
# 显示所有内核缓冲区信息
dmesg

# 以人类可读的格式显示
dmesg -H

# 显示带时间戳的信息
dmesg -T

# 只显示错误和警告信息
dmesg --level=err,warn
```


