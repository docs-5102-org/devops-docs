---
title: wget命令-网络上下载文件
category:
  - Linux命令
tag:
  - 网络工具
  - 文件下载
date: 2022-09-16

---

# wget命令-网络上下载文件

## 简介

`wget`是一个在Linux系统中用于从网络上下载文件的命令行工具。它支持HTTP、HTTPS和FTP协议，可以在非交互式环境下工作，这意味着它可以在用户退出系统后继续在后台运行下载任务。`wget`因其稳定性和强大的功能而广受欢迎，即使在网络不稳定的情况下也能可靠地完成下载任务。

## 基本语法

```bash
wget [选项] [URL]
```

## 主要特性

- 支持HTTP、HTTPS和FTP协议
- 支持HTTP代理
- 支持断点续传
- 支持后台下载
- 支持递归下载（可以下载整个网站）
- 支持转换链接为本地链接，便于离线浏览
- 在不稳定网络中具有良好的适应性
- 支持限速下载
- 完全免费且体积小巧

## 常用选项

### 基本选项

| 选项 | 描述 |
| --- | --- |
| -V, --version | 显示版本信息 |
| -h, --help | 显示帮助信息 |
| -b, --background | 下载后转入后台执行 |
| -e, --execute=COMMAND | 执行`.wgetrc`格式的命令 |

### 日志和输入文件选项

| 选项 | 描述 |
| --- | --- |
| -o, --output-file=FILE | 将日志写入指定文件 |
| -a, --append-output=FILE | 将日志追加到指定文件 |
| -d, --debug | 打印调试输出 |
| -q, --quiet | 安静模式（无输出） |
| -v, --verbose | 详细模式（默认） |
| -i, --input-file=FILE | 下载文件中列出的URL |

### 下载选项

| 选项 | 描述 |
| --- | --- |
| -O, --output-document=FILE | 将下载内容写入指定文件 |
| -c, --continue | 断点续传 |
| -N, --timestamping | 只下载比本地文件新的文件 |
| --limit-rate=RATE | 限制下载速度（如：200k） |
| -t, --tries=NUMBER | 设置重试次数（0表示无限） |
| -T, --timeout=SECONDS | 设置响应超时时间 |
| -w, --wait=SECONDS | 两次尝试之间等待的秒数 |
| -Q, --quota=NUMBER | 设置下载配额（如：5m表示5MB） |

### 目录选项

| 选项 | 描述 |
| --- | --- |
| -P, --directory-prefix=PREFIX | 保存文件到指定目录 |
| -nd, --no-directories | 不创建目录 |
| -x, --force-directories | 强制创建目录 |
| -nH, --no-host-directories | 不创建主机目录 |

### 递归下载选项

| 选项 | 描述 |
| --- | --- |
| -r, --recursive | 递归下载 |
| -l, --level=NUMBER | 最大递归深度（0表示无限） |
| -k, --convert-links | 转换链接为本地链接 |
| -p, --page-requisites | 下载显示页面所需的所有文件 |
| -m, --mirror | 镜像下载（等同于-r -N -l inf --no-remove-listing） |

### HTTP选项

| 选项 | 描述 |
| --- | --- |
| --http-user=USER | 设置HTTP用户名 |
| --http-password=PASS | 设置HTTP密码 |
| -U, --user-agent=AGENT | 设置用户代理字符串 |
| --referer=URL | 在HTTP请求中包含Referer头 |
| --save-cookies=FILE | 保存cookies到文件 |
| --load-cookies=FILE | 从文件加载cookies |

### FTP选项

| 选项 | 描述 |
| --- | --- |
| --ftp-user=USER | 设置FTP用户名 |
| --ftp-password=PASS | 设置FTP密码 |
| --passive-ftp | 使用被动传输模式（默认） |
| --active-ftp | 使用主动传输模式 |

## 常用实例

### 1. 下载单个文件

```bash
wget https://example.com/file.zip
```

这将下载指定URL的文件并保存到当前目录，文件名与URL中的文件名相同。

### 2. 指定保存文件名

```bash
wget -O custom_name.zip https://example.com/download?id=123
```

使用`-O`选项可以指定保存的文件名，这对于下载动态URL特别有用。

### 3. 断点续传

```bash
wget -c https://example.com/large_file.iso
```

使用`-c`选项可以继续下载之前中断的文件，而不必重新开始。

### 4. 限速下载

```bash
wget --limit-rate=200k https://example.com/large_file.iso
```

限制下载速度为200KB/s，避免占用全部带宽。

### 5. 后台下载

```bash
wget -b https://example.com/large_file.iso
```

将下载任务放到后台执行，输出会被重定向到`wget-log`文件。

### 6. 下载多个文件

