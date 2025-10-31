---
title:  Gitea 常见工作流
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
  - 工作流
date: 2023-09-17
---

# Gitea 常见工作流

### Hello World

```
name: Gitea Actions Demo
run-name: ${{ gitea.actor }} is testing out Gitea Actions 🚀
on: [push]

jobs:
  Explore-Gitea-Actions:
    runs-on: ubuntu-latest
    steps:
      - run: echo "🎉 The job was automatically triggered by a ${{ gitea.event_name }} event."
      - run: echo "🐧 This job is now running on a ${{ runner.os }} server hosted by Gitea!"
      - run: echo "🔎 The name of your branch is ${{ gitea.ref }} and your repository is ${{ gitea.repository }}."
      - name: Check out repository code
        uses: actions/checkout@v4
      - run: echo "💡 The ${{ gitea.repository }} repository has been cloned to the runner."
      - run: echo "🖥️ The workflow is now ready to test your code on the runner."
      - name: List files in the repository
        run: |
          ls ${{ gitea.workspace }}
      - run: echo "🍏 This job's status is ${{ job.status }}."
```


### 容器内部使用 ssh 连接主机

```
name: Simple File Transfer via SSH (Alternative)

on:
  push:
    branches: [ main, master ]

jobs:
  transfer-file:
    runs-on: ubuntu-latest
    
    steps:
    - name: Test file creation in different directories
      uses: appleboy/ssh-action@v1.0.3
      with:
        host: ${{ secrets.SSH_HOST }}
        username: ${{ secrets.SSH_USER }}
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        script: |
          echo "🔍 Testing file creation in different locations..."
          
          echo "📁 Current user: $(whoami)"
          echo "📁 Current directory: $(pwd)"
          echo "📁 Home directory: $HOME"
          
          # 测试1: 尝试在 /tmp 目录创建（通常都有权限）
          echo "🧪 Test 1: Creating file in /tmp..."
          if echo "Hello from /tmp!" > /tmp/test-file.txt 2>/dev/null; then
            echo "✅ /tmp/test-file.txt created successfully!"
            cat /tmp/test-file.txt
            ls -la /tmp/test-file.txt
          else
            echo "❌ Failed to create file in /tmp"
          fi
          
          echo ""
          
          # 测试2: 尝试在当前目录创建
          echo "🧪 Test 2: Creating file in current directory..."
          if echo "Hello from current dir!" > ./test-file.txt 2>/dev/null; then
            echo "✅ ./test-file.txt created successfully!"
            echo "📁 Full path: $(pwd)/test-file.txt"
            cat ./test-file.txt
            ls -la ./test-file.txt
          else
            echo "❌ Failed to create file in current directory"
          fi
          
          echo ""
          
          # 测试3: 检查磁盘空间
          echo "💾 Disk space check:"
          df -h
          
          echo ""
          
          # 测试4: 检查用户权限
          echo "🔐 User permissions:"
          id
          groups
```

[Gitea工作流示例](https://gitee.com/fast-template-org/gitea-starter)
