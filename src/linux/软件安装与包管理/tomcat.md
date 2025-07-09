---
title: tomcat性能优化
category:
  - Linux
  - 软件安装与包管理
tag:
  - tomcat
  - apr
  - 性能优化
date: 2022-10-01

---

# Apache Tomcat Native 安装配置指南

## 1. 概述

本指南介绍如何在Linux系统上安装和配置Apache Tomcat Native组件以提升Tomcat性能。

### 主要组件说明
- **APR (Apache Portable Runtime)**: Apache开发的高性能本地化组件，提供Socket、Thread、IO等底层操作系统级别的功能
- **Tomcat Native**: 允许Tomcat使用Apache APR包处理文件和网络IO操作，显著提升性能

## 2. 安装APR组件

### 2.1 安装APR核心库

```bash
# 下载APR源码包
wget http://archive.apache.org/dist/apr/apr-1.4.5.tar.gz

# 解压并编译安装
tar zxvf apr-1.4.5.tar.gz
cd apr-1.4.5
./configure --prefix=/usr/local/www/apr
make
make install
```

### 2.2 安装APR-iconv（字符编码转换库）

```bash
# 下载APR-iconv源码包
wget http://archive.apache.org/dist/apr/apr-iconv-1.2.1.tar.gz

# 解压并编译安装
tar -zxvf apr-iconv-1.2.1.tar.gz
cd apr-iconv-1.2.1
./configure --prefix=/usr/local/www/apr-iconv --with-apr=/usr/local/www/apr
make
make install
```

### 2.3 安装APR-util（APR工具库）

```bash
# 下载APR-util源码包
wget http://archive.apache.org/dist/apr/apr-util-1.3.10.tar.gz

# 解压并编译安装
tar zxvf apr-util-1.3.10.tar.gz
cd apr-util-1.3.10
./configure --prefix=/usr/local/www/apr-util \
    --with-apr=/usr/local/www/apr \
    --with-apr-iconv=/usr/local/www/apr-iconv/bin/apriconv
make
make install
```

## 3. 安装JDK和Tomcat

### 3.1 安装JDK

```bash
# 下载JDK 1.8（推荐使用Oracle官网或OpenJDK）
# 方法1：使用yum安装OpenJDK（推荐）
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

# 方法2：手动下载Oracle JDK（需要Oracle账户）
# wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" \
# "http://download.oracle.com/otn-pub/java/jdk/8u281-b09/89d678681d05c85204d708c1f5e9d533/jdk-8u281-linux-x64.tar.gz"

# 如果使用yum安装，Java通常安装在以下位置
# CentOS/RHEL: /usr/lib/jvm/java-1.8.0-openjdk
# Ubuntu/Debian: /usr/lib/jvm/java-8-openjdk-amd64

# 创建软链接便于管理（根据实际安装路径调整）
ln -s /usr/lib/jvm/java-1.8.0-openjdk /usr/local/java
```

### 3.2 配置Java环境变量

编辑系统环境变量文件：

```bash
vi /etc/profile
```

在文件末尾添加以下内容：

```bash
# Java环境变量配置
export JAVA_HOME=/usr/local/java
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

验证安装：

```bash
# 重新加载环境变量
source /etc/profile

# 检查Java版本（应该显示1.8.x）
java -version
```

### 3.3 安装Tomcat

```bash
# 下载Tomcat 7（请使用最新稳定版本）
wget http://mirror.bjtu.edu.cn/apache/tomcat/tomcat-7/v7.0.16/bin/apache-tomcat-7.0.16.tar.gz

# 解压并移动到目标目录
tar -zxvf apache-tomcat-7.0.16.tar.gz
mv apache-tomcat-7.0.16 /usr/local/www/tomcat
```

配置Tomcat环境变量：

```bash
# 编辑Tomcat启动脚本
vi /usr/local/www/tomcat/bin/catalina.sh

# 在文件开头添加Java路径
JAVA_HOME=/usr/local/java
```

## 4. 安装配置Tomcat Native

### 4.1 编译安装Tomcat Native

Tomcat 7已经包含了tomcat-native源码包，直接使用即可：

```bash
# 进入Tomcat bin目录
cd /usr/local/www/tomcat/bin

# 解压tomcat-native源码
tar zxvf tomcat-native.tar.gz
cd tomcat-native-1.1.20-src/jni/native

# 配置编译参数
./configure --with-apr=/usr/local/www/apr --with-java-home=/usr/local/java

# 编译并安装
make
make install
```

### 4.2 配置APR库路径

```bash
# 编辑系统环境变量
vi /etc/profile

# 添加APR库路径
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/apr/lib

# 使配置生效
source /etc/profile
```

## 5. 启动和验证

### 5.1 启动Tomcat

```bash
# 启动Tomcat服务
/usr/local/www/tomcat/bin/startup.sh
```

### 5.2 查看日志

```bash
# 查看启动日志
more /usr/local/www/tomcat/logs/catalina.out

# 实时监控日志（按Ctrl+C退出）
tail -f /usr/local/www/tomcat/logs/catalina.out
```

### 5.3 验证APR是否生效

在日志中查找类似以下信息，表示APR已成功启用：

```
INFO: Loaded APR based Apache Tomcat Native library
```

## 6. 注意事项

1. **版本兼容性**: 确保APR、Tomcat Native和Tomcat版本之间的兼容性
2. **权限问题**: 确保安装目录有适当的读写权限
3. **防火墙设置**: 如需外部访问，请开放Tomcat端口（默认8080）
4. **系统依赖**: 某些系统可能需要安装gcc、make等编译工具

## 7. 常见问题排查

- **编译错误**: 检查是否安装了必要的开发工具和库文件
- **库文件找不到**: 确认LD_LIBRARY_PATH环境变量设置正确
- **权限拒绝**: 使用root用户或sudo权限进行安装

---

通过以上步骤，您应该能够成功安装并配置Apache Tomcat Native，从而显著提升Tomcat的性能表现。
