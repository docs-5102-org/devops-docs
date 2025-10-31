---
title: 1panel-软件安装
category:
  - Linux
  - 软件安装与包管理
tag:
  - 1panel
date: 2022-09-19

---

# 1panel软件安装

## 安装1panel

### 详细教程

https://1panel.cn/docs/v2/installation/package_installation/#41

### 下载链接：

```bash
bash -c "$(curl -sSL https://resource.fit2cloud.com/1panel/package/v2/quick_start.sh)"
```

### 界面展示

```
 ██╗    ██████╗  █████╗ ███╗   ██╗███████╗██╗
███║    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
╚██║    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
 ██║    ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
 ██║    ██║     ██║  ██║██║ ╚████║███████╗███████╗
 ╚═╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
[1Panel Log]: ======================= 开始安装 =======================
设置 1Panel 安装目录 (默认为 /opt):
[1Panel Log]: 您选择的安装路径是 /opt
是否要配置镜像加速 [y/n]: y
[1Panel Log]: 配置文件已存在，我们将备份现有的配置文件到:  /etc/docker/daemon.json.1panel_bak.
[1Panel Log]: 创建新配置文件 /etc/docker/daemon.json...
[1Panel Log]: 已添加镜像加速配置。
[1Panel Log]: 正在重启 Docker 服务...
[1Panel Log]: Docker 服务已成功重启。
设置 1Panel 端口 (默认是 24227): 14000
[1Panel Log]: 您设置的端口是:  14000
[1Panel Log]: 正在打开防火墙端口 14000
Rules updated
Rules updated (v6)
Firewall not enabled (skipping reload)
设置 1Panel 安全入口 (默认是 1ef387f2fa):
[1Panel Log]: 您设置的面板安全入口是 1ef387f2fa
设置 1Panel 面板用户 (默认是 4e867fdc9a): 
[1Panel Log]: 您设置的面板用户是 4e867fdc9a
[1Panel Log]: 设置 1Panel 面板密码，设置后按回车键继续 (默认是 10eacf88c8):
********
[1Panel Log]: 正在配置 1Panel 服务
Created symlink /etc/systemd/system/multi-user.target.wants/1panel-agent.service → /etc/systemd/system/1panel-agent.service.
Created symlink /etc/systemd/system/multi-user.target.wants/1panel-core.service → /etc/systemd/system/1panel-core.service.
[1Panel Log]: 正在启动 1Panel 服务
[1Panel Log]: 1Panel 服务已成功启动，正在继续执行后续配置，请稍候...
[1Panel Log]:
[1Panel Log]: =================感谢您的耐心等待，安装已完成==================
[1Panel Log]:
[1Panel Log]: 请使用您的浏览器访问面板:
[1Panel Log]: 外部地址:  http://x.x.x.x:14000/1ef387f2fa
[1Panel Log]: 内部地址:  http://x.x.x.x:14000/1ef387f2fa
[1Panel Log]: 面板用户:  4e867fdc9a
[1Panel Log]: 面板密码:  10eacf88c8
[1Panel Log]:
[1Panel Log]: 官方网站: https://1panel.cn
[1Panel Log]: 项目文档: https://1panel.cn/docs
[1Panel Log]: 代码仓库: https://github.com/1Panel-dev/1Panel
[1Panel Log]: 前往 1Panel 官方论坛获取帮助: https://bbs.fit2cloud.com/c/1p/7
[1Panel Log]:
[1Panel Log]: 如果您使用的是云服务器，请在安全组中打开端口 14000
[1Panel Log]:
[1Panel Log]: 为了您的服务器安全，离开此屏幕后您将无法再次看到您的密码，请记住您的密码。
[1Panel Log]:
[1Panel Log]: ================================================================

```

1panel 所有安装docker容器的网络都是  `1panel-network`

## 1panel安装MySql

通过Web界面安装，只开通了外部端口访问，其他都是项默认配置，默认的安装目录为 `/opt/1panel/apps/mysql`

### 配置环境变量

说明： 通过1panel安装mysql，安装完后，需要额外的配置环境变量如下：

##### **方法一：通过环境变量传递启动参数（推荐）**

在 1Panel中添加环境变量：

```
MYSQL_ARGS=--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --lower-case-table-names=1
```

或者如果 1Panel 支持直接配置容器启动命令参数，可以在容器启动参数中添加。

##### **方法二：修改 MySQL 配置文件**

1. **找到 MySQL 配置文件位置**（通常是 `/etc/mysql/my.cnf` 或 `/etc/my.cnf`）
    
2. **创建或编辑配置文件**，在 `[mysqld]` 部分添加：
    
```ini
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
lower-case-table-names=1
```

3. **在 1Panel 中挂载配置文件**：
    - 在宿主机创建配置文件，如 `/opt/1panel/apps/mysql/my.cnf`
    - 在 1Panel 容器设置中添加卷映射：
        - 宿主机路径：`/opt/1panel/apps/mysql/my.cnf`
        - 容器路径：`/etc/mysql/conf.d/my.cnf`

##### **方法三：通过 1PANEL 界面**

如果 1Panel 提供了 MySQL 配置管理界面：

1. 进入 MySQL 容器管理页面
2. 找到"配置文件"或"参数设置"
3. 直接在界面中添加这些参数

##### 重要提示

⚠️ **`lower-case-table-names=1` 必须在初始化数据库之前设置**，否则可能导致数据不一致。如果数据库已经创建，建议：

1. 备份数据
2. 删除数据目录
3. 添加配置
4. 重新初始化并恢复数据

设置完成后，**重启 MySQL 容器** ，直接通过1panel重启即可使配置生效。

你可以通过以下 SQL 命令验证设置是否生效：

