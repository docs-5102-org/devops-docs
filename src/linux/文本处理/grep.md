---
title: grep命令
category:
  - Linux
  - 文本处理
tag:
  - grep
  - 文本搜索
  - 正则表达式
date: 2022-08-06

---

# grep命令

## 概述

grep命令来自英文词组global search regular expression and print out the line的缩写，意思是用于全面搜索的正则表达式，并将结果输出。

grep是一个强大的文本搜索工具，使用正则表达式在文件中查找模式或文本。它提供各种选项如大小写不敏感、计数匹配和列出文件名等功能。

## grep家族

grep家族由以下三个命令组成：

- **grep**: 标准搜索命令，支持基本正则表达式
- **egrep**: 扩展搜索命令，等价于 `grep -E`，支持扩展正则表达式
- **fgrep**: 快速搜索命令，等价于 `grep -F`，不支持正则表达式，直接按字符串内容匹配

## 命令格式

```bash
grep [options] 基本正则表达式 [filename]
```

这里基本正则表达式可以是字符串。

## 主要参数

### 常用选项

| 参数 | 功能描述 | 参数 | 功能描述 |
|------|----------|------|----------|
| `-c` | 只输出匹配行的计数 | `-o` | 显示匹配词距文件头部的偏移量 |
| `-i` | 不区分大小写(只适用于单字符) | `-q` | 静默执行模式 |
| `-h` | 查询多文件时不显示文件名 | `-r` | 递归搜索模式 |
| `-l` | 查询多文件时只输出包含匹配字符的文件名 | `-s` | 不显示没有匹配文本的错误信息 |
| `-n` | 显示匹配行及行号 | `-v` | 显示不包含匹配文本的所有行 |
| `-E` | 支持扩展正则表达式 | `-w` | 精准匹配整词 |
| `-F` | 匹配固定字符串的内容 | `-x` | 精准匹配整行 |
| `-b` | 显示匹配行距文件头部的偏移量 | | |

## 正则表达式主要参数

| 符号 | 功能描述 |
|------|----------|
| `\` | 忽略正则表达式中特殊字符的原有含义 |
| `^` | 匹配正则表达式的开始行 |
| `$` | 匹配正则表达式的结束行 |
| `\<` | 从匹配正则表达式的行开始 |
| `\>` | 到匹配正则表达式的行结束 |
| `[ ]` | 单个字符，如[A]即A符合要求 |
| `[ - ]` | 范围，如[A-Z]，即A、B、C一直到Z都符合要求 |
| `.` | 所有的单个字符 |
| `*` | 有字符，长度可以为0 |

## 基础使用示例

### 1. 基本搜索

```bash
# 搜索指定文件中包含某个关键词的内容行
grep root /etc/passwd

# 搜索指定文件中以某个关键词开头的内容行
grep ^root /etc/passwd

# 在文件中搜索"the"字符串，并显示行号
grep -n 'the' test.txt
```

### 2. 反向搜索

```bash
# 搜索不包含"the"字符串的内容，并显示行号
grep -vn 'the' test.txt

# 搜索指定文件中不包含某个关键词的内容行
grep -v nologin /etc/passwd
```

### 3. 忽略大小写

```bash
# 搜索"the"字符串，显示行号并忽略大小写
grep -in 'the' test.txt
```

### 4. 多文件搜索

```bash
# 搜索多个文件中包含某个关键词的内容行
grep linuxprobe /etc/passwd /etc/shadow

# 搜索多个文件中包含某个关键词的内容，不显示文件名称
grep -h linuxprobe /etc/passwd /etc/shadow
```

### 5. 计数和行号

```bash
# 显示指定文件中包含某个关键词的行数量
grep -c root /etc/passwd

# 搜索指定文件中包含某个关键词位置的行号及内容行
grep -n network anaconda-ks.cfg
```

## 正则表达式应用示例

### 1. 字符类匹配

```bash
# 搜索"oo"字符串，但排除"goo"
grep -n '[^g]oo' test.txt

# 搜索"oo"字符串，但排除oo之前的小写字母
grep -n '[^a-z]oo' test.txt

# 搜索有数字的一行
grep -n [0-9] test.txt
```

### 2. 行首行尾匹配

```bash
# 只列出行首的"the"，并忽略大小写
grep -ni ^the test.txt

# 搜索开头不是英文字母的语句
grep -n ^[^a-zA-Z] test.txt

# 找到结尾为"."的一行
grep -n '\.$' test.txt

# 显示行首不是4或8的行
grep "^[^48]" file.txt
```

### 3. 空行和重复字符

```bash
# 查找空白行
grep -n '^$' test.txt

