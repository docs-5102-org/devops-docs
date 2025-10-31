---
title:  Gitea Act Runner 镜像对应关系
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
  - gitea
  - act runner
date: 2023-09-17
---

# Gitea Act Runner 镜像对应关系

## 目录

[[toc]]

## 📦 官方标准镜像映射

#### **Ubuntu 系列**

| runs-on 标签      | Docker 镜像                           | 大小     | 说明                    |
| --------------- | ----------------------------------- | ------ | --------------------- |
| `ubuntu-latest` | `catthehacker/ubuntu:act-latest`    | ~1.2GB | 最新 Ubuntu，基础工具集       |
| `ubuntu-latest` | `catthehacker/ubuntu:full-latest`   | ~2.5GB | 完整版，含 Node.js/Python等 |
| `ubuntu-latest` | `catthehacker/ubuntu:runner-latest` | ~1.8GB | 最接近 GitHub Actions 环境 |
| `ubuntu-22.04`  | `catthehacker/ubuntu:act-22.04`     | ~1.2GB | Ubuntu 22.04 LTS (推荐) |
| `ubuntu-20.04`  | `catthehacker/ubuntu:act-20.04`     | ~1.1GB | Ubuntu 20.04 LTS      |
| `ubuntu-18.04`  | `catthehacker/ubuntu:act-18.04`     | ~1.0GB | Ubuntu 18.04 (已停止维护)  |

#### **其他常用系统**

|runs-on 标签|Docker 镜像|大小|说明|
|---|---|---|---|
|`node:16-bullseye`|`node:16-bullseye`|~900MB|Node.js 16 + Debian|
|`node:18-bullseye`|`node:18-bullseye`|~950MB|Node.js 18 + Debian|
|`node:20-bullseye`|`node:20-bullseye`|~980MB|Node.js 20 + Debian|
|`alpine:latest`|`catthehacker/ubuntu:act-alpine`|~300MB|Alpine Linux (轻量级)|
|`debian:latest`|`debian:bullseye-slim`|~150MB|Debian 最小镜像|

## 🔗 官方资源链接

- **Docker Hub 镜像仓库**: https://hub.docker.com/r/catthehacker/ubuntu
- **GitHub 源码仓库**: https://github.com/catthehacker/docker_images
- **Gitea Actions 文档**: https://docs.gitea.com/usage/actions/overview
- **act_runner 文档**: https://gitea.com/gitea/act_runner

## 📝 版本说明

### 基础版 (act-*)

```yaml
runs-on: ubuntu-latest
container: catthehacker/ubuntu:act-latest
```

- 包含基本构建工具（gcc, make, git）
- 适合简单的编译任务
- 镜像体积最小

### 完整版 (full-*)

```yaml
runs-on: ubuntu-latest
container: catthehacker/ubuntu:full-latest
```

- 包含 Node.js (多版本)
- 包含 Python (2.7, 3.x)
- 包含 Docker、Docker Compose
- 包含常用开发工具链

### Runner 版 (runner-*)

```yaml
runs-on: ubuntu-latest
container: catthehacker/ubuntu:runner-latest
```

- 最接近 GitHub Actions 官方环境
- 预装大部分 GitHub Actions 工具
- 推荐用于迁移 GitHub Actions 工作流

## 💡 配置示例

### act_runner 配置文件 (.runner)

```yaml
labels:
  - "ubuntu-latest:docker://catthehacker/ubuntu:act-latest"
  - "ubuntu-22.04:docker://catthehacker/ubuntu:act-22.04"
  - "ubuntu-full:docker://catthehacker/ubuntu:full-latest"
  - "node:16:docker://node:16-bullseye"
  - "alpine:docker://alpine:latest"
```

### Workflow 使用示例

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    # 或指定特定版本
    # runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3
      - name: Build
        run: make build
```

## ⚠️ 注意事项

1. **首次拉取**：镜像较大，首次运行会较慢
2. **磁盘空间**：建议预留 5GB+ 磁盘空间
3. **网络问题**：国内可使用镜像加速器（如阿里云、腾讯云）
4. **版本选择**：生产环境建议使用明确版本号而非 `latest`

