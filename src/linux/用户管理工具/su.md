---
title: su命令-切换用户
category:
  - Linux命令
tag:
  - 用户管理
  - 系统管理
date: 2022-08-24

---

# su命令-切换用户

## 简介

`su`（Switch User）命令用于在当前登录会话中切换到另一个用户，通常是切换到超级用户（root）或其他系统用户。它允许用户在不注销并重新登录的情况下，临时获取其他用户的权限。

## 基本语法

```bash
su [选项] [用户名]
```

如果不指定用户名，默认切换到root用户。

## 常用选项

| 选项 | 说明 |
| --- | --- |
| - | 切换用户的同时切换环境变量，相当于完全登录到新用户 |
| -c 命令 | 执行完指定命令后，立即恢复原来的用户身份 |
| -s SHELL | 指定要使用的shell |
| -l | 与`-`相同，提供类似于直接登录的环境 |
| -p | 保留当前环境变量 |
| --help | 显示帮助信息 |
| --version | 显示版本信息 |

## 基本用法

### 切换到root用户

```bash
su
```

执行此命令后，系统会提示输入root用户的密码。

### 切换到指定用户

```bash
su username
```

执行此命令后，系统会提示输入指定用户的密码。

### 切换用户并切换环境

```bash
su - username
# 或者
su -l username
```

这种方式不仅会切换用户身份，还会切换到目标用户的环境，包括HOME目录、PATH变量等。

## 环境变量的区别

### 不带连字符（-）的su

当使用不带连字符的`su`命令时：
- 只切换用户ID
- 保留当前用户的环境变量
- 保留当前工作目录
- 不会执行目标用户的启动文件（如`.bash_profile`）

例如：

```bash
# 以普通用户身份
echo $HOME
# 输出：/home/user1

# 切换到root用户，但不切换环境
su
echo $HOME
# 输出仍然是：/home/user1
```

### 带连字符（-）的su

当使用带连字符的`su -`命令时：
- 切换用户ID
- 切换到目标用户的环境变量
- 切换到目标用户的HOME目录
- 执行目标用户的启动文件

例如：

```bash
# 以普通用户身份
echo $HOME
# 输出：/home/user1

# 切换到root用户，并切换环境
su -
echo $HOME
# 输出：/root
```

## 高级用法

### 执行单个命令后返回

使用`-c`选项可以以其他用户身份执行单个命令，然后立即返回原用户：

```bash
su -c "命令" 用户名
```

例如，以root用户身份更新系统：

```bash
su -c "apt update && apt upgrade -y" root
```

### 指定使用的shell

使用`-s`选项可以指定切换用户后要使用的shell：

```bash
su -s /bin/zsh username
```

### 保留当前环境变量

使用`-p`选项可以在切换用户的同时保留当前的环境变量：

```bash
su -p username
```

## 与sudo的区别

`su`和`sudo`都可以用来获取其他用户（通常是root）的权限，但它们有几个关键区别：

| 特性 | su | sudo |
| --- | --- | --- |
| 密码 | 需要目标用户的密码 | 需要当前用户的密码 |
| 权限范围 | 获取目标用户的所有权限 | 可以配置只允许执行特定命令 |
| 日志记录 | 不记录执行的命令 | 记录所有执行的命令 |
| 会话持续时间 | 直到退出或切换回原用户 | 通常有时间限制（默认5分钟） |

## 实用示例

### 1. 切换到root用户并获取完整环境

```bash
su -
```

### 2. 切换到特定用户并获取完整环境

```bash
su - username
```

### 3. 以root用户身份执行命令后返回

```bash
su -c "systemctl restart nginx" root
```

### 4. 切换到root用户并使用特定shell

```bash
su -s /bin/zsh -
```

### 5. 切换用户并执行特定脚本

```bash
su - username -c "/path/to/script.sh"
```

## 安全注意事项

1. **限制root直接登录**：在生产环境中，应该禁止直接使用`su`切换到root用户，而是使用`sudo`分配特定权限。

2. **使用sudo替代su**：`sudo`提供了更细粒度的权限控制和更好的审计功能。

3. **定期更改密码**：确保所有用户账户（尤其是root）使用强密码，并定期更改。

4. **监控su使用情况**：可以通过查看`/var/log/auth.log`或`/var/log/secure`文件来监控`su`命令的使用。

## 常见问题

### "认证失败"错误

如果使用`su`命令时出现"认证失败"错误，可能是：
- 输入的密码不正确
- 目标用户账户被锁定
- 目标用户没有登录shell（在`/etc/passwd`中设置为`/sbin/nologin`）

### 无法切换到某用户

确保：
- 目标用户存在
- 您有权限切换到该用户
- 目标用户有有效的登录shell

## 相关命令

- `sudo` - 以另一个用户身份执行命令
- `whoami` - 显示当前有效用户
- `id` - 显示用户身份信息
- `login` - 开始登录会话

## 参考资料

- [Linux man pages: su(1)](https://linux.die.net/man/1/su)
- [GNU Coreutils: su](https://www.gnu.org/software/coreutils/manual/html_node/su-invocation.html) 
