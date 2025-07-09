---
title: jdk安装-Java环境配置指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - jdk
  - java
  - 环境配置
date: 2022-09-19

---

# Java（Jdk）下载和环境安装

## Windows安装Java环境

参考：[https://www.runoob.com/java/java-environment-setup.html](https://www.runoob.com/java/java-environment-setup.html)


## Linux安装Java环境

#### 源码包准备

首先到官网下载jdk

官网最新版本下载页面：[https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/)
官网历史版本下载页面：[https://www.oracle.com/java/technologies/downloads/archive/](https://www.oracle.com/java/technologies/downloads/archive/)

本示例教程，采用java8

[https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html#license-lightbox](https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html#license-lightbox)


[](../_resources/jdk/38fc9fbe075a3086638b28b7cadd0d6e.png)

下载后，上传到服务器上  PS: 现在下载JDk需要登录，链接下载会有问题

>官网查看时，可以发现有两个Jdk8的版本，  
Java SE 8 (8u211 and later) （推荐）  
Java SE 8 (8u202 and earlier) （不推荐）  
区别：  
从JDK版本7u71以后，JAVA将会在同一时间发布两个版本的JDK，其中：奇数版本为BUG修正并全部通过检验的版本，官方强烈推荐使用这个版本。偶数版本包含了奇数版本所有的内容，以及未被验证的BUG修复，Oracle官方表示：除非你深受BUG困扰，否则不推荐您使用这个版本。

#### 解压

在/usr/local目录下新建java文件夹

```
[root@localhost ~]# mkdir /usr/local/java
```
然后将下载到压缩包拷贝到`usr/local/java`件夹中

```
[root@localhost ~]# cp jdk-8u341-linux-x64.tar.gz /usr/local/java
```

解压压缩包

```
[root@localhost ~]#  cd /usr/local/java
[root@localhost java]# tar -xvf jdk-8u341-linux-x64.tar.gz
[root@localhost java]# rm jdk-8u341-linux-x64.tar.gz
```

#### 设置Java环境变量

root用户，给所有用户设置环境变量

```
sudo gedit /etc/profile
或者 vi /etc/profile
```
在文件末尾添加

```
export JAVA_HOME=/usr/local/java/jdk1.8.0_341
export JRE_HOME=/usr/local/java/jdk1.8.0_341/jre
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$PATH

或

JAVA_HOME=/usr/local/java/jdk1.8.0_341
JRE_HOME=/usr/local/java/jdk1.8.0_341/jre
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
PATH=$JAVA_HOME/bin:$PATH

export PATH CLASSPATH JAVA_HOME


```
> 说明： 在上述添加过程中，等号两侧不要加入空格，不然会出现"不是有效的标识符"，因为source /etc/profile 时不能识别多余到空格，会理解为是路径一部分。然后保存

使profile生效
```
source /etc/profile
```

给当前用户设置环境变量

```
vim ~/.bash_profile 文件
```

其他操作跟root用户设置环境变量是一样的

#### 检验是否安装成功

检查环境变量

```bash
echo ＄JAVA_HOME
echo ＄CLASSPATH
echo ＄PATH
```

检测版本

```
[root@localhost jdk1.8.0_341]# java -version
java version "1.8.0_341"
Java(TM) SE Runtime Environment (build 1.8.0_341-b10)
Java HotSpot(TM) 64-Bit Server VM (build 25.341-b10, mixed mode)
```


## 其他版本


[下载资源](https://www.oracle.com/java/technologies/downloads/archive/)




















