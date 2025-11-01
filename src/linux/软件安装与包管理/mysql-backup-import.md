---
title: MySQL 数据库备份与导入指南
category:
  - Linux
  - 软件安装与包管理
tag:
  - MySQL
  - 数据库备份和导入
date: 2022-09-21
---

# MySQL 数据库备份与导入指南

> 📅 最后更新：2025-11-01  
> 📝 涵盖 Linux、Windows 和 Docker 环境的完整操作指南

---

## 📋 目录

- [传统环境操作](#传统环境操作)
  - [Linux 环境](#linux-环境)
  - [Windows 环境](#windows-环境)
  - [MySQL 配置查询](#mysql-配置查询)
- [Docker 环境操作](#docker-环境操作)
  - [快速开始](#快速开始)
  - [五种导入方法](#五种导入方法)
  - [实战示例](#实战示例)
  - [性能优化](#性能优化)
  - [问题排查](#问题排查)

---

## 传统环境操作

### Linux 环境

#### 备份数据库

```bash
# 基本备份命令
mysqldump database_name > backup.sql

# 指定 -S /data/mysql/mysql.sock 指定链接文件
# 软链如果没有指定，使用默认的，可以去掉 `-S /data/mysql/mysql.sock`
mysqldump database_name -S /data/mysql/mysql.sock > backup.sql

# 后台执行备份（推荐用于大型数据库）
nohup mysqldump novel_mp -S /data/mysql/mysql.sock > /data/novel_mp_20200901.sql &
nohup mysqldump novel_oauth -S /data/mysql/mysql.sock > /data/novel_oauth_20200901.sql &
```

#### 导入数据库

```bash
# 基本导入命令
mysql -uroot -p database_name < backup.sql

# 指定 socket 文件导入
mysql -S /data/mysql/mysql.sock -uroot -p novel_mp < novel_mp_20200901.sql
mysql -S /data/mysql/mysql.sock -uroot -p miliqk_mp < miliqk_mp_20220709.sql
```

### Windows 环境

#### 备份数据库

```bash
# 备份单个数据库
mysqldump -uroot -proot novel_mp > novel_mp_20210228.sql
mysqldump -uroot -proot novel_oauth > novel_oauth_20210228.sql
```

#### 导入数据库

```bash
# 导入到指定数据库
mysql -uroot -proot novel_mp_test < novel_mp_20210226.sql
mysql -uroot -proot novel_oauth_test < novel_oauth_20210226.sql
```

### MySQL 配置查询

```sql
-- ========== 连接状态 ==========
-- 查看当前连接状态
SHOW STATUS LIKE '%connect%';

-- 查看最大连接数配置
SHOW VARIABLES LIKE '%connect%';

-- 查看当前所有连接
SHOW PROCESSLIST;

-- ========== 字符编码 ==========
-- 查看服务器字符集
SHOW VARIABLES LIKE 'character_set_server';

-- 查看排序规则
SHOW VARIABLES LIKE 'collation_server';

-- ========== 其他配置 ==========
-- 查看表名大小写设置（0=区分，1=不区分）
SHOW VARIABLES LIKE 'lower_case_table_names';

-- 查看监听地址（* 或 0.0.0.0 表示监听所有接口）
SHOW VARIABLES LIKE 'bind_address';

-- 查看 binlog 状态
SHOW VARIABLES LIKE 'log_bin';

-- ========== 权限管理 ==========
-- 查看用户权限
SHOW GRANTS FOR 'root'@'%';
SHOW GRANTS FOR 'appuser'@'%';
```

---

## Docker 环境操作

### 快速开始

```bash
# 💡 最常用的导入命令（推荐），mysql-container: 容器名称
docker exec -i mysql-container mysql -uroot -pPassword mydb < mysql.sql

# 查看导入结果
docker exec -it mysql-container mysql -uroot -pPassword -e "SHOW DATABASES;"
docker exec -it mysql-container mysql -uroot -pPassword mydb -e "SHOW TABLES;"


# nohup 导入方式
nohup docker exec -i mysql /bin/bash -c 'mysqldump test 1>> /mnt/data/test.sql 2>> test.log' & 
nohup docker exec -i mysql /bin/bash -c 'mysqldump test > /mnt/data/test.sql ' & 
nohup docker exec -i mysql /bin/bash -c 'mysql test < /mnt/data/test.sql' & 
```
> 说明： 
> 这里的 `mysqldump` 备份命令 和 `mysql` 导入命令没有使用用户名和密码 ，是因为已经在 [my.cnf](https://devops.dzspace.top/assets/_resources/mysql/my.cnf) 配置过忽略用户名和密码

```

---

### 五种导入方法

#### 方法一：管道导入 ⭐ 推荐

**适用场景**：日常使用，SQL 文件在宿主机

```bash
# 基本语法
docker exec -i 容器名 mysql -u用户名 -p密码 数据库名 < mysql.sql

# 导入到指定数据库
docker exec -i mysql-container mysql -uroot -pYourPassword mydb < mysql.sql

# 无密码导入
docker exec -i mysql-container mysql -uroot mydb < mysql.sql

# 导入包含 CREATE DATABASE 的 SQL
docker exec -i mysql-container mysql -uroot -pYourPassword < mysql.sql
```

**优点**：简单快速，一条命令完成  
**缺点**：不适合超大文件（>1GB）

---

#### 方法二：docker cp + 容器内执行

**适用场景**：大文件导入，需要保留 SQL 文件在容器内

```bash
# 步骤 1：复制文件到容器
docker cp /path/to/mysql.sql mysql-container:/tmp/

# 步骤 2：执行导入
docker exec mysql-container mysql -uroot -pYourPassword mydb < /tmp/mysql.sql

# 或使用 source 命令
docker exec -it mysql-container mysql -uroot -pYourPassword mydb -e "source /tmp/mysql.sql"

# 步骤 3：清理临时文件（可选）
docker exec mysql-container rm /tmp/mysql.sql
```

**优点**：适合大文件，可重复执行  
**缺点**：需要多个步骤

---

#### 方法三：交互式导入

**适用场景**：需要手动操作，调试导入过程

```bash
# 步骤 1：复制文件到容器
docker cp mysql.sql mysql-container:/tmp/mysql.sql

# 步骤 2：进入容器
docker exec -it mysql-container bash

# 步骤 3：在容器内导入
mysql -uroot -pYourPassword mydb < /tmp/mysql.sql

# 步骤 4：退出容器
exit
```

**优点**：可以手动调试  
**缺点**：操作繁琐

---

#### 方法四：卷挂载

**适用场景**：频繁导入操作，多个 SQL 文件

```bash
# 启动容器时挂载目录
docker run -d \
  --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=YourPassword \
  -v /host/path/sql:/sql \
  -p 3306:3306 \
  mysql:8.0

# 导入 SQL 文件
docker exec -i mysql-container mysql -uroot -pYourPassword mydb < /sql/mysql.sql

# 导入多个文件
docker exec mysql-container bash -c \
  'for f in /sql/*.sql; do mysql -uroot -pYourPassword mydb < "$f"; done'
```

**优点**：方便管理多个 SQL 文件  
**缺点**：需要规划目录结构

---

#### 方法五：Docker Compose 自动导入

**适用场景**：容器初始化，自动化部署

**docker-compose.yml**

```yaml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: mysql-container
    environment:
      MYSQL_ROOT_PASSWORD: YourPassword
      MYSQL_DATABASE: mydb
    volumes:
      - mysql-data:/var/lib/mysql
      - ./sql:/docker-entrypoint-initdb.d  # 自动导入
    ports:
      - "3306:3306"
    restart: unless-stopped

volumes:
  mysql-data:
```

**使用方法**

```bash
# 1. 准备 SQL 文件
mkdir -p sql
cp mysql.sql sql/

# 2. 启动容器（自动导入）
docker-compose up -d

# 3. 查看日志
docker-compose logs -f mysql
```

> ⚠️ **注意**：`/docker-entrypoint-initdb.d` 只在首次创建数据库时自动执行

**优点**：自动化，适合 CI/CD  
**缺点**：仅首次运行有效

---

#### 方法六：端口映射从宿主机导入

**适用场景**：已有 MySQL 客户端工具

```bash
# 确保容器暴露端口
docker ps | grep mysql
# 输出示例：0.0.0.0:3306->3306/tcp

# 从宿主机直接连接导入（需安装 mysql 客户端）
mysql -h 127.0.0.1 -P 3306 -uroot -pYourPassword mydb < mysql.sql

# 或使用 IP 地址
mysql -h 172.17.0.2 -P 3306 -uroot -pYourPassword mydb < mysql.sql
```

**优点**：可以使用熟悉的工具  
**缺点**：需要安装 MySQL 客户端

---

### 实战示例

#### 示例 1：导入单个数据库

```bash
# 场景：导入备份文件到生产数据库
# 文件：/home/user/backup/mysql.sql
# 容器：mysql-container
# 数据库：myapp

# 方案 A：直接导入（小文件 <100MB）
docker exec -i mysql-container mysql -uroot -pMySecretPass123 myapp < /home/user/backup/mysql.sql

# 方案 B：复制后导入（大文件 >100MB）
docker cp /home/user/backup/mysql.sql mysql-container:/tmp/
docker exec mysql-container mysql -uroot -pMySecretPass123 myapp -e "source /tmp/mysql.sql"
docker exec mysql-container rm /tmp/mysql.sql
```

---

#### 示例 2：导入包含多个数据库的 SQL

```bash
# SQL 文件包含 CREATE DATABASE 语句
docker exec -i mysql-container mysql -uroot -pYourPassword < mysql.sql

# 验证导入的数据库
docker exec -it mysql-container mysql -uroot -pYourPassword -e "SHOW DATABASES;"
```

---

#### 示例 3：导入压缩文件

```bash
# .gz 压缩文件
gunzip < mysql.sql.gz | docker exec -i mysql-container mysql -uroot -pPassword mydb

# .xz 压缩文件
xz -dc mysql.sql.xz | docker exec -i mysql-container mysql -uroot -pPassword mydb

# .bz2 压缩文件
bzcat mysql.sql.bz2 | docker exec -i mysql-container mysql -uroot -pPassword mydb

# .zip 压缩文件
unzip -p mysql.sql.zip | docker exec -i mysql-container mysql -uroot -pPassword mydb
```

---

#### 示例 4：批量导入多个文件

```bash
# 方法 1：Shell 循环导入
for sql_file in *.sql; do
    echo "📥 Importing $sql_file..."
    docker exec -i mysql-container mysql -uroot -pPassword mydb < "$sql_file"
done

# 方法 2：合并后一次性导入
cat *.sql | docker exec -i mysql-container mysql -uroot -pPassword mydb

# 方法 3：复制到容器后批量导入
docker cp ./sql-files mysql-container:/tmp/
docker exec mysql-container bash -c \
  'for f in /tmp/sql-files/*.sql; do mysql -uroot -pPassword mydb < "$f"; done'
```

---

#### 示例 5：定时备份脚本

```bash
#!/bin/bash
# 文件：mysql-backup.sh

# 配置
CONTAINER="mysql-container"
PASSWORD="YourPassword"
BACKUP_DIR="/backup/mysql"
DATE=$(date +%Y%m%d_%H%M%S)

# 创建备份目录
mkdir -p "$BACKUP_DIR"

# 备份所有数据库
docker exec $CONTAINER mysqldump -uroot -p$PASSWORD --all-databases > \
  "$BACKUP_DIR/all_databases_$DATE.sql"

# 压缩备份
gzip "$BACKUP_DIR/all_databases_$DATE.sql"

# 删除 7 天前的备份
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +7 -delete

echo "✅ 备份完成：all_databases_$DATE.sql.gz"
```

**设置定时任务**

```bash
# 编辑 crontab
crontab -e

# 每天凌晨 2 点执行备份
0 2 * * * /path/to/mysql-backup.sh >> /var/log/mysql-backup.log 2>&1
```

---

### 性能优化

#### 导入前优化设置

```bash
# 创建优化的 SQL 文件
cat > optimized.sql << 'EOF'
-- 禁用检查以提高导入速度
SET autocommit=0;
SET unique_checks=0;
SET foreign_key_checks=0;
SET sql_log_bin=0;

-- 原始 SQL 内容
SOURCE /tmp/mysql.sql;

-- 恢复设置
SET unique_checks=1;
SET foreign_key_checks=1;
SET autocommit=1;
COMMIT;
EOF

# 导入优化后的 SQL
docker cp optimized.sql mysql-container:/tmp/
docker exec mysql-container mysql -uroot -pPassword mydb < /tmp/optimized.sql
```

---

#### 调整 MySQL 配置

```bash
# 临时增加内存限制
docker exec mysql-container mysql -uroot -pPassword -e \
  "SET GLOBAL max_allowed_packet=512*1024*1024;"

# 永久修改配置（需重启）
docker exec mysql-container bash -c \
  'echo "max_allowed_packet=512M" >> /etc/mysql/my.cnf'
docker restart mysql-container
```

---

#### 分批导入大文件

```bash
# 分割大文件（每 10000 行一个文件）
split -l 10000 mysql.sql mysql_part_

# 批量导入
for part in mysql_part_*; do
    echo "导入 $part..."
    docker exec -i mysql-container mysql -uroot -pPassword mydb < "$part"
done

# 清理临时文件
rm -f mysql_part_*
```

---

### 验证与监控

#### 查看导入进度

```bash
# 实时查看容器日志
docker logs -f mysql-container

# 查看 MySQL 慢查询日志
docker exec -it mysql-container tail -f /var/log/mysql/slow.log

# 查看错误日志
docker exec -it mysql-container tail -f /var/log/mysql/error.log
```

---

#### 验证导入结果

```bash
# 查看所有数据库
docker exec -it mysql-container mysql -uroot -pPassword -e "SHOW DATABASES;"

# 查看指定数据库的表
docker exec -it mysql-container mysql -uroot -pPassword mydb -e "SHOW TABLES;"

# 统计表记录数
docker exec -it mysql-container mysql -uroot -pPassword mydb -e \
  "SELECT TABLE_NAME, TABLE_ROWS FROM information_schema.TABLES WHERE TABLE_SCHEMA='mydb';"

# 查看表结构
docker exec -it mysql-container mysql -uroot -pPassword mydb -e "DESCRIBE users;"

# 验证数据完整性
docker exec -it mysql-container mysql -uroot -pPassword mydb -e \
  "SELECT COUNT(*) as total FROM users;"
```

---

#### 性能监控

```bash
# 查看导入耗时
time docker exec -i mysql-container mysql -uroot -pPassword mydb < mysql.sql

# 查看数据库大小
docker exec mysql-container mysql -uroot -pPassword -e \
  "SELECT table_schema AS 'Database', 
   ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' 
   FROM information_schema.TABLES 
   GROUP BY table_schema;"

# 查看表空间使用情况
docker exec mysql-container mysql -uroot -pPassword mydb -e \
  "SELECT TABLE_NAME, 
   ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS 'Size (MB)'
   FROM information_schema.TABLES 
   WHERE TABLE_SCHEMA = 'mydb' 
   ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;"
```

---

### 问题排查

#### ❌ 问题 1：ERROR 2002 - Can't connect to MySQL server

**原因**：容器未启动或 MySQL 服务未就绪

```bash
# 检查容器状态
docker ps -a | grep mysql

# 启动容器
docker start mysql-container

# 检查 MySQL 是否就绪
docker exec mysql-container mysqladmin -uroot -pPassword ping

# 查看详细日志
docker logs --tail 100 mysql-container

# 等待 MySQL 完全启动
until docker exec mysql-container mysqladmin -uroot -pPassword ping &>/dev/null; do
    echo "等待 MySQL 启动..."
    sleep 2
done
echo "✅ MySQL 已就绪"
```

---

#### ❌ 问题 2：ERROR 1045 - Access denied

**原因**：密码错误或用户权限不足

```bash
# 测试密码是否正确
docker exec -it mysql-container mysql -uroot -pYourPassword

# 重置 root 密码
docker exec mysql-container mysql -uroot -e \
  "ALTER USER 'root'@'localhost' IDENTIFIED BY 'NewPassword';"

# 授予远程访问权限
docker exec mysql-container mysql -uroot -pPassword -e \
  "CREATE USER 'root'@'%' IDENTIFIED BY 'Password';
   GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
   FLUSH PRIVILEGES;"
```

---

#### ❌ 问题 3：ERROR 1049 - Unknown database

**原因**：目标数据库不存在

```bash
# 创建数据库
docker exec mysql-container mysql -uroot -pPassword -e \
  "CREATE DATABASE IF NOT EXISTS mydb 
   CHARACTER SET utf8mb4 
   COLLATE utf8mb4_unicode_ci;"

# 然后导入数据
docker exec -i mysql-container mysql -uroot -pPassword mydb < mysql.sql
```

---

#### ❌ 问题 4：ERROR 2006 - MySQL server has gone away

**原因**：数据包过大或超时

```bash
# 增加最大数据包大小
docker exec mysql-container mysql -uroot -pPassword -e \
  "SET GLOBAL max_allowed_packet=1073741824;"  # 1GB

# 或修改配置文件
docker exec mysql-container bash -c \
  'cat >> /etc/mysql/my.cnf << EOF
[mysqld]
max_allowed_packet=512M
wait_timeout=3600
interactive_timeout=3600
EOF'

# 重启容器使配置生效
docker restart mysql-container
```

---

#### ❌ 问题 5：字符编码错误

**原因**：字符集不匹配

```bash
# 指定字符集导入
docker exec -i mysql-container mysql -uroot -pPassword \
  --default-character-set=utf8mb4 mydb < mysql.sql

# 在 SQL 文件开头添加字符集设置
cat > import.sql << 'EOF'
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
EOF
cat mysql.sql >> import.sql

docker exec -i mysql-container mysql -uroot -pPassword mydb < import.sql
```

---

#### ❌ 问题 6：容器内存不足

**原因**：导入大文件时内存耗尽

```bash
# 重启容器并增加内存限制
docker stop mysql-container
docker rm mysql-container

docker run -d \
  --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=Password \
  -m 4g \
  --memory-swap 4g \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:8.0

# 查看容器内存使用
docker stats mysql-container
```

---

## 🚀 完整自动化脚本

```bash
#!/bin/bash
# 文件：mysql-import.sh
# 用途：自动化 MySQL 导入流程

set -e  # 遇到错误立即退出

# ========== 配置区域 ==========
CONTAINER_NAME="${CONTAINER_NAME:-mysql-container}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-YourPassword}"
DATABASE_NAME="${DATABASE_NAME:-mydb}"
SQL_FILE="${1:-mysql.sql}"

# ========== 颜色输出 ==========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ========== 检查环境 ==========
log_info "检查环境..."

# 检查 Docker 是否运行
if ! docker ps &> /dev/null; then
    log_error "Docker 未运行或无权限访问"
    exit 1
fi

# 检查容器是否存在并运行
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    log_error "容器 $CONTAINER_NAME 未运行"
    log_info "尝试启动容器..."
    docker start "$CONTAINER_NAME" || exit 1
    sleep 5
fi

# 检查 SQL 文件
if [ ! -f "$SQL_FILE" ]; then
    log_error "SQL 文件不存在: $SQL_FILE"
    exit 1
fi

FILE_SIZE=$(du -h "$SQL_FILE" | cut -f1)
log_info "SQL 文件大小: $FILE_SIZE"

# ========== 等待 MySQL 就绪 ==========
log_info "等待 MySQL 服务就绪..."
MAX_TRIES=30
COUNT=0

until docker exec "$CONTAINER_NAME" mysqladmin \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" ping &>/dev/null; do
    
    COUNT=$((COUNT + 1))
    if [ $COUNT -ge $MAX_TRIES ]; then
        log_error "MySQL 启动超时"
        exit 1
    fi
    
    echo -n "."
    sleep 2
done
echo ""
log_info "✅ MySQL 已就绪"

# ========== 创建数据库 ==========
log_info "创建数据库 $DATABASE_NAME（如果不存在）..."
docker exec "$CONTAINER_NAME" mysql \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e \
    "CREATE DATABASE IF NOT EXISTS \`$DATABASE_NAME\` 
     CHARACTER SET utf8mb4 
     COLLATE utf8mb4_unicode_ci;"

# ========== 导入数据 ==========
log_info "🚀 开始导入数据..."
START_TIME=$(date +%s)

docker exec -i "$CONTAINER_NAME" mysql \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    --default-character-set=utf8mb4 \
    "$DATABASE_NAME" < "$SQL_FILE"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
log_info "✅ 导入完成，耗时: ${DURATION}秒"

# ========== 验证导入 ==========
log_info "验证导入结果..."

# 显示表列表
log_info "数据库中的表:"
docker exec "$CONTAINER_NAME" mysql \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    "$DATABASE_NAME" -e "SHOW TABLES;"

# 统计表记录数
log_info "表记录统计:"
docker exec "$CONTAINER_NAME" mysql \
    -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
    "$DATABASE_NAME" -e \
    "SELECT TABLE_NAME, TABLE_ROWS 
     FROM information_schema.TABLES 
     WHERE TABLE_SCHEMA='$DATABASE_NAME';"

log_info "🎉 所有操作完成！"
```

**使用方法**

```bash
# 赋予执行权限
chmod +x mysql-import.sh

# 使用默认配置
./mysql-import.sh mysql.sql

# 使用自定义配置
CONTAINER_NAME=my-mysql \
MYSQL_PASSWORD=MyPassword \
DATABASE_NAME=myapp \
./mysql-import.sh backup.sql
```

---

## 📝 最佳实践

### ✅ 导入前

1. **备份现有数据**：即使是导入到新数据库，也要确保有备份
2. **检查磁盘空间**：确保容器有足够空间（建议至少 2 倍 SQL 文件大小）
3. **测试导入**：先在测试环境验证 SQL 文件的正确性
4. **字符集检查**：确保 SQL 文件和数据库字符集一致

### ✅ 导入时

1. **大文件优化**：使用 `docker cp` 方法，禁用索引和外键检查
2. **压缩传输**：网络传输时使用压缩格式
3. **监控日志**：实时查看日志，及时发现问题
4. **避免高峰期**：生产环境导入选择业务低峰期

### ✅ 导入后

1. **验证完整性**：检查表数量、记录数是否正确
2. **重建索引**：大批量导入后重建索引提高性能
3. **分析表**：运行 `ANALYZE TABLE` 更新统计信息
4. **清理临时文件**：删除容器内的临时 SQL 文件

---

## 🔗 快速参考

| 场景 | 推荐方法 | 命令 |
|------|----------|------|
| 小文件 (<100MB) | 管道导入 | `docker exec -i mysql-container mysql -uroot -pPwd db < file.sql` |
| 大文件 (>100MB) | docker cp | `docker cp file.sql c:/tmp/ && docker exec c mysql -uroot -pPwd db < /tmp/file.sql` |
| 压缩文件 | 管道解压 | `gunzip < file.sql.gz \| docker exec -i c mysql -uroot -pPwd db` |
| 多个文件 | Shell 循环 | `for f in *.sql; do docker exec -i c mysql -uroot -pPwd db < "$f"; done` |
| 自动化部署 | Docker Compose | 挂载到 `/docker-entrypoint-initdb.d` |
| 频繁操作 | 卷挂载 | `-v /host/sql:/sql` 然后导入 |

---

## 📚 相关资源

- [MySQL 官方文档](https://dev.mysql.com/doc/)
- [Docker MySQL 镜像文档](https://hub.docker.com/_/mysql)
- [mysqldump 参数详解](https://dev.mysql.com/doc/refman/8.0/en/mysqldump.html)

---

**文档版本**：v2.0  
**维护者**：Your Name  
**许可证**：MIT