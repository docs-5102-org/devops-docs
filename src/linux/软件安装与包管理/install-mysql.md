---
title: MySQL 安装
category:
  - Linux
  - 软件安装与包管理
tag:
  - MySQL
  - 服务配置
date: 2022-09-21

---

# MySQL 安装

## 安装教程

[菜鸟教程：https://www.runoob.com/mysql/mysql-install.html](https://www.runoob.com/mysql/mysql-install.html)

[MySql8离线安装](https://www.cnblogs.com/quchunhui/p/11115339.html)

<a :href="$withBase('./assets/_resources/Linux_MySQL的安装与配置.resources/第九章MySQL的安装与配置.pdf')">Mysql安装与配置.pdf</a>

软件安装目录 `/usr/local/`

## 常用配置

### 配置信息

* 系统Root 临时初始化密码：`ryasz)e9NP7s`，查看临时密码日志文件： cat /var/log/mysqld.log，
* 查看临时密码命令：grep “A temporary password” /var/log/mysqld.log
* 安装及远程配置参考地址： https://www.cnblogs.com/quchunhui/p/11115339.html

### 服务相关命令

- [MySQL 启动命令大全](./mysql-service-command.md)

### MySql 查询配置信息

```sql
-- mysql连接状态
show status like '%connect%';
-- mysql最大连接数
show variables like '%connect%';
-- 查看字符编码
SHOW VARIABLES LIKE 'character_set_server';
SHOW VARIABLES LIKE 'collation_server';
-- 查看表名大小写设置（0=区分大小写，1=不区分）
SHOW VARIABLES LIKE 'lower_case_table_names';
-- 查看监听地址（* 或 0.0.0.0 表示监听所有接口）
SHOW VARIABLES LIKE 'bind_address';
-- 查看当前连接信息
SHOW PROCESSLIST;
-- 查看用户权限
SHOW GRANTS FOR 'root'@'%';
SHOW GRANTS FOR 'appuser'@'%';
-- 查看 binlog 状态
SHOW VARIABLES LIKE 'log_bin';
```

### 默认配置文件位置

```shell
cat /etc/my.cnf
```
- <a :href="$withBase('./assets/_resources/mysql/my.cnf')">示例文件</a>
- <a :href="$withBase('./assets/_resources/mysql/default/my.cnf')">默认配置文件</a>

> 说明: 如果文件不存在 就新建

