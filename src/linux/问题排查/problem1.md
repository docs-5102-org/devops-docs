---
title: 常见问题一
toc: 目录
category:
  - Linux
  - 问题排查
tag:
  - 故障处理
  - 错误解决
  - 系统配置
  - 软件安装
source: https://blog.csdn.net/JacksonKing/article/details/89501668

date: 2022-10-09

---

# 常见问题一

## /bin/bash^M: bad interpreter: No such file or directory

**解决方式一, 手动更改编码格式**

```
:set fileencoding

fileencoding=utf-8

:set ff=unix
:wq
```

**解决方式二, 将 Windows 格式文件转换为 Unix 格式**

```bash
dos2unix filename.txt
```

参考: [doc2unix](../软件安装与包管理/doc2unix.md)

---

## checking for C compiler ... not found

[](../_resources/configure_error_C_compiler_cc_is_not_found.resources/unknown_filename.png)

这个错误表示系统缺少C编译器。以下是针对不同Linux发行版的优化安装命令：

### RedHat/CentOS/Fedora 系列

**CentOS 7/RHEL 7:**
```bash
yum groupinstall -y "Development Tools"
# 或者单独安装
yum install -y gcc gcc-c++ make autoconf automake
```

**CentOS 8/RHEL 8/Rocky Linux/AlmaLinux:**
```bash
dnf groupinstall -y "Development Tools"
# 或者
dnf install -y gcc gcc-c++ make autoconf automake
```

**Fedora:**
```bash
dnf groupinstall -y "C Development Tools and Libraries"
# 或者
dnf install -y gcc gcc-c++ make autoconf automake
```

### Debian/Ubuntu 系列

**Ubuntu/Debian:**
```bash
apt update && apt install -y build-essential autoconf automake
# build-essential 包含了 gcc, g++, make 等基础编译工具
```

### SUSE 系列

**openSUSE:**
```bash
zypper install -y gcc gcc-c++ make autoconf automake
# 或者安装开发工具组
zypper install -y -t pattern devel_basis
```

### Alpine Linux

```bash
apk add --no-cache gcc g++ make autoconf automake musl-dev
```

### Arch Linux

```bash
pacman -S gcc make autoconf automake
# 或者安装完整的开发工具组
pacman -S base-devel
```

---

## nginx getpwnam("www") failed 


### 问题描述

在配置或启动nginx时，可能会遇到以下错误：
```
nginx: [emerg] getpwnam("www") failed
```

这个错误表示nginx无法找到指定的用户"www"，通常出现在系统缺少对应用户或nginx配置不当的情况下。

### 解决方案

#### 方案一：修改nginx配置文件（推荐用于测试环境）

1. 编辑nginx配置文件：
   ```bash
   sudo vim /etc/nginx/nginx.conf
   ```

2. 找到配置文件开头的用户设置行，将其修改为：
   ```nginx
   user nobody;
   ```
   
3. 如果该行被注释掉（前面有#），请去掉注释符号

4. 保存配置文件并重启nginx：
   ```bash
   sudo nginx -t          # 测试配置文件语法
   sudo systemctl restart nginx
   ```

#### 方案二：创建www用户（推荐用于生产环境）

这是更规范的解决方案，为nginx创建专用的用户和用户组：

1. 创建www用户组：
   ```bash
   sudo groupadd -f www
   ```

2. 创建www用户并加入www组：
   ```bash
   sudo useradd -g www -s /sbin/nologin -M www
   ```
   
   参数说明：
   - `-g www`：指定用户的主组为www
   - `-s /sbin/nologin`：禁止用户登录shell，提高安全性
   - `-M`：不创建用户家目录

3. 确认nginx配置文件中的用户设置：
   ```nginx
   user www;
   ```

4. 重启nginx服务：
   ```bash
   sudo nginx -t
   sudo systemctl restart nginx
   ```

### 验证解决方案

解决问题后，可以通过以下方式验证：

1. **检查nginx状态**：
   ```bash
   sudo systemctl status nginx
   ```

2. **检查nginx进程**：
   ```bash
   ps aux | grep nginx
   ```
   应该看到nginx进程正在以指定用户身份运行

3. **浏览器测试**：
   在浏览器中访问服务器IP地址，应该能看到nginx的欢迎页面：
   ```
   Welcome to nginx!
   ```

### 最佳实践建议

1. **生产环境**建议使用方案二，为nginx创建专用用户，提高系统安全性
2. **测试环境**可以使用方案一快速解决问题
3. 定期检查nginx配置文件语法：`nginx -t`
4. 配置文件修改后务必重启服务使配置生效

### 常见问题

**Q: 为什么要创建专用的www用户？**
A: 使用专用用户可以限制nginx进程的权限，即使nginx出现安全漏洞，攻击者也无法获得过高的系统权限。

**Q: 可以使用其他用户名吗？**
A: 可以，只需要确保nginx.conf中的用户配置与实际创建的用户名一致即可。

---

## Ubuntu解决"apt-get: Package has no installation candidate"问题

### 问题描述
在Ubuntu系统中使用apt-get安装软件时，经常会遇到以下错误：

```bash
# apt-get install <packagename>
Reading package lists... Done
Building dependency tree... Done
Package <packagename> is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or is only available from another source

E: Package <packagename> has no installation candidate
```

### 解决方案

#### 1. 更新软件包列表（必需步骤）
```bash
sudo apt-get update
```
这个命令会从配置的软件源下载最新的软件包列表信息。

#### 2. 检查并添加软件源（如需要）
如果更新后仍然无法找到软件包，可能需要添加或修改软件源：

```bash
sudo vim /etc/apt/sources.list
```

添加适合的软件源，例如：
```
# 163镜像源
deb http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse
deb-src http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse

# 官方源
deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
```

**注意：** 将`focal`替换为你的Ubuntu版本代号（如jammy、bionic等）。

#### 3. 升级已安装的软件包（可选）
```bash
sudo apt-get upgrade
```

#### 4. 重新安装目标软件包
```bash
sudo apt-get install <packagename>
```

### 其他解决方法

#### 方法一：使用apt替代apt-get
```bash
sudo apt update
sudo apt install <packagename>
```

#### 方法二：搜索相似软件包
```bash
apt search <packagename>
# 或
apt-cache search <packagename>
```

#### 方法三：检查软件包是否存在于其他仓库
```bash
apt list --upgradable | grep <packagename>
```


### 预防措施
- 定期运行`sudo apt update`保持软件包列表最新
- 确保软件源配置正确且可访问
- 使用LTS版本的Ubuntu以获得更好的软件包支持

通过以上步骤，通常可以解决"Package has no installation candidate"的问题。

---

## 解决systemctl启动firewalld时出现`Unit is masked`错误

原因：firewalld服务被锁定，不能添加对应端口

[](../_resources/执行_systemctl_start_firewalld_命令后出现Failed_to_start_firewalld.service_Unit_is_masked.resources/unknown_filename.png)

### 解决方法

执行命令，即可实现取消服务的锁定

```bash
# systemctl unmask firewalld
```

下次需要锁定该服务时执行

```bash
# systemctl mask firewalld
```

## 问题libm.so.6 version `GLIBC_2.27` not found的解决方法

解决问题方法

https://blog.csdn.net/chen1231992/article/details/117255528

glibc 与 centOs 系统对应关系

参考：[](http://www.rpmfind.net/linux/rpm2html/search.php?query=glibc&submit=Search+...&system=&arch=)

