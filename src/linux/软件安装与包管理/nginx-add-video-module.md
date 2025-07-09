---
title: nginx视频模块-流媒体服务配置
category:
  - Linux
  - 软件安装与包管理
tag:
  - nginx
  - 视频模块
  - 流媒体
date: 2022-09-23

---

# Nginx添加MP4、FLV模块教程

## 概述
本教程介绍如何在已安装的Nginx服务器中添加MP4和FLV流媒体模块，以支持视频文件的HTTP流式传输。

## 前提条件
- 已安装的Nginx服务器
- 具有root权限
- 保留原始Nginx安装目录和源码

## 步骤详解

### 1. 查看当前Nginx编译参数
首先查看当前Nginx的编译配置，以确保新编译时保持原有功能：

```bash
nginx -V
```

示例输出：
```
configure arguments: --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module
```

### 2. 进入Nginx源码目录
进入之前安装Nginx时使用的源码目录。例如使用lnmp1.0脚本安装的情况：

```bash
cd /root/lnmp1.0-full/nginx-1.4.3
```

> **注意**：请根据您的实际安装路径和版本号调整目录名称。

### 3. 备份当前Nginx可执行文件
在重新编译前，备份当前的Nginx可执行文件：

```bash
mv /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx.old
```

### 4. 重新配置编译参数
使用原有配置参数，并添加MP4和FLV模块：

```bash
./configure --user=www --group=www --prefix=/usr/local/nginx \
  --with-http_stub_status_module \
  --with-http_ssl_module \
  --with-http_gzip_static_module \
  --with-http_mp4_module \
  --with-http_flv_module
```

### 5. 验证配置结果
配置完成后，检查输出信息确认无错误。正常情况下应显示：

```
Configuration summary
+ using system PCRE library
+ using system OpenSSL library
+ md5: using OpenSSL library
+ sha1: using OpenSSL library
+ using system zlib library

nginx path prefix: "/usr/local/nginx"
nginx binary file: "/usr/local/nginx/sbin/nginx"
nginx configuration prefix: "/usr/local/nginx/conf"
nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
nginx pid file: "/usr/local/nginx/logs/nginx.pid"
nginx error log file: "/usr/local/nginx/logs/error.log"
nginx http access log file: "/usr/local/nginx/logs/access.log"
nginx http client request body temporary files: "client_body_temp"
nginx http proxy temporary files: "proxy_temp"
nginx http fastcgi temporary files: "fastcgi_temp"
nginx http uwsgi temporary files: "uwsgi_temp"
nginx http scgi temporary files: "scgi_temp"
```

### 6. 编译Nginx
执行编译命令：

```bash
make
```

> **重要提醒**：只执行`make`命令，不要执行`make install`，以避免覆盖配置文件。

### 7. 测试配置文件
在安装新版本前，测试配置文件语法：

```bash
nginx -t
```

正常情况下应显示：
```
nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
```

### 8. 安装新版本
如果测试通过，执行安装：

```bash
make install
```

### 9. 验证安装结果
检查新版本是否正确安装：

```bash
nginx -V
```

应该显示包含新模块的配置信息：
```
nginx version: nginx/1.4.3
built by gcc 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC)
TLS SNI support enabled
configure arguments: --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-http_mp4_module --with-http_flv_module
```

## 模块功能说明

### HTTP MP4模块
- **功能**：为MP4文件提供HTTP流式传输支持
- **特点**：支持视频拖拽、快进快退等功能
- **使用场景**：在线视频播放、点播服务

### HTTP FLV模块  
- **功能**：为FLV文件提供HTTP流式传输支持
- **特点**：支持Flash视频的流式播放
- **使用场景**：Flash视频播放、直播回放

## 注意事项

1. **备份重要性**：重新编译前务必备份原有可执行文件
2. **模块兼容性**：所使用的模块都是Nginx官方支持的内置模块
3. **配置保持**：新编译时保持原有的所有配置参数
4. **测试验证**：安装前先测试配置文件语法正确性
5. **版本一致性**：确保使用相同版本的源码进行重新编译

## 故障排除

### 如果编译失败
1. 检查系统依赖包是否完整
2. 确认源码目录和版本正确
3. 查看编译错误日志定位问题

### 如果配置测试失败
1. 检查配置文件语法
2. 确认路径和权限设置正确
3. 对比备份的配置文件

### 回滚方案
如果出现问题，可以快速回滚：
```bash
mv /usr/local/nginx/sbin/nginx.old /usr/local/nginx/sbin/nginx
```

## 总结

通过以上步骤，您已成功为Nginx添加了MP4和FLV流媒体模块。这两个模块将为您的Web服务器提供强大的视频流式传输能力，支持现代Web应用的多媒体需求。
