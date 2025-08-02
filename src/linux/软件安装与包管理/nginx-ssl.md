---
title: nginx配置ssl证书
category:
  - Linux
  - 软件安装与包管理
tag:
  - nginx
  - ssl证书
  - 服务管理
date: 2022-09-25

---

# Nginx SSL证书配置指南（优化版）

## 目录

[[toc]]

## 一、Nginx配置文件示例

### 1. HTTP重定向到HTTPS配置
```nginx
server {
    listen 80;
    # 填写绑定证书的域名（注意：这里只需要域名，不需要http://前缀）
    server_name miliqkadmin.motopa.cn;
    
    # 将HTTP请求重定向到HTTPS，确保网站安全性
    return 301 https://$server_name$request_uri;
}
```

### 2. HTTPS服务器配置
```nginx
server {
    # 监听443端口并启用SSL
    listen 443 ssl http2;
    
    # 服务器域名（注意：这里只需要域名，不需要https://前缀）
    server_name miliqkadmin.motopa.cn;
    
    # ============== SSL证书配置开始 ==============
    # SSL证书文件路径（公钥证书）
    ssl_certificate /etc/nginx/ssl/fullchain.cer;
    # SSL私钥文件路径
    ssl_certificate_key /etc/nginx/ssl/miliqkadmin.motopa.cn.key;
    
    # SSL会话缓存配置
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # 支持的SSL/TLS协议版本（推荐只使用TLS 1.2和1.3）
    ssl_protocols TLSv1.2 TLSv1.3;
    
    # 加密套件配置（现代化、安全的配置）
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256;
    ssl_prefer_server_ciphers off;
    
    # 启用OCSP装订
    ssl_stapling on;
    ssl_stapling_verify on;
    
    # 安全头部配置
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    # ============== SSL证书配置结束 ==============
    
    # API代理配置
    location /api/ {
        proxy_pass http://127.0.0.1:9330/;
        
        # 代理头部设置
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # 客户端请求配置
        client_max_body_size 100m;
        client_body_buffer_size 128k;
        
        # 代理超时配置
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
        proxy_read_timeout 300;
        
        # 代理缓冲配置
        proxy_buffer_size 4k;
        proxy_buffers 4 32k;
        proxy_busy_buffers_size 64k;
        proxy_temp_file_write_size 64k;
    }
    
    # 静态文件配置
    location ^~ /fmsf {
        root /home/daizhao/static/miliqk;
        expires 30d;
        access_log off;
        
        # 静态文件缓存控制
        add_header Cache-Control "public, immutable";
    }
    
    # 前端应用配置
    location / {
        root /home/daizhao/web/miliqk-manage-web-dev;
        try_files $uri $uri/ /index.html;
        index index.html index.htm;
        
        # 设置前端文件缓存
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }
    
    # 错误页面配置
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }
}
```

## 二、配置说明与注意事项

### 1. 证书文件准备
- **证书文件**：`/etc/nginx/ssl/fullchain.cer`（包含完整证书链）
- **私钥文件**：`/etc/nginx/ssl/miliqkadmin.motopa.cn.key`
- **文件权限**：建议设置为600或644，确保nginx用户可读

### 2. 安全改进点
- **协议版本**：只使用TLS 1.2和1.3，移除了不安全的TLS 1.0和1.1
- **加密套件**：使用现代化的加密算法，提高安全性
- **HTTP/2支持**：启用HTTP/2协议，提升性能
- **安全头部**：添加HSTS、XSS保护等安全头部
- **OCSP装订**：启用OCSP装订，提高SSL握手性能

### 3. 性能优化
- **SSL会话缓存**：共享SSL会话缓存，减少握手次数
- **静态文件缓存**：为静态资源设置长期缓存
- **Gzip压缩**：建议在http块中启用gzip压缩

### 4. 端口开放
确保防火墙开放以下端口：
- **80端口**：HTTP流量（重定向用）
- **443端口**：HTTPS流量

### 5. 证书申请推荐
- **Let's Encrypt**：免费SSL证书，支持自动续期
- **acme.sh**：自动化证书管理工具
- **Certbot**：Let's Encrypt官方客户端

### 6. 证书格式说明
- **PEM格式**：最常用的证书格式，文本格式
- **CER格式**：二进制或Base64编码的证书
- **JKS格式**：Java密钥库格式
- **PKCS12格式**：包含私钥和证书的格式

## 三、测试与验证

### 1. 配置语法检查
```bash
nginx -t
```

### 2. SSL配置测试
使用在线工具测试SSL配置：
- SSL Labs：https://www.ssllabs.com/ssltest/
- MySSL：https://myssl.com/

### 3. 重新加载配置
```bash
nginx -s reload
```

## 四、常见问题排查

1. **证书路径错误**：检查证书文件路径和权限
2. **域名不匹配**：确保server_name与证书域名一致
3. **端口被占用**：检查80和443端口是否被其他程序使用
4. **防火墙阻拦**：确认防火墙规则允许443端口访问

---
*参考链接：*
- *SSL证书格式介绍：https://blog.freessl.cn/ssl-cert-format-introduce/*
- *ACME客户端快速入门：https://blog.freessl.cn/acme-quick-start/*