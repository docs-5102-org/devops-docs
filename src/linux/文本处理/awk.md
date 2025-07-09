---
title: awk命令
category:
  - Linux
  - 文本处理
tag:
  - awk
  - 文本处理
  - 数据分析
date: 2022-08-01

---

# awk命令

## 简介

AWK是一个强大的文本分析工具，相对于grep的查找，sed的编辑，awk在其对数据分析并生成报告时，显得尤为强大。简单来说awk就是把文件逐行的读入，以空格为默认分隔符将每行切片，切开的部分再进行各种分析处理。

awk是一种编程语言，用于在linux/unix下对文本和数据进行处理。数据可以来自标准输入、一个或多个文件，或其它命令的输出。它支持用户自定义函数和动态正则表达式等先进功能，是linux/unix下的一个强大编程工具。它在命令行中使用，但更多是作为脚本来使用。

### 工作原理

awk的处理文本和数据的方式：它逐行扫描文件，从第一行到最后一行，寻找匹配的特定模式的行，并在这些行上进行你想要的操作。如果没有指定处理动作，则把匹配的行显示到标准输出(屏幕)，如果没有指定模式，则所有被操作所指定的行都被处理。

### 版本说明

- **AWK**: 原始版本
- **NAWK**: New AWK，改进版本
- **GAWK**: GNU AWK，GNU版本，提供了Bell实验室和GNU的一些扩展

awk分别代表其作者姓氏的第一个字母。因为它的作者是三个人，分别是Alfred Aho、Brian Kernighan、Peter Weinberger。在linux系统中已把awk链接到gawk，所以下面全部以awk进行介绍。

## 使用方法

### 基本语法

```bash
awk '{pattern + action}' filenames
```

尽管操作可能会很复杂，但语法总是这样，其中pattern表示AWK在数据中查找的内容，而action是在找到匹配内容时所执行的一系列命令。花括号（{}）不需要在程序中始终出现，但它们用于根据特定的模式对一系列指令进行分组。pattern就是要表示的正则表达式，用斜杠括起来。

### 调用方式

awk有三种调用方式：

#### 1. 命令行方式
```bash
awk [options] 'script' var=value file(s)
awk [-F field-separator] 'commands' input-file(s)
```

#### 2. Shell脚本方式
将所有的awk命令插入一个文件，并使awk程序可执行，然后awk命令解释器作为脚本的首行：
```bash
#!/bin/awk
```

#### 3. 脚本文件方式
```bash
awk -f scriptfile var=value file(s)
awk -f awk-script-file input-file(s)
```

## 命令选项详解

| 选项 | 说明 |
|------|------|
| `-F fs` 或 `--field-separator fs` | 指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F: |
| `-v var=value` 或 `--asign var=value` | 赋值一个用户定义变量 |
| `-f scripfile` 或 `--file scriptfile` | 从脚本文件中读取awk命令 |
| `-mf nnn` 和 `-mr nnn` | 对nnn值设置内在限制，-mf选项限制分配给nnn的最大块数目；-mr选项限制记录的最大数目 |
| `-W compact` 或 `--compat` | 在兼容模式下运行awk |
| `-W copyleft` 或 `--copyleft` | 打印简短的版权信息 |
| `-W help` 或 `--help` | 打印全部awk选项和每个选项的简短说明 |
| `-W lint` 或 `--lint` | 打印不能向传统unix平台移植的结构的警告 |
| `-W posix` | 打开兼容模式 |
| `-W re-interval` 或 `--re-inerval` | 允许间隔正则表达式的使用 |
| `-W source program-text` | 使用program-text作为源代码，可与-f命令混用 |
| `-W version` 或 `--version` | 打印bug报告信息的版本 |

## 内置变量

### 基础变量

