---
title:  Gitea Act Runner 配置文件和自定义标签
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

# Gitea Act Runner 配置文件和自定义标签

## 目录

[[toc]]

## **创建配置文件**

### **二进制文件创建配置文件[可选方式1]**

```bash
./act_runner generate-config > config.yaml  
 ```
### **Docker 创建配置文件[可选方式2-推荐]**

```bash
docker run --entrypoint="" --rm -it docker.io/gitea/act_runner:latest act_runner generate-config > config.yaml

# 阿里云的版本是 0.2.13
docker run --entrypoint="" --rm -it gitea/act_runner:0.2.13 act_runner generate-config > config.yaml
```

> 启动前，建议要先生成一个配置文件，就算用这种1panel 可以添加自定义配置文件和标签

:::tip

**[标签作用](#为什么加入自定义标签)**

用于区分不同`runner`的标签

参考: https://docs.gitea.com/zh-cn/usage/actions/faq?_highlight=labels#%E5%A6%82%E6%9E%9C%E5%AE%83%E5%9C%A8%E5%A4%9A%E4%B8%AA%E6%A0%87%E7%AD%BE%E4%B8%8A%E8%BF%90%E8%A1%8C%E4%BE%8B%E5%A6%82-runs-on-label_a-label_b%E4%BC%9A%E5%8F%91%E7%94%9F%E4%BB%80%E4%B9%88

:::

### **生成默认配置文件**

<a :href="$withBase('./assets/_resources/gitea/config.yaml')">默认配置文件</a>

#### **白名单的配置-config.yaml**

```yaml
container:
  # 允许挂载任何卷
  # valid_volumes:
  #   - '**'
  valid_volumes: ['**']
```

配置了以后，act_runner 中镜像就可以挂载任何卷了，否则挂载不成功，示例如下：

```yaml
name: Build and Deploy miliqk-api

on:
  # push 时触发(取消注释以启用)
  # push:
  #   branches: [ main, master, dev ]
  # 手动触发
  workflow_dispatch:

jobs:
  build-and-deploy:
    runs-on: miliqk-api
    container:
      image: maven:3.8.6-openjdk-8  # 已包含 Java 8 + Maven 3.8.6，无需额外设置
      # ============ Maven 配置挂载, 缓存下载============
      volumes:
        # ⚠️ 挂载前提条件(在 Runner 真实宿主机上执行):
        #   方案1: sudo mkdir -p /opt/.m2 && sudo chmod 755 /opt/.m2
        #  挂载 .m2/settings.xml 文件（推荐）
        - /opt/.m2:/root/.m2
    steps:
      # 省略...
```

### **添加共享网络**

在已生成的默认配置文件，这里主要修改的地方有两点：

1. network: "gitea_network"  : 加了一个共享网络 因为runner是独立于Gitea安装的这里必须设置同一个网络
2. 挂载了一个默认目录

> 注意要点：
> 1. Runner 是独立于Gitea 安装的
> 2. 上面的 配置文件区别于官网，加入了一个共享网络，使它与gitea在同一个网络，主要是因为是不同的Docker启动的，建议是不同Docker

## 如何自定义标签

### **加入自定义标签**

在已生成的默认配置文件中，主要关注 labels 内容，默认内容如下：

```yml
labels:
   - "ubuntu-latest:docker://docker.gitea.com/runner-images:ubuntu-latest"
   - "ubuntu-22.04:docker://docker.gitea.com/runner-images:ubuntu-22.04"
   - "ubuntu-20.04:docker://docker.gitea.com/runner-images:ubuntu-20.04"
```

添加新的标签

```yml
labels:
   - "ubuntu-latest:docker://docker.gitea.com/runner-images:ubuntu-latest"
   - "ubuntu-22.04:docker://docker.gitea.com/runner-images:ubuntu-22.04"
   - "ubuntu-20.04:docker://docker.gitea.com/runner-images:ubuntu-20.04"
   - "web-ubuntu-latest:docker://docker.gitea.com/runner-images:ubuntu-latest"
```

### **为什么加入自定义标签?**

可以用于区分不同的项目工作流来触发不同的`runner`

### **参考资料**

* https://docs.gitea.com/zh-cn/usage/actions/act-runner#%E9%85%8D%E7%BD%AE
- **Act Runner 官方文档**: https://docs.gitea.com/usage/actions/act-runner
- **配置 Runner**: https://docs.gitea.com/usage/actions/act-runner#configuration
- **自定义 Labels**: https://docs.gitea.com/usage/actions/act-runner#labels