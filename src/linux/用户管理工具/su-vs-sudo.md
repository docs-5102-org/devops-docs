---
title: su和sudo的区别与使用指南
category:
  - Linux系统
tag:
  - 用户管理
  - 系统管理
  - 权限控制
  - 安全
date: 2022-08-23

---

# su和sudo的区别与使用指南

## 一、使用 su 命令临时切换用户身份

### 1. su 的适用条件和威力

su命令是切换用户的工具。例如，当我们以普通用户beinan登录系统，但需要执行添加用户的任务（useradd命令）时，由于beinan用户没有这个权限，而root用户拥有此权限，我们有两种解决方案：

1. **方案一**：退出beinan用户，重新以root用户登录（不推荐）
2. **方案二**：使用su命令切换到root用户执行相关操作，完成后再退出root（推荐）

**权限特点：**
- 超级用户root向普通或虚拟用户切换**不需要密码**
- 普通用户切换到任何其他用户都**需要密码验证**

### 2. su 的用法

```bash
su [选项参数] [用户]
```

**主要参数：**
- `-, -l, --login`：登录并改变到所切换的用户环境
- `-c, --command=COMMAND`：执行一个命令，然后退出所切换到的用户环境

### 3. su 的使用示例

#### 3.1 基本切换（不改变环境）
```bash
[beinan@localhost ~]$ su
Password:
[root@localhost beinan]# pwd
/home/beinan
```
*说明：切换到root用户，但仍在beinan的家目录*

#### 3.2 完全切换（改变环境）
```bash
[beinan@localhost ~]$ su -
Password:
[root@localhost ~]# pwd
/root
```
*说明：切换到root用户并改变到root的环境*

#### 3.3 切换到指定用户
```bash
[beinan@localhost ~]$ su - linuxsir
Password:
[linuxsir@localhost ~]$ pwd
/home/linuxsir
[linuxsir@localhost ~]$ id
uid=505(linuxsir) gid=502(linuxsir) groups=0(root),500(beinan),502(linuxsir)
```

#### 3.4 执行命令后退出
```bash
[beinan@localhost ~]$ su - -c ls
Password:
anaconda-ks.cfg Desktop install.log install.log.syslog testgroup
[beinan@localhost ~]$ pwd
/home/beinan
```
*说明：以root身份执行ls命令后自动退回原用户*

### 4. su的优缺点

**优点：**
- 管理方便，通过切换到root可以完成所有系统管理工作

**缺点：**
- **安全隐患**：需要告诉所有管理员root密码
- **权限无限制**：切换后拥有完全的系统权限
- **无法追踪**：无法明确哪个管理员执行了哪些操作
- **风险高**：任何操作失误都可能导致系统崩溃或数据丢失

**适用场景：**
- 只有1-2个人参与管理的系统
- 不适合多人参与的系统管理

---

## 二、sudo - 授权许可使用的受限制su

### 1. sudo 的适用条件

sudo相比su有以下优势：
- **针对性授权**：可以有针对性地下放权限
- **无需root密码**：普通用户不需要知道root密码
- **相对安全**：被称为"受限制的su"或"授权许可的su"
- **操作追踪**：可以记录谁执行了什么操作

**工作流程：**
当前用户 → 切换到root（或指定用户） → 执行命令 → 退回当前用户

### 2. sudo配置文件 /etc/sudoers

**编辑方法：**
```bash
visudo
```
*注意：使用visudo编辑器的好处是在规则错误时会提示错误信息*

