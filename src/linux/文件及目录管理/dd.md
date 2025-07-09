---
title: dd
category:
  - Linux
tag:
  - dd
date: 2022-07-23
---

# Linux dd命令完全指南

## 目录
1. [dd命令基础](#dd命令基础)
2. [性能优化策略](#性能优化策略)
3. [常见使用场景](#常见使用场景)
4. [参数详解](#参数详解)
5. [实战示例](#实战示例)
6. [故障排除](#故障排除)

## dd命令基础

### 什么是dd命令
dd（Data Duplicator）是Linux系统中用于复制和转换数据的强大工具，可以在文件、设备、分区之间进行数据传输。

### 基本语法
```bash
dd if=输入源 of=输出目标 [选项]
```

### 核心概念
- **if**（input file）：输入源
- **of**（output file）：输出目标  
- **bs**（block size）：块大小
- **count**：复制的块数量

## 性能优化策略

### 1. 块大小优化

| 块大小 | 适用场景 | 性能特点 |
|--------|----------|----------|
| `1K-4K` | 小文件处理 | 系统调用频繁，速度慢 |
| `64K-1M` | 一般用途 | 平衡性能和内存使用 |
| `4M-16M` | 大文件处理 | 高性能，需要更多内存 |

```bash
# 性能对比示例
dd if=/dev/zero of=test_1k bs=1K count=100000    # 慢
dd if=/dev/zero of=test_1m bs=1M count=100       # 快
dd if=/dev/zero of=test_4m bs=4M count=25        # 更快
```

### 2. 写入策略优化

```bash
# 基础写入
dd if=/dev/zero of=file bs=1M count=100

# 异步写入（默认）
dd if=/dev/zero of=file bs=1M count=100 conv=notrunc

# 同步写入（确保数据落盘）
dd if=/dev/zero of=file bs=1M count=100 conv=fsync

# 直接I/O（绕过系统缓存）
dd if=/dev/zero of=file bs=1M count=100 iflag=direct oflag=direct
```

## 常见使用场景

### 1. 创建测试文件

```bash
# 创建100MB测试文件
dd if=/dev/zero of=/tmp/test.file bs=1M count=100 status=progress

# 创建随机数据文件
dd if=/dev/urandom of=/tmp/random.file bs=1M count=10 status=progress

# 创建稀疏文件（fallocate替代）
fallocate -l 1G /tmp/sparse.file
```

### 2. 磁盘性能测试

```bash
# 测试写入性能
dd if=/dev/zero of=/tmp/test bs=1M count=1000 conv=fsync status=progress

# 测试读取性能  
dd if=/tmp/test of=/dev/null bs=1M status=progress

# 测试随机读写性能
dd if=/dev/urandom of=/tmp/random bs=1M count=100 status=progress
```

### 3. 设备备份与克隆

```bash
# 完整磁盘备份
dd if=/dev/sda of=/backup/disk.img bs=4M status=progress

# MBR备份
dd if=/dev/sda of=/backup/mbr.img bs=512 count=1

# 分区克隆
dd if=/dev/sda1 of=/dev/sdb1 bs=4M status=progress
```

### 4. ISO镜像处理

```bash
# 制作ISO镜像
dd if=/dev/cdrom of=/tmp/cd.iso bs=2048 status=progress

# 写入ISO到U盘
dd if=/tmp/ubuntu.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

## 参数详解

### 输入输出参数
| 参数 | 说明 | 示例 |
|------|------|------|
| `if=FILE` | 输入文件/设备 | `if=/dev/zero`, `if=input.txt` |
| `of=FILE` | 输出文件/设备 | `of=output.txt`, `of=/dev/sdb` |
| `bs=BYTES` | 块大小 | `bs=1M`, `bs=4096` |
| `count=N` | 复制块数 | `count=100` |
| `skip=N` | 跳过输入的前N块 | `skip=10` |
| `seek=N` | 跳过输出的前N块 | `seek=5` |

### 转换参数
| 参数 | 说明 | 用途 |
|------|------|------|
| `conv=sync` | 用NUL填充输入块 | 确保块大小一致 |
| `conv=fsync` | 强制写入磁盘 | 确保数据安全 |
| `conv=notrunc` | 不截断输出文件 | 部分覆盖文件 |
| `conv=noerror` | 遇到错误继续 | 数据恢复场景 |

### 标志参数
| 参数 | 说明 | 效果 |
|------|------|------|
| `iflag=direct` | 输入直接I/O | 绕过读缓存 |
| `oflag=direct` | 输出直接I/O | 绕过写缓存 |
| `iflag=fullblock` | 强制读取完整块 | 避免短读 |
| `status=progress` | 显示进度 | 实时监控 |

## 实战示例

### 简单示例

在`/tmp`目录产生了一个100M的测试文件test.iso。

```bash
dd if=/dev/zero of=/tmp/test.iso bs=1K count=100000
```
> 改变count大小，就可以调整产生的文件大小了。

### 快速文件生成脚本

```bash
#!/bin/bash
# 快速生成测试文件

create_test_file() {
    local size=$1
    local filename=$2
    local unit=${size: -1}
    local number=${size%?}
    
    case $unit in
        K|k) bs="1K"; count=$number ;;
        M|m) bs="1M"; count=$number ;;
        G|g) bs="1M"; count=$((number * 1024)) ;;
        *) echo "错误: 不支持的单位"; exit 1 ;;
    esac
    
    echo "创建 $size 文件: $filename"
    dd if=/dev/zero of="$filename" bs=$bs count=$count status=progress
}

# 使用示例
create_test_file "100M" "test_100m.file"
create_test_file "1G" "test_1g.file"
```

### 磁盘性能测试脚本

```bash
#!/bin/bash
# 磁盘性能测试

test_disk_performance() {
    local test_file="/tmp/disk_test_$$"
    local size_mb=1000
    
    echo "=== 磁盘性能测试 ==="
    
    # 写入测试
    echo "1. 写入性能测试..."
    write_start=$(date +%s.%N)
    dd if=/dev/zero of="$test_file" bs=1M count=$size_mb conv=fsync 2>/dev/null
    write_end=$(date +%s.%N)
    write_time=$(echo "$write_end - $write_start" | bc)
    write_speed=$(echo "scale=2; $size_mb / $write_time" | bc)
    
    # 读取测试
    echo "2. 读取性能测试..."
    read_start=$(date +%s.%N)
    dd if="$test_file" of=/dev/null bs=1M 2>/dev/null
    read_end=$(date +%s.%N)
    read_time=$(echo "$read_end - $read_start" | bc)
    read_speed=$(echo "scale=2; $size_mb / $read_time" | bc)
    
    echo "=== 测试结果 ==="
    echo "写入速度: ${write_speed} MB/s"
    echo "读取速度: ${read_speed} MB/s"
    
    # 清理
    rm -f "$test_file"
}

test_disk_performance
```

### 安全擦除脚本

```bash
#!/bin/bash
# 安全擦除磁盘数据

secure_wipe() {
    local device=$1
    
    if [[ ! -b "$device" ]]; then
        echo "错误: $device 不是有效的块设备"
        exit 1
    fi
    
    echo "警告: 将完全擦除 $device 上的所有数据"
    read -p "确认继续? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        echo "操作已取消"
        exit 0
    fi
    
    echo "开始安全擦除..."
    
    # 第一遍: 写入零
    echo "第1遍: 写入零..."
    dd if=/dev/zero of="$device" bs=1M status=progress
    
    # 第二遍: 写入随机数据
    echo "第2遍: 写入随机数据..."
    dd if=/dev/urandom of="$device" bs=1M status=progress
    
    # 第三遍: 再次写入零
    echo "第3遍: 写入零..."
    dd if=/dev/zero of="$device" bs=1M status=progress
    
    echo "安全擦除完成"
}

# 使用示例（危险操作，请谨慎使用）
# secure_wipe /dev/sdX
```

## 故障排除

### 常见错误与解决方案

#### 1. 权限不足
```bash
# 错误信息
dd: failed to open '/dev/sda': Permission denied

# 解决方案
sudo dd if=/dev/zero of=/dev/sda bs=1M count=1
```

#### 2. 磁盘空间不足
```bash
# 错误信息
dd: error writing 'output.file': No space left on device

# 解决方案
df -h  # 检查磁盘空间
du -sh output.file  # 检查文件大小
```

#### 3. 设备忙碌
```bash
# 错误信息
dd: failed to open '/dev/sda': Device or resource busy

# 解决方案
lsof | grep /dev/sda  # 查看占用进程
umount /dev/sda1      # 卸载分区
```

#### 4. 输入/输出错误
```bash
# 使用错误继续选项
dd if=/dev/sda of=/backup/disk.img bs=4M conv=noerror,sync status=progress
```

### 性能调优建议

1. **选择合适的块大小**
   - 一般情况下，1M-4M是较好的选择
   - SSD可以使用更大的块大小（8M-16M）
   - 网络传输建议使用较小的块（64K-1M）

2. **使用状态监控**
   - 总是添加 `status=progress` 参数
   - 大文件操作时使用 `pv` 命令监控

3. **考虑直接I/O**
   - 大文件传输时使用 `iflag=direct oflag=direct`
   - 避免系统缓存影响

4. **合理使用同步**
   - 重要数据使用 `conv=fsync`
   - 临时文件可以省略同步以提高速度

## 高级技巧

### 1. 进度监控增强
```bash
# 使用pv命令增强进度显示
dd if=/dev/zero bs=1M count=1000 | pv | dd of=/tmp/test bs=1M

# 实时监控dd进程
watch -n 1 'kill -USR1 $(pgrep dd)'
```

### 2. 网络传输
```bash
# 通过网络传输磁盘镜像
dd if=/dev/sda bs=1M | gzip | ssh user@remote 'gunzip | dd of=/dev/sdb bs=1M'
```

### 3. 分割大文件
```bash
# 创建分割的备份文件
dd if=/dev/sda bs=1M | split -b 1G - disk_backup_part_
```

通过掌握这些dd命令的技巧和最佳实践，您可以高效地处理各种数据复制、备份和测试任务。记住始终要谨慎操作，特别是在处理重要数据时。
