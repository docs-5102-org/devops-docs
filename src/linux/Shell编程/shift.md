---
title: shift命令详解
category:
  - Linux
  - Shell编程
tag:
  - Shell脚本
  - 参数处理
date: 2022-07-15

---

# shift命令详解

## 简介

`shift`命令是Shell脚本中用于参数处理的内置命令，它可以将位置参数左移指定的数量，使得脚本能够依次处理多个命令行参数。这个命令在处理不定数量的参数时特别有用。

## 基本语法

```bash
shift [n]
```

其中，`n`是一个可选的整数，表示要左移的参数个数。如果不指定`n`，则默认为1。

## 工作原理

当执行`shift`命令时，它会将位置参数左移：
- `$2`的值会变成新的`$1`
- `$3`的值会变成新的`$2`
- 以此类推...
- 原来的`$1`值会被丢弃，无法再访问
- 参数总数`$#`会相应减少

## 基本用法

### 简单的shift示例

下面是一个简单的示例，展示`shift`命令的基本用法：

```bash
#!/bin/bash
# 测试shift命令

echo "初始参数: $*"
echo "参数个数: $#"
echo "第一个参数: $1"

shift  # 左移一位

echo "执行shift后..."
echo "参数: $*"
echo "参数个数: $#"
echo "第一个参数: $1"
```

如果我们执行：`./test.sh a b c`，输出将是：

```
初始参数: a b c
参数个数: 3
第一个参数: a
执行shift后...
参数: b c
参数个数: 2
第一个参数: b
```

### 使用shift处理所有参数

使用`shift`命令可以依次处理所有参数：

```bash
#!/bin/bash
# 使用shift处理所有参数

until [ $# -eq 0 ]
do
    echo "处理参数: $1"
    shift
done
```

执行：`./process.sh apple banana cherry`，输出：

```
处理参数: apple
处理参数: banana
处理参数: cherry
```

### 计算所有参数的和

下面的示例使用`shift`命令计算所有命令行参数的和：

```bash
#!/bin/bash
# 计算参数之和

if [ $# -eq 0 ]
then
    echo "用法: $0 数字1 数字2 ..."
    exit 1
fi

sum=0
until [ $# -eq 0 ]
do
    sum=$((sum + $1))
    shift
done

echo "总和是: $sum"
```

执行：`./sum.sh 10 20 30`，输出：

```
总和是: 60
```

### 指定shift的数量

`shift`命令可以指定一次左移多个位置：

```bash
#!/bin/bash
# 测试shift n

echo "所有参数: $*"
echo "参数个数: $#"

shift 2  # 左移两位

echo "执行shift 2后..."
echo "参数: $*"
echo "参数个数: $#"
```

执行：`./test_shift_n.sh a b c d e`，输出：

```
所有参数: a b c d e
参数个数: 5
执行shift 2后...
参数: c d e
参数个数: 3
```

## 高级用法

### 处理超过9个参数

在早期的Shell中，直接引用的位置参数只能到`$9`。要访问第10个及以后的参数，需要使用`shift`：

```bash
#!/bin/bash
# 处理超过9个参数

# 处理前9个参数
echo "前9个参数:"
for i in {1..9}
do
    eval echo "\$$i"
done

# 使用shift访问更多参数
shift 9
echo "第10个参数及以后:"
while [ $# -gt 0 ]
do
    echo "$1"
    shift
done
```

::: tip 提示
在现代Shell中，可以使用`${10}`, `${11}`等形式直接访问第10个及以后的参数，不必依赖shift。
:::

### 在循环中使用shift

`shift`命令经常在循环中使用，特别是在处理带有选项的命令行参数时：

```bash
#!/bin/bash
# 处理命令行选项

while [ $# -gt 0 ]
do
    case "$1" in
        -v|--verbose)
            verbose=true
            shift
            ;;
        -f|--file)
            file="$2"
            shift 2
            ;;
        -h|--help)
            echo "用法: $0 [-v|--verbose] [-f|--file filename] [-h|--help]"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            exit 1
            ;;
    esac
done

echo "verbose: $verbose"
echo "file: $file"
```

## 注意事项

1. 如果`shift`的参数大于剩余参数的数量，会产生错误。
2. `shift`命令会永久删除已经移出的参数，无法恢复。
3. 在使用`shift`前，最好先检查是否还有足够的参数。
4. `shift 0`是合法的，但不会有任何效果。

## 参考资料

- [Bash Reference Manual - Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html)
- [Advanced Bash-Scripting Guide - Looping and Branching](https://tldp.org/LDP/abs/html/loops1.html) 
