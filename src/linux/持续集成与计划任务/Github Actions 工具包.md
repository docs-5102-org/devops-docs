# GitHub Actions 工具包

GitHub Actions 提供了丰富的官方和社区维护的 Actions，用于简化 CI/CD 工作流程。本文档介绍常用的 Actions 工具及其工作原理。

## 目录
- [代码检出](#代码检出)
- [环境配置](#环境配置)
- [缓存管理](#缓存管理)
- [部署相关](#部署相关)
- [其他工具](#其他工具)

---

## 代码检出

### actions/checkout

**官方链接**: https://github.com/actions/checkout

**用途**: 将仓库代码检出到 runner 的工作目录中，这是几乎所有工作流的第一步。

**运行原理**:
1. 使用 Git 协议连接到 GitHub 仓库
2. 根据触发事件（push、pull request 等）确定要检出的提交
3. 执行 `git clone` 或 `git fetch` 获取代码
4. 切换到指定的分支、标签或提交
5. 支持子模块检出、LFS 文件处理等高级功能

**示例**:
```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0  # 获取完整历史记录
    submodules: true  # 检出子模块
```

---

## 环境配置

### actions/setup-node

**官方链接**: https://github.com/actions/setup-node

**用途**: 配置 Node.js 运行环境，用于构建 JavaScript/TypeScript 项目。

**运行原理**:
1. 从 GitHub 托管的工具缓存或官方源下载指定版本的 Node.js
2. 解压并安装到 runner 的工具目录
3. 将 Node.js 和 npm/yarn 添加到系统 PATH
4. 配置 npm registry（如果指定）
5. 设置缓存路径用于依赖缓存

**示例**:
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'  # 自动缓存 npm 依赖
```

**官方下载地址**:

- [下载指定包的地址](https://github.com/actions/node-versions/releases/download/24.11.0-18894910158/node-24.11.0-linux-x64.tar.gz)
- [包含所有Node版本的地址](https://github.com/actions/node-versions)

---

### actions/setup-python

**官方链接**: https://github.com/actions/setup-python

**用途**: 配置 Python 运行环境。

**运行原理**:
1. 检查 runner 预装的 Python 版本
2. 如果需要其他版本，从工具缓存或 python.org 下载
3. 使用 `pyenv` 或直接安装来设置 Python
4. 配置 pip 并添加到 PATH
5. 支持虚拟环境和依赖缓存

**示例**:
```yaml
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'
    cache: 'pip'
```

---

### actions/setup-java

**官方链接**: https://github.com/actions/setup-java

**用途**: 配置 Java Development Kit (JDK) 环境。

**运行原理**:
1. 根据指定的发行版（Temurin、Zulu、Adopt 等）确定下载源
2. 从工具缓存或发行版官方源下载 JDK
3. 解压并安装到指定路径
4. 设置 `JAVA_HOME` 环境变量
5. 将 JDK 的 bin 目录添加到 PATH
6. 配置 Maven/Gradle 的 settings.xml（如果需要）
7. 支持多 JDK 版本并存

**示例**:
```yaml
- uses: actions/setup-java@v4
  with:
    distribution: 'temurin'  # Eclipse Temurin (原 AdoptOpenJDK)
    java-version: '17'
    cache: 'maven'  # 缓存 Maven 依赖
```

**直接使用镜像**

```
# 推荐：直接使用包含工具的容器镜像
jobs:
  build:
    container: node:24-alpine  # 或构建自己的镜像
    steps:
      - uses: actions/checkout@v3
      - run: npm ci
      - run: npm test
```
这样可以完全避免每次下载 Node.js，只需在首次拉取镜像时下载一次。

---

### actions/setup-go

**官方链接**: https://github.com/actions/setup-go

**用途**: 配置 Go 语言开发环境。

**运行原理**:
1. 从 Go 官方或工具缓存下载指定版本
2. 解压并设置到工具目录
3. 配置 `GOROOT` 和 `GOPATH` 环境变量
4. 将 Go 二进制文件添加到 PATH
5. 支持模块缓存以加速依赖下载

**示例**:
```yaml
- uses: actions/setup-go@v5
  with:
    go-version: '1.21'
    cache: true
```

---

### actions/setup-dotnet

**官方链接**: https://github.com/actions/setup-dotnet

**用途**: 配置 .NET SDK 环境。

**运行原理**:
1. 从 Microsoft 官方源下载 .NET SDK
2. 安装到 runner 的工具目录
3. 配置环境变量和 PATH
4. 支持多版本 SDK 并存
5. 设置 NuGet 源和认证

**示例**:
```yaml
- uses: actions/setup-dotnet@v4
  with:
    dotnet-version: '8.0.x'
```

---

## 缓存管理

### actions/cache

**官方链接**: https://github.com/actions/cache

**用途**: 缓存依赖和构建输出，加速后续工作流运行。

**运行原理**:
1. 根据 key 计算缓存标识符（通常基于锁文件的哈希）
2. 在工作流开始时尝试从 GitHub 缓存服务器恢复缓存
3. 如果缓存命中，解压到指定路径
4. 工作流结束时，将指定路径打包并上传到缓存服务器
5. 缓存有大小限制（10GB）和过期时间（7天未使用）

**示例**:
```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

---

## 部署相关

### actions/upload-artifact

**官方链接**: https://github.com/actions/upload-artifact

**用途**: 上传构建产物（artifact），在工作流的不同 job 之间共享文件或保存构建结果。

**运行原理**:
1. 将指定路径的文件打包（通常使用 tar 或 zip）
2. 上传到 GitHub 的 artifact 存储服务
3. 与当前工作流运行关联
4. 可在 GitHub UI 中下载，或被其他 job 使用
5. 默认保留 90 天

**示例**:
```yaml
- uses: actions/upload-artifact@v4
  with:
    name: build-output
    path: dist/
```

---

### actions/download-artifact

**官方链接**: https://github.com/actions/download-artifact

**用途**: 下载之前上传的构建产物。

**运行原理**:
1. 从 GitHub artifact 存储服务查询指定名称的 artifact
2. 下载 artifact 压缩包
3. 解压到指定路径
4. 恢复文件权限和属性

**示例**:
```yaml
- uses: actions/download-artifact@v4
  with:
    name: build-output
    path: dist/
```

---

### actions/deploy-pages

**官方链接**: https://github.com/actions/deploy-pages

**用途**: 部署静态网站到 GitHub Pages。

**运行原理**:
1. 接收上传的 artifact（通常是静态网站文件）
2. 将文件推送到仓库的 `gh-pages` 分支或特殊的 Pages 部署 API
3. 触发 GitHub Pages 的构建和发布流程
4. 更新 Pages 站点内容

**示例**:
```yaml
- uses: actions/deploy-pages@v4
```

---

## 其他工具

### actions/github-script

**官方链接**: https://github.com/actions/github-script

**用途**: 在工作流中执行 JavaScript 脚本，通过 Octokit 客户端与 GitHub API 交互。

**运行原理**:
1. 提供预配置的 Octokit 客户端（已认证）
2. 在 Node.js 环境中执行用户提供的 JavaScript 代码
3. 自动注入 context 对象（包含事件信息、仓库信息等）
4. 可以操作 issues、PR、标签等 GitHub 资源
5. 脚本返回值可被后续步骤使用

**示例**:
```yaml
- uses: actions/github-script@v7
  with:
    script: |
      github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: '👋 感谢你的贡献！'
      })
```

---

### docker/login-action

**官方链接**: https://github.com/docker/login-action

**用途**: 登录到 Docker 镜像仓库（Docker Hub、GitHub Container Registry 等）。

**运行原理**:
1. 接收认证凭据（用户名/密码或 token）
2. 执行 `docker login` 命令
3. 将认证信息保存到 Docker 配置文件
4. 支持多个镜像仓库同时登录

**示例**:
```yaml
- uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

---

### docker/build-push-action

**官方链接**: https://github.com/docker/build-push-action

**用途**: 构建 Docker 镜像并推送到镜像仓库。

**运行原理**:
1. 使用 Buildx（Docker 的高级构建引擎）
2. 读取 Dockerfile 并执行多阶段构建
3. 支持缓存层以加速构建
4. 可以构建多架构镜像（amd64、arm64 等）
5. 构建完成后推送到指定的镜像仓库
6. 支持设置标签、元数据等

**示例**:
```yaml
- uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: user/app:latest
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

---

### codecov/codecov-action

**官方链接**: https://github.com/codecov/codecov-action

**用途**: 上传代码覆盖率报告到 Codecov 服务。

**运行原理**:
1. 扫描工作空间中的覆盖率报告文件（支持多种格式）
2. 解析覆盖率数据（行覆盖、分支覆盖等）
3. 使用 Codecov 的上传工具将数据发送到 Codecov API
4. 自动检测 CI 环境信息（commit SHA、分支等）
5. Codecov 服务生成可视化报告和徽章

**示例**:
```yaml
- uses: codecov/codecov-action@v4
  with:
    files: ./coverage.xml
    flags: unittests
    name: codecov-umbrella
```

**下载配置**:
```yaml
# Codecov uploader 镜像配置（可选）
CODECOV_UPLOADER_URL: https://uploader.codecov.io/latest/linux/codecov
```


---

### appleboy/ssh-action

**官方链接**: https://github.com/appleboy/ssh-action

**用途**: 通过 SSH 连接到远程服务器并执行命令，常用于部署场景。

**运行原理**:
1. 使用提供的 SSH 凭据（密码或密钥）建立 SSH 连接
2. 支持密钥文件、密钥内容、密码等多种认证方式
3. 在远程服务器上执行指定的 shell 脚本或命令
4. 捕获命令输出和退出状态
5. 支持代理跳转、端口转发等高级 SSH 特性
6. 内部使用 Go 语言的 SSH 客户端库

**示例**:
```yaml
- uses: appleboy/ssh-action@v1
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    key: ${{ secrets.SSH_PRIVATE_KEY }}
    port: 22
    script: |
      cd /var/www/app
      git pull origin main
      npm install
      pm2 restart app
```

**下载配置**:
```yaml
# 通过源代码 `https://github.com/appleboy/ssh-action/entrypoint.sh` 可以找到默认的下载地址变量 `DRONE_SSH_RELEASE_URL`、`DRONE_SSH_VERSION`
# SSH Action 国内镜像地址（适用于自建 runner）
DRONE_SSH_RELEASE_URL: https://gitee.com/mirror-org/drone-ssh/releases/download
DRONE_SSH_VERSION: 1.8.1
```

---

### appleboy/scp-action

**官方链接**: https://github.com/appleboy/scp-action

**用途**: 通过 SCP 协议将文件传输到远程服务器。

**运行原理**:
1. 使用 SSH 协议建立安全连接
2. 通过 SCP（Secure Copy Protocol）传输文件
3. 支持单个文件、多个文件或整个目录的传输
4. 可以设置目标路径、文件权限等
5. 支持覆盖、递归复制等选项
6. 传输完成后验证文件完整性

**示例**:
```yaml
- uses: appleboy/scp-action@v1
  with:
    host: ${{ secrets.HOST }}
    username: ${{ secrets.USERNAME }}
    key: ${{ secrets.SSH_PRIVATE_KEY }}
    port: 22
    source: "dist/*"
    target: "/var/www/html"
    strip_components: 1
```

**下载配置**:
```yaml
# 通过源代码 `https://github.com/appleboy/scp-action/entrypoint.sh` 可以找到默认的下载地址变量 `DRONE_SCP_RELEASE_URL`
# SCP Action 国内镜像地址（适用于自建 runner），来自于
DRONE_SCP_RELEASE_URL: https://gitee.com/mirror-org/drone-scp/releases/download
DRONE_SCP_VERSION: 1.8.0
```

## 最佳实践

1. **固定版本**: 使用特定版本标签（如 `@v4`）而非 `@main`，确保工作流稳定性
2. **启用缓存**: 合理使用缓存功能加速构建，减少网络请求
3. **最小权限**: 为 Actions 配置所需的最小权限
4. **安全存储**: 敏感信息使用 GitHub Secrets 存储
5. **矩阵策略**: 使用矩阵构建测试多个版本/平台组合

## 参考资源

- [GitHub Actions 官方文档](https://docs.github.com/en/actions)
- [GitHub Actions 市场](https://github.com/marketplace?type=actions)
- [Actions 更多工具包](https://github.com/actions/toolkit)