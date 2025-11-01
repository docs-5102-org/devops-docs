---
title: MySQL 配置远程连接
category:
  - Linux
  - 软件安装与包管理
tag:
  - MySQL
  - 远程链接
date: 2022-09-21

---

# MySQL 远程连接配置完整指南

## 一、问题背景

默认情况下，MySQL 的 root 用户只允许本地登录（localhost），无法从远程主机连接。这是出于安全考虑的默认配置。要实现远程连接，需要：

1. 授权用户允许远程访问
2. 修改 MySQL 配置文件
3. 配置防火墙规则

## 二、查看当前用户权限

首先登录 MySQL 查看现有用户的权限情况：

```bash
mysql -h localhost -u root -p
```

```sql
-- 切换到 mysql 系统数据库
USE mysql;

-- 查看用户权限情况
SELECT host, user, authentication_string FROM mysql.user;
```

典型的默认输出：

```
+-----------+------+-------------------------------------------+
| host      | user | authentication_string                     |
+-----------+------+-------------------------------------------+
| localhost | root | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
| 127.0.0.1 | root | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
| localhost |      |                                           |
+-----------+------+-------------------------------------------+
```

可以看到，root 用户只能以 localhost 方式访问。

## 三、授权用户远程访问

### 示例 1：授权 root 用户远程访问（任意 IP）

```sql
-- 方式一：如果用户已存在，直接授权
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'your_strong_password' WITH GRANT OPTION;

-- 方式二：MySQL 8.0+ 推荐方式（先创建用户再授权）
CREATE USER 'root'@'%' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- 刷新权限使其立即生效
FLUSH PRIVILEGES;
```

**说明：**
- `'root'@'%'`：root 是用户名，`%` 表示允许从任意 IP 地址访问
- `*.*`：表示所有数据库的所有表
- `WITH GRANT OPTION`：允许该用户授权其他用户

### 示例 2：创建普通用户并授权

```sql
-- 创建普通用户，允许从任意 IP 访问
CREATE USER 'appuser'@'%' IDENTIFIED BY 'App@Pass123';

-- 授予特定数据库的所有权限
GRANT ALL PRIVILEGES ON myapp_db.* TO 'appuser'@'%';

-- 刷新权限
FLUSH PRIVILEGES;
```

### 示例 3：按 IP 地址精确授权（推荐）

```sql
-- root 用户仅允许特定 IP 访问
CREATE USER 'root'@'192.168.1.100' IDENTIFIED BY 'Root@Pass123';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.100' WITH GRANT OPTION;

-- 普通用户仅允许特定 IP 段访问
CREATE USER 'appuser'@'192.168.1.%' IDENTIFIED BY 'App@Pass123';
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp_db.* TO 'appuser'@'192.168.1.%';

-- 刷新权限
FLUSH PRIVILEGES;
```

### 示例 4：只授权不设置密码

#### 使用 GRANT 不带 IDENTIFIED BY

```sql
-- 只授权，不改密码
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```
#### 先创建用户（如果不存在），再授权

```sql
-- 如果用户不存在，先创建（不设密码或设空密码）
CREATE USER IF NOT EXISTS 'root'@'%';

-- 然后授权
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### 示例5: 修改现有用户权限（不动密码）

如果用户已存在，只想修改权限：

```sql
-- 直接授权，完全不涉及密码
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

### 示例6：如果授权记录已存在，想修改对应的主机

#### 方法1：删除旧记录 + 创建新记录（推荐）

```sql
-- 1. 撤销旧的授权
REVOKE ALL PRIVILEGES ON *.* FROM 'root'@'%';

-- 2. 删除旧用户（谨慎！！！ 可选，如果要完全移除）
DROP USER 'root'@'%';

-- 3. 创建新的主机授权
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.100' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

#### 方法2：直接修改 mysql.user 表（不推荐，但有效）

```sql
-- MySQL 5.7 及以下
UPDATE mysql.user SET host='192.168.1.100' WHERE user='root' AND host='%';
FLUSH PRIVILEGES;

