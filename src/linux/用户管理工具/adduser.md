---
title: Linux 用户权限管理命令文档
category:
  - Linux命令
tag:
  - 用户管理
  - 系统管理
  - groupdel
  - adduser
  - passwd
  - usermod
  - userdel
date: 2022-08-26

---

# Linux 用户权限管理命令文档

## 一、用户管理基础

### 1.1 添加用户

#### adduser 命令说明

`adduser` 是一个交互式的用户添加工具，相比 `useradd` 更加友好和自动化。

**系统支持情况：**
- **Debian/Ubuntu 系列**：原生支持，推荐使用（交互式，自动创建家目录）
- **RHEL/CentOS/Fedora 系列**：部分版本支持，通常是 `useradd` 的符号链接
- **建议**：Debian 系统使用 `adduser`，RHEL 系统使用 `useradd`

**基本用法：**

```bash
# Debian/Ubuntu 系统
sudo adduser tommy

info: Adding user `tommy' ...
info: Selecting UID/GID from range 1000 to 59999 ...
info: Adding new group `tommy' (1001) ...
info: Adding new user `tommy' (1001) with group `tommy (1001)' ...
info: Creating home directory `/home/tommy' ...
info: Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for tommy
Enter the new value, or press ENTER for the default
        Full Name []:
        Room Number []: 1001
        Work Phone []: 15210895103
        Home Phone []:
        Other []:
Is the information correct? [Y/n]
info: Adding new user `tommy' to supplemental / extra groups `users' ...
info: Adding user `tommy' to group `users' ...

# RHEL/CentOS 系统（使用 useradd）
sudo useradd -m tommy
sudo passwd tommy
```

**adduser 的优势：**
- 自动创建家目录
- 自动设置默认 shell
- 交互式设置密码
- 自动创建同名用户组
- 自动复制 `/etc/skel` 目录内容

### 1.2 修改用户密码

```bash
# 修改指定用户密码
sudo passwd tommy

# 执行后按提示输入新密码
New password:              # 输入新密码
Retype new password:       # 再次确认密码
passwd: password updated successfully
```

### 1.3 完整的使用示例

**添加用户和组**

```bash
# 添加用户
$ adduser daizhao

info: Adding user `daizhao' ...
info: Selecting UID/GID from range 1000 to 59999 ...
info: Adding new group `daizhao' (1001) ...
info: Adding new user `daizhao' (1001) with group `daizhao (1001)' ...
info: Creating home directory `/home/daizhao' ...
info: Copying files from `/etc/skel' ...
New password:
Retype new password:
passwd: password updated successfully
Changing the user information for daizhao
Enter the new value, or press ENTER for the default
        Full Name []:
        Room Number []: 1001
        Work Phone []: 15210895103
        Home Phone []:
        Other []:
Is the information correct? [Y/n]
info: Adding new user `daizhao' to supplemental / extra groups `users' ...
info: Adding user `daizhao' to group `users' ...

# 查看所在组
$ id daizhao
uid=1001(daizhao) gid=1001(daizhao) groups=1001(daizhao),100(users)

# 添加用户到sudo附加组（获得管理员权限）
$ usermod -aG sudo daizhao
# 添加用户到docker附加组（使用 Docker）
$ usermod -aG docker daizhao
# 验证
$ id daizhao
uid=1001(daizhao) gid=1001(daizhao) groups=1001(daizhao),27(sudo),100(users)
```

**修改用户名和组**

```bash
# 1. 确保要修改的用户已登出（重要！）
# 如果该用户正在登录，必须先退出或强制踢出

# 2. 切换到 root 用户
sudo su -

# 3. 杀掉该用户的所有进程（如果用户在线）
pkill -u oldusername

# 4. 修改用户名
usermod -l newusername oldusername

# 5. 修改用户的家目录名称（可选但推荐）
usermod -d /home/newusername -m newusername

# 6. 修改用户的主组名（如果需要）
groupmod -n newusername oldusername

# 7. 验证修改
id newusername
```



## 二、sudo 权限配置

### 2.1 准备工作

`/etc/sudoers` 是 Linux 系统中控制哪些用户可以使用 `sudo` 命令的配置文件。这个文件非常重要，如果改错了可能导致系统无法正常使用管理员权限。

修改 sudoers 文件前，需要注意权限问题：

#### 方法一：直接修改文件（不推荐）

```bash
# 如果遇到只读文件无法修改，临时添加写权限
sudo chmod u+w /etc/sudoers

# 修改完成后，务必恢复只读权限（安全考虑）
sudo chmod u-w /etc/sudoers
```

#### 方法二：使用 visudo（强烈推荐）它会自动检查语法错误 ✅

```bash
sudo visudo
```

### 2.2 授予 sudo 权限的2种方法

#### 方法一：通过 wheel/sudo 组授权（推荐）✅

这是最标准和安全的方式，通过用户组统一管理权限。

```bash
# 将用户添加到对应的管理组
# Debian/Ubuntu 系统
sudo usermod -aG sudo tommy

