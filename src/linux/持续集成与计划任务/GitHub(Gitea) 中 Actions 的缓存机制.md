---
title:  GitHub(Gitea) 中 Actions 的缓存机制
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
  - gitea
  - Actions
date: 2023-09-17
---

# GitHub(Gitea) 中 Actions 的缓存机制

## 目录

[[toc]]

## 决于运行环境

- **GitHub Actions（官方）**：不会重复下载，有缓存机制
- **Act Runner（自托管）**：**会重复下载**，每次都重新拉取

---

## 详细说明

### **1. GitHub Actions（GitHub 官方托管）**

#### **缓存机制**

GitHub Actions 对 actions 有完善的缓存策略：

```yaml
uses: appleboy/ssh-action@v1.0.3
uses: appleboy/scp-action@v1
```

**运行流程：**

```
第一次运行：
1. 下载 appleboy/ssh-action@v1.0.3
2. 缓存到 GitHub 的 runner 存储
3. 执行 action

第二次运行：
1. 检查缓存中是否有 appleboy/ssh-action@v1.0.3
2. ✅ 有缓存 → 直接使用（不下载）
3. 执行 action
```

**验证日志示例：**

```bash
# 第一次运行
Run appleboy/ssh-action@v1.0.3
  Downloading action from https://github.com/appleboy/ssh-action
  Download completed (2.3 MB)
  
# 第二次运行
Run appleboy/ssh-action@v1.0.3
  Using cached action
```

✅ **结论：GitHub Actions 不会重复下载**

---

### **2. Act Runner（Gitea/自托管）**

#### 当前行为（重要！）

**Act Runner 目前的实现：每次运行都会重新下载 actions**

```yaml
# Gitea Actions 工作流
name: Deploy
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: appleboy/ssh-action@v1.0.3  # 每次都下载
      - uses: appleboy/scp-action@v1      # 每次都下载
```

**实际运行日志：**

```bash
# 第一次运行
[Act Runner] Preparing workflow...
[Act Runner] Downloading action: appleboy/ssh-action@v1.0.3
[Act Runner] Cloning https://github.com/appleboy/ssh-action
[Act Runner] Checked out v1.0.3
[Act Runner] Running action...

# 第二次运行（再次下载）
[Act Runner] Preparing workflow...
[Act Runner] Downloading action: appleboy/ssh-action@v1.0.3
[Act Runner] Cloning https://github.com/appleboy/ssh-action
[Act Runner] Checked out v1.0.3
[Act Runner] Running action...
```

⬇️ **结论：Act Runner 会重复下载**

---

## 为什么 Act Runner 会重复下载？

### **原因分析**

1. **容器化执行环境**
    
    ```bash
    # 每次运行创建新容器
    docker run --rm \
      docker.gitea.com/runner-images:ubuntu-latest \
      /workspace/workflow.yml
    ```
    
    - 容器执行完毕后销毁（`--rm` 参数）
    - 下次运行重新创建新容器
    - 容器内没有持久化存储
2. **Act Runner 架构设计**
    
    - 目前 Act Runner 将 actions 下载到**容器内临时目录**
    - 容器销毁后，下载的 actions 也被删除
    - 没有实现类似 GitHub Actions 的持久化缓存层
3. **与 Docker 镜像缓存的区别**
    
    ```
    Docker 镜像：
    - 存储在宿主机 /var/lib/docker/
    - 多次使用，持久化存储
    
    Actions 代码：
    - 下载到容器内 /tmp/ 或 /workspace/
    - 容器销毁即删除
    ```
    

---

## 影响分析

### 对运行速度的影响

**典型 action 下载时间：**

|Action|大小|下载时间（国内）|下载时间（国外）|
|---|---|---|---|
|`actions/checkout@v4`|~500KB|1-3 秒|<1 秒|
|`appleboy/ssh-action@v1.0.3`|~50KB|<1 秒|<1 秒|
|`appleboy/scp-action@v1`|~50KB|<1 秒|<1 秒|
|`docker/build-push-action@v5`|~2MB|3-8 秒|1-2 秒|

**完整工作流额外开销：**

- 简单工作流（2-3 个 actions）：增加 **5-15 秒**
- 复杂工作流（5+ 个 actions）：增加 **15-40 秒**

### 对网络的影响

```bash
# 每天运行 10 次的工作流
10 次运行 × 2 个 actions × 50KB = 1MB/天

# 频繁触发的工作流（每小时一次）
24 次 × 2 个 actions × 50KB = 2.4MB/天
```

⚠️ **注意：** 如果访问 GitHub 网络不稳定，可能导致下载失败。

---

## 解决方案和优化建议

### **方案 1：使用本地 Actions**

`uses: appleboy/ssh-action@v1.0.3`
`uses: appleboy/ssh-action@v1.0.3`

仓库还是会引用远程下载地址，可以关注每一个action源代码中 `entrypoint.sh`

