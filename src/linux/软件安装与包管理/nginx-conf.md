---
title: nginx配置-服务器详细配置指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - nginx
  - 配置文件
  - web服务器
date: 2022-09-24

---

# Nginx配置文件详解 (nginx.conf)

## 官方文档链接

- **Nginx官方文档**: <https://nginx.org/en/docs/>
- **配置文件管理**: <https://docs.nginx.com/nginx/admin-guide/basic-functionality/managing-configuration-files/>
- **初学者指南**: <http://nginx.org/en/docs/beginners_guide.html>
- **完整配置示例**: <https://www.nginx.com/resources/wiki/start/topics/examples/full/>

## 配置文件结构

Nginx配置文件采用层次化结构，主要包含以下几个重要部分：

### 1. 全局配置块 (Main Context)

```nginx
# 定义Nginx运行的用户和用户组
user www-data;

# Nginx进程数，建议设置为等于CPU总核心数
worker_processes auto;  # 或者设置为具体数字，如 4

# 全局错误日志定义类型
# 级别：debug | info | notice | warn | error | crit
error_log /var/log/nginx/error.log warn;

# 进程PID文件
pid /var/run/nginx.pid;

# 一个Nginx进程打开的最多文件描述符数目
# 建议与系统的ulimit -n值保持一致
worker_rlimit_nofile 65535;
```

### 2. 事件配置块 (Events Context)

```nginx
events {
    # 参考事件模型
    # Linux 2.6+推荐使用epoll，FreeBSD推荐使用kqueue
    use epoll;
    
    # 单个进程最大连接数
    # 最大连接数 = 连接数 × 进程数
    worker_connections 1024;
    
    # 设置一个进程是否同时接受多个网络连接
    multi_accept on;
    
    # 开启高效传输模式
    accept_mutex on;
}
```

### 3. HTTP配置块 (HTTP Context)

#### 基础配置

```nginx
http {
    # 文件扩展名与文件类型映射表
    include /etc/nginx/mime.types;
    
    # 默认文件类型
    default_type application/octet-stream;
    
    # 字符集
    charset utf-8;
    
    # 服务器名字的hash表大小
    server_names_hash_bucket_size 128;
    
    # 客户端请求头部的缓冲区大小
    client_header_buffer_size 32k;
    large_client_header_buffers 4 64k;
    
    # 设置请求体的最大允许大小
    client_max_body_size 50m;
    
    # 请求体的缓冲区大小
    client_body_buffer_size 128k;
```

#### 性能优化配置

```nginx
    # 开启高效文件传输模式
    sendfile on;
    
    # 开启目录列表访问（适合下载服务器）
    autoindex off;  # 生产环境建议关闭
    
    # 防止网络阻塞
    tcp_nopush on;
    tcp_nodelay on;
    
    # 长连接超时时间（秒）
    keepalive_timeout 65;
    keepalive_requests 100;
```

#### 日志配置

```nginx
    # 日志格式定义
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
    
    # 访问日志
    access_log /var/log/nginx/access.log main;
    
    # 错误日志
    error_log /var/log/nginx/error.log warn;
```

#### Gzip压缩配置

```nginx
    # 开启Gzip压缩
    gzip on;
    
    # 启用压缩的最小文件大小
    gzip_min_length 1k;
    
    # 压缩缓冲区
    gzip_buffers 4 16k;
    
    # 压缩版本
    gzip_http_version 1.1;
    
    # 压缩级别 1-9，级别越高压缩率越大，但CPU消耗也越大
    gzip_comp_level 6;
    
    # 压缩的文件类型
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json
        image/svg+xml;
    
    # 在响应头添加Vary: Accept-Encoding
    gzip_vary on;
    
    # 禁用IE6的gzip压缩
    gzip_disable "msie6";
```

#### FastCGI配置（适用于PHP）

```nginx
    # FastCGI相关参数优化
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    
    # FastCGI缓存配置
    fastcgi_cache_path /var/cache/nginx/fastcgi_cache 
                       levels=1:2 keys_zone=FASTCGI:100m 
                       inactive=60m max_size=1g;
```

### 4. 负载均衡配置 (Upstream)

```nginx
    # 定义后端服务器组
    upstream backend {
        # 权重分配，权重越高被分配到的几率越大
        server 192.168.1.10:8080 weight=3;
        server 192.168.1.11:8080 weight=2;
        server 192.168.1.12:8080 weight=1;
        
        # 备用服务器
        server 192.168.1.13:8080 backup;
        
        # 负载均衡方法
        # ip_hash;          # 基于IP的会话保持
        # least_conn;       # 最少连接数
        # hash $request_uri; # 基于URI的哈希
        
        # 健康检查
        server 192.168.1.10:8080 max_fails=3 fail_timeout=30s;
    }
```