-- MySQL 8.0+
-- 不推荐直接修改系统表，建议用方法一
```

#### 方法3：重命名用户（MySQL 5.7+、MySQL 8.0+）推荐

```sql
-- 将 root@'%' 改为 root@'192.168.1.100'
RENAME USER 'root'@'%' TO 'root'@'192.168.1.100';
FLUSH PRIVILEGES;
```


### 验证授权结果

```sql
-- 再次查看用户列表
SELECT host, user, authentication_string FROM user;
```

现在应该看到新增的远程用户：

```
+-----------+---------+-------------------------------------------+
| host      | user    | authentication_string                     |
+-----------+---------+-------------------------------------------+
| localhost | root    | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
| 127.0.0.1 | root    | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
| %         | root    | *4ACFE3202A5FF5CF467898FC58AAB1D615029441 |
| %         | appuser | *8B2E71D8E4F4A5D9C3A1F6E7B9D4C2A8E5F3B6D1 |
+-----------+---------+-------------------------------------------+
```

## 四、修改 MySQL 配置文件

### 1. 找到并编辑配置文件

**Linux:**
```bash
# Ubuntu/Debian
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf

# CentOS/RHEL
sudo vi /etc/my.cnf
```

**Windows:**
```
C:\ProgramData\MySQL\MySQL Server 8.0\my.ini
```

### 2. 修改 bind-address

找到 `[mysqld]` 部分，修改或添加以下内容：

```ini
[mysqld]
# 注释掉或修改 bind-address
# bind-address = 127.0.0.1

# 允许所有 IP 连接（推荐）
bind-address = 0.0.0.0

# 或者指定服务器的具体 IP
# bind-address = 192.168.1.10

# 如果该行不存在，MySQL 8.0+ 默认监听所有接口
```

:::tip
关于 `bind-address` 的默认值，情况因 MySQL 版本而异：

#### MySQL 默认 bind-address 行为

**MySQL 8.0 及以上版本**
- **默认值**: `*`（等同于 `0.0.0.0`）
- **行为**: 默认监听所有网络接口，允许远程连接

**MySQL 5.7 及更早版本**
- **默认值**: `*` 或 `0.0.0.0`
- **行为**: 也是监听所有接口，但某些发行版（如 Ubuntu/Debian）会在配置文件中显式设置为 `127.0.0.1`

#### 如何查看当前配置

**方法一：查看 MySQL 变量**
```sql
-- 登录 MySQL 后执行
SHOW VARIABLES LIKE 'bind_address';
```

输出示例：
```
+---------------+-----------+
| Variable_name | Value     |
+---------------+-----------+
| bind_address  | 0.0.0.0   |
+---------------+-----------+
```

**方法二：使用 netstat 查看监听状态**
```bash
# Linux
sudo netstat -tulpn | grep 3306

# 或使用 ss 命令
sudo ss -tulpn | grep 3306
```

输出解读：
```bash
# 监听所有接口（允许远程连接）
tcp  0.0.0.0:3306  0.0.0.0:*  LISTEN

# 仅监听本地（不允许远程连接）
tcp  127.0.0.1:3306  0.0.0.0:*  LISTEN
```

#### 重要说明

即使 `bind-address` 允许远程连接，你仍然需要：

1. **授权用户远程访问权限**（使用 `'user'@'%'` 或 `'user'@'IP'`）
2. **开放防火墙端口**
3. **云服务器需配置安全组规则**

所以如果配置文件中没有 `bind-address` 这一行，MySQL 通常会监听所有接口，但你依然需要完成用户授权和防火墙配置才能实现远程连接。
:::

### 3. 重启 MySQL 服务

**Linux:**
```bash
# Ubuntu/Debian
sudo systemctl restart mysql
sudo systemctl status mysql

# CentOS/RHEL
sudo systemctl restart mysqld
sudo systemctl status mysqld
```

**Windows:**
```cmd
net stop mysql80
net start mysql80
```

### 4. 验证监听状态

```bash
# 检查 MySQL 是否监听在正确的地址
netstat -tulpn | grep 3306

# 期望输出（监听所有接口）：
# tcp    0    0 0.0.0.0:3306    0.0.0.0:*    LISTEN    1234/mysqld
```

## 五、配置防火墙规则

### Linux - UFW（Ubuntu/Debian）

```bash
# 允许所有 IP 访问 MySQL 端口
sudo ufw allow 3306/tcp