```
GITHUB_ACTION_PATH="${GITHUB_ACTION_PATH%/}"
DRONE_SSH_RELEASE_URL="${DRONE_SSH_RELEASE_URL:-https://github.com/appleboy/drone-ssh/releases/download}"
DRONE_SSH_VERSION="${DRONE_SSH_VERSION:-1.8.1}"
```

`uses: actions/checkout@v4` 可以直接使用本地路径，无需额外的下载

将常用 actions 克隆到本地，使用本地路径引用：

```bash
# 在 Act Runner 服务器上
mkdir -p /opt/actions
cd /opt/actions

# 克隆常用 actions
git clone https://github.com/appleboy/ssh-action.git
# 可选切换指定版本，默认v1即可
cd ssh-action && git checkout v1.0.3 && cd ..

git clone https://github.com/appleboy/scp-action.git
# 可选切换指定版本，默认v1即可
cd scp-action && git checkout v1 && cd ..

git clone https://github.com/actions/checkout.git
# 可选切换指定版本，默认v4即可
cd scp-action && git checkout v4 && cd ..
```

#### ⚠️ **注意：** 需要在 `act_runner` 配置中挂载本地路径到容器

<a :href="$withBase('./assets/_resources/gitea/config.yaml')">默认配置文件</a>

**编辑已生成的配置文件**

```yaml
# config.yaml
container:
  network: bridge
  privileged: false
  options: "-v /opt/actions:/opt/actions:ro"
  
  # 设置挂载卷的白名单
  valid_volumes:
    - /opt/actions
  # 或 所有卷    
  valid_volumes:
    - '**'
```

#### **修改工作流：**

```yaml
name: Gitea 使用本地 Actions 示例
run-name: ${{ gitea.actor }} is testing out Gitea Actions 🚀

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:
jobs:
  Explore-Gitea-Actions:
    runs-on: ubuntu-latest
    steps:
      - name: 打印触发信息
        run: echo "🎉 The job was automatically triggered by a ${{ gitea.event_name }} event."
      - name: 打印运行环境
        run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by Gitea!"
      - name: 打印仓库信息
        run: echo "🔎 The name of your branch is ${{ gitea.ref }} and your repository is ${{ gitea.repository }}."
      # 方案 1 将 actions 复制到 workspace(推荐)
      - name: 准备本地 Actions
        run: |
          if [ -d "/opt/actions" ]; then
            echo "✅ 发现挂载的 Actions 目录"
            cp -r /opt/actions ${{ gitea.workspace }}/
            ls -la ${{ gitea.workspace }}/actions/
            echo "actions_available=true" >> $GITHUB_ENV
          else
            echo "⚠️  未发现 /opt/actions 目录，将使用远程 Actions"
            echo "actions_available=false" >> $GITHUB_ENV
          fi

      # 使用本地 Actions(从 workspace 相对路径)
      - name: 使用本地 Actions 签出代码
        if: env.actions_available == 'true'
        uses: ./actions/checkout
```

