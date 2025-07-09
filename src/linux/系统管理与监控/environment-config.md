---
title: export命令-环境变量配置
category:
  - Linux
  - 系统管理与监控
tag:
  - export
  - 环境变量
  - PATH配置
date: 2022-09-03

---

# 配置环境变量

## Linux环境变量概述

环境变量是操作系统用来存储系统配置信息的变量，其中PATH是最重要的环境变量之一。PATH决定了shell将到哪些目录中寻找命令或程序，当您运行一个程序时，Linux在这些目录下进行搜寻编译链接。

## 查看环境变量

### 查看所有环境变量
```bash
export
```

### 查看PATH环境变量
```bash
echo $PATH
```

PATH的值是一系列目录，格式为：
```
PATH=$PATH:<PATH 1>:<PATH 2>:<PATH 3>:------:<PATH N>
```
路径之间用冒号":"分隔。

## 三种配置环境变量的方法

### 1. 临时设置（仅当前终端有效）

直接在shell终端执行命令：
```bash
export JAVA_HOME=/usr/share/jdk1.5.0_05
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

**特点：**
- 设置简单快速
- 仅在当前终端会话中有效
- 终端关闭后设置消失
- 适合临时测试使用

### 2. 用户级配置（影响当前用户）

修改用户主目录下的`.bashrc`文件：

```bash
vim ~/.bashrc
```

在文件末尾添加：
```bash
export JAVA_HOME=/usr/share/jdk1.5.0_05
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

保存后执行：
```bash
source ~/.bashrc
```

**特点：**
- 更安全的配置方式
- 仅影响当前用户
- 可以精确控制用户权限
- 推荐用于个人开发环境

### 3. 系统级配置（影响所有用户）

修改`/etc/profile`文件：

```bash
vim /etc/profile
```

在文件末尾添加：
```bash
export JAVA_HOME=/usr/share/jdk1.5.0_05
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
```

保存后执行：
```bash
source /etc/profile
```

**特点：**
- 影响系统所有用户
- 适合开发专用机器
- 可能带来安全性问题
- 需要管理员权限

## 配置注意事项

1. **路径分隔符**：Linux下用冒号":"来分隔路径

2. **引用原值**：使用`$PATH`、`$CLASSPATH`、`$JAVA_HOME`引用原来的环境变量值，避免覆盖

3. **当前目录**：CLASSPATH中的当前目录"."不能丢失

4. **导出变量**：使用`export`将变量导出为全局变量

5. **大小写敏感**：变量名大小写必须严格区分

6. **安全考虑**：不建议将当前路径"./"放到PATH中，可能受到意想不到的攻击

7. **立即生效**：修改配置文件后，使用`source`命令可以立即生效，否则需要重新登录

## 实例：添加自定义程序路径

临时添加：
```bash
export PATH=/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH
```

永久添加（用户级）：
```bash
echo 'export PATH="/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

永久添加（系统级）：
```bash
echo 'export PATH="/opt/STM/STLinux-2.3/devkit/sh4/bin:$PATH"' >> /etc/profile
source /etc/profile
```

通过合理选择配置方法，可以根据实际需求灵活管理Linux系统的环境变量。