```sql
-- 登录 MySQL 后执行 

-- 查看编码
SHOW VARIABLES LIKE 'character_set_server';
SHOW VARIABLES LIKE 'collation_server';
-- 忽略表名大小写
SHOW VARIABLES LIKE 'lower_case_table_names';
-- 显示默认监听行为
-- 默认值: `*`（等同于 `0.0.0.0`），默认监听所有网络接口，允许远程连接
SHOW VARIABLES LIKE 'bind_address';
```

#### 配置binlog参数

```
[mysqld]
host-cache-size=0
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

binlog_expire_logs_seconds=259200

pid-file=/var/run/mysqld/mysqld.pid
lower_case_table_names=1
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

```

> 增加 binlog_expire_logs_seconds=259200， binlog备份3天过期，默认是binlog_expire_logs_seconds=259200000， 30天

---

配置完后重启，直接通过1panel重启即可

#### **mysql 配置文件 `my.cnf`** 

* [示例文件](https://devops.dzspace.top/assets/_resources/mysql/my.cnf)
* [官方默认文件](https://devops.dzspace.top/assets/_resources/mysql/default/my.cnf)

#### **参考文档**

* [通用的mysql配置-需要gitee登录权限](https://gitee.com/ecs-common-deploy/ecs-deploy-document/blob/master/docs/common.md#mysql-%E5%B8%B8%E7%94%A8%E9%85%8D%E7%BD%AE%E5%92%8C%E5%91%BD%E4%BB%A4)
* [Docker 备份MySQL数据库完整指南](https://github.com/tuonioooo/docker/blob/master/advanced/docker-mysql-backup.md)
* [MySQL 数据库备份与恢复指南](https://gitee.com/ecs-common-deploy/ecs-deploy-document/blob/master/docs/database-backup.md)

## 1panel安装OpenResty

通过Web界面安装，默认的安装目录为 `/opt/1panel/apps/openresty`

网站目录(默认网站目录会放置在 1Panel 安装目录下，如需修改请以绝对路径填写)	默认-`/opt/1panel/www`

网站目录如果是通过CI/CD上传文件时，需要额外的设置CI/CD用户的权限
注意在设置网站目录时，如果使用giea runner传输文件时，要授权`ssh`用户

```bash
sudo chown -R dz:dz /opt/1panel/web
sudo chmod -R 755 /opt/1panel/web
```

## 1panel安装Redis、Gitea(直接按Web界面操作即可)

## 1panel安装 Act Runner

### **安装的注意事项**

通过1panel 安装Act Runner ，安装过程中添加对应的参数要点：

1. `GITEA_INSTANCE_URL`- 尽量要用gitea实例的容器名称，避免内外IP切换的麻烦
2. `GITEA_RUNNER_REGISTRATION_TOKEN` - 需要先在gitea实例中创建一个组件或者仓库获取令牌
3. `CONFIG_FILE` 暂时不放开，等安装完后，通过终端来生成默认配置文件，参考[Act Runner 配置文件和自定义标签](../持续集成与计划任务/Gitea%20Act%20Runner%20配置文件和自定义标签.md)，配置参数如下：

```yaml
container:
    network: "1panel-network"
    privileged: false 
    options: "-v /opt/actions:/opt/actions:ro"
    valid_volumes: 
            - /opt/actions
    force_pull: false
```

> `/opt/actions` 是本地下载的actions，主要是由于 actions是用github actions，网络访问会慢，额外又配置了国内镜像源: https://gitee.com/mirror-org
 

配置参数后进行挂载并重启 ，当前是1panel安装的，编排脚本如下：

```yaml
networks:
    1panel-network:
        external: true
services:
    act_runner:
        container_name: ${CONTAINER_NAME}
        deploy:
            resources:
                limits:
                    cpus: ${CPUS}
                    memory: ${MEMORY_LIMIT}
        environment:
            - CONFIG_FILE=/config.yaml
            - GITEA_INSTANCE_URL=${GITEA_INSTANCE_URL}
            - GITEA_RUNNER_REGISTRATION_TOKEN=${RUNNER_REGISTRATION_TOKEN}
            - GITEA_RUNNER_NAME=${RUNNER_NAME}
            - GITEA_RUNNER_LABELS=${RUNNER_LABELS}
        image: gitea/act_runner:0.2.13
        labels:
            createdBy: Apps
        networks:
            - 1panel-network
        restart: always
        volumes:
            - ./config.yaml:/config.yaml
            - ./data:/data
            - /var/run/docker.sock:/var/run/docker.sock

```
 
4. `GITEA_RUNNER_LABELS` 填写 `ubuntu-latest` 来过渡，等安装后，根据业务需求来扩展`runner`不同的标签 参考如下文档
- [Act Runner 配置文件和自定义标签](../持续集成与计划任务/Gitea%20Act%20Runner%20配置文件和自定义标签.md)
- [Gitea完整教程](../持续集成与计划任务/Gitea%20教程.md)
- [Gitea Runner 镜像对应关系](../持续集成与计划任务/Gitea%20Act%20Runner%20镜像对应关系.md)
	 
> ⚠️ 注意：如果用的是1panel创建的runner，在gitea实例中删除runner后，需要重新安装容器，否则注册不上

#### runner 工作流action方案

采用了国内镜像+本地action 的版本，避免构建代码时卡顿

国内镜像如下：https://gitee.com/mirror-org

详见教程：
[GitHub(Gitea) 中 Actions 的缓存机制](../持续集成与计划任务/GitHub(Gitea)%20中%20Actions%20的缓存机制.md)

#### 工作流示例

[Gitea工作流示例](https://gitee.com/fast-template-org/gitea-starter)