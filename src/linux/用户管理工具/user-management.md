---
title: Ubuntu用户管理命令
category:
  - Linux命令
tag:
  - 用户管理
  - Ubuntu
  - 系统管理
  - groupdel
  - useradd
  - passwd
  - usermod
  - userdel
date: 2022-08-26

---

# ubuntu用户管理命令

## 简介

用户管理是Linux系统管理中的重要组成部分。Ubuntu作为一种流行的Linux发行版，提供了一系列命令行工具来创建、修改和删除用户账户以及管理用户组。本文档将介绍Ubuntu系统中常用的用户管理命令。

## 用户相关文件

在了解用户管理命令之前，先了解一下与用户账户信息相关的重要文件：

| 文件路径 | 描述 |
| --- | --- |
| `/etc/passwd` | 存储用户账户信息的文件 |
| `/etc/shadow` | 存储用户密码的加密信息 |
| `/etc/group` | 存储组信息 |
| `/etc/default/useradd` | 定义创建用户的默认设置 |
| `/etc/login.defs` | 系统广义设置文件 |
| `/etc/skel` | 新用户主目录的默认初始配置文件目录 |

## 用户管理命令

### 1. 添加用户 (useradd)

`useradd`命令用于创建新用户账户。

#### 基本语法

```bash
sudo useradd [选项] 用户名
```

#### 常用选项

| 选项 | 描述 |
| --- | --- |
| `-m` | 创建用户的主目录 |
| `-d 目录` | 指定用户的主目录 |
| `-g 组名` | 指定用户的主组 |
| `-G 组列表` | 指定用户的附加组，多个组用逗号分隔 |
| `-s shell` | 指定用户的登录shell |
| `-c 注释` | 添加用户的注释信息 |
| `-e 日期` | 指定账户的过期日期，格式为YYYY-MM-DD |

#### 示例

创建一个基本用户：

```bash
sudo useradd username
```

创建用户并指定主目录、组和shell：

```bash
sudo useradd -m -d /home/customhome -g developers -s /bin/bash newuser
```

创建用户并添加到多个组：

```bash
sudo useradd -m -G sudo,developers,docker newuser
```

### 2. 设置用户密码 (passwd)

`passwd`命令用于设置或修改用户密码。

#### 基本语法

```bash
sudo passwd [选项] [用户名]
```

如果不指定用户名，则修改当前用户的密码。

#### 常用选项

| 选项 | 描述 |
| --- | --- |
| `-e` | 强制用户下次登录时修改密码 |
| `-l` | 锁定用户账户 |
| `-u` | 解锁用户账户 |
| `-d` | 删除用户密码 |
| `-S` | 显示账户密码状态 |

#### 示例

设置新用户的密码(密码激活)：

```bash
sudo passwd username
```

强制用户下次登录时修改密码：

```bash
sudo passwd -e username
```

锁定用户账户：

```bash
sudo passwd -l username
```

解锁用户账户：

```bash
sudo passwd -u username
```

### 3. 修改用户信息 (usermod)

`usermod`命令用于修改已存在用户的各种属性。

#### 基本语法

```bash
sudo usermod [选项] 用户名
```

#### 常用选项

| 选项 | 描述 |
| --- | --- |
| `-d 目录` | 修改用户的主目录 |
| `-m` | 与-d一起使用，将原主目录内容移动到新目录 |
| `-g 组名` | 修改用户的主组 |
| `-G 组列表` | 修改用户的附加组 |
| `-a` | 与-G一起使用，将用户添加到新的附加组，而不移除已有的组 |
| `-s shell` | 修改用户的登录shell |
| `-l 新用户名` | 修改用户名 |
| `-L` | 锁定用户账户 |
| `-U` | 解锁用户账户 |
| `-e 日期` | 设置账户过期日期 |

#### 示例

将用户添加到新的组（保留原有组）：

```bash
sudo usermod -a -G docker username
```

修改用户的主组：

```bash
sudo usermod -g developers username
```

修改用户的主目录并移动内容：

```bash
sudo usermod -d /home/newpath -m username
```

修改用户的登录shell：

```bash
sudo usermod -s /bin/zsh username
```

修改用户名：

```bash
sudo usermod -l newname oldname
```

设置账户过期日期：

```bash
sudo usermod -e 2023-12-31 username
```

### 4. 删除用户 (userdel)

`userdel`命令用于删除用户账户。

#### 基本语法

```bash
sudo userdel [选项] 用户名
```