# 或仅允许特定 IP 访问
sudo ufw allow from 192.168.1.100 to any port 3306

# 或允许特定 IP 段访问
sudo ufw allow from 192.168.1.0/24 to any port 3306

# 查看防火墙规则
sudo ufw status
```

### Linux - firewalld（CentOS/RHEL）

```bash
# 永久开放 3306 端口
sudo firewall-cmd --permanent --add-port=3306/tcp

# 或添加 MySQL 服务
sudo firewall-cmd --permanent --add-service=mysql

# 重载防火墙配置
sudo firewall-cmd --reload

# 查看规则
sudo firewall-cmd --list-all
```

### Windows 防火墙

```powershell
# 以管理员身份运行 PowerShell
New-NetFirewallRule -DisplayName "MySQL Server" -Direction Inbound -Protocol TCP -LocalPort 3306 -Action Allow
```

**或通过图形界面：**
1. 控制面板 → Windows Defender 防火墙 → 高级设置
2. 入站规则 → 新建规则 → 端口 → TCP 3306 → 允许连接

### 云服务器安全组

如果使用阿里云、腾讯云、AWS 等云服务器，还需要在控制台配置安全组规则，开放 3306 端口。

## 六、测试远程连接

### 从远程客户端连接

```bash
# 使用 root 用户连接
mysql -h 192.168.1.10 -P 3306 -u root -p

# 使用普通用户连接
mysql -h 192.168.1.10 -P 3306 -u appuser -p
```

### 测试连接工具

- **命令行:** MySQL Client
- **GUI 工具:** MySQL Workbench, Navicat, DBeaver, HeidiSQL
- **编程语言测试:**

```python
# Python 示例
import pymysql

connection = pymysql.connect(
    host='192.168.1.10',
    port=3306,
    user='appuser',
    password='App@Pass123',
    database='myapp_db'
)
print("连接成功！")
connection.close()
```

## 七、验证配置

登录 MySQL 后执行以下命令检查配置：

```sql
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
```

## 八、用户权限管理

### 查看和管理用户

```sql
-- 查看所有用户
SELECT user, host, authentication_string FROM mysql.user;

-- 查看特定用户的详细权限
SHOW GRANTS FOR 'appuser'@'%';

-- 查看当前用户权限
SHOW GRANTS FOR CURRENT_USER;
```

### 修改用户密码

```sql
-- MySQL 5.7+
ALTER USER 'root'@'%' IDENTIFIED BY 'NewPassword123!';

-- MySQL 8.0+ 指定认证插件
ALTER USER 'appuser'@'%' IDENTIFIED WITH mysql_native_password BY 'NewPass456!';

-- 刷新权限
FLUSH PRIVILEGES;
```

### 撤销权限

```sql
-- 撤销所有权限
REVOKE ALL PRIVILEGES ON *.* FROM 'appuser'@'%';

-- 撤销特定权限
REVOKE INSERT, DELETE ON myapp_db.* FROM 'appuser'@'%';

-- 刷新权限
FLUSH PRIVILEGES;
```

### 删除用户

```sql
-- 删除用户
DROP USER 'appuser'@'%';

-- 删除多个用户
DROP USER 'user1'@'%', 'user2'@'localhost';
```

## 九、常见权限说明

```sql
-- 仅授予查询权限（只读用户）
GRANT SELECT ON myapp_db.* TO 'readonly'@'%';

-- 授予查询、插入、更新权限（常规应用用户）
GRANT SELECT, INSERT, UPDATE ON myapp_db.* TO 'appuser'@'%';

-- 授予所有权限但不能授权给其他用户
GRANT ALL PRIVILEGES ON myapp_db.* TO 'appuser'@'%';

-- 授予所有权限且可以授权给其他用户（管理员）
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

-- 授予创建数据库的权限
GRANT CREATE ON *.* TO 'dbcreator'@'%';

-- 授予执行存储过程的权限
GRANT EXECUTE ON myapp_db.* TO 'appuser'@'%';
```

## 十、安全最佳实践

### 1. 用户权限最小化

```sql
-- ❌ 不推荐：给所有权限
GRANT ALL PRIVILEGES ON *.* TO 'appuser'@'%';

