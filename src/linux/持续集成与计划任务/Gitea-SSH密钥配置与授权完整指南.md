---
title:  Gitea-SSH密钥配置与授权完整指南
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
  - gitea
date: 2023-09-17
---

# Gitea-SSH密钥配置与授权完整指南

## 目录

[[toc]]

## 1. 生成SSH密钥对

### 1.1 生成新的SSH密钥

```bash
# 生成RSA密钥（推荐4096位）
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# 或者生成更安全的ED25519密钥
ssh-keygen -t ed25519 -C "your_email@example.com"
```

### 1.2 交互式配置

执行命令后会有以下提示：

```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/username/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
```

**建议配置：**

- 使用默认路径或指定有意义的文件名（如 `~/.ssh/id_rsa_gitea`）
- 设置一个强密码短语（可选但推荐）

### 1.3 验证密钥生成

```bash
# 查看生成的密钥文件
ls -la ~/.ssh/

# 应该看到以下文件：
# id_rsa (私钥)
# id_rsa.pub (公钥)
```

## 2. 配置SSH客户端

### 2.1 设置适当的文件权限

```bash
# 设置SSH目录权限 所有者可以读、写、执行（进入目录），群组/其他人无权限
chmod 700 ~/.ssh

# 设置私钥权限（重要！）所有者可以读、写，群组/其他人无权限
chmod 600 ~/.ssh/id_rsa

# 设置公钥权限 所有者可以读、写，群组/其他人可以读
chmod 644 ~/.ssh/id_rsa.pub
```

### 2.2 配置SSH客户端配置文件

创建或编辑 `~/.ssh/config` 文件：

```bash
# 编辑SSH配置文件
nano ~/.ssh/config
```

添加Gitea服务器配置：

```conf
Host gitea-server
    HostName your-gitea-server.com
    Port 22
    User git
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes
```

设置配置文件权限：

```bash
chmod 600 ~/.ssh/config
```

## 3. 服务器端配置（Gitea服务器）

### 3.1 确保SSH服务正常运行

```bash
# 检查SSH服务状态
sudo systemctl status ssh

# 如果未运行，启动SSH服务
sudo systemctl start ssh
sudo systemctl enable ssh
```

### 3.2 配置SSH服务（**默认不需要配置，除非是自定义配置ssh文件内容或者是自建服务器**）

编辑SSH服务配置：

```bash
sudo nano /etc/ssh/sshd_config
```

确保以下配置：

```
# 允许公钥认证
PubkeyAuthentication yes

# 指定授权密钥文件位置
AuthorizedKeysFile .ssh/authorized_keys

# 可选：禁用密码认证（提高安全性）
PasswordAuthentication no
```

重启SSH服务：

```bash
sudo systemctl restart ssh
```

## 4. 配置authorized_keys文件

### 4.1 在服务器上创建SSH目录

```bash
# 切换到git用户（Gitea的运行用户）
sudo su - git

# 创建.ssh目录
mkdir -p ~/.ssh

# 设置目录权限
chmod 700 ~/.ssh
```

### 4.2 添加公钥到authorized_keys

```bash
# 创建或编辑authorized_keys文件
nano ~/.ssh/authorized_keys

# 将客户端的公钥内容粘贴到文件中
# 公钥内容类似：ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... your_email@example.com
cat ~/.ssh/id_rsa.pub | tee -a ~/.ssh/authorized_keys
```

### 4.3 设置正确的文件权限

```bash
# 设置authorized_keys文件权限
chmod 600 ~/.ssh/authorized_keys

# 确保git用户拥有这些文件
chown -R git:git ~/.ssh
```

## 5. 获取并添加公钥

### 5.1 在客户端获取公钥内容

```bash
# 显示公钥内容
cat ~/.ssh/id_rsa.pub

# 或者复制到剪贴板（Linux）
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

# 或者复制到剪贴板（macOS）
cat ~/.ssh/id_rsa.pub | pbcopy
```

### 5.2 通过Gitea Web界面添加公钥

