---
title:  Github Actions 教程
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
  - Github Actions
date: 2023-09-17
---

# GitHub Actions 教程

## 目录

[[toc]]

## 介绍

GitHub Actions 是一种持续集成和持续交付 (CI/CD) 平台，可用于自动执行生成、测试和部署管道。你可以创建工作流，以便在推送更改到存储库时运行测试，或将合并的拉取请求部署到生产环境。

本快速入门指南将介绍如何使用 GitHub 的用户界面添加工作流，以便演示 GitHub Actions 的某些基本功能，抽离了官网教程的部分链接作为快速搜索点以及一些场景的使用经验。

## 官方资源

- [GitHub Actions 文档 - GitHub 文档](https://docs.github.com/zh/actions)
- [微软 Github Actions 教程文档](https://learn.microsoft.com/zh-cn/training/paths/github-actions/)
- [Github Actions 官方示例模版](https://github.com/actions/starter-workflows)
- [Github Actions 官方市场模版](https://github.com/marketplace?type=actions)
- [GitHub Actions 官方 actions/xxx 仓库](https://github.com/actions)

## 核心概念

### 工作流语法

官网：[GitHub Actions 的工作流语法 - GitHub 文档](https://docs.github.com/zh/actions/writing-workflows/workflow-syntax-for-github-actions)

```yaml
name: Workflow名称
on: [push]  # 触发事件
env:  # 全局环境变量
  VAR_NAME: value
jobs:
  job_id:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo ${{ env.VAR_NAME }}
```

### 表达式语法

官网：[GitHub Actions 的表达式语法 - GitHub 文档](https://docs.github.com/zh/actions/writing-workflows/choosing-what-your-workflow-does/evaluate-expressions-in-workflows-and-actions)

常用表达式：

- `${{ github.ref }}` - 当前分支/标签引用
- `${{ contains(github.event.issue.labels.*.name, 'bug') }}` - 检查标签
- `${{ fromJSON(needs.job1.outputs.matrix) }}` - JSON转换

### 元数据语法

官网：[GitHub Actions 的元数据语法 - GitHub 文档](https://docs.github.com/zh/actions/sharing-automations/creating-actions/metadata-syntax-for-github-actions)

```yaml
name: 'Action名称'
description: '描述'
inputs:
  input1:
    description: '输入描述'
    required: true
    default: '默认值'
runs:
  using: 'node20'
  main: 'index.js'
```

### 工作流触发事件

官网：

- [触发工作流程 - GitHub 文档](https://docs.github.com/zh/actions/writing-workflows/choosing-when-your-workflow-runs/triggering-a-workflow#using-filters)
- [触发工作流的事件 - GitHub 文档](https://docs.github.com/zh/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows)

### 构建与测试

官网：

- [创建示例工作流 - GitHub 文档](https://docs.github.com/zh/actions/use-cases-and-examples/creating-an-example-workflow)
- [构建和测试 - GitHub 文档](https://docs.github.com/zh/actions/use-cases-and-examples/building-and-testing)

支持的语言/框架：

- Java (Maven/Gradle)
- .NET
- Node.js
- Python
- Go
- Ruby
- Swift等

### 工作流的使用限制和计费管理

官网：[使用限制、计费和管理 - GitHub 文档](https://docs.github.com/zh/actions/administering-github-actions/usage-limits-billing-and-administration)

- 作业执行时间：最长6小时
- 工作流运行时间：最长35天
- API请求：每小时最多1000次
- 并发作业数：根据账户类型不同(免费账户20个)

## 工作流场景

### env环境变量生效的范围

#### env（普通环境变量）

```yaml
env:
  MY_ENV: "123"
```

是**直接在 Workflow、Job 或 Step** 里定义的环境变量。

作用范围是：定义的位置以下（可以在整个工作流、某个 Job、或者某个 Step 里单独定义）。

值是固定的（静态写死的），或者可以动态引用其他上下文，比如 `${{ github.actor }}`。

#### vars（配置变量）

```yaml
env:
  env_var: ${{ vars.ENV_CONTEXT_VAR }}
```

vars 是 GitHub **仓库级别** 或 **组织级别** 定义的**配置变量**。

你可以在 GitHub 仓库的 **Settings → Variables → Repository Variables** 页面定义它们。

**特点**：

- **集中管理**，不像 env 那样每次写死在 yml 文件里。
- **更安全**（尤其适合需要频繁变化但又不想频繁提交代码的变量）。
- 在工作流中可以通过 `${{ vars.VARIABLE_NAME }}` 引用。

### Matrix 无法使用env定义的变量

参考：https://github.com/orgs/community/discussions/26388

### 手动触发的工作流，不显示的问题

✅ 造成这种情况最常见的原因有：

#### 1. 分支问题

GitHub 只会在默认分支（如 `main`）或者是你当前选中的分支上，显示支持 `workflow_dispatch` 的工作流。

如果你提交到了别的分支（比如 `dev`、`feature/test`），**是不会在 Actions 里面显示的**。

#### 2. 位置问题

GitHub 要求工作流文件必须放在：`.github/workflows/` 目录下。

如果你放错了，比如 `.github/action/`、`.github/` 根目录，**也是不会生效的**。

#### 3. 文件名是否正确且是 YAML 格式

必须是 `.yml` 或 `.yaml` 后缀，比如 `my-workflow.yml`。

（如果不是 `.yml` 后缀，比如 `.txt`，GitHub识别不了）

#### 4. 工作流文件有没有被成功提交并合并到远端

只有**push到 GitHub 仓库**（而不是你本地）后，GitHub 才能看到并加载新的工作流。

## 工作流的实战

以下是使用 GitHub Actions 自动打包并发布到自有 Web 服务器的完整方案，分为基础版和进阶版两种实现方式：

### 方案一：基础版（SSH + rsync）

#### 准备工作

在服务器生成 SSH 密钥对：

```bash
ssh-keygen -t ed25519 -C "github-actions"  # 不要设置密码
```

将公钥 (id_ed25519.pub) 添加到服务器的 `~/.ssh/authorized_keys`

在 GitHub 仓库的 Settings > Secrets 中添加：

- `SERVER_IP` - 服务器 IP
- `SERVER_USER` - SSH 用户名
- `SSH_PRIVATE_KEY` - 私钥内容 (id_ed25519)

#### 工作流文件 (.github/workflows/deploy.yml)

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Build project
        run: npm run build

      - name: Install SSH key
        uses: webfactory/ssh-agent@v0.8.0
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Deploy via rsync
        run: |
          rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no" \
            ./dist/ ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }}:/var/www/html/
```

### 方案二：进阶版（Docker + SSH）

#### 服务器准备

安装 Docker 并创建专用用户：

```bash
sudo usermod -aG docker deploy-user
```

#### 工作流文件

```yaml
name: Docker Build and Deploy

env:
  DOCKER_IMAGE: my-web-app
  SERVER_PORT: 22
  DEPLOY_PATH: /var/www/html

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker image
        run: |
          docker build -t $DOCKER_IMAGE .
          docker save $DOCKER_IMAGE > image.tar

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: docker-image
          path: image.tar

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v4
        with:
          name: docker-image

      - name: Install SSH key
        uses: webfactory/ssh-agent@v0.8.0
        with:
          ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

      - name: Deploy to server
        run: |
          scp -P $SERVER_PORT -o StrictHostKeyChecking=no image.tar \
            ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }}:/tmp/
          ssh -p $SERVER_PORT ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }} \
            "docker load -i /tmp/image.tar && \
             docker stop web || true && \
             docker rm web || true && \
             docker run -d --name web -p 80:80 $DOCKER_IMAGE"
```

## 关键安全实践

### 最小权限原则

服务器创建专用用户 `deploy-user`，仅授予必要权限：

```bash
sudo adduser deploy-user
sudo setfacl -R -m u:deploy-user:rwx /var/www/html
```

### 敏感信息保护

所有凭证（SSH key、Docker Hub 密码等）必须存储在 GitHub Secrets

在工作流中屏蔽敏感输出：

```yaml
- name: Hide sensitive info
  run: echo "::add-mask::${{ secrets.SSH_PRIVATE_KEY }}"
```

### 验证部署

```yaml
- name: Verify deployment
  run: |
    curl -sSf http://${{ secrets.SERVER_IP }} > /dev/null || exit 1
```

## 备选方案对比

| 方案 | 适用场景 | 优点 | 缺点 |
|------|----------|------|------|
| rsync | 静态网站（HTML/CSS/JS） | 部署速度快，配置简单 | 需要开放 SSH 端口 |
| Docker | 动态应用（Node.js/Python等） | 环境一致性高，易回滚 | 服务器需安装 Docker |
| Webhook | 已有部署脚本 | 无需暴露服务器端口 | 需自行实现接收端逻辑 |
| S3/FTP | 托管静态资源 | 无需管理服务器 | 产生云服务费用 |

## Webhook 方案示例（无需 SSH）

### 在服务器创建接收脚本 /deploy/hook.sh

```bash
#!/bin/bash
git pull origin main
npm ci
npm run build
systemctl restart nginx
```

### 配置 GitHub Actions

```yaml
- name: Trigger webhook
  run: |
    curl -X POST -H "Authorization: Bearer ${{ secrets.DEPLOY_TOKEN }}" \
      https://your-server.com/deploy-hook
```