[完整示例工作流-教程](https://gitee.com/fast-template-org/gitea-starter/blob/master/docs/build-local-action.md#/fast-template-org/gitea-starter/blob/master/.gitea/workflows/build-local-action.yml)

---

### **方案 2：使用 Github 代理（不稳定）**

如果下载速度慢，可以配置 Git 代理：

```bash
# 在 act_runner 服务器上配置
git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"

# 或使用其他镜像
git config --global url."https://hub.fastgit.xyz".insteadOf "https://github.com"
```

**常用镜像站：**

- `https://ghproxy.com/`
- `https://mirror.ghproxy.com/`
- `https://gh-proxy.com/`

---

### **方案 3：自建 Actions 镜像（企业方案- 推荐）**

目前已自建的镜像 如表格下：

| 镜像仓库地址                                    |                  源地址                  | action仓库                               |
| :---------------------------------------- | :-----------------------------------: | -------------------------------------- |
| https://gitee.com/mirror-org/drone-scp    | https://github.com/appleboy/drone-scp | https://github.com/appleboy/scp-action |
| https://gitee.com/mirror-org/drone-ssh    | https://github.com/appleboy/drone-ssh | https://github.com/appleboy/ssh-action |
| https://gitee.com/mirror-org/checkout.git |  https://github.com/actions/checkout  | 无-远程下载                                 |

action执行逻辑是 : 访问action->访问 `entrypoint.sh` ->镜像仓库地址，下载源代码并执行

环境变量配置

```
env:
  # 配置 SCP国内镜像地址，避免远程下载耗时，当前变量是 `scp-action/entrypoint.sh` 中定义的环境变量不可自定义

  DRONE_SCP_RELEASE_URL: https://gitee.com/mirror-org/drone-scp/releases/download/
  DRONE_SCP_VERSION: 1.8.0

  # 配置 SSH国内镜像地址，避免远程下载耗时，当前变量是 `ssh-action/entrypoint.sh` 中定义的环境变量不可自定义
  DRONE_SSH_RELEASE_URL: https://gitee.com/mirror-org/drone-ssh/releases/download

  DRONE_SSH_VERSION: 1.8.1
```

checkout没有额外的下载，可以直接使用国内镜像

```
- name: Check out repository code
  # uses: actions/checkout@v4
  uses: https://gitee.com/mirror-org/checkout
- run: echo "💡 The ${{ gitea.repository }} repository has been cloned to the runner."
```

镜像仓库使用示例：

```
name: Build and Deploy miliqk-portal

on:

  # 手动触发
  workflow_dispatch:

env:

  # 全局环境变量
  DEPLOY_TARGET: "/opt/1panel/web/sites/miliqk-portal/index"
  BUILD_PATH: "./miliqk-portal/unpackage/dist/build/h5"
  # 配置 SCP国内镜像地址，避免远程下载耗时，当前变量是 `scp-action/entrypoint.sh` 中定义的环境变量不可自定义
  DRONE_SCP_RELEASE_URL: https://gitee.com/mirror-org/drone-scp/releases/download/
  DRONE_SCP_VERSION: 1.8.0

jobs:

  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
    # ==================== 第一步：克隆代码 ====================
    - name: 🔄 克隆 miliqk-portal 仓库
      env:
        GIT_TERMINAL_PROMPT: 0  # 禁用交互式密码提示
      run: |
        echo "开始克隆仓库..."
        git clone --depth 1 https://oauth2:${{ secrets.GITEE_TOKEN }}@gitee.com/miliqk-org/miliqk-portal.git miliqk-portal
        echo "✅ 克隆完成！"
        echo "📁 仓库内容："
        ls -lah miliqk-portal/

    # ==================== 第二步：验证构建产物 ====================
    - name: 📦 验证构建产物
      id: validate
      run: |
        if [ -d "${{ env.BUILD_PATH }}" ]; then
          echo "✅ 发现构建目录: ${{ env.BUILD_PATH }}"
          echo "📊 文件统计："
          find ${{ env.BUILD_PATH }} -type f | wc -l
          ls -lh ${{ env.BUILD_PATH }}/
          echo "build_exists=true" >> $GITHUB_OUTPUT
        else
          echo "⚠️  未发现构建目录，可能需要先执行构建步骤"
          echo "build_exists=false" >> $GITHUB_OUTPUT
          exit 1
        fi

    - name: 🚀 部署到服务器(远程 Action)
      uses: appleboy/scp-action@v1
      with:
        host: ${{ secrets.SSH_HOST }}
        username: ${{ secrets.SSH_USER }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        port: 22
        timeout: 60s
        debug: true
        source: "${{ env.BUILD_PATH }}/*"
        target: ${{ env.DEPLOY_TARGET }}
        strip_components: 5
        overwrite: true
    # ==================== 第五步：部署后验证 ====================

    - name: ✅ 验证部署结果
      uses: appleboy/ssh-action@v1.0.3
      with:
        host: ${{ secrets.SSH_HOST }}
        username: ${{ secrets.SSH_USER }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        port: 22
        script: |
          echo "📁 检查部署目录："
          ls -lh ${{ env.DEPLOY_TARGET }}/
          echo ""
          echo "📊 文件总数："
          find ${{ env.DEPLOY_TARGET }} -type f | wc -l
          echo ""
          echo "✅ 部署完成！"
```

工作流中的变量，可以查看action源代码中 `entrypoint.sh` 文件了解具体的意思

```
GITHUB_ACTION_PATH="${GITHUB_ACTION_PATH%/}"
DRONE_SSH_RELEASE_URL="${DRONE_SSH_RELEASE_URL:-https://github.com/appleboy/drone-ssh/releases/download}"
DRONE_SSH_VERSION="${DRONE_SSH_VERSION:-1.8.1}"
```

### **方案 4：自建 Actions 镜像+本地action（企业方案- 推荐）**



---

## 总结对比表

|特性|GitHub Actions|Act Runner (当前)|
|---|---|---|
|Actions 缓存|✅ 自动缓存|❌ 每次下载|
|Docker 镜像缓存|✅ 缓存|✅ 缓存|
|首次运行速度|慢（需下载）|慢（需下载）|
|后续运行速度|快（使用缓存）|慢（重复下载）|
|网络依赖|首次高，后续低|持续高|
|离线运行|首次需联网|每次需联网|

---

## 最终建议

1. **短期方案**：接受当前行为，actions 通常很小（几十 KB），影响有限
    
2. **中期方案**：使用 Git 加速镜像，缓解下载慢的问题
    
3. **长期方案**：
    
    - 关注 Act Runner 更新，未来版本可能支持缓存
    - 对于关键 actions，采用本地克隆 + 挂载的方式
4. **企业方案**：搭建内部 actions 仓库，完全掌控依赖
    

**核心结论：**

- ✅ Docker 镜像会缓存，不会重复下载
- ❌ Actions 代码会重复下载，每次执行都拉取
- 💡 影响通常可接受，除非网络环境极差或工作流极其频繁