| 变量 | 说明 |
|------|------|
| `$0` | 完整的输入记录 |
| `$1, $2, ..., $n` | 当前记录的第n个字段，字段间由FS分隔 |
| `NF` | 当前记录中的字段数 |
| `NR` | 当前记录数 |
| `FNR` | 同NR，但相对于当前文件 |
| `FS` | 字段分隔符(默认是任何空格) |
| `OFS` | 输出字段分隔符(默认值是一个空格) |
| `RS` | 记录分隔符(默认是一个换行符) |
| `ORS` | 输出记录分隔符(默认值是一个换行符) |

### 高级变量

| 变量 | 说明 |
|------|------|
| `ARGC` | 命令行参数的数目 |
| `ARGV` | 包含命令行参数的数组 |
| `ARGIND` | 命令行中当前文件的位置(从0开始算) |
| `CONVFMT` | 数字转换格式(默认值为%.6g) |
| `ENVIRON` | 环境变量关联数组 |
| `ERRNO` | 最后一个系统错误的描述 |
| `FIELDWIDTHS` | 字段宽度列表(用空格键分隔) |
| `FILENAME` | 当前文件名 |
| `IGNORECASE` | 如果为真，则进行忽略大小写的匹配 |
| `OFMT` | 数字的输出格式(默认值是%.6g) |
| `RLENGTH` | 由match函数所匹配的字符串的长度 |
| `RSTART` | 由match函数所匹配的字符串的第一个位置 |
| `SUBSEP` | 数组下标分隔符(默认值是\034) |

## 运算符

| 运算符类型 | 运算符 | 说明 |
|------------|--------|------|
| 赋值运算符 | `= += -= *= /= %= ^= **=` | 赋值运算符 |
| 条件运算符 | `?:` | C条件表达式 |
| 逻辑运算符 | `\|\| && !` | 逻辑或、逻辑与、逻辑非 |
| 匹配运算符 | `~ !~` | 匹配正则表达式和不匹配正则表达式 |
| 关系运算符 | `< <= > >= != ==` | 关系运算符 |
| 算术运算符 | `+ - * / %` | 加、减、乘、除与求余 |
| 一元运算符 | `+ - !` | 一元加，减和逻辑非 |
| 递增递减 | `++ --` | 增加或减少，作为前缀或后缀 |

## 模式和操作

### 模式类型

1. **正则表达式**：使用通配符的扩展集
2. **关系表达式**：可以用关系运算符进行操作，可以是字符串或数字的比较
3. **模式匹配表达式**：用运算符~(匹配)和!~(不匹配)
4. **模式范围**：指定一个行的范围，语法不能包括BEGIN和END模式
5. **BEGIN**：让用户指定在第一条输入记录被处理之前所发生的动作
6. **END**：让用户在最后一条输入记录被读取之后发生的动作

### 操作类型

操作由一个或多个命令、函数、表达式组成，之间由换行符或分号隔开，并位于大括号内。主要有四部分：

1. 变量或数组赋值
2. 输出命令
3. 内置函数
4. 控制流命令

## 入门实例

### 基础用法示例

假设`last -n 5`的输出如下：
```
root     pts/1   192.168.1.100  Tue Feb 10 11:21   still logged in
root     pts/1   192.168.1.100  Tue Feb 10 00:46 - 02:28  (01:41)
root     pts/1   192.168.1.100  Mon Feb  9 11:41 - 18:30  (06:48)
dmtsai   pts/1   192.168.1.100  Mon Feb  9 11:41 - 11:41  (00:00)
root     tty1                   Fri Sep  5 14:09 - 14:10  (00:01)
```

显示最近登录的5个帐号：
```bash
last -n 5 | awk '{print $1}'
```

显示/etc/passwd的账户：
```bash
cat /etc/passwd | awk -F ':' '{print $1}'
```

显示账户和对应的shell，以tab分割：
```bash
cat /etc/passwd | awk -F ':' '{print $1"\t"$7}'
```

添加表头和表尾：
```bash
cat /etc/passwd | awk -F ':' 'BEGIN {print "name,shell"} {print $1","$7} END {print "blue,/bin/nosh"}'
```

## 记录和域

### 记录

awk把每一个以换行符结束的行称为一个记录。