# 查找两个以上的o
grep -n 'ooo*' test.txt

# 搜索指定文件中空行的数量
grep -c ^$ anaconda-ks.cfg
```

### 4. 复杂模式匹配

```bash
# 查找以g开头，并且以g结尾的字符串
grep -n 'g.*g' test.txt

# 显示以K开头，以D结尾的所有代码
grep "K...D" file.txt

# 显示头两个是大写字母，中间两个任意，并以C结尾的代码
grep "[A-Z][A-Z]..C" file.txt

# 查询所有以5开始以1996或1998结尾的所有记录
grep "5..199[68]" file.txt
```

## 高级功能示例

### 1. 递归搜索

```bash
# 在目录及其子目录中搜索字符串
grep Aug -R /var/log/*

# 不仅搜索指定目录，还搜索其内子目录内是否有关键词文件
grep -srl root /etc
```

### 2. 精确匹配

```bash
# 精确匹配只含有"48"字符串的行
grep "48\>" file.txt

# 搜索指定文件中精准匹配到某个关键词的内容行
grep -x cdrom anaconda-ks.cfg

# 精准匹配整词
grep -w "word" file.txt
```

### 3. 扩展正则表达式

```bash
# 抽取代码为484和483的城市位置
grep -E "48[3|4]\>" file.txt

# 显示含有九月份的行
grep -E "[Ss]ept" file.txt
```

### 4. 静默模式和状态判断

```bash
# 判断指定文件中是否包含某个关键词，通过返回状态值输出结果
# 0为包含，1为不包含
grep -q linuxprobe anaconda-ks.cfg
echo $?
```

### 5. 文件列表和错误处理

```bash
# 搜索当前工作目录中包含某个关键词内容的文件，未找到则提示
grep -l root *

# 搜索当前工作目录中包含某个关键词内容的文件，未找到也不提示
grep -sl root *
```

## 实际应用场景

### 1. 日志分析

```bash
# 在系统日志中查找包含"Aug"的条目
grep Aug /var/log/messages

# 查找以"Aug"开始的日志条目
grep ^Aug /var/log/messages

# 选择包含数字的日志行
grep [0-9] /var/log/messages
```

### 2. 系统管理

```bash
# 查找系统用户信息
grep root /etc/passwd

# 查找特定服务配置
grep Port /etc/ssh/sshd_config

# 查找网络配置
grep network anaconda-ks.cfg
```

### 3. 代码搜索

```bash
# 在代码中搜索函数定义
grep -n "function.*(" *.js

# 搜索特定的错误模式
grep -i "error\|warning" logfile.txt

# 递归搜索代码目录中的特定模式
grep -r "TODO" /path/to/code/
```

## 与其他命令的组合使用

### 1. 与管道结合

```bash
# 显示/etc/passwd文件，并且打印行号，同时去掉2至5行
nl /etc/passwd | sed '2,5d'

# 根据使用频率列举Shell历史记录中的命令
history | awk '{print $2}' | awk 'BEGIN{FS="|"}{print $1}' | sort | uniq -c | sort -n
```

### 2. 与awk结合

```bash
# 只显示/etc/passwd文件的用户名和UID，且UID小于10
cat /etc/passwd | awk 'BEGIN {FS=":"} $3 < 10 {print $1 "\t " $3}'

# 显示所有登录用户，并显示登录用户的所在行数和列数
last | awk '{print $1 "\t lines: " NR "\t columes: " NF}'
```

## 性能和最佳实践

1. **使用-F选项进行字符串匹配**: 当搜索固定字符串时，使用`grep -F`比正则表达式更快
2. **合理使用-q选项**: 在脚本中只需要知道是否匹配时，使用静默模式提高效率
3. **递归搜索时使用-r**: 避免手动遍历目录结构
4. **组合使用选项**: 如`grep -rni`可以递归搜索、忽略大小写并显示行号

## 常见错误和解决方案

1. **特殊字符转义**: 记住使用反斜杠转义特殊字符
2. **大小写敏感**: 使用`-i`选项忽略大小写
3. **整词匹配**: 使用`-w`选项避免部分匹配
4. **文件权限**: 确保有足够权限访问要搜索的文件

## 总结

grep命令是Linux用户高效处理文本相关任务的重要工具。掌握grep可以增强你在Linux环境中处理文本数据的能力。无论是系统管理、日志分析还是代码搜索，grep都是不可或缺的工具。通过掌握其各种选项和正则表达式的使用，可以大大提高文本处理的效率。
