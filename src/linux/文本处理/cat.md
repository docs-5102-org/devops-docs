---
title: cat命令
category:
  - Linux
  - 命令帮助
tag:
  - cat
  - 文件查看
  - 文本处理
  - 清空文件
date: 2022-08-02

---

# cat命令-查看、创建和合并文件内容

`cat`命令是Linux系统中最常用的文本输出命令之一，名称来源于英文单词"concatenate"（连接）的缩写。它主要用于观看某个文件的内容，是Linux下的一个文本输出命令。

## 命令格式

```bash
cat [-AbeEnstTuv] [--help] [--version] fileName
```

## cat命令的三大功能

### 1. 一次显示整个文件
```bash
cat filename
```

### 2. 从键盘创建一个文件
```bash
cat > filename
```
注意：只能创建新文件，不能编辑已有文件。

### 3. 将几个文件合并为一个文件
```bash
cat file1 file2 > file
```

## 常用选项

| 选项 | 长选项 | 描述 |
|------|--------|------|
| `-n` | `--number` | 显示行号，包括空行（由1开始对所有输出的行数编号） |
| `-b` | `--number-nonblank` | 显示行号，但不包括空行（和-n相似，只不过对于空白行不编号） |
| `-s` | `--squeeze-blank` | 当遇到连续两行以上的空白行，就替换为一行空白行 |
| `-v` | `--show-nonprinting` | 显示非打印字符，使用`^`和`M-`符号 |
| `-E` | `--show-ends` | 在每行结束处显示`$`符号 |
| `-T` | `--show-tabs` | 将制表符显示为`^I` |
| `-A` | `--show-all` | 等同于`-vET`，显示所有控制字符 |
| | `--help` | 显示帮助信息 |
| | `--version` | 显示版本信息 |

## 基本使用示例

### 查看文件内容

```bash
# 显示整个文件内容
cat filename.txt

# 显示多个文件内容
cat file1.txt file2.txt

# 显示带行号的文件内容
cat -n filename.txt

# 显示非空行的行号
cat -b filename.txt

# 压缩连续空行
cat -s filename.txt
```

### 创建新文件

```bash
# 从键盘创建新文件（按Ctrl+D结束输入）
cat > newfile.txt
输入内容...
[Ctrl+D]

# 直接创建带内容的文件
cat > test.txt << EOF
这是测试内容
可以输入多行
EOF
```

### 合并文件

```bash
# 合并多个文件到一个新文件
cat file1.txt file2.txt > combined.txt

# 追加内容到现有文件
cat file3.txt >> combined.txt
```

## 经典范例

### 范例1：添加行号并输出到新文件
```bash
cat -n linuxfile1 > linuxfile2
```
把linuxfile1的档案内容加上行号后输入linuxfile2这个档案里。

### 范例2：合并文件并添加行号
```bash
cat -b linuxfile1 linuxfile2 >> linuxfile3
```
把linuxfile1和linuxfile2的档案内容加上行号（空白行不加）之后将内容附加到linuxfile3里。

### 范例3：清空文件内容
```bash
cat /dev/null > /etc/test.txt
```
此为清空/etc/test.txt档案内容。

- `cat /dev/null`：读取 `/dev/null` 的内容（空内容）
- `>` ：重定向操作符，将左边命令的输出重定向到右边的文件
- `log.out`：目标文件

#### 具体作用

1. **清空文件**：将 `log.out` 文件的内容完全清空，文件大小变为 0 字节
2. **保留文件**：与删除文件不同，文件本身仍然存在，只是内容被清空
3. **保持权限**：文件的权限、所有者等属性保持不变

#### /dev/null 说明

`/dev/null` 是Linux系统中的一个特殊设备文件，被称为"空设备"或"黑洞"：

- 读取它时返回空内容（EOF）
- 写入它的任何数据都会被丢弃
- 常用于丢弃不需要的输出


## Here Document（<<EOF）详解

### 什么是Here Document

在Linux shell脚本中经常见到类似于`cat << EOF`的语句：

```bash
cat << EOF
（内容）
EOF
```

**EOF是"end of file"的缩写**，表示文本结束符。但在这里EOF没有特殊含义，你可以使用任何标识符（如FOE、OOO、HHH等）。

### Here Document的常见用法

#### 1. 以EOF为输入结束标识
```bash
cat << EOF
这里是内容
可以有多行
EOF
```

