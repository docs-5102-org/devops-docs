---
title: cut命令-剪切文件
category:
  - Linux
  - 文本处理
tag:
  - cut
  - 文本处理
  - 命令行工具
date: 2022-08-03

---

# cut命令-剪切文件

`cut`命令是Linux系统中用于剪切文件中的行数据的工具，可以按列、字节或字符进行提取。它能够从一个文本文件或文本流中提取文本列，是文本处理中的重要工具。

## 命令格式

```bash
# 按字节提取
cut -b list [-n] [file ...]

# 按字符提取
cut -c list [file ...]

# 按字段提取
cut -f list [-d delim] [-s] [file ...]
```

## 参数说明

- `-b`：以字节为单位进行分割
- `-c`：以字符为单位进行分割
- `-d`：自定义分隔符，默认为制表符
- `-f`：与-d一起使用，指定显示哪个区域
- `-n`：取消分割多字节字符，仅和-b标志一起使用
- `-s`：不输出不包含分隔符的行

## 范围的表示方法

| 格式 | 说明 |
| --- | --- |
| N | 只有第N项 |
| N- | 从第N项一直到行尾 |
| N-M | 从第N项到第M项(包括M) |
| -M | 从一行的开始到第M项(包括M) |
| - | 从一行的开始到结束的所有项 |

## 按字节提取（-b选项）

按字节提取是最基本的用法，需要注意的是一个空格算一个字节，一个汉字通常算三个字节。

```bash
# 示例
$ date
2011年08月11日 星期四20:44:52 EDT

# 取前四个字节
$ date | cut -b 1-4
2011

# 一个汉字算三个字节
$ date | cut -b 1-7
2011年

# 多个定位之间用逗号隔开
$ date | cut -b 1-7,10
2011年8

# cut会先把-b后面所有的定位进行从小到大排序，然后再提取
$ date | cut -b 10,1-7
2011年8

# 负号的使用
$ date | cut -b -4      # 从第一个字节到第四个字节
2011
$ date | cut -b 4-      # 从第四个字节到行尾
1年08月11日 星期四21:05:30 EDT
```

### 多字节字符处理

当处理包含多字节字符（如中文）的文本时，使用`-b`选项可能会导致乱码，因为它会将多字节字符拆开。这时可以使用`-n`选项：

```bash
# 不使用-n选项，会出现乱码
$ cat chinese.txt | cut -b 2
�

# 使用-n选项，不会拆分多字节字符
$ cat chinese.txt | cut -nb 1,2,3
星
```

## 按字符提取（-c选项）

按字符提取指定文件的内容，中文字符和空格都算一个字符。

```bash
$ cut -c 1-4 /etc/passwd 
root 
bin: 
daem 
adm: 
lp:x 
sync 
shut 
halt 
mail 
……………省略部分输出信息………………
```

按字符提取相对比较简单，中文字符和空格都算一个字符。

```bash
$ date | cut -c 1-5
2011年
```

对于中文等多字节字符，使用`-c`选项比`-b`更合适：

```bash
$ cat chinese.txt
星期一
星期二
星期三
星期四

# 使用-c选项正确提取第三个字符
$ cut -c 3 chinese.txt
一
二
三
四

# 使用-b选项会出现乱码
$ cut -b 3 chinese.txt
�
�
�
�
```

## 按字段提取（-f选项）

按字段提取主要用于处理有固定分隔符的文本，如CSV文件、`/etc/passwd`文件等。

```bash
# 使用冒号作为分隔符，提取第1个字段
$ head -n5 /etc/passwd | cut -d : -f 1
root
bin
daemon
adm
lp

# 提取多个字段
$ head -n5 /etc/passwd | cut -d : -f 1,3-5
root:0:0:root
bin:1:1:bin
daemon:2:2:daemon
adm:3:4:adm
lp:4:7:lp

# 提取从开始到第2个字段
$ head -n5 /etc/passwd | cut -d : -f -2
root:x
bin:x
daemon:x
adm:x
lp:x
```

### 制表符和空格的处理

`-d`选项的默认分隔符是制表符。如果要以空格作为分隔符，可以这样：

```bash
$ cat text.txt | cut -d ' ' -f 1
```

注意：
1. `-d`选项只能设置一个字符作为分隔符
2. 如果文本中有多个连续空格，`cut`命令处理起来会比较麻烦

如何区分空格和制表符？可以使用`sed`命令：

```bash
$ sed -n l file.txt
this is tab\tfinish.$
this is several space      finish.$
```

制表符会显示为`\t`，而空格会原样显示。

## 实用示例

### 提取用户名和UID

```bash
$ cat /etc/passwd | cut -d: -f1,3
root:0
daemon:1
bin:2
...
```

### 提取IP地址的某一部分

```bash
$ echo "192.168.1.1" | cut -d. -f1,4
192.1
```

### 结合其他命令使用

```bash
# 查看系统中所有用户的登录shell
$ cat /etc/passwd | cut -d: -f1,7
root:/bin/bash
daemon:/usr/sbin/nologin
...

# 提取HTTP状态码
$ cat access.log | cut -d' ' -f9
200
404
500
...
```

## 注意事项和局限性

1. Cut命令不擅长处理多空格分隔的文本，因为它只能设置单个字符作为分隔符
2. 处理多字节字符（如中文）时，应优先使用`-c`选项而非`-b`选项
3. 如果需要更复杂的文本处理，可能需要结合`awk`或`sed`等工具使用

## 总结

Cut命令是Linux文本处理的基础工具之一，掌握它的用法可以帮助我们快速提取文本中的特定内容。虽然它有一些局限性，但在处理格式规范的文本时非常高效。对于更复杂的文本处理需求，可以考虑使用awk或sed等更强大的工具。 
