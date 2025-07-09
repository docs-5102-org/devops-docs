---
title: rpm命令-软件包管理工具
category:
  - Linux
  - 软件安装与包管理
tag:
  - rpm
  - 包管理
  - 软件安装
date: 2022-09-29

---

# rpm命令-软件包管理工具

## 简介

`rpm`（RPM Package Manager）是Red Hat、CentOS、Fedora等基于RPM的Linux发行版中使用的软件包管理工具。它用于安装、卸载、更新、查询和验证软件包。RPM包是一种预编译的软件包，包含了程序文件、配置文件以及依赖关系等信息。

## 基本语法

```bash
rpm [选项] [包文件|包名称]
```

## 常用选项

### 查询相关选项

| 选项 | 描述 |
| --- | --- |
| -q | 查询模式 |
| -a | 查询所有已安装的包 |
| -i | 显示包的详细信息 |
| -l | 列出包中的所有文件 |
| -f | 查询指定文件属于哪个包 |
| -p | 查询未安装的RPM包文件 |
| -c | 列出配置文件 |
| -d | 列出文档文件 |
| --requires | 列出包的依赖 |
| --provides | 列出包提供的功能 |

### 安装相关选项

| 选项 | 描述 |
| --- | --- |
| -i | 安装软件包 |
| -U | 升级软件包（如果不存在则安装） |
| -F | 只升级已安装的软件包 |
| --replacepkgs | 重新安装软件包 |
| --nodeps | 不检查依赖关系 |
| --force | 强制安装 |
| -h, --hash | 安装时显示进度条 |
| -v | 显示详细信息 |

### 卸载相关选项

| 选项 | 描述 |
| --- | --- |
| -e | 卸载软件包 |
| --nodeps | 不检查依赖关系 |
| --allmatches | 删除所有匹配的包 |

### 验证相关选项

| 选项 | 描述 |
| --- | --- |
| -V | 验证已安装的包 |
| --nofiles | 不验证文件属性 |
| --nodeps | 不验证包依赖 |

## 基本用法

### 查询操作

#### 查询所有已安装的包

```bash
rpm -qa
```

#### 查询特定包是否已安装

```bash
rpm -q package_name
```

例如：

```bash
rpm -q httpd
```

#### 使用通配符查询

```bash
rpm -qa 'package_pattern*'
```

例如：

```bash
rpm -qa 'http*'
```

#### 结合grep过滤查询结果

```bash
rpm -qa | grep package_pattern
```

例如：

```bash
rpm -qa | grep vim
```

#### 查看包的详细信息

```bash
rpm -qi package_name
```

例如：

```bash
rpm -qi httpd
```

#### 查看未安装包的详细信息

```bash
rpm -qip package_file.rpm
```

#### 列出包中的所有文件

```bash
rpm -ql package_name
```

例如：

```bash
rpm -ql httpd
```

#### 查询指定文件属于哪个包

```bash
rpm -qf /path/to/file
```

例如：

```bash
rpm -qf /usr/bin/vim
```

或者使用命令的输出：

```bash
rpm -qf `which vim`
```

#### 列出包的依赖关系

```bash
rpm -qR package_name
```

例如：

```bash
rpm -qR httpd
```

#### 列出包提供的功能

```bash
rpm -q --provides package_name
```

### 安装操作

#### 安装RPM包

```bash
rpm -ivh package_file.rpm
```

其中：
- `-i`：安装
- `-v`：显示详细信息
- `-h`：显示进度条

#### 升级RPM包

```bash
rpm -Uvh package_file.rpm
```

#### 只升级已安装的包

```bash
rpm -Fvh package_file.rpm
```

#### 不检查依赖关系安装

```bash
rpm -ivh --nodeps package_file.rpm
```

::: warning 警告
使用`--nodeps`选项可能会导致软件无法正常工作，因为缺少必要的依赖。
:::

#### 强制安装

```bash
rpm -ivh --force package_file.rpm
```

### 卸载操作

#### 卸载软件包

```bash
rpm -e package_name
```

#### 不检查依赖关系卸载

```bash
rpm -e --nodeps package_name
```

::: warning 警告
使用`--nodeps`选项可能会破坏系统中其他依赖此包的软件。
:::

### 验证操作

#### 验证已安装的包

```bash
rpm -V package_name
```

如果没有输出，表示包完好无损。否则会显示被修改的文件信息。

#### 验证所有已安装的包

```bash
rpm -Va
```

#### 验证特定文件

```bash
rpm -Vf /path/to/file
```

## 高级用法

### 导入GPG密钥

```bash
rpm --import /path/to/key.asc
```

或从URL导入：

```bash
rpm --import https://example.com/RPM-GPG-KEY
```

### 查询包的安装日期

```bash
rpm -qa --last
```

### 查询包的脚本

```bash
rpm -q --scripts package_name
```

### 从特定位置安装

```bash
rpm -ivh ftp://server/path/package.rpm
```

### 重建RPM数据库

```bash
rpm --rebuilddb
```

### 修复损坏的RPM数据库

```bash
rm -f /var/lib/rpm/__db*
rpm --rebuilddb
```

## 实用示例

### 查找特定命令属于哪个包

```bash
which command_name
rpm -qf `which command_name`
```

例如：

```bash
which ls
rpm -qf `which ls`
```

### 查看包的变更历史

```bash
rpm -q --changelog package_name
```

### 列出包的配置文件

```bash
rpm -qc package_name
```

### 列出包的文档文件

```bash
rpm -qd package_name
```

### 检查包的签名

```bash
rpm --checksig package_file.rpm
```

### 提取RPM包中的文件（不安装）

```bash
rpm2cpio package_file.rpm | cpio -idmv
```

## 常见问题及解决方案

### 依赖问题

问题：安装时提示缺少依赖。

解决方案：
- 安装缺少的依赖包
- 使用`yum`或`dnf`代替`rpm`命令，它们会自动处理依赖关系
- 如果只是测试，可以使用`--nodeps`选项（不推荐用于生产环境）

```bash
# 使用yum安装RPM包及其依赖
yum localinstall package_file.rpm
```

### 文件冲突

问题：安装时提示文件冲突。

解决方案：
- 使用`--replacefiles`选项覆盖冲突文件
- 先卸载冲突的包，再安装新包

```bash
rpm -ivh --replacefiles package_file.rpm
```

### 版本冲突

问题：安装时提示版本冲突。

解决方案：
- 使用`--oldpackage`选项允许降级
- 使用`--force`选项强制安装

```bash
rpm -Uvh --oldpackage package_file.rpm
```

## 与其他包管理工具的比较

### rpm vs yum/dnf

| 特性 | rpm | yum/dnf |
| --- | --- | --- |
| 依赖处理 | 手动 | 自动 |
| 软件源 | 本地文件 | 本地文件和远程仓库 |
| 升级系统 | 需逐个包升级 | 可一键升级所有包 |
| 易用性 | 较复杂 | 较简单 |

::: tip 建议
- 对于日常软件安装和更新，推荐使用`yum`或`dnf`
- 对于特殊情况下的包管理操作，可以使用`rpm`命令
:::

## 参考资料

- [RPM官方文档](http://rpm.org/documentation.html)
- [CentOS RPM指南](https://wiki.centos.org/PackageManagement/Rpm)
- [Fedora RPM指南](https://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/) 