1. 登录Gitea Web界面
2. 进入用户设置 → SSH/GPG Keys
3. 点击"Add Key"
4. 粘贴公钥内容
5. 给密钥起一个有意义的名称
6. 保存

### 5.3 或者直接添加到服务器

```bash
# 在服务器上直接添加公钥
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... your_email@example.com" >> ~/.ssh/authorized_keys
```
### 5.4 通过Web UI 手动添加

<img src="/assets/images/QQ_1749912634002.png" style="width: auto;"></img>

## 6. 测试SSH连接

### 6.1 测试SSH连接

```bash
# 测试SSH连接
ssh -T git@your-gitea-server.com

# 或者使用配置的Host别名
ssh -T gitea-server
```

### 6.2 首次连接处理

首次连接时会提示：

```
The authenticity of host 'your-gitea-server.com' can't be established.
RSA key fingerprint is SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.
Are you sure you want to continue connecting (yes/no)?
```

输入 `yes` 确认。

### 6.3 成功连接的示例输出

```
Hi username! You've successfully authenticated, but Gitea does not provide shell access.
```

## 7. Git操作配置

### 7.1 配置Git使用SSH

```bash
# 克隆仓库使用SSH URL
git clone git@your-gitea-server.com:username/repository.git

# 或者更改现有仓库的远程URL
git remote set-url origin git@your-gitea-server.com:username/repository.git
```

### 7.2 验证Git配置

```bash
# 查看远程仓库配置
git remote -v

# 测试推送（需要有推送权限）
git push origin main
```

## 8. 故障排除

### 8.1 常见问题诊断

```bash
# 详细输出SSH连接过程
ssh -vvv git@your-gitea-server.com

# 检查SSH agent
ssh-add -l

# 添加私钥到SSH agent
ssh-add ~/.ssh/id_rsa
```

### 8.2 权限问题检查

```bash
# 检查客户端权限
ls -la ~/.ssh/

# 检查服务器端权限（在服务器上执行）
ls -la ~/.ssh/
```

### 8.3 常见错误解决

- **Permission denied (publickey)**: 检查公钥是否正确添加到authorized_keys
- **Host key verification failed**: 删除~/.ssh/known_hosts中的对应条目
- **Connection refused**: 检查SSH服务是否运行，端口是否正确

📋 检查清单

[ ] SSH 私钥格式是 OpenSSH 格式（-----BEGIN OPENSSH PRIVATE KEY-----）
[ ] 私钥内容完整（包括开始和结束行）
[ ] 换行符没有丢失（在 Gitea Secrets 中保留了所有换行）
[ ] 公钥已添加到远程服务器 ~/.ssh/authorized_keys
[ ] 公钥和私钥相匹配
[ ] SSH 用户名正确（daizhao）
[ ] SSH Host 正确（你的 IP 地址）
[ ] 远程服务器允许 SSH 连接（防火墙未阻止）

## 9. 安全最佳实践

### 9.1 密钥管理

- 定期轮换SSH密钥
- 为不同服务使用不同的密钥
- 使用强密码短语保护私钥
- 妥善备份私钥

### 9.2 服务器安全

- 禁用密码认证，仅使用密钥认证
- 更改默认SSH端口
- 配置防火墙规则
- 定期更新系统和SSH服务

### 9.3 监控和审计

```bash
# 查看SSH登录日志
sudo tail -f /var/log/auth.log

# 查看当前SSH连接
who
```

这个完整的流程涵盖了从密钥生成到实际使用的所有步骤，确保SSH密钥认证的安全性和可靠性。

参考文档：

https://docs.gitea.com/zh-cn/installation/install-with-docker#ssh-%E5%AE%B9%E5%99%A8%E7%9B%B4%E9%80%9A

https://qvctgytc9tu.feishu.cn/wiki/J41OwWiLxig03FkeTCycjszPnCh?fromScene=spaceOverview#share-Dh1xdYkAfoYHy7xw3SycB0KnnKd