**文件规则：**
- 每行为一个规则
- `#`开头为注释
- 长规则可用`\`续行
- 规则分为两类：别名定义和授权规则

### 3. 别名规则定义

#### 3.1 别名定义格式
```
Alias_Type NAME = item1, item2, ...
```

#### 3.2 别名类型

| 别名类型 | 说明 | 示例 |
|---------|------|------|
| `Host_Alias` | 定义主机别名 | 主机名、IP地址、网段 |
| `User_Alias` | 定义用户别名 | 用户名、用户组（前加%） |
| `Runas_Alias` | 定义目标用户别名 | sudo允许切换到的用户 |
| `Cmnd_Alias` | 定义命令别名 | 系统命令的绝对路径 |

#### 3.3 别名定义示例

**主机别名：**
```bash
Host_Alias HT01=localhost,st05,st04,10.0.0.4,255.255.255.0,192.168.1.0/24
Host_Alias HT02=st09,st10
```

**用户别名：**
```bash
User_Alias SYSAD=beinan,linuxsir,bnnnb,lanhaitun
User_Alias NETAD=beinan,bnnb
User_Alias WEBMASTER=linuxsir
```

**命令别名：**
```bash
Cmnd_Alias USERMAG=/usr/sbin/adduser,/usr/sbin/userdel,/usr/bin/passwd [A-Za-z]*,/bin/chown,/bin/chmod
Cmnd_Alias DISKMAG=/sbin/fdisk,/sbin/parted
Cmnd_Alias NETMAG=/sbin/ifconfig,/etc/init.d/network
Cmnd_Alias PWMAG=/usr/sbin/reboot,/usr/sbin/halt
```

**运行身份别名：**
```bash
Runas_Alias OP=root,operator
Runas_Alias DBADM=mysql
```

### 4. 授权规则

#### 4.1 基本格式
```
授权用户 主机=命令动作
```

#### 4.2 完整格式
```
授权用户 主机=[(切换到的用户)] [是否需要密码验证] 命令1,[(切换到的用户)] [是否需要密码验证] 命令2
```

#### 4.3 授权规则示例

**示例1：基本授权**
```bash
beinan ALL=/bin/chown,/bin/chmod
```
*说明：beinan用户可以在任何主机上以root身份执行chown和chmod命令*

**示例2：指定目标用户**
```bash
beinan ALL=(root) /bin/chown,/bin/chmod
```

**示例3：免密码执行**
```bash
beinan ALL=(root) NOPASSWD: /bin/chown,/bin/chmod
```

**示例4：实际应用场景**
```bash
beinan ALL=/bin/more
```
*说明：允许beinan用户以root身份查看文件*

**示例5：用户组授权**
```bash
%beinan ALL=/usr/sbin/*,/sbin/*
```
*说明：beinan用户组的所有成员可以执行/usr/sbin和/sbin下的所有命令*

**示例6：禁止特定命令**
```bash
beinan ALL=/usr/sbin/*,/sbin/*,!/usr/sbin/fdisk
```
*说明：可以执行/usr/sbin和/sbin下的所有命令，但fdisk除外*

#### 4.4 别名应用实例

```bash
# 定义别名
User_Alias SYSADER=beinan,linuxsir,%beinan
User_Alias DISKADER=lanhaitun
Runas_Alias OP=root
Cmnd_Alias SYDCMD=/bin/chown,/bin/chmod,/usr/sbin/adduser,/usr/bin/passwd [A-Za-z]*,!/usr/bin/passwd root
Cmnd_Alias DSKCMD=/sbin/parted,/sbin/fdisk

# 授权规则
SYSADER ALL=SYDCMD,DSKCMD
DISKADER ALL=(OP) DSKCMD
```

### 5. sudo命令使用

#### 5.1 基本语法
```bash
sudo [参数选项] 命令
```

#### 5.2 常用参数

| 参数 | 说明 |
|------|------|
| `-l` | 列出用户可用的和被禁止的命令 |
| `-v` | 验证用户的时间戳 |
| `-u` | 指定以某个用户身份执行 |
| `-k` | 删除时间戳，下次需要重新输入密码 |

#### 5.3 使用示例

**查看可用命令：**
```bash
[beinan@localhost ~]$ sudo -l
Password:
User beinan may run the following commands on this host:
    (root) /bin/chown
    (root) /bin/chmod
    (root) /usr/sbin/adduser
    (root) /usr/bin/passwd [A-Za-z]*
    (root) !/usr/bin/passwd root
    (root) /sbin/parted
    (root) /sbin/fdisk
```

**执行授权命令：**
```bash
[beinan@localhost ~]$ sudo chown beinan:beinan /opt
[beinan@localhost ~]$ sudo passwd linuxsir
Changing password for user linuxsir.
New UNIX password:
Retype new UNIX password:
passwd: all authentication tokens updated successfully.
```

---

## 三、su与sudo的对比总结

| 特性 | su | sudo |
|------|----|----- |
| **密码要求** | 需要目标用户密码 | 需要当前用户密码 |
| **权限控制** | 完全权限，无限制 | 精确权限控制 |
| **安全性** | 相对较低 | 相对较高 |
| **适用场景** | 少数人管理 | 多人协作管理 |
| **操作追踪** | 难以追踪 | 可以记录和追踪 |
| **配置复杂度** | 简单 | 相对复杂 |

## 四、最佳实践建议

1. **单人或少数人管理**：可以使用su命令
2. **多人协作管理**：推荐使用sudo
3. **生产环境**：优先考虑sudo，提供更好的安全性和可控性
4. **权限最小化**：只授予必要的权限，避免过度授权
5. **定期审查**：定期检查和更新sudo配置
6. **日志监控**：监控sudo的使用日志，及时发现异常操作

---

*注：本文档基于Linux系统环境，不同发行版可能存在细微差异。使用时请参考相应的man手册获取详细信息。*