```bash
wget -i download_list.txt
```

从`download_list.txt`文件中读取URL列表并下载，每行一个URL。

### 7. 镜像整个网站

```bash
wget -m -p -k -E https://example.com/
```

- `-m`：镜像下载
- `-p`：下载所有显示页面所需的文件（如图片）
- `-k`：转换链接为本地链接
- `-E`：将HTML文件保存为.html扩展名

### 8. 只下载特定类型的文件

```bash
wget -r -A "*.pdf" https://example.com/documents/
```

递归下载目录中所有PDF文件。

### 9. 排除特定类型的文件

```bash
wget -r -R "*.jpg,*.png,*.gif" https://example.com/
```

递归下载时排除图片文件。

### 10. 设置重试次数和等待时间

```bash
wget -t 5 -w 3 https://example.com/file.zip
```

设置最大重试次数为5次，每次重试间隔3秒。

### 11. 使用用户名和密码

```bash
# HTTP基本认证
wget --http-user=username --http-password=password https://example.com/private/

# FTP认证
wget --ftp-user=username --ftp-password=password ftp://example.com/file.zip
```

### 12. 使用代理服务器

```bash
wget -e use_proxy=yes -e http_proxy=http://proxy.example.com:8080 https://example.com/file.zip
```

### 13. 检查URL是否可访问（不下载）

```bash
wget --spider https://example.com/file.zip
```

只检查URL是否存在，不下载实际内容。

### 14. 保存到指定目录

```bash
wget -P /path/to/directory https://example.com/file.zip
```

将下载的文件保存到指定目录。

### 15. 设置超时时间

```bash
wget -T 30 https://example.com/file.zip
```

设置连接和读取超时时间为30秒。

## 高级用法

### 使用.wgetrc配置文件

可以在`/etc/wgetrc`（系统级）或`~/.wgetrc`（用户级）创建配置文件，设置默认选项：

```
# 示例配置
timeout = 60
tries = 3
retry_connrefused = on
limit_rate = 100k
```

### 下载并显示进度条

默认情况下，wget会显示进度条。如果你想要更详细的进度信息：

```bash
wget --progress=dot:mega https://example.com/large_file.iso
```

进度类型：
- `dot`：显示点状进度条
- `bar`：显示条形进度条
- `mega`：以MB为单位显示已传输的数据量

### 使用正则表达式下载文件

结合`-A`和`-R`选项可以使用模式匹配下载特定文件：

```bash
# 下载所有PDF和DOC文件
wget -r -A "*.pdf,*.doc" https://example.com/documents/
```

### 限制下载深度

```bash
wget -r -l 2 https://example.com/
```

递归下载，但最多只深入2层目录。

### 避免覆盖现有文件

```bash
wget -nc https://example.com/file.zip
```

如果文件已经存在，则不下载。

## 实用技巧

### 1. 创建站点备份脚本

```bash
#!/bin/bash
# 网站备份脚本
DATE=$(date +%Y%m%d)
wget -m -k -p -E -e robots=off \
     --restrict-file-names=windows \
     -P backup_$DATE \
     https://example.com/
```

### 2. 批量下载文件

```bash
#!/bin/bash
# 从文件读取URL并下载
while read url; do
  wget -c "$url"
done < urls.txt
```

### 3. 定时下载文件

结合`cron`定时任务使用wget：

```
# 每天凌晨3点下载文件
0 3 * * * wget -q -O /path/to/save/file.zip https://example.com/daily_update.zip
```

### 4. 下载并解压文件

```bash
wget -qO- https://example.com/archive.tar.gz | tar xz
```

直接下载并解压缩，无需保存中间文件。

## 常见问题及解决方案

### 1. 证书验证失败

问题：wget报告SSL证书验证失败。

解决方案：
```bash
# 不安全方式（不推荐用于敏感数据）
wget --no-check-certificate https://example.com/file.zip

# 安全方式（指定CA证书）
wget --ca-certificate=/path/to/ca-bundle.crt https://example.com/file.zip
```

### 2. 服务器拒绝访问

问题：服务器可能拒绝wget的默认用户代理。

解决方案：
```bash
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" https://example.com/file.zip
```

### 3. 下载速度过慢

问题：下载速度不理想。

解决方案：
```bash
# 尝试使用多个连接
wget -t 0 -c https://example.com/file.zip

# 如果服务器支持，可以使用aria2c代替wget获得更好的性能
# apt-get install aria2
# aria2c -x 16 https://example.com/file.zip
```

## 参考资料

- [GNU Wget 官方手册](https://www.gnu.org/software/wget/manual/wget.html)
- [Linux man pages: wget(1)](https://linux.die.net/man/1/wget) 
