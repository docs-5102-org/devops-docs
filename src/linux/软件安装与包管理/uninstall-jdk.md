---
title: Linux卸载系统自带JDK完整指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - jdk
  - java
date: 2021-10-01

---

# Linux卸载系统自带JDK完整指南

## 概述

在Linux系统中安装Oracle JDK后，经常会遇到系统自带的OpenJDK与新安装的Oracle JDK冲突的问题。这种冲突会导致`java -version`和`javac -version`显示不同的JDK版本，影响Java环境的正常使用。本文档将详细介绍如何完全卸载系统自带的OpenJDK。

## 问题现象

### JDK版本冲突表现

当系统同时存在Oracle JDK和OpenJDK时，会出现以下现象：

```bash
[root@doctortang ~]# java -version
java version "1.7.0_45"
OpenJDK Runtime Environment (rhel-2.4.3.3.el6-x86_64 u45-b15)
OpenJDK 64-Bit Server VM (build 24.45-b08, mixed mode)

[root@doctortang ~]# javac -version
javac 1.6.0_45
```

**问题分析：**
- `java -version`显示的是OpenJDK 1.7.0版本
- `javac -version`显示的是Oracle JDK 1.6.0版本
- 版本不一致说明系统中存在多个JDK

## 解决方案

### 步骤1：查找系统中的OpenJDK包

使用RPM命令查找所有与Java相关的包：

```bash
[root@doctortang ~]# rpm -qa | grep java
```

典型输出：
```bash
java-1.6.0-openjdk-1.6.0.0-1.66.1.13.0.el6.x86_64
tzdata-java-2013g-1.el6.noarch
java-1.7.0-openjdk-1.7.0.45-2.4.3.3.el6.x86_64
```

### 步骤2：卸载OpenJDK包

使用RPM命令逐个卸载OpenJDK相关包：

```bash
# 卸载OpenJDK 1.6.0
[root@doctortang ~]# rpm -e --nodeps java-1.6.0-openjdk-1.6.0.0-1.66.1.13.0.el6.x86_64

# 卸载OpenJDK 1.7.0
[root@doctortang ~]# rpm -e --nodeps java-1.7.0-openjdk-1.7.0.45-2.4.3.3.el6.x86_64

# 卸载Java时区数据包
[root@doctortang ~]# rpm -e --nodeps tzdata-java-2013g-1.el6.noarch
```

**参数说明：**
- `--nodeps`：忽略依赖关系强制卸载

### 步骤3：使用YUM方式卸载（备选方案）

如果RPM方式无法找到OpenJDK包，可以使用YUM命令：

```bash
# 卸载旧版本Java
yum -y remove java java-1.4.2-gcj-compat-1.4.2.0-40jpp.115

# 卸载OpenJDK 1.6.0
yum -y remove java java-1.6.0-openjdk-1.6.0.0-1.7.b09.el5
```

### 步骤4：验证卸载结果

卸载后验证当前状态：

```bash
[root@doctortang ~]# java -version
-bash: /usr/bin/java: 没有那个文件或目录

[root@doctortang ~]# javac -version
javac 1.6.0_45
```

**状态说明：**
- `java -version`报错说明OpenJDK已被成功卸载
- `javac -version`正常说明Oracle JDK编译器仍然可用

### 步骤5：重新加载环境变量

执行source命令使之前配置的JDK环境变量重新生效：

```bash
[root@doctortang ~]# source /etc/profile
```

### 步骤6：验证最终结果

重新检查Java环境：

```bash
[root@doctortang ~]# java -version
java version "1.6.0_45"
Java(TM) SE Runtime Environment (build 1.6.0_45-b06)
Java HotSpot(TM) 64-Bit Server VM (build 20.45-b01, mixed mode)

[root@doctortang ~]# javac -version
javac 1.6.0_45
```

**成功标志：**
- `java -version`和`javac -version`显示相同版本
- 显示的是Oracle JDK（Java(TM) SE Runtime Environment）

## 常用命令汇总

### 查找相关命令

```bash
# 查找所有Java相关包
rpm -qa | grep java

# 查找OpenJDK相关包
rpm -qa | grep openjdk

# 查看当前Java安装路径
which java
which javac

# 查看所有Java相关进程
ps -ef | grep java
```

### 卸载相关命令

```bash
# RPM方式卸载（推荐）
rpm -e --nodeps <package-name>

# YUM方式卸载
yum remove <package-name>

# 强制YUM卸载
yum -y remove <package-name>
```

### 环境变量相关命令

```bash
# 重新加载profile文件
source /etc/profile

# 查看当前环境变量
echo $JAVA_HOME
echo $PATH

# 编辑环境变量文件
vi /etc/profile
```

## 故障排除

### 常见问题及解决方案

#### 1. 卸载时提示依赖关系错误

**问题：**卸载OpenJDK时提示有其他包依赖

**解决：**使用`--nodeps`参数强制卸载
```bash
rpm -e --nodeps <package-name>
```

#### 2. 卸载后java命令仍然可用

**问题：**卸载OpenJDK后java命令仍然指向旧版本

**解决：**
1. 检查是否有其他Java包未卸载
2. 重新加载环境变量
3. 检查PATH设置

#### 3. 环境变量不生效

**问题：**source /etc/profile后环境变量仍然不正确

**解决：**
1. 检查/etc/profile文件中的JAVA_HOME配置
2. 注销并重新登录
3. 重启系统

#### 4. 无法找到要卸载的包

**问题：**rpm -qa | grep java没有找到OpenJDK包

**解决方案：**
```bash
# 尝试更精确的搜索
rpm -qa | grep -i jdk
rpm -qa | grep -i jre

# 使用dpkg（适用于Debian/Ubuntu系统）
dpkg -l | grep -i jdk
```

## 最佳实践

### 1. 卸载前备份

```bash
# 备份当前环境变量配置
cp /etc/profile /etc/profile.backup

# 记录当前Java版本信息
java -version > java_version_backup.txt
javac -version >> java_version_backup.txt
```

### 2. 逐步验证

```bash
# 每卸载一个包后都验证一次
rpm -qa | grep java
java -version
```

### 3. 完整清理

```bash
# 清理可能的残留文件
find / -name "*openjdk*" 2>/dev/null
find / -name "*java*" -path "*/bin/*" 2>/dev/null
```

## 注意事项

1. **权限要求**：需要root权限执行卸载操作
2. **依赖检查**：卸载前检查是否有其他应用依赖OpenJDK
3. **备份重要**：卸载前备份重要的配置文件
4. **测试验证**：卸载后充分测试Java应用的运行情况
5. **系统兼容**：不同Linux发行版可能需要使用不同的包管理工具

## 总结

通过以上步骤，可以成功卸载Linux系统自带的OpenJDK，确保Oracle JDK成为系统唯一的Java运行环境。关键在于：

1. **准确识别**需要卸载的OpenJDK包
2. **完整卸载**所有相关组件
3. **正确配置**环境变量
4. **充分验证**最终结果

完成这些操作后，系统将只保留Oracle JDK，避免多JDK共存导致的版本冲突问题。