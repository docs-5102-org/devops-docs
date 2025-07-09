---
title: tomcat多实例-服务器配置指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - tomcat
  - 多实例
  - 服务配置
date: 2022-09-30

---

# Linux环境下部署多个Tomcat实例的完整指南

## 背景需求
为了实现门户网站和WebService的独立运行，避免相互影响（如其中一个服务瘫痪不会影响另一个），需要在Linux系统上部署两个独立的Tomcat实例。

## 问题分析
初始部署时遇到第二个Tomcat无法启动的问题，通过排查发现：
- 表面原因：端口冲突
- 根本原因：需要修改多个端口配置，不仅仅是HTTP端口

## 解决方案

### 方案一：环境变量配置法（推荐用于安装版Tomcat）

#### 1. 修改系统环境变量
编辑 `/etc/profile` 文件，添加以下配置：

```bash
# Java环境变量
JAVA_HOME=/usr/java/jdk
CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib:$JAVA_HOME/bin
export JAVA_HOME CLASSPATH

# 第一个Tomcat环境变量
CATALINA_BASE=/usr/local/tomcat
CATALINA_HOME=/usr/local/tomcat
TOMCAT_HOME=/usr/local/tomcat
export CATALINA_BASE CATALINA_HOME TOMCAT_HOME

# 第二个Tomcat环境变量
CATALINA_2_BASE=/usr/local/tomcat2/apache-tomcat-5.5.17
CATALINA_2_HOME=/usr/local/tomcat2/apache-tomcat-5.5.17
TOMCAT_2_HOME=/usr/local/tomcat2/apache-tomcat-5.5.17
export CATALINA_2_BASE CATALINA_2_HOME TOMCAT_2_HOME
```

使配置生效：
```bash
source /etc/profile
```

#### 2. 修改第二个Tomcat的启动脚本
编辑第二个Tomcat的 `bin/startup.sh` 和 `bin/shutdown.sh` 文件，在文件开头添加：

```bash
export JAVA_HOME=/usr/jdk
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=$JAVA_HOME/lib
export CATALINA_HOME=$CATALINA_2_HOME
export CATALINA_BASE=$CATALINA_2_BASE
```

### 方案二：端口配置法（推荐用于免安装版Tomcat）

#### 修改第二个Tomcat的端口配置
编辑第二个Tomcat的 `conf/server.xml` 文件，修改以下三个关键端口：

```xml
<!-- 1. 修改服务器关闭端口 -->
<Server port="9005" shutdown="SHUTDOWN">
<!-- 原端口：8005 → 新端口：9005 -->

<!-- 2. 修改HTTP连接端口 -->
<Connector port="9080" maxHttpHeaderSize="8192"
           maxThreads="150" minSpareThreads="25" maxSpareThreads="75"
           enableLookups="false" redirectPort="8443" acceptCount="100"
           connectionTimeout="20000" disableUploadTimeout="true" />
<!-- 原端口：8080 → 新端口：9080 -->

<!-- 3. 修改AJP连接端口 -->
<Connector port="9009"
           enableLookups="false" redirectPort="8443" protocol="AJP/1.3" />
<!-- 原端口：8009 → 新端口：9009 -->
```

## 端口说明

| 端口类型 | 第一个Tomcat | 第二个Tomcat | 用途说明 |
|----------|-------------|-------------|----------|
| Server Port | 8005 | 9005 | 服务器关闭监听端口 |
| HTTP Port | 8080 | 9080 | HTTP请求处理端口 |
| AJP Port | 8009 | 9009 | Apache集成端口 |

## 验证部署

### 1. 检查端口占用
```bash
# 检查端口是否被占用
netstat -nap | grep 8080
netstat -nap | grep 9080
```

### 2. 启动服务
```bash
# 启动第一个Tomcat
/usr/local/tomcat/bin/startup.sh

# 启动第二个Tomcat
/usr/local/tomcat2/apache-tomcat-5.5.17/bin/startup.sh
```

### 3. 验证访问
- 第一个Tomcat：http://服务器IP:8080
- 第二个Tomcat：http://服务器IP:9080

## 注意事项

1. **免安装版Tomcat**：通常只需要修改端口配置即可，无需修改环境变量
2. **安装版Tomcat**：建议同时配置环境变量和端口设置
3. **防火墙设置**：确保新端口在防火墙中已开放
4. **日志监控**：启动后检查各自的日志文件确认启动状态

## 故障排除

如果第二个Tomcat仍无法启动：
1. 检查所有三个端口是否都已修改
2. 确认端口未被其他进程占用
3. 检查Tomcat日志文件中的错误信息
4. 验证Java环境变量配置是否正确

通过以上配置，即可实现两个Tomcat实例的独立运行，确保门户网站和WebService服务的高可用性。
