---
title: yum命令
category:
  - Linux
  - 软件安装与包管理
tag:
  - yum
  - 包管理
  - 软件安装
date: 2022-10-02

---

# YUM 包管理器完整使用指南

## 系统兼容性

YUM（Yellowdog Updater Modified）是基于 RPM 的包管理器，主要适用于以下 Linux 发行版：

- **Red Hat Enterprise Linux (RHEL)** 5/6/7
- **CentOS** 5/6/7
- **Fedora** 早期版本（22 之前）
- **Scientific Linux**
- **Oracle Linux**

> **注意**：从 RHEL 8/CentOS 8 开始，YUM 已被 DNF 取代。Fedora 从版本 22 开始也使用 DNF。

## 基本概念

YUM 的工作原理是管理 RPM 格式的软件包，它会自动解决依赖关系问题。当安装软件时，YUM 会查询数据库，检查依赖关系，并提供解决方案。

## 软件包管理

### 安装软件包

```bash
# 安装单个软件包
yum install package-name

# 自动确认安装（跳过确认提示）
yum -y install package-name

# 支持通配符安装
yum install package*

# 从本地 RPM 文件安装并解决依赖
yum localinstall package.rpm
```

### 卸载软件包

```bash
# 卸载软件包
yum remove package-name

# 注意：remove 命令不支持通配符
```

### 更新软件包

```bash
# 更新所有软件包
yum update

# 更新特定软件包
yum update package-name

# 升级系统（与 update 类似）
yum upgrade
```

## 查询功能

### 搜索软件包

```bash
# 按关键词搜索
yum search keyword

# 示例：搜索即时通讯软件
yum search messenger
```

### 列出软件包

```bash
# 列出所有可安装的软件包
yum list

# 列出所有可更新的软件包
yum list updates

# 列出所有已安装的软件包
yum list installed

# 列出已安装但不在仓库中的软件包
yum list extras

# 列出特定软件包
yum list package-name
```

### 获取软件包信息

```bash
# 获取特定软件包信息
yum info package-name

# 列出所有软件包信息
yum info

# 列出可更新软件包信息
yum info updates

# 列出已安装软件包信息
yum info installed

# 列出额外软件包信息
yum info extras
```

### 查询文件提供者

```bash
# 查看软件包提供哪些文件
yum provides filename

# 示例：查看哪个包提供了某个命令
yum provides /bin/ls
```

### 依赖关系查询

```bash
# 查看软件包依赖关系
yum deplist package-name
```

## 软件组管理

```bash
# 列出所有软件组
yum grouplist

# 安装软件组
yum groupinstall "Group Name"

# 更新软件组
yum groupupdate "Group Name"

# 卸载软件组
yum groupremove "Group Name"

# 实用示例
yum groupinstall "Development Tools"
yum groupinstall "Development Libraries"
yum groupinstall "Chinese Support"
```

## 缓存管理

YUM 会将下载的软件包和头文件存储在缓存中（默认位置：`/var/cache/yum`）。

```bash
# 清除下载的软件包
yum clean packages

# 清除头文件缓存
yum clean headers

# 清除旧的头文件
yum clean oldheaders

# 清除所有缓存
yum clean all
```

## 高级技巧

### 1. 加速 YUM

安装 fastestmirror 插件来自动选择最快的镜像源：

```bash
# CentOS 5/6/7
yum -y install yum-fastestmirror

# CentOS 4
yum -y install yum-plugin-fastestmirror
```

### 2. 扩展软件源

添加第三方仓库以获取更多软件包：

**RPMforge 仓库（已停止维护）：**
```bash
# RHEL/CentOS 5 x86_64
rpm -Uhv http://apt.sw.be/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.3.6-1.el5.rf.x86_64.rpm

# RHEL/CentOS 5 i386
rpm -Uhv http://apt.sw.be/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.3.6-1.el5.rf.i386.rpm
```

**EPEL 仓库（推荐）：**
```bash
# CentOS 7
yum install epel-release

# CentOS 6
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
```

### 3. 下载源码包

使用 yum-utils 工具下载源码包：

```bash
# 安装 yum-utils
yum install yum-utils

# 下载源码包
yumdownloader --source package-name

# 示例
yumdownloader --source vsftpd
```

### 4. 仅下载不安装

```bash
# 仅下载 RPM 包
yumdownloader package-name

# 下载到指定目录
yumdownloader --destdir=/tmp package-name
```

## YUM 与 RPM 命令对比

| 功能 | YUM 命令 | RPM 命令 |
|------|----------|----------|
| 安装 | `yum install pkg` | `rpm -ivh pkg.rpm` |
| 卸载 | `yum remove pkg` | `rpm -e pkg` |
| 查询已安装 | `yum list installed` | `rpm -qa` |
| 查询包信息 | `yum info pkg` | `rpm -qi pkg` |
| 查询包文件 | `yum provides file` | `rpm -qf file` |

## 配置文件

主要配置文件：
- `/etc/yum.conf` - YUM 主配置文件
- `/etc/yum.repos.d/` - 仓库配置目录

## 注意事项

1. **权限要求**：大多数 YUM 操作需要 root 权限
2. **网络连接**：需要互联网连接来下载软件包
3. **依赖解决**：YUM 会自动处理依赖关系，比 RPM 更智能
4. **缓存空间**：定期清理缓存以释放磁盘空间
5. **仓库配置**：确保仓库配置正确且可访问

## 常见错误排查

```bash
# 清除所有缓存并重新生成
yum clean all
yum makecache

# 检查仓库配置
yum repolist

# 检查网络连接
yum check-update
```

通过掌握这些 YUM 命令，您可以高效地管理基于 RPM 的 Linux 系统软件包。