#### 2. 创建文件并以EOF结束
```bash
cat > filename << EOF
文件内容
多行文本
EOF
```

#### 3. 结合重定向创建文件
```bash
cat << EOF > test.sh
#!/bin/bash
# Shell脚本内容
echo "Hello World"
EOF
```

### Here Document实用示例

#### 创建脚本文件
```bash
# 创建Shell脚本
cat << EOF > test.sh
#!/bin/bash
#you Shell script writes here.
EOF

# 查看创建的文件
cat test.sh
```

#### 追加内容到文件
```bash
# 追加内容到文件末尾
cat << EOF >> test.sh
echo "This is appended content"
EOF
```

#### 使用自定义标识符
```bash
# 使用HHH作为结束标识符
cat << HHH > iii.txt
这是第一行
这是第二行
这是第三行
HHH
```

#### 不同的写法
```bash
# 另一种写法
cat > test.sh << EOF
脚本内容
EOF
```

### 非脚本环境下的使用

在非脚本环境中，可以使用Ctrl+D来输出EOF标识：

```bash
cat > iii.txt
输入第一行内容
输入第二行内容
输入第三行内容
[Ctrl+D]
```

## 高级用法和技巧

### 使用管道

```bash
# 结合grep过滤内容
cat file.txt | grep "search_term"

# 结合more或less分页显示
cat large_file.txt | more
cat large_file.txt | less

# 结合sort排序
cat file.txt | sort

# 结合head显示前几行
cat file.txt | head -n 10
```

### 特殊字符显示

```bash
# 显示所有控制字符
cat -A filename.txt

# 显示制表符
cat -T filename.txt

# 显示行尾符号
cat -E filename.txt

# 显示非打印字符
cat -v filename.txt
```

### 文件操作技巧

```bash
# 复制文件内容
cat source.txt > destination.txt

# 合并并排序
cat file1.txt file2.txt | sort > sorted.txt

# 去除空行
cat -s file.txt

# 编号非空行
cat -b file.txt
```

## 实际应用场景

### 1. 查看配置文件
```bash
cat /etc/hosts
cat /etc/passwd
cat ~/.bashrc
```

### 2. 查看日志文件
```bash
cat /var/log/messages
cat /var/log/syslog
```

### 3. 创建临时脚本
```bash
cat > temp_script.sh << 'EOF'
#!/bin/bash
echo "Temporary script"
date
EOF
chmod +x temp_script.sh
```

### 4. 数据处理
```bash
# 合并CSV文件
cat file1.csv file2.csv > combined.csv

# 查看文件编码
cat -A file.txt | head -n 5
```

## 注意事项和最佳实践

1. **文件大小限制**：对于大文件，使用`cat`可能导致终端响应缓慢，建议使用`less`或`more`。

2. **文件覆盖警告**：使用`cat > file`会覆盖现有文件，使用`cat >> file`追加内容。

3. **二进制文件**：避免对二进制文件使用`cat`，可能导致终端显示异常。

4. **特殊字符**：处理包含特殊字符的文件时，使用`-v`选项查看不可见字符。

5. **权限问题**：确保对要读取的文件有读权限，对要写入的文件有写权限。

## 与其他命令的比较

- **less/more**: 提供分页功能，适合查看大文件
- **head/tail**: 只查看文件的开头或结尾部分
- **tac**: 按行反向显示文件内容（cat的反向）
- **nl**: 专门用于显示带行号的文件内容
- **grep**: 用于搜索文件内容中的特定模式

## 常见问题解决

### 显示乱码问题
```bash
# 检查文件编码
file filename.txt

# 转换编码后查看
iconv -f GBK -t UTF-8 filename.txt | cat
```

### 终端显示异常
```bash
# 重置终端
reset

# 或者使用
tput reset
```

### 查看二进制文件
```bash
# 使用hexdump查看二进制文件
hexdump -C binary_file

# 使用xxd查看
xxd binary_file
```

## 总结

`cat`命令是Linux系统中非常基础且重要的命令，掌握其用法对于日常的文件操作和系统管理都很有帮助。通过合理使用各种选项和技巧，可以大大提高工作效率。特别是Here Document的用法，在shell脚本编写中非常实用。

---

*关于">"、">>"、"<"、"<<"等重定向符号的详细说明，请查看bash相关文档。*