-- ✅ 推荐：只给必要权限
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp_db.* TO 'appuser'@'%';
```

### 2. 限制访问来源

```sql
-- ❌ 不推荐：允许任意 IP
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';

-- ✅ 推荐：限制特定 IP 或网段
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.100';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.%';
```

### 3. 使用强密码

```sql
-- 设置密码复杂度策略
SET GLOBAL validate_password.policy=STRONG;
SET GLOBAL validate_password.length=12;

-- 创建用户时使用强密码
CREATE USER 'appuser'@'%' IDENTIFIED BY 'Str0ng!P@ssw0rd#2024';
```

### 4. 修改默认端口（可选）

编辑 `my.cnf` 或 `my.ini`:

```ini
[mysqld]
port = 3307  # 改为非默认端口
```

### 5. 启用 SSL 加密连接

```sql
-- 要求用户必须使用 SSL 连接
ALTER USER 'appuser'@'%' REQUIRE SSL;
```

### 6. 定期审计

```sql
-- 查看最近的连接
SELECT user, host, db, command, time, state, info 
FROM information_schema.processlist;

-- 查看用户上次登录时间（需要启用审计插件）
SELECT user, host, plugin FROM mysql.user;
```

## 十一、故障排查清单

如果远程连接失败，按以下顺序检查：

1. ✅ **用户是否已授权远程访问**
   ```sql
   SELECT user, host FROM mysql.user WHERE user='appuser';
   ```

2. ✅ **bind-address 是否正确配置**
   ```sql
   SHOW VARIABLES LIKE 'bind_address';
   ```

3. ✅ **MySQL 服务是否已重启**
   ```bash
   sudo systemctl status mysql
   ```

4. ✅ **MySQL 是否监听正确端口**
   ```bash
   netstat -tulpn | grep 3306
   # 或
   ss -tulpn | grep 3306
   ```

5. ✅ **防火墙是否放行 3306 端口**
   ```bash
   sudo ufw status
   # 或
   sudo firewall-cmd --list-all
   ```

6. ✅ **云服务器安全组是否开放**
   - 登录云服务商控制台检查安全组规则

7. ✅ **测试端口连通性**
   ```bash
   telnet 192.168.1.10 3306
   # 或
   nc -zv 192.168.1.10 3306
   ```

8. ✅ **检查 MySQL 错误日志**
   ```bash
   # Linux
   sudo tail -f /var/log/mysql/error.log
   
   # Windows
   # 查看 MySQL 数据目录下的 .err 文件
   ```

## 十二、完整配置示例

### 场景：生产环境配置

```sql
-- 1. 创建管理员用户（仅允许办公网 IP）
CREATE USER 'admin'@'192.168.1.%' IDENTIFIED BY 'Admin@Strong#Pass2024';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'192.168.1.%' WITH GRANT OPTION;

-- 2. 创建应用用户（仅允许应用服务器 IP）
CREATE USER 'webapp'@'10.0.1.100' IDENTIFIED BY 'WebApp@Pass2024';
GRANT SELECT, INSERT, UPDATE, DELETE ON production_db.* TO 'webapp'@'10.0.1.100';

-- 3. 创建只读用户（用于数据分析）
CREATE USER 'analyst'@'192.168.1.%' IDENTIFIED BY 'Analyst@Pass2024';
GRANT SELECT ON production_db.* TO 'analyst'@'192.168.1.%';

-- 4. 创建备份用户
CREATE USER 'backup'@'localhost' IDENTIFIED BY 'Backup@Pass2024';
GRANT SELECT, LOCK TABLES, SHOW VIEW, RELOAD, REPLICATION CLIENT ON *.* TO 'backup'@'localhost';

-- 5. 刷新权限
FLUSH PRIVILEGES;

-- 6. 验证配置
SELECT user, host, authentication_string FROM mysql.user;
SHOW GRANTS FOR 'webapp'@'10.0.1.100';
```

通过以上配置，你就可以安全地实现 MySQL 的远程访问了！记住始终遵循最小权限原则，定期审查用户权限，确保数据库安全。