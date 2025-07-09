---
title: tar、gzip、bzip2、zip命令
# icon: file-zipper
order: 2
category:
  - Linux
  - 文件管理
tag:
  - tar
  - gzip
  - bzip2
  - zip
  - 压缩
  - 解压
date: 2022-07-28
---

# 压缩解压命令完整指南

## 目录
- [tar 格式](#tar-格式)
- [gzip 格式](#gzip-格式)
- [bzip2 格式](#bzip2-格式)
- [compress 格式](#compress-格式)
- [zip 格式](#zip-格式)
- [rar 格式](#rar-格式)
- [7z 格式](#7z-格式)
- [其他格式](#其他格式)
- [实用技巧](#实用技巧)

## tar 格式

### .tar (打包，不压缩)
```bash
# 打包
tar -cvf archive.tar directory/
tar -cvf archive.tar file1 file2 file3

# 解包
tar -xvf archive.tar

# 查看内容
tar -tvf archive.tar
```

### .tar.gz / .tgz (打包 + gzip压缩)
```bash
# 压缩
tar -zcvf archive.tar.gz directory/
tar -zcvf archive.tgz directory/

# 解压
tar -zxvf archive.tar.gz
tar -zxvf archive.tgz

# 查看内容
tar -ztvf archive.tar.gz
```

### .tar.bz2 (打包 + bzip2压缩)
```bash
# 压缩
tar -jcvf archive.tar.bz2 directory/

# 解压
tar -jxvf archive.tar.bz2

# 查看内容
tar -jtvf archive.tar.bz2
```

### .tar.xz (打包 + xz压缩)
```bash
# 压缩
tar -Jcvf archive.tar.xz directory/

# 解压
tar -Jxvf archive.tar.xz

# 查看内容
tar -Jtvf archive.tar.xz
```

## gzip 格式

### .gz
```bash
# 压缩（原文件会被删除）
gzip filename

# 压缩并保留原文件
gzip -c filename > filename.gz

# 解压
gunzip filename.gz
# 或
gzip -d filename.gz

# 查看压缩文件信息
gzip -l filename.gz
```

## bzip2 格式

### .bz2
```bash
# 压缩
bzip2 filename
# 或
bzip2 -z filename

# 解压
bunzip2 filename.bz2
# 或
bzip2 -d filename.bz2

# 查看压缩文件信息
bzip2 -l filename.bz2
```

## compress 格式

### .Z
```bash
# 压缩
compress filename

# 解压
uncompress filename.Z

# 查看内容
zcat filename.Z
```

### .tar.Z
```bash
# 压缩
tar -Zcvf archive.tar.Z directory/

# 解压
tar -Zxvf archive.tar.Z
```

## zip 格式

### .zip
```bash
# 压缩文件
zip archive.zip file1 file2 file3

# 压缩目录
zip -r archive.zip directory/

# 解压
unzip archive.zip

# 解压到指定目录
unzip archive.zip -d /path/to/destination/

# 查看内容
unzip -l archive.zip
```

## rar 格式

### .rar
```bash
# 压缩
rar a archive.rar file1 file2 file3
rar a -r archive.rar directory/

# 解压
rar x archive.rar
# 或
unrar x archive.rar

# 查看内容
rar l archive.rar
```

**注意**: 需要安装 rar 工具
```bash
# CentOS/RHEL
yum install rar unrar

# Ubuntu/Debian
apt-get install rar unrar-free
```

## 7z 格式

### .7z
```bash
# 压缩
7z a archive.7z file1 file2 file3
7z a archive.7z directory/

# 解压
7z x archive.7z

# 查看内容
7z l archive.7z
```

## 其他格式

### .lha / .lzh
```bash
# 压缩
lha -a archive.lha filename

# 解压
lha -e archive.lha
```

### .rpm (Red Hat 包)
```bash
# 解包
rpm2cpio package.rpm | cpio -div
```

### .deb (Debian 包)
```bash
# 解包
ar p package.deb data.tar.gz | tar zxf -
```

## 实用技巧

### tar 常用选项说明
- `-c`: 创建归档
- `-x`: 提取归档
- `-v`: 显示详细信息
- `-f`: 指定归档文件名
- `-z`: 使用gzip压缩
- `-j`: 使用bzip2压缩
- `-J`: 使用xz压缩
- `-t`: 查看归档内容

### 排除文件/目录
```bash
# 排除特定目录
tar -zcvf backup.tar.gz --exclude=/path/to/exclude directory/

# 排除多个目录
tar -zcvf backup.tar.gz \
    --exclude=/path/to/exclude1 \
    --exclude=/path/to/exclude2 \
    directory/

# 排除特定文件类型
tar -zcvf backup.tar.gz --exclude='*.log' directory/
```

### 压缩时不包含父目录
```bash
# 进入目录后压缩
cd /path/to/directory
tar -zcvf ../archive.tar.gz ./*

# 或使用 -C 选项
tar -zcvf archive.tar.gz -C /path/to/directory .
```

### 查看压缩比
```bash
# gzip 文件
gzip -l filename.gz

# bzip2 文件  
bzip2 -l filename.bz2

# tar 包大小对比
ls -lh original_directory/
ls -lh archive.tar.gz
```

### 解压到指定目录
```bash
# tar 包
tar -zxvf archive.tar.gz -C /path/to/destination/

# zip 包
unzip archive.zip -d /path/to/destination/
```

### 压缩级别控制
```bash
# gzip 压缩级别 (1-9，9为最高压缩)
gzip -9 filename          # 最高压缩
gzip -1 filename          # 最快压缩

# tar.gz 压缩级别
tar -zcvf archive.tar.gz directory/
GZIP=-9 tar -zcvf archive.tar.gz directory/  # 最高压缩
```

### 多文件批量操作
```bash
# 批量压缩当前目录所有文件
for file in *; do gzip "$file"; done

# 批量解压所有 .gz 文件
for file in *.gz; do gunzip "$file"; done
```

### 实用别名设置
```bash
# 添加到 ~/.bashrc
alias ll='ls -la'
alias extract='tar -zxvf'
alias compress='tar -zcvf'
```