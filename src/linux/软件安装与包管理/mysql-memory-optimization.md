---
title: MySQL 内存优化篇
category:
  - Linux
  - 软件安装与包管理
tag:
  - MySQL
  - 内存优化篇
date: 2025-11-16

---

# MySQL 内存优化完整指南

## 📋 目录

- [前言](#前言)
- [内存占用诊断](#内存占用诊断)
- [核心内存参数解析](#核心内存参数解析)
- [优化方案](#优化方案)
- [配置示例](#配置示例)
- [验证与监控](#验证与监控)
- [常见问题](#常见问题)

---

## 前言

MySQL 默认配置往往会占用较多内存（1-2GB），对于小型服务器或容器环境可能造成资源紧张。本文档提供完整的内存优化方案，帮助你在保证性能的前提下合理控制内存使用。

### 典型场景
- Docker MySQL 容器占用 1.5-2GB 内存
- 服务器内存不足，需要优化
- 个人项目或小型应用，不需要默认的高并发配置

---

## 内存占用诊断

### 1. 查看容器内存使用

```bash
# 实时查看容器资源占用
docker stats <容器名>

# 查看容器内存限制
docker inspect <容器名> | grep -i memory
```

### 2. 查看 MySQL 内存配置

进入 MySQL 容器：

```bash
docker exec -it <容器名> mysql -u root -p
```

执行以下 SQL 查询：

```sql
-- 查看关键内存参数（带 MB 格式化）
SELECT 
    Variable_name AS 参数名,
    CASE 
        WHEN Variable_name = 'max_connections' 
        THEN CONCAT(Variable_value, ' 个连接')
        ELSE CONCAT(ROUND(Variable_value / 1024 / 1024, 2), ' MB')
    END AS 配置值
FROM performance_schema.global_variables
WHERE Variable_name IN (
    'innodb_buffer_pool_size',
    'innodb_log_buffer_size',
    'key_buffer_size',
    'tmp_table_size',
    'max_heap_table_size',
    'sort_buffer_size',
    'read_buffer_size',
    'max_connections'
)
ORDER BY Variable_name;
```

### 3. 查看实际内存使用详情

```sql
-- 查看内存使用 TOP 20
SELECT 
    EVENT_NAME, 
    ROUND(CURRENT_NUMBER_OF_BYTES_USED/1024/1024, 2) AS MB使用量
FROM performance_schema.memory_summary_global_by_event_name 
WHERE CURRENT_NUMBER_OF_BYTES_USED > 0 
ORDER BY CURRENT_NUMBER_OF_BYTES_USED DESC 
LIMIT 20;
```

---

## 核心内存参数解析

### 主要内存占用来源

| 参数 | 默认值 | 说明 | 优化建议 |
|------|--------|------|----------|
| **innodb_buffer_pool_size** | 128 MB | InnoDB 最重要的缓存，存储表数据和索引 | 小型应用保持 128MB；中型应用 512MB-1GB |
| **max_connections** | 151 | 最大连接数，每个连接占 4-10 MB | **主要优化点**！小型应用建议 20-50 |
| **innodb_log_buffer_size** | 16 MB | 事务日志缓冲区 | 读多写少保持 16MB；高并发写入 32-64MB |
| **key_buffer_size** | 8 MB | MyISAM 索引缓存 | InnoDB 引擎可忽略 |
| **tmp_table_size** | 16 MB | 内存临时表大小 | 默认即可，复杂查询可适当增加 |
| **max_heap_table_size** | 16 MB | MEMORY 表最大值 | 与 tmp_table_size 保持一致 |
| **sort_buffer_size** | 256 KB | 排序缓冲区（每连接） | 默认即可，不建议调大 |
| **read_buffer_size** | 128 KB | 顺序读缓冲区（每连接） | 默认即可 |

### 内存计算公式

```
总内存 ≈ 全局缓冲区 + (每连接缓冲区 × 最大连接数)

全局缓冲区 = innodb_buffer_pool_size + innodb_log_buffer_size + key_buffer_size + ...

每连接缓冲区 = sort_buffer_size + read_buffer_size + join_buffer_size + thread_stack + ...
              ≈ 4-10 MB（视查询复杂度）
```

### 示例计算

**默认配置（占用约 1.5-1.7 GB）：**
```
= 128MB (buffer_pool) + 64MB (log_buffer) + 8MB (key_buffer)
  + (151 连接 × 5MB) + 其他缓存
= 200MB + 755MB + 300MB
≈ 1.25-1.7 GB
```

**优化后配置（占用约 600-800 MB）：**
```
= 128MB (buffer_pool) + 16MB (log_buffer) + 8MB (key_buffer)
  + (50 连接 × 5MB) + 其他缓存
= 152MB + 250MB + 200MB
≈ 600-800 MB
```

---

## 优化方案

### 方案一：调整连接数（最有效）

#### 1. 查看实际连接使用情况

```sql
-- 当前活跃连接数
SHOW STATUS LIKE 'Threads_connected';

-- 服务器启动以来的最大连接数（重要！）
SHOW STATUS LIKE 'Max_used_connections';

-- 查看所有连接
SHOW PROCESSLIST;
```

#### 2. 确定合理的连接数

**设置公式：**
```
max_connections = Max_used_connections × 1.5 到 2 倍
```

**参考值：**
- 个人项目/小型应用：20-50
- 中小型网站：50-100
- 中型业务系统：100-200
- 大型/高并发系统：200-500+

**示例：**
- 如果 `Max_used_connections` = 15，设置 `max_connections = 30-40`
- 如果 `Max_used_connections` = 80，设置 `max_connections = 120-150`

### 方案二：优化日志缓冲区

#### 判断是否需要调整

```sql
-- 查看日志写入次数
SHOW GLOBAL STATUS LIKE 'Innodb_log_writes';

-- 查看日志等待次数（重要指标）
SHOW GLOBAL STATUS LIKE 'Innodb_log_waits';
```

**判断标准：**
- `Innodb_log_waits` = 0 或很小 → 16MB 够用
- `Innodb_log_waits` 持续增长 → 需要调大到 32-64MB

#### 配置建议

| 应用类型 | 推荐值 | 说明 |
|---------|--------|------|
| 读多写少（博客、CMS） | 16 MB | 默认值，节省内存 |
| 均衡读写 | 32 MB | 中间值 |
| 写入密集（订单、日志） | 64 MB | 减少磁盘 I/O |

### 方案三：限制容器内存

如果不想修改 MySQL 配置，可以直接限制容器可用内存：

```bash
# 更新现有容器
docker update --memory="1g" --memory-swap="1g" <容器名>

# 或在启动时指定
docker run -d \
  --name mysql \
  --memory="1g" \
  --memory-swap="1g" \
  mysql:8.0
```

**注意：** 内存限制过小可能导致 MySQL 性能下降或 OOM 被杀。

---

## 配置示例

### Docker Compose 配置（推荐）

#### 完整的 docker-compose.yml

```yaml
version: '3'

networks:
  1panel-network:
    external: true

services:
  mysql:
    image: mysql:8.4.7
    container_name: ${CONTAINER_NAME}
    
    # 资源限制
    deploy:
      resources:
        limits:
          cpus: ${CPUS}
          memory: ${MEMORY_LIMIT}
    
    # 环境变量
    environment:
      MYSQL_ROOT_PASSWORD: ${PANEL_DB_ROOT_PASSWORD}
    
    # 网络配置
    networks:
      - 1panel-network
    
    # 端口映射
    ports:
      - ${HOST_IP}:${PANEL_APP_PORT_HTTP}:3306
    
    # 重启策略
    restart: always
    
    # 数据卷挂载
    volumes:
      - ./data/:/var/lib/mysql
      - ./conf/my.cnf:/etc/my.cnf
      - ./log:/var/log/mysql
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    
    labels:
      createdBy: Apps
```

#### 配置文件 my.cnf（推荐方式）

创建 `./conf/my.cnf` 文件：

```ini
[mysqld]
# ==================== 字符集配置 ====================
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

# ==================== 表名大小写 ====================
# 0: 大小写敏感（Linux默认）
# 1: 表名存储为小写，比较不区分大小写（推荐）
lower-case-table-names=1

# ==================== 内存优化配置 ====================
# 最大连接数（默认151，小型应用建议20-50）
max_connections=50

# InnoDB 缓冲池大小（默认128M，建议保持或根据数据量调整）
innodb_buffer_pool_size=128M

# 事务日志缓冲区（默认16M，写入密集可调到32-64M）
innodb_log_buffer_size=16M

# MyISAM 索引缓存（InnoDB引擎可忽略）
key_buffer_size=8M

# 内存临时表大小
tmp_table_size=16M
max_heap_table_size=16M

# 每连接缓冲区（不建议调大）
sort_buffer_size=256K
read_buffer_size=128K
read_rnd_buffer_size=256K
join_buffer_size=256K

# ==================== 性能优化 ====================
# 查询缓存（MySQL 8.0 已移除）
# query_cache_size=0
# query_cache_type=0

# 线程缓存
thread_cache_size=8

# 表缓存
table_open_cache=2000
table_definition_cache=1000

# ==================== 日志配置 ====================
# 错误日志
log-error=/var/log/mysql/error.log

# 慢查询日志
slow_query_log=1
slow_query_log_file=/var/log/mysql/slow.log
long_query_time=2

# 二进制日志（主从复制需要）
# log-bin=/var/log/mysql/mysql-bin
# binlog_expire_logs_seconds=604800

# ==================== InnoDB 配置 ====================
# 文件格式
innodb_file_per_table=1
innodb_flush_method=O_DIRECT

# 日志文件大小
innodb_log_file_size=48M
innodb_log_files_in_group=2

# 刷新策略（1最安全但慢，2性能好但可能丢1秒数据）
innodb_flush_log_at_trx_commit=1

# ==================== 连接配置 ====================
max_allowed_packet=64M
wait_timeout=28800
interactive_timeout=28800

[client]
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4
```

### Docker Run 方式

```bash
docker run -d \
  --name mysql \
  --memory="1g" \
  --memory-swap="1g" \
  -e MYSQL_ROOT_PASSWORD=yourpassword \
  -v /path/to/data:/var/lib/mysql \
  -v /path/to/my.cnf:/etc/my.cnf \
  -p 3306:3306 \
  mysql:8.0
```

### 不同应用场景的配置

#### 1. 小型应用（个人博客、开发环境）

```ini
[mysqld]
max_connections=30
innodb_buffer_pool_size=128M
innodb_log_buffer_size=16M
```

**预期内存：** 400-600 MB

#### 2. 中小型应用（小型电商、企业网站）

```ini
[mysqld]
max_connections=80
innodb_buffer_pool_size=512M
innodb_log_buffer_size=32M
```

**预期内存：** 1-1.5 GB

#### 3. 中型应用（SaaS平台、API服务）

```ini
[mysqld]
max_connections=150
innodb_buffer_pool_size=1G
innodb_log_buffer_size=64M
```

**预期内存：** 2-3 GB

---

## 验证与监控

### 1. 重启容器使配置生效

```bash
# Docker Compose 方式
docker-compose down
docker-compose up -d

# Docker Run 方式
docker restart mysql

# 查看启动日志
docker-compose logs -f mysql
# 或
docker logs -f mysql
```

### 2. 验证配置是否生效

```bash
# 进入容器
docker exec -it mysql mysql -u root -p

# 在 MySQL 中执行
mysql> SHOW VARIABLES LIKE 'max_connections';
mysql> SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
mysql> SHOW VARIABLES LIKE 'innodb_log_buffer_size';
```

### 3. 监控内存使用

```sql
-- 查看当前活跃连接
SHOW STATUS LIKE 'Threads_connected';

-- 查看历史最大连接数
SHOW STATUS LIKE 'Max_used_connections';

-- 查看内存使用详情
SELECT 
    EVENT_NAME, 
    ROUND(CURRENT_NUMBER_OF_BYTES_USED/1024/1024, 2) AS MB
FROM performance_schema.memory_summary_global_by_event_name 
WHERE CURRENT_NUMBER_OF_BYTES_USED > 0 
ORDER BY CURRENT_NUMBER_OF_BYTES_USED DESC 
LIMIT 10;
```

### 4. 持续监控脚本

创建一个简单的监控脚本 `monitor.sh`：

```bash
#!/bin/bash

echo "=== MySQL 内存监控 ==="
echo "容器内存使用:"
docker stats mysql --no-stream

echo -e "\nMySQL 连接情况:"
docker exec mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} \
  -e "SHOW STATUS LIKE 'Threads_connected'; SHOW STATUS LIKE 'Max_used_connections';"

echo -e "\n缓冲池使用率:"
docker exec mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} \
  -e "SELECT 
    ROUND((SELECT VARIABLE_VALUE FROM performance_schema.global_status WHERE VARIABLE_NAME='Innodb_buffer_pool_bytes_data') / 
    (SELECT VARIABLE_VALUE FROM performance_schema.global_variables WHERE VARIABLE_NAME='innodb_buffer_pool_size') * 100, 2) 
    AS '缓冲池使用率%';"
```

---

## 常见问题

### Q1: 修改配置后容器无法启动？

**可能原因：**
1. `lower-case-table-names=1` 在已有数据库上设置
2. 配置文件语法错误
3. 内存限制过小

**解决方法：**

```bash
# 查看容器日志
docker logs mysql

# 检查配置文件语法
docker exec mysql cat /etc/my.cnf

# 临时去掉有问题的配置项，逐个测试
```

### Q2: 修改 max_connections 后应用报连接不足？

**解决方法：**

```sql
-- 先查看实际使用情况
SHOW STATUS LIKE 'Max_used_connections';

-- 适当增加连接数
SET GLOBAL max_connections = 80;

-- 或考虑使用连接池（如 HikariCP, Druid）
```

### Q3: 内存优化后性能下降？

**检查以下指标：**

```sql
-- 缓冲池命中率（应 > 99%）
SHOW STATUS LIKE 'Innodb_buffer_pool_read%';

-- 如果命中率低，考虑增加 innodb_buffer_pool_size
SET GLOBAL innodb_buffer_pool_size = 512*1024*1024;
```

### Q4: Docker 重启后配置丢失？

**原因：** 使用了 `SET GLOBAL` 临时修改

**解决：** 始终在 `my.cnf` 配置文件中修改，并确保正确挂载：

```yaml
volumes:
  - ./conf/my.cnf:/etc/my.cnf
```

### Q5: 如何判断当前配置是否合理？

**关键指标监控：**

```sql
-- 1. 连接使用率（应 < 80%）
SELECT 
    (SELECT VARIABLE_VALUE FROM performance_schema.global_status WHERE VARIABLE_NAME='Max_used_connections') /
    (SELECT VARIABLE_VALUE FROM performance_schema.global_variables WHERE VARIABLE_NAME='max_connections') * 100 
    AS '连接使用率%';

-- 2. 缓冲池命中率（应 > 99%）
SHOW STATUS LIKE 'Innodb_buffer_pool_read%';

-- 3. 日志等待（应为 0 或很小）
SHOW STATUS LIKE 'Innodb_log_waits';

-- 4. 临时表到磁盘比例（应 < 10%）
SHOW STATUS LIKE 'Created_tmp%';
```

---

## 总结

### 优化要点

1. **max_connections 是最主要的内存优化点**
   - 默认 151 → 建议 20-50（小型应用）
   - 可节省 500-700 MB 内存

2. **innodb_buffer_pool_size 根据数据量调整**
   - 小于 1GB 数据：保持 128M
   - 1-10GB 数据：512M - 1GB
   - 大型数据库：可用内存的 50-70%

3. **innodb_log_buffer_size 根据写入量调整**
   - 读多写少：16M
   - 写入频繁：32-64M

4. **使用配置文件而非环境变量**
   - 统一管理，方便维护
   - 避免配置冲突

### 优化效果

| 配置 | 优化前 | 优化后 | 节省 |
|------|--------|--------|------|
| max_connections | 151 | 50 | ~500 MB |
| innodb_log_buffer_size | 64 MB | 16 MB | ~48 MB |
| **总内存占用** | **1.69 GB** | **600-800 MB** | **~900 MB** |

### 最佳实践

1. ✅ 先监控，后优化（了解实际使用情况）
2. ✅ 小步调整，逐步验证
3. ✅ 保留配置备份
4. ✅ 定期检查关键指标
5. ✅ 使用连接池技术（应用层优化）

---

## 参考资源

- [MySQL 官方文档 - 内存优化](https://dev.mysql.com/doc/refman/8.0/en/memory-use.html)
- [Docker MySQL 镜像文档](https://hub.docker.com/_/mysql)
- [InnoDB 配置参数详解](https://dev.mysql.com/doc/refman/8.0/en/innodb-parameters.html)

---

**文档版本:** v1.0  
**最后更新:** 2024-11  
**适用版本:** MySQL 5.7+, 8.0+