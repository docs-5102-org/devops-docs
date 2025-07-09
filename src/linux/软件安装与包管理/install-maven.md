---
title: maven安装-构建工具配置指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - maven
  - 构建工具
  - java开发
date: 2022-09-20

---

# maven安装教程

## Windows、Mac安装maven


菜鸟教程：
[https://www.runoob.com/maven/maven-setup.html](https://www.runoob.com/maven/maven-setup.html)

第三方文档:

[https://github.com/tuonioooo/engineering-management/blob/master/maven/mavenan-zhuang-he-pei-zhi.md](https://github.com/tuonioooo/engineering-management/blob/master/maven/mavenan-zhuang-he-pei-zhi.md)

[https://tuonioooo.gitbooks.io/engineering-management/content/maven.html](https://tuonioooo.gitbooks.io/engineering-management/content/maven.html)

## Linux安装maven

#### 下载解压

```
[root@localhost mydata]# wget http://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
[root@localhost mydata]# tar -xvf apache-maven-3.8.6-bin.tar.gz
[root@localhost mydata]# mv -f apache-maven-3.8.6 /usr/local/
```
>maven官网：https://maven.apache.org/download.cgi

#### 设置环境变量

vi /etc/profile 在文件末尾添加如下代码：


```
export MAVEN_HOME=/usr/local/apache-maven-3.8.6
export PATH=${PATH}:${MAVEN_HOME}/bin
```

保存文件，并运行如下命令使环境变量生效：

```
$ source /etc/profile
```
查看是否生效
```
$ mvn -v
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /usr/local/apache-maven-3.8.6
Java version: 1.8.0_341, vendor: Oracle Corporation, runtime: /usr/local/java/jdk1.8.0_341/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-1062.el7.x86_64", arch: "amd64", family: "unix"
```

