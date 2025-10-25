---
title: git安装
category:
  - Linux
  - 软件安装与包管理
tag:
  - git
  - 环境配置
date: 2022-09-19

---

# git安装

## linux 系统安装

### Centos/RedHat 系统安装Git 云服务通用配置（推荐）

#### 线上直接安装

安装依赖包

```
$ yum install curl-devel expat-devel gettext-devel \
  openssl-devel zlib-devel
```

安装git包
```
$ yum -y install git-core

$ git --version
git version 1.8.3.1
```

  
#### 源码安装（推荐，可以下载最新的版本）


我们也可以在官网下载源码包来安装，最新源码包下载地址寻找流程如下：
https://git-scm.com/download ->
https://git-scm.com/download/linux ->

![./git_01.png](./assets/_resources/git/git_01.png)

> 源码安装说明：  
> 目前最新的源码包: https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.gz    
> `https://mirrors.edge.kernel.org` 这是一个镜像地址  
> `https://www.kernel.org` 这是源地址  
> github最新的源码包: `https://github.com/git/git/releases/tag/v2.38.1` , 也可以查看历史版本  

安装指定系统的依赖包：

```
$ yum install curl-devel expat-devel gettext-devel \
  openssl-devel zlib-devel
```

解压安装下载的源码包：

```
$ cd /usr/local/
$ wget http://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.gz
$ tar xvf git-2.38.1.tar.gz 
$ cd git-2.38.1
$ ./configure
$ make
$ make install
```
> 说明:  
> wget http://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.1.tar.gz 尽量用http链接 否则有可能会报证书问题
> 使用默认配置进行安装，如果想修改配置，可以使用 ./configure --help 来获取帮助
> By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.  
> make使用说明:  
> ./configure && make -j 4 && make install
> – j 4 的含义是4个核心同时多线程进行编译，如果你的处理器有更多的核心，还可以 -j 6 -j 8······


#### 验证
验证
```
$ whereis git
git: /usr/bin/git /usr/local/bin/git /usr/share/man/man1/git.1.gz
$ git --version
git version 2.38.1
```


#### 卸载git

直接卸载
```
yum remove git
```
进入目录卸载（进入目录后要谨慎删除,或者备份后在删除）
```
#查看git的安装目录
$ which -a git  或 $ whereis git
#进入显示出来的git安装路径
$cd /git安装路径
#在git的安装路径下，执行卸载命令(谨慎使用)
$sudo rm -rf git*
```

### 参考教程

* [Debian/Ubuntu 系统安装Git](https://www.runoob.com/git/git-install-setup.html)
* [菜鸟教程- windows 系统安装Git](https://www.runoob.com/git/git-install-setup.html)
* [菜鸟教程- Mac 平台上安装](https://www.runoob.com/git/git-install-setup.html)
* [gitee.com - git安装](https://gitee.com/help/articles/4106#article-header0)