#### 常用选项

| 选项 | 描述 |
| --- | --- |
| `-r` | 删除用户的主目录和邮件池 |
| `-f` | 强制删除用户，即使用户仍然登录 |

#### 示例

删除用户但保留其主目录：

```bash
sudo userdel username
```

删除用户及其主目录：

```bash
sudo userdel -r username
```

### 5. 组管理命令

#### 添加组 (groupadd)

```bash
sudo groupadd [选项] 组名
```

常用选项：

| 选项 | 描述 |
| --- | --- |
| `-g GID` | 指定组ID |

示例：

```bash
sudo groupadd developers
```

#### 修改组 (groupmod)

```bash
sudo groupmod [选项] 组名
```

常用选项：

| 选项 | 描述 |
| --- | --- |
| `-n 新组名` | 修改组名 |
| `-g GID` | 修改组ID |

示例：

```bash
sudo groupmod -n dev developers
```

#### 删除组 (groupdel)

```bash
sudo groupdel 组名
```

示例：

```bash
sudo groupdel developers
```

#### 查看用户所属组 (groups)

```bash
groups [用户名]
```

如果不指定用户名，则显示当前用户所属的组。

示例：

```bash
groups username
```

### 6. 查看用户信息

#### 查看用户ID和组信息 (id)

```bash
id [用户名]
```

如果不指定用户名，则显示当前用户的信息。

示例：

```bash
id username
```

#### 查看当前登录的用户 (who)

```bash
who
```

#### 查看当前用户名 (whoami)

```bash
whoami
```

#### 查看用户登录历史 (last)

```bash
last [用户名]
```

## 实用案例

### 1. 创建一个具有sudo权限的新用户

```bash
# 创建用户
sudo useradd -m -s /bin/bash newadmin

# 设置密码
sudo passwd newadmin

# 将用户添加到sudo组
sudo usermod -a -G sudo newadmin
```

### 2. 创建一个系统用户（用于运行服务）

```bash
# 创建系统用户，不创建主目录，不允许登录
sudo useradd -r -s /usr/sbin/nologin serviceuser
```

### 3. 批量创建多个用户

```bash
# 创建一个包含用户名的文件
echo -e "user1\nuser2\nuser3" > users.txt

# 批量创建用户
while read user; do
  sudo useradd -m -s /bin/bash $user
  echo "Created user: $user"
done < users.txt
```

### 4. 修改文件夹的所有权

```bash
sudo chown username:groupname /path/to/directory
```

递归修改目录及其所有内容的所有权：

```bash
sudo chown -R username:groupname /path/to/directory
```

## 用户权限管理

### 使用chmod修改文件权限

```bash
# 给文件所有者添加执行权限
chmod u+x filename

# 设置精确的权限模式
chmod 755 filename  # rwxr-xr-x

# 递归修改目录权限
chmod -R 755 directory
```

### 使用chown修改文件所有者

```bash
# 修改文件所有者
chown username filename

# 修改文件所有者和组
chown username:groupname filename

# 递归修改目录所有权
chown -R username:groupname directory
```

## 常见问题及解决方案

### 1. 无法删除用户

问题：使用`userdel`命令时提示"用户正在使用"。

解决方案：
- 确认用户是否已登录：`who | grep username`
- 强制用户登出：`sudo pkill -u username`
- 然后再删除用户：`sudo userdel -r username`

### 2. 用户无法使用sudo

问题：新创建的用户无法使用sudo命令。

解决方案：
- 将用户添加到sudo组：`sudo usermod -a -G sudo username`
- 或者编辑sudoers文件：`sudo visudo`，添加`username ALL=(ALL:ALL) ALL`

### 3. 忘记root密码

解决方案：
1. 重启系统，进入恢复模式
2. 选择"root - Drop to root shell prompt"
3. 重新挂载根文件系统为可写：`mount -o remount,rw /`
4. 使用`passwd`命令重置root密码
5. 重启系统：`reboot`

## 参考资料

- [Ubuntu官方文档 - 用户管理](https://help.ubuntu.com/community/AddUsersHowto)
- [Linux man pages: useradd(8)](https://linux.die.net/man/8/useradd)
- [Linux man pages: usermod(8)](https://linux.die.net/man/8/usermod)
- [Linux man pages: userdel(8)](https://linux.die.net/man/8/userdel) 
- [用户管理ppt](../_resources/Linux_用户管理.resources/Linux用户管理.ppt)
