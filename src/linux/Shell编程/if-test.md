---
title: if和test语法使用指南
category:
  - Linux
  - Shell编程
tag:
  - if语句
  - test命令
  - 条件判断
  - 脚本编程
date: 2022-07-11

---

# if和test语法使用指南

## 概述

在 Shell 脚本编程中，`if` 语句结合 `test` 命令（或 `[ ]` 语法）是进行条件判断的核心工具。本文档详细介绍各种判断参数的使用方法。

## 基本语法

```bash
# 方式一：使用 test 命令
if test 条件; then
    # 执行语句
fi

# 方式二：使用 [ ] 语法（推荐）
if [ 条件 ]; then
    # 执行语句
fi

# 方式三：使用 [[ ]] 语法（bash 扩展）
if [[ 条件 ]]; then
    # 执行语句
fi
```

## 文件测试运算符

### 文件类型判断

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `-f file` | 文件存在且为普通文件 | `[ -f /etc/passwd ]` |
| `-d file` | 文件存在且为目录 | `[ -d /tmp ]` |
| `-e file` | 文件或目录存在 | `[ -e /var/log/syslog ]` |
| `-L file` | 文件存在且为符号链接 | `[ -L /usr/bin/vi ]` |
| `-b file` | 文件存在且为块设备文件 | `[ -b /dev/sda1 ]` |
| `-c file` | 文件存在且为字符设备文件 | `[ -c /dev/tty ]` |
| `-p file` | 文件存在且为命名管道 | `[ -p /tmp/mypipe ]` |
| `-S file` | 文件存在且为套接字 | `[ -S /tmp/socket ]` |

### 文件权限判断

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `-r file` | 文件存在且可读 | `[ -r /etc/hosts ]` |
| `-w file` | 文件存在且可写 | `[ -w /tmp/test.txt ]` |
| `-x file` | 文件存在且可执行 | `[ -x /usr/bin/ls ]` |

### 文件属性判断

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `-s file` | 文件存在且大小大于0 | `[ -s /var/log/messages ]` |
| `-u file` | 文件存在且设置了SUID位 | `[ -u /usr/bin/passwd ]` |
| `-g file` | 文件存在且设置了SGID位 | `[ -g /usr/bin/wall ]` |
| `-k file` | 文件存在且设置了粘滞位 | `[ -k /tmp ]` |
| `-O file` | 文件存在且被当前用户拥有 | `[ -O ~/.bashrc ]` |
| `-G file` | 文件存在且属于当前用户组 | `[ -G /home/user/file ]` |

### 文件比较

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `file1 -nt file2` | file1 比 file2 新 | `[ file1.txt -nt file2.txt ]` |
| `file1 -ot file2` | file1 比 file2 旧 | `[ backup.txt -ot original.txt ]` |
| `file1 -ef file2` | file1 和 file2 指向同一文件 | `[ /bin/sh -ef /dash ]` |

## 字符串测试运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `-z string` | 字符串长度为零 | `[ -z "$var" ]` |
| `-n string` | 字符串长度非零 | `[ -n "$var" ]` |
| `string1 = string2` | 字符串相等 | `[ "$name" = "admin" ]` |
| `string1 != string2` | 字符串不等 | `[ "$name" != "guest" ]` |
| `string1 < string2` | 字符串按字典序小于 | `[[ "abc" < "def" ]]` |
| `string1 > string2` | 字符串按字典序大于 | `[[ "xyz" > "abc" ]]` |

**注意：** 字符串比较时建议使用双引号包围变量，防止空格等特殊字符干扰。

## 数值比较运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `num1 -eq num2` | 等于 | `[ $count -eq 10 ]` |
| `num1 -ne num2` | 不等于 | `[ $count -ne 0 ]` |
| `num1 -lt num2` | 小于 | `[ $age -lt 18 ]` |
| `num1 -le num2` | 小于等于 | `[ $score -le 100 ]` |
| `num1 -gt num2` | 大于 | `[ $price -gt 1000 ]` |
| `num1 -ge num2` | 大于等于 | `[ $level -ge 5 ]` |

## 逻辑运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `!` | 逻辑非 | `[ ! -f /tmp/lock ]` |
| `-a` 或 `&&` | 逻辑与 | `[ -f file -a -r file ]` 或 `[[ -f file && -r file ]]` |
| `-o` 或 `\|\|` | 逻辑或 | `[ -f file1 -o -f file2 ]` 或 `[[ -f file1 \|\| -f file2 ]]` |

