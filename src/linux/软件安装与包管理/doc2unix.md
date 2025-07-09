---
title: doc2unix
category:
  - Linux
tag:
  - doc2unix
date: 2022-09-18
---

# dos2unix 完整使用指南

## 概述

dos2unix 是一个用于转换文本文件行尾符的实用工具。它可以将 DOS/Windows 格式的文本文件（使用 CRLF `\r\n` 作为行尾符）转换为 Unix/Linux 格式（使用 LF `\n` 作为行尾符），反之亦然。

## 背景知识

不同操作系统使用不同的行尾符：
- **Unix/Linux/macOS**: LF (`\n`)
- **Windows/DOS**: CRLF (`\r\n`)
- **经典 Mac**: CR (`\r`)

这种差异经常导致跨平台文件传输和处理时出现问题。

## 安装方法

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install dos2unix
```

### CentOS/RHEL/Fedora
```bash
# CentOS/RHEL
sudo yum install dos2unix
# 或者在较新版本中
sudo dnf install dos2unix

# Fedora
sudo dnf install dos2unix
```

### macOS
```bash
# 使用 Homebrew
brew install dos2unix

# 使用 MacPorts
sudo port install dos2unix
```

### Windows
```bash
# 使用 Chocolatey
choco install dos2unix

# 使用 Scoop
scoop install dos2unix
```

### 从源码编译
```bash
wget http://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.3.tar.gz
tar -xzf dos2unix-7.4.3.tar.gz
cd dos2unix-7.4.3
make
sudo make install
```

## 基本语法

```bash
dos2unix [选项] 文件名...
unix2dos [选项] 文件名...
```

## 常用选项

| 选项 | 说明 |
|------|------|
| `-k` | 保持文件的时间戳不变 |
| `-q` | 安静模式，不显示处理信息 |
| `-v` | 详细模式，显示详细处理信息 |
| `-n` | 新文件模式，不修改原文件 |
| `-o` | 覆盖只读文件 |
| `-b` | 创建备份文件 |
| `-f` | 强制转换二进制文件 |
| `-h` | 显示帮助信息 |
| `-V` | 显示版本信息 |

## 使用场景

### 1. 基本文件转换

**将 Windows 格式文件转换为 Unix 格式：**
```bash
dos2unix filename.txt
```

**将 Unix 格式文件转换为 Windows 格式：**
```bash
unix2dos filename.txt
```

### 2. 批量转换文件

**转换当前目录下的所有 .txt 文件：**
```bash
dos2unix *.txt
```

**递归转换目录下的所有文件：**
```bash
find /path/to/directory -type f -name "*.txt" -exec dos2unix {} \;
```

**转换多个特定文件：**
```bash
dos2unix file1.txt file2.py file3.sh
```

### 3. 保持文件时间戳

```bash
dos2unix -k filename.txt
```

### 4. 创建新文件而不修改原文件

```bash
dos2unix -n oldfile.txt newfile.txt
```

### 5. 创建备份文件

```bash
dos2unix -b filename.txt
# 这会创建 filename.txt.bak 备份文件
```

### 6. 安静模式处理

```bash
dos2unix -q *.txt
```

### 7. 处理不同编码的文件

**转换 UTF-8 文件：**
```bash
dos2unix -c UTF-8 filename.txt
```

**从 ISO-8859-1 转换为 UTF-8：**
```bash
dos2unix -c ISO-8859-1 -n input.txt output.txt
```

### 8. 脚本中的批量处理

```bash
#!/bin/bash
# 批量转换脚本

# 转换所有源代码文件
for ext in c cpp h py java js; do
    find . -name "*.$ext" -type f -exec dos2unix {} \;
done

echo "所有源代码文件已转换完成"
```

### 9. 检查文件格式

```bash
# 使用 file 命令检查文件格式
file filename.txt

# 使用 hexdump 查看行尾符
hexdump -C filename.txt | head
```

### 10. 处理特殊情况

**强制转换二进制文件（不推荐）：**
```bash
dos2unix -f binaryfile.dat
```

**覆盖只读文件：**
```bash
dos2unix -o readonly.txt
```

## 实际应用案例

### 案例 1: Web 开发项目迁移

当将 Windows 开发的项目迁移到 Linux 服务器时：

```bash
# 转换所有 Web 相关文件
find /var/www/html -type f \( -name "*.html" -o -name "*.css" -o -name "*.js" -o -name "*.php" \) -exec dos2unix {} \;
```

### 案例 2: 脚本执行问题修复

Linux 下 shell 脚本出现执行错误，可能是行尾符问题：

```bash
dos2unix myscript.sh
chmod +x myscript.sh
./myscript.sh
```

### 案例 3: 配置文件处理

```bash
# 处理配置文件
dos2unix /etc/myapp/config.conf

# 保持时间戳并创建备份
dos2unix -kb /etc/myapp/config.conf
```

### 案例 4: 开发环境统一

```bash
#!/bin/bash
# 项目初始化脚本

echo "统一项目文件格式..."

# 转换源代码文件
find src/ -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" \) -exec dos2unix -k {} \;

# 转换文档文件
find docs/ -type f \( -name "*.txt" -o -name "*.md" \) -exec dos2unix -k {} \;

# 转换配置文件
dos2unix -k config/*.conf

echo "格式统一完成"
```

## 注意事项

1. **备份重要文件**: 在转换重要文件前，建议先创建备份
2. **二进制文件**: 避免对二进制文件使用 dos2unix，可能导致文件损坏
3. **权限问题**: 确保有足够权限修改目标文件
4. **批量操作**: 大批量操作前建议先测试小范围文件
5. **编码问题**: 注意文件的字符编码，必要时指定正确的编码

## 相关工具

- `unix2dos`: dos2unix 的反向操作
- `fromdos`/`todos`: 某些系统中的别名
- `tr`: 可用于简单的行尾符转换
- `sed`: 也可用于行尾符处理

## 故障排除

### 常见错误及解决方法

**1. 权限被拒绝**
```bash
sudo dos2unix filename.txt
# 或者
chmod 644 filename.txt && dos2unix filename.txt
```

**2. 文件格式检测**
```bash
# 检查文件是否包含 Windows 行尾符
grep -P '\r$' filename.txt
```

**3. 批量检查行尾符格式**
```bash
#!/bin/bash
for file in *.txt; do
    if grep -q $'\r' "$file"; then
        echo "$file: DOS 格式"
    else
        echo "$file: Unix 格式"
    fi
done
```

## 总结

dos2unix 是处理跨平台文本文件兼容性问题的重要工具。掌握其基本用法和常见场景，可以有效解决开发和运维中遇到的行尾符问题。在使用时要注意文件备份和权限管理，确保数据安全。
