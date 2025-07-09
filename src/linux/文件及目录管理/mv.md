---
title: mv命令-移动或重命名
# icon: arrows-alt
category:
  - Linux
  - 命令帮助
tag:
  - mv
  - 文件管理
  - 移动文件
  - 重命名
date: 2022-07-27

---

# mv命令-移动或重命名文件和目录

`mv`命令是Linux系统中用于移动或重命名文件和目录的基本命令，名称来源于英文"move"的缩写。

## 命令格式

```bash
mv [选项] 源文件/目录 目标文件/目录
```

## 基本功能

- 将文件或目录从一个位置移动到另一个位置
- 重命名文件或目录

## 常用选项

| 选项 | 描述 |
| --- | --- |
| `-f` | 强制移动，不询问是否覆盖已存在的目标文件 |
| `-i` | 交互模式，询问是否覆盖已存在的目标文件 |
| `-n` | 不覆盖已存在的文件 |
| `-u` | 仅当源文件比目标文件新或目标文件不存在时才移动 |
| `-v` | 显示详细操作过程 |
| `-b` | 覆盖前为目标文件创建备份 |

## 使用示例

### 重命名文件或目录

```bash
# 将文件重命名
mv old_file.txt new_file.txt

# 将目录重命名
mv old_directory new_directory
```

### 移动文件到其他目录

```bash
# 移动单个文件到目标目录
mv file.txt /destination/directory/

# 移动多个文件到目标目录
mv file1.txt file2.txt /destination/directory/
```

### 移动并重命名

```bash
# 将文件移动到其他目录并重命名
mv /source/path/old_name.txt /destination/path/new_name.txt

# 将目录移动到其他位置并重命名
mv /a /b/c
```

### 使用选项

```bash
# 交互式移动，会在覆盖前询问
mv -i file.txt /destination/

# 显示详细信息
mv -v file.txt /destination/

# 仅当源文件较新时才移动
mv -u file.txt /destination/
```

## 注意事项

1. 如果目标文件已存在，`mv`命令默认会直接覆盖，不会有任何提示。使用`-i`选项可以在覆盖前进行确认。

2. 当源文件与目标文件在同一目录中时，`mv`命令实际上是执行重命名操作。

3. 移动文件时，文件的所有者和权限通常保持不变，除非移动到不同的文件系统。

4. 使用`mv`命令时应小心，特别是在使用通配符时，以避免意外覆盖重要文件。

5. `mv`命令一次只能重命名一个文件，不能批量重命名多个文件（需要结合其他命令或使用`rename`命令）。

## 实用技巧

### 创建备份

```bash
# 移动文件并创建备份（添加~后缀）
mv -b file.txt /destination/

# 指定备份后缀
mv -b --suffix=.bak file.txt /destination/
```

### 结合其他命令使用

```bash
# 查找并移动所有.txt文件
find . -name "*.txt" -exec mv {} /destination/ \;

# 移动多个文件并显示进度
ls *.jpg | xargs -I{} mv -v {} /destination/
```

### 避免覆盖文件

```bash
# 如果目标文件存在则不移动
mv -n file.txt /destination/
``` 