# RHEL/CentOS 系统
sudo usermod -aG wheel tommy

# 验证用户组
id tommy
# 输出示例：uid=1001(tommy) gid=1001(tommy) groups=1001(tommy),10(wheel)

# 查看组成员
# Debian/Ubuntu
getent group sudo

# RHEL/CentOS
getent group wheel
```

**说明：**
- `-a` 表示 append（追加），保留用户原有的其他组
- `-G` 指定要添加的附加组
- 用户需要重新登录才能使权限生效

---

#### 方法二：直接授予单个用户权限

适用于需要单独管理特定用户权限的场景（如只允许执行特定命令）。
```bash
# 编辑 sudoers 文件
sudo visudo

# 在文件末尾添加以下内容
tommy   ALL=(ALL:ALL)   ALL

# 如果希望执行 sudo 时不需要输入密码（谨慎使用）
tommy   ALL=(ALL:ALL)   NOPASSWD:ALL

# 如果只允许执行特定命令
tommy   ALL=(ALL)       /usr/bin/systemctl, /usr/bin/apt
```

**参数说明：**
- `tommy`：用户名
- `ALL`：可以从任何主机登录
- `(ALL:ALL)`：可以作为任何用户和任何组执行命令
- `ALL`：可以执行任何命令

---

#### 验证权限
```bash
# 切换到目标用户
su - tommy

# 测试 sudo 权限
sudo whoami
# 应输出：root

# 查看当前用户可以执行的 sudo 命令
sudo -l

```

---

#### 最佳实践建议

1. **优先使用方法一**（用户组方式），便于统一管理
2. **避免使用 NOPASSWD**，除非在自动化脚本等特殊场景
3. **遵循最小权限原则**，只授予必要的命令执行权限
4. **定期审计** sudoers 配置和用户组成员


## 三、用户和组的删除

### 3.1 删除用户

```bash
# 删除用户及其家目录
sudo userdel -r tommy

# 常见问题：用户正在使用中
# 错误信息：user tommy is currently used by process 1983
# 解决方法：
# 1. 退出该用户的所有会话
exit  # 在 tommy 用户会话中执行

# 2. 终止用户的所有进程
sudo pkill -u tommy

# 3. 再次尝试删除
sudo userdel -r tommy
```

### 3.2 删除用户组

```bash
# 查看当前系统的组
tail -n 10 /etc/group

# 或者查看特定组
getent group tommy

# 删除组（确保没有用户关联）
sudo groupdel tommy

# 验证是否删除成功
getent group tommy
# 无输出表示删除成功
```

## 四、特定权限管理示例

### 4.1 Docker 用户组管理

将用户添加到 docker 组，使其无需 sudo 即可执行 docker 命令：

```bash
# 1. 检查 docker 组是否存在
getent group docker

# 2. 如果不存在，创建 docker 组
sudo groupadd docker

# 3. 将用户添加到 docker 组
sudo usermod -aG docker tommy

# 4. 验证
getent group docker
# 输出：docker:x:993:tommy

# 5. 重启 docker 服务
sudo systemctl restart docker

# 6. 用户需要重新登录才能生效
# 或者执行以下命令立即生效
newgrp docker
```

## 五、最佳实践建议

1. **使用 visudo 编辑 sudoers**：自动语法检查，避免配置错误导致系统无法管理
2. **通过用户组管理权限**：便于批量管理和权限审计
3. **避免使用 NOPASSWD**：除非在自动化脚本场景，否则要求输入密码更安全
4. **定期审查用户权限**：删除不再需要的用户和权限
5. **使用强密码策略**：配合 PAM 模块强制密码复杂度
6. **记录 sudo 操作日志**：便于安全审计（日志位置：`/var/log/auth.log` 或 `/var/log/secure`）

## 六、常用命令速查

```bash
# 用户管理
sudo adduser username          # 添加用户（Debian/Ubuntu）
sudo useradd -m username       # 添加用户（RHEL/CentOS）
sudo passwd username           # 修改密码
sudo userdel -r username       # 删除用户及家目录
id username                    # 查看用户信息

# 组管理
sudo groupadd groupname        # 创建组
sudo groupdel groupname        # 删除组
sudo usermod -aG group user    # 将用户添加到组
getent group groupname         # 查看组信息

# sudo 权限
sudo visudo                    # 安全编辑 sudoers
sudo -l                        # 查看当前用户 sudo 权限
sudo -l -U username           # 查看指定用户 sudo 权限

# 会话管理
su - username                  # 切换用户（完整环境）
su username                    # 切换用户（保留当前环境）
exit                          # 退出当前会话
```

---

**注意事项：**
- 本文档适用于主流 Linux 发行版
- 不同系统的默认配置可能略有差异
- 操作前建议先在测试环境验证
- 关键操作建议做好备份和记录