- **记录分隔符**：默认的输入和输出的分隔符都是回车，保存在内建变量ORS和RS中
- **$0变量**：它指的是整条记录
- **变量NR**：一个计数器，每处理完一条记录，NR的值就增加1

### 域

记录中每个单词称做"域"，默认情况下以空格或tab分隔。awk可跟踪域的个数，并在内建变量NF中保存该值。

### 域分隔符

内建变量FS保存输入域分隔符的值，默认是空格或tab。我们可以通过-F命令行选项修改FS的值。

可以同时使用多个域分隔符：
```bash
awk -F'[: \t]' '{print $1,$3}' test
```

## print和printf

### print函数

print函数的参数可以是变量、数值或者字符串。字符串必须用双引号引用，参数用逗号分隔。如果没有逗号，参数就串联在一起而无法区分。

### printf函数

printf函数，其用法和c语言中printf基本相似，可以格式化字符串，输出复杂时，printf更加好用，代码更易懂。

示例：
```bash
awk -F ':' '{printf("filename:%10s,linenumber:%s,columns:%s,linecontent:%s\n",FILENAME,NR,NF,$0)}' /etc/passwd
```

## AWK编程

### 变量和赋值

除了awk的内置变量，awk还可以自定义变量。

统计/etc/passwd的账户人数：
```bash
awk '{count++;print $0;} END{print "user count is ", count}' /etc/passwd
```

更完整的版本：
```bash
awk 'BEGIN {count=0;print "[start]user count is ", count} {count=count+1;print $0;} END{print "[end]user count is ", count}' /etc/passwd
```

### 条件语句

awk中的条件语句借鉴于C语言：

```bash
if (expression) {
    statement;
}

if (expression) {
    statement1;
} else {
    statement2;
}

if (expression) {
    statement1;
} else if (expression1) {
    statement2;
} else {
    statement3;
}
```

示例 - 统计文件夹大小，过滤4096大小的文件：
```bash
ls -l | awk 'BEGIN {size=0;print "[start]size is ", size} {if($5!=4096){size=size+$5;}} END{print "[end]size is ", size/1024/1024,"M"}'
```

### 循环语句

awk支持while、do/while、for、break、continue等循环控制语句：

```bash
# while循环
awk '{ i=1;while(i<NF) {print NF,$i;i++}}' file

# for循环
awk '{ for(i=1;i<NF;i++) {print NF,$i}}' file
```

### 数组

awk中数组的下标可以是数字和字母，数组的下标通常被称为关键字(key)。

显示/etc/passwd的账户：
```bash
awk -F ':' 'BEGIN {count=0;} {name[count] = $1;count++;}; END{for (i = 0; i < NR; i++) print i, name[i]}' /etc/passwd
```

## 正则表达式

### 基本正则表达式

awk支持扩展的正则表达式，可以用于模式匹配。

### gawk专用正则表达式元字符

以下几个是gawk专用的，不适合unix版本的awk：

| 元字符 | 说明 |
|--------|------|
| `\y` | 匹配一个单词开头或者末尾的空字符串 |
| `\B` | 匹配单词内的空字符串 |
| `\<` | 匹配一个单词的开头的空字符串，锚定开始 |
| `\>` | 匹配一个单词的末尾的空字符串，锚定末尾 |
| `\w` | 匹配一个字母数字组成的单词 |
| `\W` | 匹配一个非字母数字组成的单词 |
| `\'` | 匹配字符串开头的一个空字符串 |
| `\'` | 匹配字符串末尾的一个空字符串 |

## 实用示例集合

### 基础操作示例

```bash
# 1. 显示包含101的行
awk '/101/' file

# 2. 显示从101到105之间的行
awk '/101/,/105/' file

# 3. 第一个域等于5的行
awk '$1 == 5' file

# 4. 第一个域等于"CT"的行（注意引号）
awk '$1 == "CT"' file

# 5. 第一个域乘以第二个域大于100的行
awk '$1 * $2 >100 ' file

# 6. 第二个域大于5且小于等于15的行
awk '$2 >5 && $2<=15' file
```

