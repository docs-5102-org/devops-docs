---
title: Swap分区优化管理指南
category:
  - Linux
  - 磁盘管理
tag:
  - Swap
  - 内存管理
  - 系统优化
date: 2022-08-31

---

# Linux Swap分区优化管理指南

## 概述

Swap分区（交换分区）是Linux系统中的虚拟内存扩展机制。当物理内存不足时，系统会将长时间未使用的内存页面移动到swap空间，为活跃进程释放内存资源。合理配置swap分区对于系统性能优化至关重要。

## Swap分区工作原理

当系统内存使用率过高时，内核会根据最近最少使用（LRU）算法，将不活跃的内存页面交换到磁盘上的swap空间。需要时再将数据从swap读回内存。这个过程确保系统在内存不足时仍能正常运行，但会带来性能开销。

## 性能优化建议

### 1. 合理确定Swap大小

| 物理内存大小 | 推荐Swap大小 | 说明 |
|-------------|-------------|------|
| < 2GB | 2倍物理内存 | 内存较小时需要更多swap |
| 2GB - 8GB | 等于物理内存 | 平衡性能和空间 |
| 8GB - 64GB | 0.5倍物理内存 | 减少swap依赖 |
| > 64GB | 4GB - 8GB | 仅作为安全缓冲 |

### 2. Swap性能参数调优

```bash
# 查看当前swappiness值（默认60）
cat /proc/sys/vm/swappiness

# 临时调整swappiness值
echo 10 > /proc/sys/vm/swappiness

# 永久调整swappiness值
echo 'vm.swappiness=10' >> /etc/sysctl.conf
```

**swappiness参数说明：**
- 0：仅在内存不足时使用swap
- 10：推荐服务器设置，减少swap使用
- 60：系统默认值
- 100：积极使用swap

## 操作步骤详解

### 一、系统状态检查

#### 1.1 检查当前内存和swap状态
```bash
# 查看内存使用情况
free -h
```

输出内容

```
total        used        free      shared  buff/cache   available
Mem:      7.6G        3.6G        3.0G        401M        996M        3.4G
Swap:      0B          0B          0B
```
```bash
# 查看swap详细信息
swapon --show

# 查看系统负载
cat /proc/loadavg
```

#### 1.2 检查磁盘空间
```bash
# 查看磁盘使用情况
df -h

# 查看磁盘I/O性能
iostat -x 1 5
```

### 二、创建Swap分区

#### 2.1 使用fallocate创建swap文件（推荐）
```bash
# 创建4GB swap文件（性能更好）
fallocate -l 4G /swapfile

# 设置文件权限
chmod 600 /swapfile

# 验证文件大小
ls -lh /swapfile
```

#### 2.2 使用dd命令创建（传统方法）
```bash
# 创建4GB swap文件
dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress

# 设置文件权限
chmod 600 /swapfile
```

#### 2.3 格式化为swap格式
```bash
# 格式化swap文件
mkswap /swapfile

# 启用swap
swapon /swapfile

# 验证swap状态
swapon --show
free -h
```

### 三、配置自动挂载

#### 3.1 添加到fstab
```bash
# 备份fstab文件
cp /etc/fstab /etc/fstab.backup

# 添加swap条目
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# 验证fstab配置
mount -a
```

#### 3.2 使用UUID挂载（推荐）
```bash
# 获取swap UUID
blkid /swapfile

# 使用UUID添加到fstab
echo 'UUID=your-uuid-here none swap sw 0 0' >> /etc/fstab
```

### 四、性能监控和调优

#### 4.1 监控swap使用情况
```bash
# 实时监控内存和swap
watch -n 1 free -h

# 查看哪些进程使用swap最多
for file in /proc/*/status; do
    awk '/VmSwap|Name/{printf $2 " " $3}END{print ""}' $file
done | sort -k 2 -n | tail -10
```

#### 4.2 调整内核参数
```bash
# 编辑sysctl.conf
vi /etc/sysctl.conf

# 添加以下优化参数
vm.swappiness=10                # 降低swap使用倾向
vm.vfs_cache_pressure=50        # 调整缓存回收策略
vm.dirty_ratio=15               # 脏页比例
vm.dirty_background_ratio=5     # 后台写入阈值

# 应用配置
sysctl -p
```

### 五、Swap分区管理

#### 5.1 临时禁用swap
```bash
# 禁用所有swap
swapoff -a

# 禁用特定swap文件
swapoff /swapfile
```

#### 5.2 调整swap优先级
```bash
# 设置swap优先级（数值越高优先级越高）
swapon -p 10 /swapfile

# 在fstab中设置优先级
/swapfile none swap sw,pri=10 0 0
```

#### 5.3 删除swap分区
```bash
# 1. 禁用swap
swapoff /swapfile

# 2. 从fstab移除相关条目
sed -i '/swapfile/d' /etc/fstab

# 3. 删除swap文件
rm /swapfile
```

## 高级优化策略

### 1. 使用SSD存储swap
```bash
# 在SSD上创建swap以提高性能
fallocate -l 4G /mnt/ssd/swapfile
chmod 600 /mnt/ssd/swapfile
mkswap /mnt/ssd/swapfile
swapon /mnt/ssd/swapfile
```

### 2. 配置多个swap分区
```bash
# 创建多个swap文件并设置不同优先级
fallocate -l 2G /swapfile1
fallocate -l 2G /swapfile2
chmod 600 /swapfile1 /swapfile2
mkswap /swapfile1
mkswap /swapfile2
swapon -p 10 /swapfile1
swapon -p 5 /swapfile2
```

### 3. 使用zram压缩swap
```bash
# 安装zram-tools
apt install zram-tools  # Debian/Ubuntu
yum install zram       # CentOS/RHEL

# 配置zram
echo 'ALGO=lz4' >> /etc/default/zramswap
echo 'PERCENT=25' >> /etc/default/zramswap
systemctl enable zramswap
systemctl start zramswap
```

## 故障排除

### 常见问题及解决方案

1. **swap文件创建失败**
   ```bash
   # 检查磁盘空间
   df -h
   # 检查权限
   ls -la /
   ```

2. **swap启用失败**
   ```bash
   # 检查文件格式
   file /swapfile
   # 重新格式化
   mkswap /swapfile
   ```

3. **系统启动时swap未自动挂载**
   ```bash
   # 检查fstab语法
   mount -a
   # 验证UUID是否正确
   blkid /swapfile
   ```

## 性能测试

### 测试swap性能
```bash
# 使用dd测试swap读写速度
dd if=/dev/zero of=/swapfile bs=1M count=1024 oflag=direct
dd if=/swapfile of=/dev/null bs=1M count=1024 iflag=direct

# 使用sysbench测试内存性能
sysbench memory --memory-total-size=2G run
```

## 最佳实践总结

1. **服务器环境**：设置swappiness=10，减少swap使用
2. **桌面环境**：保持默认swappiness=60，平衡性能和响应性
3. **监控重要**：定期监控swap使用率，超过50%需要考虑增加内存
4. **存储选择**：优先使用SSD存储swap分区
5. **大小合理**：避免过大的swap分区，影响系统性能
6. **安全考虑**：swap文件权限设置为600，防止信息泄露

通过合理配置和优化swap分区，可以显著提升Linux服务器的性能和稳定性。定期监控和调整swap参数，确保系统在各种负载条件下都能高效运行。

## 参考

<https://www.cnblogs.com/thrillerz/p/4140197.html>    简单容易理解
<https://www.cnblogs.com/chentop/p/10330052.html>  简单容易理解
<https://www.cnblogs.com/zhenyuyaodidiao/p/4691342.html>   讲解全面
