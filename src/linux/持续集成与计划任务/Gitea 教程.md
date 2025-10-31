---
title:  Gitea教程
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
date: 2023-09-17
---

# Gitea教程

## 目录

[[toc]]

## Gitea 简介

Gitea 是一个轻量级的 DevOps 平台软件，旨在提供一个易于安装、运行快速且用户体验良好的自建 Git 服务。它涵盖了软件开发生命周期的多个方面，包括 Git 仓库托管、代码审查、团队协作、软件包注册和持续集成/持续部署（CI/CD）功能。Gitea 最初是从 Gogs 分支而来，但经过了大量的代码修改和改进。

示例项目：[https://gitee.com/code-org/gitea-starter](https://gitee.com/code-org/gitea-starter)

* 包含各种工作流模版
* 用于测试gitea自动化构建脚本

**Gitea 的主要目标：**

*   **极易安装：** 简化部署过程，让个人开发者和小型团队能够方便地设置和管理自己的 Git 服务。
*   **运行快速：** 设计上注重轻量级和高性能，即使在资源有限的服务器环境下也能表现出色。
*   **良好体验：** 提供直观的用户界面和丰富的功能，提升开发者的使用体验。

**主要功能特性：**

*   **代码托管：** 支持创建和管理仓库、浏览提交历史、代码文件，以及进行代码审查和合并。支持标签、Cherry-pick、hook 等常见 Git 特性。
*   **轻量级和快速：** 资源消耗低，适合在各种服务器上运行。
*   **易于部署和维护：** 部署过程简单，依赖少，方便个人或团队快速搭建。
*   **安全性：** 提供用户权限管理和访问控制列表等功能，确保代码和数据安全。
*   **代码评审：** 支持 Pull Request 和 AGit 工作流，方便团队在线进行代码评审，提高代码质量。
*   **CI/CD：** Gitea Actions 兼容 GitHub Actions，用户可以使用熟悉的 YAML 格式编写工作流，并重用大量现有 Actions 插件。
*   **项目管理：** 通过看板和工单（支持分支、标签、里程碑、指派、时间跟踪、到期时间、依赖关系等）跟踪项目需求、功能和 Bug。
*   **制品库：** 支持超过 20 种不同类型的公共或私有软件包管理，如 Cargo, Chef, Composer, Conan, Conda, Container, Helm, Maven, npm, NuGet, Pub, PyPI, RubyGems, Vagrant 等。
*   **开源社区支持：** Gitea 是一个基于 MIT 许可证的开源项目，拥有活跃的社区，持续开发和改进。
*   **多语言支持：** 提供多种语言界面，支持国际化和本地化。

## 安装

### 二进制安装

https://docs.gitea.com/zh-cn/installation/install-from-binary

### Docker安装

https://docs.gitea.com/zh-cn/installation/install-with-docker

```yml
version: "3"

networks:
  gitea:
    external: false # 表示这不是一个 **外部网络**，是一个新建网络
    name: gitea_network

services:
  server:
    image: docker.gitea.com/gitea:1.24.0
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
    restart: always
    networks:
      - gitea
    volumes:
      - ./gitea:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
+     - "8080:3000"
+     - "222:22"    # 区分宿主主机的ssh端口
```

> 这里网络加了一个 命名 “gitea_network”，便于runner 共享此网络

### 数据库安装

支持 MySQL 数据库、PostgreSQL 数据库

参考官网文档：https://docs.gitea.com/zh-cn/installation/install-with-docker#mysql-%E6%95%B0%E6%8D%AE%E5%BA%93

> 同样网络与 runner、gitea实例 共享此网络

## Art Runner安装

### runner运行原理

[Gitea Act Runner 原理](./Gitea%20Act%20Runner%20原理.md)

### runner安装

#### 二进制安装(参考官网)

#### Docker镜像安装

```yml
version: "3.8"
services:
  runner:
    image: gitea/act_runner:nightly
    environment:
      CONFIG_FILE: /config.yaml
      GITEA_INSTANCE_URL: "${INSTANCE_URL}"
      GITEA_RUNNER_REGISTRATION_TOKEN: "${REGISTRATION_TOKEN}"
      GITEA_RUNNER_NAME: "${RUNNER_NAME}"
      GITEA_RUNNER_LABELS: "${RUNNER_LABELS}"
    networks:
      - gitea
    volumes:
      - ./config.yaml:/config.yaml
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock

networks:
  gitea: #网络变量名
    external: true # true: 引用外部网络，false: 自动创建一个新的网络
    name: gitea_network  # 外部网络名称
```

#### **🧾 参数说明**

##### `GITEA_INSTANCE_URL`

- **说明**：Gitea 实例的完整地址（协议 + 域名/IP + 端口）。
- **示例**：
    - `http://192.168.1.100:3000`
    - `https://gitea.example.com`
- **作用**：runner 启动时，会尝试连接此地址以注册自己。

---

##### `GITEA_RUNNER_REGISTRATION_TOKEN`

- **说明**：在 Gitea Web 界面中为组织或仓库创建 Runner 时生成的 **注册 Token**。
- **示例**：
    ```text
    38917d6c-bc0e-4f0f-bf3b-59ea9a66ac19
    ```
- **作用**：Runner 利用此 Token 完成与 Gitea 的首次认证和注册。
    
<img src="/assets/images/QQ_1749910691104.png" style="width: auto;"></img>

---

##### `GITEA_RUNNER_NAME`

- **说明**：你为这个 Runner 起的名字，用于在 Gitea 前端界面中标识。
- **示例**：
    - `ci-runner-01`
    - `gitea-self-hosted-runner`
- **作用**：便于你在 Gitea 中识别不同 Runner 实例。
    
---

##### `GITEA_RUNNER_LABELS`

- **说明**：给 Runner 打的标签，可以在 Gitea Actions 工作流中用于选择 Runner。
- **示例**：
    - `linux,docker`
    - `self-hosted,alpine`
    - `ubuntu-latest`
- **作用**：你可以在 Gitea 的 workflow 文件中，使用 `runs-on: [linux, docker, ubuntu-latest]` 来匹配具有相应标签的 Runner。
- 通常定义在 GITEA_RUNNER_LABELS: "${RUNNER_LABELS}" <<<--- Defined in config.yaml

---

##### 🛠 如何获取这些变量值？

- `GITEA_INSTANCE_URL`：就是你本地部署或远程 Gitea 的访问地址。
- `GITEA_RUNNER_REGISTRATION_TOKEN`：  
    登录 Gitea → 进入某个仓库或组织 → Actions → Runners → 点击「Generate registration token」。
    
---

##### ✅ 示例（.env 文件）

你可以创建 `.env` 文件来存放这些变量：

```env
INSTANCE_URL=http://192.168.1.100:3000
REGISTRATION_TOKEN=38917d6c-bc0e-4f0f-bf3b-59ea9a66ac19
RUNNER_NAME=local-runner
RUNNER_LABELS=linux,docker,self-hosted
```

然后在你的 `docker-compose.yml` 中引用这些变量即可。

示例目录如下：

```
.env  config.yaml  data docker-compose.yml
```

官方文档： 

[Gitea Actions Runner (`gitea/act_runner`)](https://gitea.com/gitea/act_runner)
[Act runner安装](https://docs.gitea.com/zh-cn/usage/actions/act-runner)

---

### **配置文件和自定义标签**

[Gitea Act Runner 配置文件和自定义标签](./Gitea%20Act%20Runner%20配置文件和自定义标签.md)

### **变量**

<img src="/assets/images/QQ_1749911167049.png" style="width: auto;"></img>

工作流中引用变量如： `${{ vars.HOST }}`

参考文档：https://docs.gitea.com/zh-cn/usage/actions/actions-variables

### **标签和镜像的映射**

[Gitea Act Runner 镜像对应关系](./Gitea%20Act%20Runner%20镜像对应关系.md)

## 工作流

### 与GitHub Actions的对比

https://docs.gitea.com/zh-cn/usage/actions/comparison

### 不支持的工作流语法

https://docs.gitea.com/zh-cn/usage/actions/comparison#%E4%B8%8D%E6%94%AF%E6%8C%81%E7%9A%84%E5%B7%A5%E4%BD%9C%E6%B5%81%E8%AF%AD%E6%B3%95

### 密钥管理

<img src="/assets/images/QQ_1749911474742.png" style="width: auto;"></img>

密钥管理使用方式：`${{ secrets.SSH_HOST }}`

> 通常来讲gitea是部署到内网环境中的，所以 SSH_HOST 添加宿主主机的内网IP即可，`192.168.0.xx`
> 使用时，通过`docker exec -it your_gitea bash` 查看是否拼的通

#### 示例

```yaml
name: Simple File Transfer via SSH (Alternative)

on:
  push:
    branches: [ main, master ]

jobs:
  transfer-file:
    runs-on: ubuntu-latest
    
    steps:
    - name: Check permissions and create file
      uses: appleboy/ssh-action@v1.0.3
      with:
        host: ${{ secrets.SSH_HOST }}
        username: ${{ secrets.SSH_USER }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        script: |
          echo "🔍 Checking current user and permissions..."
          whoami
          pwd
          
          echo "📁 Checking home directory permissions..."
          ls -la /home/
          ls -la /home/tuonioooo/ 2>/dev/null || echo "Cannot access /home/tuonioooo/"
          
          echo "🔧 Trying to create directory in user's home..."
          # 尝试在用户家目录创建
          mkdir -p ~/web
          
          # 检查是否成功
          if [ -d ~/web ]; then
            echo "✅ Directory ~/web created successfully"
            
            # 创建文件
            cat > ~/web/test-file.txt << 'EOF'
          Hello from GitHub Actions!
          Created at: $(date)
          This file was created directly on the server via SSH
          EOF
            
            echo "✅ File created successfully!"
            echo "📁 Full path: $(pwd)/web/"
            echo "📝 File contents:"
            cat ~/web/test-file.txt
            echo ""
            echo "🔐 File permissions:"
            ls -la ~/web/test-file.txt
          else
            echo "❌ Failed to create directory"
            echo "🔍 Available directories:"
            ls -la ~/
          fi
```

#### 注意

```bash
###  这里在添加私钥Key时，要包括SSH私钥必须是完整的，包含头部和尾部：
${{ secrets.SSH_PRIVATE_KEY }}
```

```
-----BEGIN OPENSSH PRIVATE KEY-----
[私钥内容]
-----END OPENSSH PRIVATE KEY-----
```

这里很**关键**， 在SSH连接时，如果不包含头部和尾部，是连接不通的，非常蛋疼，调试了半天

**参考教程**

* [Gitea-SSH密钥配置与授权完整指南](Gitea-SSH密钥配置与授权完整指南.md)


## 相关资源链接

### **功能文档**

- [Gitea 关闭面板的注册功能](./Gitea%20关闭面板的注册功能.md)
- [GitHub(Gitea) 中 Actions 的缓存机制](./GitHub(Gitea)%20中%20Actions%20的缓存机制.md)
- [经验之谈](https://zhuanlan.zhihu.com/p/486410391)

### **主要文档**

- **Act Runner 官方文档**: https://docs.gitea.com/usage/actions/act-runner
- **配置 Runner**: https://docs.gitea.com/usage/actions/act-runner#configuration
- **自定义 Labels**: https://docs.gitea.com/usage/actions/act-runner#labels

### **相关资源**

- **Gitea Actions 总览**: https://docs.gitea.com/usage/actions/overview
- **GitHub 仓库**: https://gitea.com/gitea/act_runner
- **配置文件示例**: https://gitea.com/gitea/act_runner/src/branch/main/internal/pkg/config/config.example.yaml

### **常用镜像（catthehacker）**

- **GitHub 仓库**: https://github.com/catthehacker/docker_images
- **Docker Hub**: https://hub.docker.com/u/catthehacker

这些文档详细说明了如何配置自定义 labels、使用不同的容器镜像以及 runner 的各种配置选项。