## 实用示例

### 示例1：体重建议脚本

```bash
#!/bin/bash
# 根据身高体重给出建议

# 检查参数数量
if [ $# -ne 2 ]; then
    echo "用法: $0 体重(公斤) 身高(厘米)"
    echo "示例: $0 70 175"
    exit 1
fi

weight=$1
height=$2

# 计算理想体重（简化公式）
ideal_weight=$((height - 110))

# 根据体重情况给出建议
if [ $weight -lt $ideal_weight ]; then
    echo "您的体重偏轻，建议适当增加营养摄入。"
    echo "多吃一些健康的高热量食物。"
elif [ $weight -eq $ideal_weight ]; then
    echo "您的体重刚好，请保持现状！"
else
    echo "您的体重偏重，建议适当运动和控制饮食。"
    echo "多吃蔬菜水果，减少高热量食物。"
fi

echo "您的体重: ${weight}kg"
echo "您的身高: ${height}cm"
echo "理想体重: ${ideal_weight}kg"
```

### 示例2：文件检查脚本

```bash
#!/bin/bash
# 检查文件状态

file_path="$1"

if [ -z "$file_path" ]; then
    echo "请提供文件路径"
    exit 1
fi

echo "检查文件: $file_path"

# 检查文件是否存在
if [ ! -e "$file_path" ]; then
    echo "❌ 文件不存在"
    exit 1
fi

echo "✅ 文件存在"

# 检查文件类型
if [ -f "$file_path" ]; then
    echo "📄 这是一个普通文件"
elif [ -d "$file_path" ]; then
    echo "📁 这是一个目录"
elif [ -L "$file_path" ]; then
    echo "🔗 这是一个符号链接"
fi

# 检查文件权限
permissions=""
[ -r "$file_path" ] && permissions="${permissions}r"
[ -w "$file_path" ] && permissions="${permissions}w"
[ -x "$file_path" ] && permissions="${permissions}x"

echo "🔐 权限: $permissions"

# 检查文件大小
if [ -s "$file_path" ]; then
    echo "📏 文件不为空"
else
    echo "📏 文件为空或不是普通文件"
fi
```

### 示例3：用户输入验证

```bash
#!/bin/bash
# 用户注册验证

read -p "请输入用户名: " username
read -s -p "请输入密码: " password
echo

# 验证用户名
if [ -z "$username" ]; then
    echo "❌ 用户名不能为空"
    exit 1
fi

if [ ${#username} -lt 3 ]; then
    echo "❌ 用户名长度至少3个字符"
    exit 1
fi

# 验证密码
if [ -z "$password" ]; then
    echo "❌ 密码不能为空"
    exit 1
fi

if [ ${#password} -lt 6 ]; then
    echo "❌ 密码长度至少6个字符"
    exit 1
fi

echo "✅ 用户信息验证通过"
echo "用户名: $username"
echo "密码长度: ${#password} 个字符"
```

## 调试技巧

### 使用 -x 选项调试脚本

```bash
# 运行时显示执行过程
bash -x script.sh

# 或在脚本开头添加
#!/bin/bash -x
```

### 在脚本中开启/关闭调试

```bash
#!/bin/bash

# 开启调试
set -x
if [ $# -eq 0 ]; then
    echo "没有参数"
fi

# 关闭调试
set +x
echo "调试已关闭"
```

## 最佳实践

1. **总是用双引号包围变量**：`[ "$var" = "value" ]`
2. **检查变量是否为空**：`[ -n "$var" ]`
3. **使用 [[ ]] 进行复杂条件判断**（bash 专用）
4. **合理使用 exit 状态码**：成功返回0，失败返回非0
5. **添加注释说明复杂的条件判断**
6. **使用 shellcheck 工具检查脚本质量**

## 常见错误

1. **忘记在 [ ] 内部添加空格**
   ```bash
   # 错误
   if [$var -eq 1]; then
   
   # 正确
   if [ $var -eq 1 ]; then
   ```

2. **字符串比较时忘记引号**
   ```bash
   # 可能出错
   if [ $name = admin ]; then
   
   # 推荐
   if [ "$name" = "admin" ]; then
   ```

3. **混用数值和字符串比较**
   ```bash
   # 数值比较
   if [ $num -eq 10 ]; then
   
   # 字符串比较
   if [ "$str" = "10" ]; then
   ```

通过掌握这些 if 语句和 test 命令的用法，您就能编写出功能强大且健壮的 Shell 脚本了。
