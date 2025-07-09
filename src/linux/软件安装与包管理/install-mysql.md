---
title: mysql安装
category:
  - Linux
  - 软件安装与包管理
tag:
  - mysql
  - 数据库备份与导入
  - 服务配置
date: 2022-09-21

---

# mysql安装

## 安装教程

[菜鸟教程：https://www.runoob.com/mysql/mysql-install.html](https://www.runoob.com/mysql/mysql-install.html)

[Mysql8离线安装](https://www.cnblogs.com/quchunhui/p/11115339.html)

[Mysql安装与配置.pdf](../_resources/Linux_MySQL的安装与配置.resources/第九章MySQL的安装与配置.pdf)

软件安装目录 `/usr/local/`

## mysql常用配置

### mysql配置信息

* 系统Root 临时初始化密码：ryasz)e9NP7s，查看临时密码日志文件： cat /var/log/mysqld.log，
* 查看临时密码命令：grep “A temporary password” /var/log/mysqld.log
* 安装及远程配置参考地址： https://www.cnblogs.com/quchunhui/p/11115339.html

### mysql服务相关命令

```shell
------centOS6----------
service mysqld stop
service mysqld start
service mysqld restart
------centOS7----------
systemctl start mysqld
systemctl status mysqld
```

### Linux数据库备份导入命令

```shell
#-S /data/mysql/mysql.sock 指定链接文件

#数据库备份命令
nohup mysqldump novel_mp -S /data/mysql/mysql.sock > /data/novel_mp_20200901.sql &
nohup mysqldump novel_oauth -S /data/mysql/mysql.sock > /data/novel_oauth_20200901.sql &

#数据库导入命令
mysql -S /data/mysql/mysql.sock -uroot -p novel_mp < novel_mp_20200901.sql
mysql -S /data/mysql/mysql.sock -uroot -p miliqk_mp <  miliqk_mp_20220709.sql
```

### Windows mysql数据库备份和还原命令

```shell
#备份命令
mysqldump -uroot -proot novel_mp > novel_mp_20210228.sql
mysqldump -uroot -proot novel_oauth > novel_oauth_20210228.sql
#导入命令
mysql -uroot -proot novel_mp_test < novel_mp_20210226.sql
mysql -uroot -proot novel_oauth_test < novel_oauth_20210226.sql
```

### mysql连接状态

```sql
show status like '%connect%';
```

### mysql最大连接数

```sql
show variables like '%connect%';
```

### mysql配置文件默认位置

```shell
cat /etc/my.cnf
```
> 说明: 如果文件不存在 就新建

### 配置文件

[示例文件](../_resources/mysql/my.cnf)
[默认配置文件](../_resources/mysql/default/my.cnf)