### 5. 虚拟主机配置 (Server Context)

```nginx
    server {
        # 监听端口
        listen 80;
        listen [::]:80;  # IPv6
        
        # 服务器名称
        server_name example.com www.example.com;
        
        # 网站根目录
        root /var/www/html;
        
        # 默认首页
        index index.html index.htm index.php;
        
        # 访问日志
        access_log /var/log/nginx/example.com.access.log main;
        
        # 错误日志
        error_log /var/log/nginx/example.com.error.log warn;
        
        # 根路径处理
        location / {
            try_files $uri $uri/ =404;
        }
        
        # PHP文件处理
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
        
        # 静态文件缓存
        location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
        
        # 反向代理配置
        location /api/ {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            # 代理超时设置
            proxy_connect_timeout 30s;
            proxy_send_timeout 30s;
            proxy_read_timeout 30s;
            
            # 代理缓冲区设置
            proxy_buffer_size 4k;
            proxy_buffers 4 32k;
            proxy_busy_buffers_size 64k;
        }
        
        # 状态监控页面
        location /nginx_status {
            stub_status on;
            access_log off;
            allow 127.0.0.1;
            deny all;
        }
        
        # 禁止访问隐藏文件
        location ~ /\. {
            deny all;
        }
    }
```

### 6. HTTPS配置示例

```nginx
    server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        
        server_name example.com www.example.com;
        
        # SSL证书配置
        ssl_certificate /etc/nginx/ssl/example.com.crt;
        ssl_certificate_key /etc/nginx/ssl/example.com.key;
        
        # SSL配置
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384;
        ssl_prefer_server_ciphers off;
        
        # SSL会话缓存
        ssl_session_cache shared:SSL:10m;
        ssl_session_timeout 10m;
        
        # HSTS
        add_header Strict-Transport-Security "max-age=31536000" always;
        
        # 其他配置...
    }
    
    # HTTP到HTTPS重定向
    server {
        listen 80;
        server_name example.com www.example.com;
        return 301 https://$server_name$request_uri;
    }
```

## 配置文件包含和模块化

```nginx
http {
    # 包含其他配置文件
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    
    # 包含MIME类型定义
    include /etc/nginx/mime.types;
    
    # 包含FastCGI参数
    include /etc/nginx/fastcgi_params;
}
```

## 常用配置技巧

### 1. 限制请求频率

```nginx
http {
    # 定义限制规则
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    
    server {
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            # 其他配置...
        }
    }
}
```

### 2. 限制连接数

```nginx
http {
    limit_conn_zone $binary_remote_addr zone=addr:10m;
    
    server {
        limit_conn addr 10;
        # 其他配置...
    }
}
```

### 3. 防盗链配置

```nginx
location ~* \.(jpg|jpeg|png|gif)$ {
    valid_referers none blocked server_names *.example.com;
    if ($invalid_referer) {
        return 403;
    }
}
```

## 配置文件


### 默认配置文件

[](https://github.com/nginx/nginx/blob/master/conf/nginx.conf)

### 多实例例配置文件

[](../_resources/vhost.resources/nginx.conf)

## 性能优化建议

1. **合理设置worker_processes**：通常设置为CPU核心数
2. **优化worker_connections**：根据服务器性能调整
3. **启用gzip压缩**：减少传输数据量
4. **设置合适的缓存策略**：提高静态资源访问速度
5. **使用HTTP/2**：提高网页加载速度
6. **配置SSL会话缓存**：减少SSL握手开销

## 安全配置建议

1. **隐藏Nginx版本信息**：`server_tokens off;`
2. **限制请求方法**：只允许必要的HTTP方法
3. **配置安全头**：如HSTS、CSP等
4. **禁用不必要的模块**：减少攻击面
5. **定期更新Nginx版本**：及时修复安全漏洞

## 测试和重载配置

```bash
# 测试配置文件语法
nginx -t

# 重载配置文件
nginx -s reload

# 查看配置文件位置
nginx -V 2>&1 | grep -o '\-\-conf-path=\S*'
```

## 常见问题排查

1. **检查错误日志**：`/var/log/nginx/error.log`
2. **验证配置语法**：`nginx -t`
3. **检查端口占用**：`netstat -tlnp | grep :80`
4. **查看进程状态**：`ps aux | grep nginx`
5. **检查防火墙规则**：`ufw status` 或 `iptables -L`

---

*注意：以上配置示例仅供参考，实际部署时请根据具体需求和环境进行调整。*
