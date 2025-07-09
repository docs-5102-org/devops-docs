---
title: screen命令详解
category:
  - Linux
  - 命令帮助
tag:
  - screen
  - 终端管理
  - 远程会话
date: 2022-10-07

---

# screen命令

## 简介

GNU Screen是一款由GNU计划开发的用于命令行终端切换的自由软件。用户可以通过该软件同时连接多个本地或远程的命令行会话，并在其间自由切换。它可以看作是窗口管理器的命令行界面版本，提供了统一的管理多个会话的界面和相应的功能。

## 主要功能

### 会话恢复

只要Screen本身没有终止，在其内部运行的会话都可以恢复。这一点对于远程登录的用户特别有用——即使网络连接中断，用户也不会失去对已经打开的命令行会话的控制。只要再次登录到主机上执行`screen -r`就可以恢复会话的运行。

### 多窗口

在Screen环境下，所有的会话都独立运行，并拥有各自的编号、输入、输出和窗口缓存。用户可以通过快捷键在不同的窗口下切换，并可以自由地重定向各个窗口的输入和输出。

### 会话共享

Screen可以让一个或多个用户从不同终端多次登录一个会话，并共享会话的所有特性（比如可以看到完全相同的输出）。它同时提供了窗口访问权限的机制，可以对窗口进行密码保护。

## 安装screen

在大多数Linux发行版中，可以通过包管理器安装screen：

```bash
# Debian/Ubuntu
sudo apt-get install screen

# CentOS/RHEL
sudo yum install screen

# Fedora
sudo dnf install screen
```

## 基本语法

```bash
screen [-options] [cmd [args]]
```

## 常用参数

| 参数 | 说明 |
| --- | --- |
| -S \<name\> | 指定screen会话的名称 |
| -ls | 显示当前所有的screen会话 |
| -r \<name\> | 恢复离线的screen会话 |
| -d \<name\> | 将指定的screen会话离线 |
| -d -r \<name\> | 结束当前会话并回到指定会话 |
| -x | 恢复之前离线的screen会话 |
| -A | 将所有的视窗都调整为目前终端机的大小 |
| -h \<行数\> | 指定视窗的缓冲区行数 |
| -m | 即使目前已在作业中的screen作业，仍强制建立新的screen作业 |
| -R | 先试图恢复离线的作业。若找不到离线的作业，即建立新的screen作业 |
| -s | 指定建立新视窗时，所要执行的shell |
| -v | 显示版本信息 |
| -wipe | 检查目前所有的screen作业，并删除已经无法使用的screen作业 |

## 常用命令

### 创建和管理会话

```bash
# 创建新会话
screen -S session_name

# 列出所有会话
screen -ls

# 恢复会话
screen -r session_name

# 远程分离会话
screen -d session_name

# 结束当前会话并回到指定会话
screen -d -r session_name
```

### 在screen会话中的快捷键

::: tip 提示
在screen会话中，所有命令都以 `Ctrl+a` (简写为C-a) 开始
:::

| 快捷键 | 功能 |
| --- | --- |
| C-a ? | 显示所有键绑定信息 |
| C-a c | 创建一个新的运行shell的窗口并切换到该窗口 |
| C-a n | 切换到下一个窗口 |
| C-a p | 切换到前一个窗口 |
| C-a 0..9 | 切换到第0..9个窗口 |
| C-a [Space] | 由窗口0循序切换到窗口9 |
| C-a C-a | 在两个最近使用的窗口间切换 |
| C-a x | 锁住当前窗口，需用用户密码解锁 |
| C-a d | 暂时离开当前会话，将目前的screen会话丢到后台执行 |
| C-a z | 把当前会话放到后台执行，用shell的fg命令可回去 |
| C-a w | 显示所有窗口列表 |
| C-a t | 显示当前时间和系统负载 |
| C-a k | 强行关闭当前窗口 |
| C-a A | 为当前窗口重命名 |

### 复制模式

进入复制模式后，可以回滚、搜索、复制就像使用vi一样：

```
C-a [ -> 进入复制模式
```

在复制模式中：

| 按键 | 功能 |
| --- | --- |
| C-b | 向上翻页 |
| C-f | 向下翻页 |
| H | 将光标移至左上角 |
| L | 将光标移至左下角 |
| 0 | 移到行首 |
| $ | 移到行末 |
| w | 向前移动一个词 |
| b | 向后移动一个词 |
| Space | 第一次按为标记区起点，第二次按为终点 |
| Esc | 结束复制模式 |

```
C-a ] -> 粘贴已复制的内容
```

## 实用技巧

### 会话分离与恢复

```bash
# 在screen会话中按下C-a d分离会话
# 或者在外部使用命令分离
screen -d session_name

# 恢复已分离的会话
screen -r session_name
```

### 清除dead会话

如果由于某种原因会话死掉了，可以使用以下命令清除：

```bash
screen -wipe
```

### 会话共享

多用户可以共享同一个screen会话：

```bash
# 用户A创建会话
screen -S shared_session

# 用户B连接到该会话
screen -x shared_session
```

### 屏幕分割

```bash
C-a S  # 水平分割屏幕
C-a |  # 垂直分割屏幕（在4.00.03版本后支持）
C-a <tab>  # 在各个区块间切换
C-a X  # 关闭当前焦点所在的屏幕区块
C-a Q  # 关闭除当前区块之外所有的区块
```

## 高级配置

Screen的配置文件位于：
- 系统级配置：`/etc/screenrc`
- 用户级配置：`$HOME/.screenrc`

### 示例配置

```bash
# 设置启动信息
startup_message off

# 设置状态栏
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %d/%m %{W}%c %{g}]'

# 启用多用户模式
multiuser on

# 设置默认编码
defencoding utf8
encoding utf8 utf8

# 设置滚动行数
defscrollback 10000

# 自动分离
autodetach on
```

## 常见问题

### 无法创建目录 '/var/run/screen'

这通常是权限问题，可以尝试以下解决方案：

```bash
# 创建目录并设置权限
sudo mkdir -p /var/run/screen
sudo chmod 755 /var/run/screen
```

### 找不到会话

如果`screen -ls`显示没有会话，但你确定有会话在运行，可能是因为会话是在其他用户下创建的，或者会话已经死亡：

```bash
# 检查所有用户的screen会话
ps aux | grep SCREEN

# 清理死亡会话
screen -wipe
```

## 参考资料

- [GNU Screen官方网站](http://www.gnu.org/software/screen/)
- [Screen用户手册](https://www.gnu.org/software/screen/manual/screen.html) 