### 格式化输出示例

```bash
# 显示记录号、域数和第一个、最后一个域
awk '{print NR,NF,$1,$NF,}' file

# 显示匹配行的第一、二个域加10
awk '/101/ {print $1,$2 + 10}' file

# 显示第一、二个域，域间无分隔符
awk '/101/ {print $1$2}' file
```

### 分隔符操作示例

```bash
# 使用"|"作为分隔符
awk -F "|" '{print $1}' file

# 使用多个分隔符
awk -F '[ :\t|]' '{print $1}' file

# 使用环境变量作为分隔符
Sep="|"
awk -F $Sep '{print $1}' file

# 使用方括号作为分隔符
awk -F '[\[\]]' '{print $1}' file
```

### 高级应用示例

```bash
# 取得文件第一个域的最大值
awk 'BEGIN { max=100 ;print "max=" max} {max=($1 >max ?$1:max); print $1,"Now max is "max}' file

# 统计包含tom的行数
awk '/tom/ {count++;} END {print "tom was found "count" times"}' file

# 条件统计和输出到文件
awk 'gsub(/\$/,"");gsub(/,/,""); cost+=$4; END {print "The total is $" cost>"filename"}' file

# 交互输入
awk 'BEGIN {system("echo \"Input your name:\\c\""); getline d;print "\nYour name is",d,"\b!\n"}'

# 读取系统文件
awk 'BEGIN {FS=":"; while(getline< "/etc/passwd" >0) { if($1~"050[0-9]_") print $1}}'
```

### 实用工具示例

```bash
# 返回目标的第一行
pgrep -f java | awk 'NR==1'

# 返回目标的第一列
pgrep -f java | awk '{print $1}'

# 显示文件全路径
type file | awk -F "/" '{ for(i=1;i<NF;i++) { if(i==NF-1) { printf "%s",$i } else { printf "%s/",$i } }}'

# 日期显示
awk 'BEGIN { 
for(j=1;j<=12;j++) { 
    flag=0; 
    printf "\n%d月份\n",j; 
    for(i=1;i<=31;i++) { 
        if (j==2&&i>28) flag=1; 
        if ((j==4||j==6||j==9||j==11)&&i>30) flag=1; 
        if (flag==0) {printf "%02d%02d ",j,i} 
    } 
} }'
```

## 高级特性

### 匹配操作符(~)

用来在记录或者域内匹配正则表达式：
```bash
awk '$1 ~/^root/' test  # 显示第一列以root开头的行
```

### 比较表达式

条件表达式语法：`condition ? expression1 : expression2`

```bash
awk '{max = ($1 > $3) ? $1: $3; print max}' test
awk '$1 + $2 < 100' test
awk '$1 > 5 && $2 < 10' test
```

### 范围模板

范围模板匹配从第一个模板的第一次出现到第二个模板的第一次出现之间所有行：
```bash
awk '/root/,/mysql/' test  # 显示从root到mysql之间的所有行
```

### 系统变量调用

在awk中调用系统变量必须用单引号：
```bash
Flag=abcd
awk '{print '$Flag'}'     # 结果为abcd
awk '{print "$Flag"}'     # 结果为$Flag
```

## 最佳实践

1. **合理使用分隔符**：根据数据格式选择合适的分隔符
2. **善用内置变量**：熟练使用NR、NF、FS等变量简化操作
3. **模式匹配优化**：使用合适的正则表达式提高匹配效率
4. **代码可读性**：复杂操作时使用脚本文件而非命令行
5. **性能考虑**：大文件处理时注意内存使用和处理效率

## 总结

AWK是一个功能强大的文本处理工具，它不仅可以进行简单的文本提取和格式化，还支持复杂的编程逻辑。掌握AWK的基本语法、内置变量、模式匹配和编程特性，可以大大提高文本处理的效率。通过大量的实例练习，可以更好地理解和应用AWK的各种功能。

更多详细信息请参考：[GNU AWK用户指南](http://www.gnu.org/software/gawk/manual/gawk.html)
