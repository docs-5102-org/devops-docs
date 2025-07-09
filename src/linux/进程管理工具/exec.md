---
title: exec命令详解
category:
  - Linux
  - 命令帮助
tag:
  - exec
  - shell
  - 进程管理
  - 文件描述符
date: 2022-10-03

---

# exec命令-替换当前进程和操作文件描述符

Exec命令是Shell的内建命令，主要有两个用途：替换当前进程和操作文件描述符。它是理解Shell脚本和进程管理的重要命令。

## 命令格式

```bash
exec [命令]
exec [文件描述符操作]
```

## 替换当前进程

当exec后面跟随一个命令时，它会用这个命令替换当前的Shell进程，而不会创建新的进程。这意味着：

1. 命令执行完成后，原Shell进程结束
2. 命令继承了原Shell进程的环境和文件描述符
3. 命令执行后不会返回到原Shell

### 基本用法

```bash
# 执行ls命令后，当前Shell会终止
exec ls

# 执行bash命令，替换当前Shell
exec bash
```

### 在脚本中的使用

```bash
#!/bin/bash
echo "这行会执行"
exec ls
echo "这行不会执行，因为Shell已被替换"
```

## 操作文件描述符

当exec用于文件描述符操作时，它不会替换当前Shell进程，而是修改Shell的文件描述符表。

### 标准文件描述符

| 描述符 | 名称 | 默认连接 |
| --- | --- | --- |
| 0 | 标准输入 (stdin) | 键盘 |
| 1 | 标准输出 (stdout) | 屏幕 |
| 2 | 标准错误 (stderr) | 屏幕 |

### 常用文件描述符操作

```bash
# 将标准输出重定向到文件
exec > output.txt

# 将标准错误重定向到文件
exec 2> error.log

# 将标准输入重定向到文件
exec < input.txt

# 创建新的文件描述符
exec 3> custom.log

# 复制文件描述符
exec 4>&1  # 将文件描述符4指向标准输出

# 关闭文件描述符
exec 3>&-
```

## 实用示例

### 重定向所有输出到文件

```bash
# 所有标准输出将写入output.log，而不是屏幕
exec > output.log
echo "这行会写入文件"
ls -la

# 恢复标准输出到终端
exec >/dev/tty
echo "这行会显示在屏幕上"
```

### 保存和恢复标准输出

```bash
# 保存当前的标准输出
exec 3>&1

# 重定向标准输出到文件
exec 1>output.log

# 执行一些命令，输出到文件
echo "写入文件的内容"

# 恢复原来的标准输出
exec 1>&3

# 关闭文件描述符3
exec 3>&-

echo "这行会显示在屏幕上"
```

### 同时捕获标准输出和错误

```bash
# 将标准输出和错误都重定向到同一个文件
exec > output.log 2>&1

# 或者分别重定向
exec > output.log 2> error.log
```

### 在find命令中使用exec

```bash
# 查找所有txt文件并搜索包含"error"的行
find /path -name "*.txt" -exec grep "error" {} \;

# 删除所有临时文件
find /path -name "*.tmp" -exec rm {} \;
```

## 与system命令的区别

1. **exec**：直接替换当前进程，不创建新进程，执行完不返回
2. **system**：创建子进程执行命令，相当于fork+exec+waitpid，执行完返回原进程

## 注意事项

1. 使用exec替换进程时，exec后的代码不会执行
2. 在脚本中使用exec操作文件描述符时，影响范围是整个脚本
3. 关闭标准输入(0)可能导致脚本退出
4. 文件描述符操作完成后，需要手动关闭不再使用的描述符

## 高级应用

### 创建守护进程

```bash
#!/bin/bash
# 将标准输入、输出、错误重定向到/dev/null
exec 0</dev/null
exec 1>/dev/null
exec 2>/dev/null

# 执行守护进程
while true; do
  date >> /var/log/daemon.log
  sleep 60
done
```

### 日志分流

```bash
#!/bin/bash
# 创建文件描述符3用于错误日志
exec 3>error.log
# 创建文件描述符4用于信息日志
exec 4>info.log

# 自定义日志函数
log_error() {
  echo "[ERROR] $(date): $1" >&3
}

log_info() {
  echo "[INFO] $(date): $1" >&4
}

# 使用函数
log_info "程序启动"
log_error "发生错误"
```
