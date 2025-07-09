---
title: sed命令
category:
  - Linux
  - 文本处理
tag:
  - sed
  - 文本替换
  - 流编辑器
date: 2022-08-07

---

# sed命令

## 简介

`sed`（Stream Editor）是Linux系统中强大的流编辑器，主要用于对文本进行过滤和转换。它可以批量处理文件，进行查找替换、删除、插入等操作，是系统管理员和开发者必备的工具之一。

## 基本语法

```bash
sed [选项] '命令' 文件名
sed [选项] -f 脚本文件 文件名
```

### 常用选项

- `-i` : 直接修改文件内容（原地编辑）
- `-n` : 静默模式，只输出经过sed处理的行
- `-e` : 允许多个编辑命令
- `-f` : 从脚本文件中读取编辑命令
- `-r` : 使用扩展正则表达式

## 批量替换操作

### 1. 批量替换多个文件中的字符串

**基本格式：**
```bash
sed -i "s/查找字段/替换字段/g" `grep 查找字段 -rl 路径`
```

**实际示例：**
```bash
# 替换/home下所有文件中的www.admin99.net为admin99.net
sed -i "s/www.admin99.net/admin99.net/g" `grep www.admin99.net -rl /home`

# 替换当前目录下所有文件中的shabi为$
sed -i "s/shabi/$/g" `grep shabi -rl ./`
```

### 2. 单个文件替换

**替换单个文件中的内容：**
```bash
# 将文件1.txt内的文字"garden"替换成"mirGarden"
sed -i "s/garden/mirGarden/g" 1.txt
```

### 3. 当前目录下所有文件替换

```bash
# 将当前目录下的所有文件内的"garden"替换成"mirGarden"
sed -i "s/garden/mirGarden/g" `ls`
```

## 删除操作

### 删除空白行

```bash
# 从example.txt文件中删除所有空白行
sed '/^$/d' example.txt

# 直接修改文件，删除空白行
sed -i '/^$/d' example.txt
```

### 删除特定行

```bash
# 删除第3行
sed '3d' filename

# 删除第2到5行
sed '2,5d' filename

# 删除最后一行
sed '$d' filename

# 删除包含特定字符串的行
sed '/pattern/d' filename
```

## 插入和追加操作

### 插入行

```bash
# 在第2行前插入新行
sed '2i\新插入的内容' filename

# 在匹配行前插入
sed '/pattern/i\新插入的内容' filename
```

### 追加行

```bash
# 在第2行后追加新行
sed '2a\新追加的内容' filename

# 在匹配行后追加
sed '/pattern/a\新追加的内容' filename
```

## 查找和显示操作

### 显示特定行

```bash
# 显示第5行
sed -n '5p' filename

# 显示第2到5行
sed -n '2,5p' filename

# 显示包含特定模式的行
sed -n '/pattern/p' filename
```

## 高级替换技巧

### 使用正则表达式

```bash
# 替换行首的空格为制表符
sed 's/^[ ]*/\t/' filename

# 删除行尾空格
sed 's/[ ]*$//' filename

# 替换多个连续空格为单个空格
sed 's/[ ][ ]*/ /g' filename
```

### 分组替换

```bash
# 交换两个字段的位置
sed 's/\([^,]*\),\([^,]*\)/\2,\1/' filename

# 在匹配的内容前后添加标记
sed 's/\(pattern\)/[\1]/' filename
```

## 实用示例

### 配置文件处理

```bash
# 修改配置文件中的端口号
sed -i 's/port=8080/port=9090/g' config.properties

# 注释掉配置文件中的某一行
sed -i 's/^debug=true/#debug=true/' config.properties
```

### 日志文件处理

```bash
# 提取包含ERROR的日志行
sed -n '/ERROR/p' application.log

# 删除日志文件中的调试信息
sed -i '/DEBUG/d' application.log
```

### 文本格式化

```bash
# 在每行末尾添加分号
sed 's/$/;/' filename

# 在每行开头添加行号
sed = filename | sed 'N;s/\n/\t/'
```

## 注意事项

1. **备份重要文件**：使用 `-i` 选项会直接修改原文件，建议先备份
   ```bash
   # 创建备份后再修改
   sed -i.bak 's/old/new/g' filename
   ```

2. **特殊字符转义**：在替换包含特殊字符（如 `/`, `$`, `*` 等）的内容时需要转义
   ```bash
   # 替换路径时使用不同的分隔符
   sed 's|/old/path|/new/path|g' filename
   ```

3. **大文件处理**：处理大文件时，sed的内存使用效率很高，但仍需注意性能

4. **正则表达式**：熟练掌握正则表达式能大大提高sed的使用效率

## 总结

sed是Linux系统中非常强大的文本处理工具，掌握其基本用法可以大大提高文本处理的效率。从简单的字符串替换到复杂的文本转换，sed都能胜任。结合其他Linux命令（如grep、awk等），可以构建出功能强大的文本处理管道。
