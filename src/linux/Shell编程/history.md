---
title: history命令详解
category:
  - Linux
  - Shell编程
tag:
  - Shell
  - 命令历史
date: 2022-07-10

---

# history命令详解

## 简介

`history`命令用于显示用户之前在命令行中执行过的命令历史记录。这个功能非常有用，可以帮助用户快速查找和重新执行之前使用过的命令，从而提高工作效率。在大多数Linux系统中，命令历史记录存储在用户主目录下的`.bash_history`文件中。

## 基本语法

```bash
history [选项] [参数]
```

## 常用选项

| 选项 | 描述 |
| --- | --- |
| -c | 清除当前历史命令列表 |
| -d 偏移量 | 删除指定位置的历史命令 |
| -a | 将当前终端的命令历史追加到历史文件中 |
| -r | 从历史文件中读取历史命令到当前终端的历史列表 |
| -w | 将当前历史命令列表写入历史文件 |
| -n | 从历史文件中读取未读取的行到当前历史命令列表 |
| -p | 展开历史命令，但不存储 |
| -s | 将指定的命令添加到历史列表中 |
| 数字 | 显示最近的n条历史命令 |

## 基本用法

### 显示所有历史命令

```bash
history
```

### 显示最近n条历史命令

```bash
history n
```

例如，显示最近10条命令：

```bash
history 10
```

### 清除历史命令

```bash
history -c
```

### 删除特定的历史命令

```bash
history -d 行号
```

例如，删除第5条历史命令：

```bash
history -d 5
```

## 历史命令的重用

### 使用感叹号(!)重用命令

| 命令 | 描述 |
| --- | --- |
| !! | 执行上一条命令 |
| !n | 执行历史列表中第n条命令 |
| !-n | 执行倒数第n条命令 |
| !string | 执行最近以string开头的命令 |
| !?string | 执行最近包含string的命令 |
| ^string1^string2 | 将上一条命令中的string1替换为string2并执行 |

例如：

```bash
# 执行上一条命令
!!

# 执行历史列表中第5条命令
!5

# 执行倒数第3条命令
!-3

# 执行最近以ls开头的命令
!ls

# 执行最近包含grep的命令
!?grep

# 将上一条命令中的foo替换为bar并执行
^foo^bar
```

### 使用Ctrl+R搜索历史命令

按下`Ctrl+R`后，可以输入关键字来搜索历史命令。找到需要的命令后，按Enter执行，或按右箭头键编辑。

```
(reverse-i-search)`grep': grep -r "function" /var/www/html
```

## 历史命令的配置

### 环境变量

以下是与`history`命令相关的重要环境变量：

| 变量 | 描述 |
| --- | --- |
| HISTFILE | 指定历史命令的存储文件，默认为~/.bash_history |
| HISTFILESIZE | 历史文件中可存储的命令数量，默认为500 |
| HISTSIZE | 当前会话中可记住的命令数量，默认为500 |
| HISTCONTROL | 控制哪些命令被记录到历史列表中 |
| HISTIGNORE | 指定不记录到历史列表中的命令模式 |
| HISTTIMEFORMAT | 指定显示命令执行时间的格式 |

### 在历史记录中显示时间戳

在bash 3.0及更高版本中，可以通过设置`HISTTIMEFORMAT`变量来显示命令执行的时间：

```bash
# 编辑/etc/bashrc或~/.bashrc文件，添加以下内容
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
```

或者直接在命令行中执行：

```bash
echo 'HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "' >> ~/.bashrc
source ~/.bashrc
```

设置后，使用`history`命令将显示每条命令的执行时间：

```
1  2023-05-20 14:30:45 ls -la
2  2023-05-20 14:31:12 cd /var/www/html
3  2023-05-20 14:31:20 grep -r "function" .
```

### 忽略特定命令

可以设置`HISTIGNORE`变量来忽略某些命令，不将其记录到历史中：

```bash
# 忽略ls、cd、exit命令和以空格开头的命令
HISTIGNORE="ls:cd:exit: *"
```

### 避免记录重复命令

通过设置`HISTCONTROL`变量，可以控制如何处理重复命令：

```bash
# ignoredups: 不记录连续重复的命令
# ignorespace: 不记录以空格开头的命令
# ignoreboth: 同时启用上述两个选项
# erasedups: 删除整个历史记录中的所有重复条目
HISTCONTROL=ignoreboth:erasedups
```

## 高级用法

### 立即将命令写入历史文件

默认情况下，命令历史只在会话结束时写入历史文件。要立即写入，可以使用：

```bash
history -a
```

### 从历史文件读取新命令

如果其他终端已经将新命令写入历史文件，可以使用以下命令读取：

```bash
history -r
```

### 合并多个终端的历史记录

要在多个终端会话之间共享历史记录，可以在`~/.bashrc`中添加：

```bash
shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
```

这样，每次执行命令后，都会将当前命令追加到历史文件，并重新读取历史文件。

### 使用历史命令的参数

可以使用`!$`引用上一条命令的最后一个参数，或使用`!^`引用第一个参数：

```bash
# 创建目录
mkdir /path/to/newdir

# 进入刚才创建的目录
cd !$  # 等同于 cd /path/to/newdir

# 使用上一条命令的第一个参数
ls !^  # 如果上一条命令是 cp file1 file2，则等同于 ls file1
```

## 安全注意事项

### 清除敏感信息

如果在命令中包含了密码等敏感信息，可以从历史记录中删除：

```bash
# 查找包含密码的命令
history | grep password

# 删除特定行
history -d 行号
```

### 临时禁用历史记录

在输入敏感命令前，可以临时禁用历史记录：

```bash
# 方法1：在命令前加空格（如果HISTCONTROL包含ignorespace）
 mysql -u root -p

# 方法2：临时禁用历史
set +o history
# 输入敏感命令
mysql -u root -pMyPassword
# 重新启用历史
set -o history
```

## 实用技巧

### 统计最常用的命令

```bash
history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
```

如果设置了HISTTIMEFORMAT，则需要调整字段位置：

```bash
history | awk '{CMD[$4]++;count++} END {for (a in CMD) print CMD[a]/count*100 "% " a}' | sort -rn | head -10
```

### 查找特定日期的命令

如果设置了HISTTIMEFORMAT，可以查找特定日期执行的命令：

```bash
history | grep "2023-05-20"
```

### 将历史命令保存到文件

```bash
history > history_backup.txt
```

## 常见问题及解决方案

### 历史记录不保存

可能的原因：
- HISTSIZE或HISTFILESIZE设置为0
- HISTFILE变量被修改或未设置
- 没有正确退出终端（如强制关闭终端窗口）

解决方案：
- 检查并设置正确的HISTSIZE和HISTFILESIZE值
- 确保HISTFILE变量指向正确的文件
- 使用`exit`命令正确退出终端

### 多个终端会话覆盖历史记录

解决方案：
- 启用histappend选项：`shopt -s histappend`
- 在每条命令后追加历史：`PROMPT_COMMAND="history -a; $PROMPT_COMMAND"`

## 参考资料

- [Bash Reference Manual - History](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html)
- [Linux man pages: history(3)](https://linux.die.net/man/3/history) 
