---
title: 服务器常用一键脚本集合
category:
  - Linux
  - Shell编程
tag:
  - 一键脚本
  - 服务器优化
  - 系统工具
  - 自动化
source: https://www.lutofan.com/2817.html
date: 2022-07-20

---

# 服务器常用一键脚本集合

## Linux网络优化加速一键脚本

```bash
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh"
chmod +x tcp.sh
./tcp.sh
```

## BBR一键安装

```bash
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
chmod +x bbr.sh
./bbr.sh
```

## 服务器时间同步中国时间

```bash
timedatectl set-timezone Asia/Shanghai
yum install ntpdate
ntpdate ntp1.aliyun.com
timedatectl set-ntp yes
```

## 一键安装pip

```bash
curl -O https://bootstrap.pypa.io/get-pip.py
python get-pip.py
```

## 安装Youtube-dl

```bash
# 安装
yum install youtube-dl

# 升级
sudo pip install --upgrade youtube-dl
```

## qBittorrent for CentOS7一键安装脚本

```bash
wget https://blog.lutofan.com/script/qBittorrentCentOS7install.sh && chmod +x qBittorrentCentOS7install.sh
./qBittorrentCentOS7install.sh
```

## 一键安装CCAA（Aria2 + AriaNg + Filebrowser）

```bash
bash <(curl -Lsk https://raw.githubusercontent.com/helloxz/ccaa/master/ccaa.sh)
```

如果出现 `-bash: curl: command not found` 错误，需要先安装curl：

```bash
# CentOS
yum -y install curl
```

## 一键安装宝塔面板脚本

```bash
yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
```

## 宝塔面板Linux数据盘一键挂载

### CentOS

```bash
yum install wget -y && wget -O disk.sh http://download.bt.cn/tools/disk.sh && bash disk.sh
```

### Ubuntu

```bash
wget -O disk.sh http://download.bt.cn/tools/disk.sh && sudo bash disk.sh
```

### Debian

```bash
wget -O disk.sh http://download.bt.cn/tools/disk.sh && bash disk.sh
```

### 自定义挂载目录

默认挂载到 `/www` 目录，如需挂载到其他目录，可在挂载命令后加上挂载目录（务必以 `/` 为开头）。

以下示例挂载到 `/website` 目录：

```bash
wget -O disk.sh http://download.bt.cn/tools/disk.sh && bash disk.sh /website
```

---

**注意事项：**
- 执行脚本前请确保服务器网络连接正常
- 建议在测试环境中先行验证脚本功能
- 部分脚本可能需要root权限执行
- 脚本来源请确保可信，避免安全风险

**参考链接：**
- [原文地址](https://www.lutofan.com/2817.html)
