---
title: 时间戳获取指南
category:
  - Linux
  - Shell编程
tag:
  - 时间戳
  - date命令
  - 脚本编程
  - 时间处理
date: 2022-07-17

---

# Linux 时间戳获取指南

## 概述
本文档提供了在 Linux 系统中获取不同精度时间戳的 shell 脚本示例。

## 1. 获取明天凌晨的毫秒时间戳

```bash
# 方法一：使用 next-day 参数
tomorrow=$(date -d "next-day" +%Y-%m-%d)
timestamp=$(date -d "$tomorrow 00:00:00" +%s)
tomorrow_ms_timestamp=$((timestamp * 1000))
echo "明天凌晨毫秒时间戳: $tomorrow_ms_timestamp"

# 方法二：使用 tomorrow 参数（更简洁）
tomorrow_ms_timestamp=$(date -d "tomorrow 00:00:00" +%s)000
echo "明天凌晨毫秒时间戳: $tomorrow_ms_timestamp"
```

## 2. 获取当前时间的毫秒时间戳

```bash
# 方法一：完整毫秒精度
current_s=$(date +%s)
current_ns=$(date +%N)
current_ms_timestamp=$((current_s * 1000 + 10#$current_ns / 1000000))
echo "当前毫秒时间戳: $current_ms_timestamp"

# 方法二：使用 %3N 获取毫秒部分（推荐）
current_ms_timestamp=$(date +%s%3N)
echo "当前毫秒时间戳: $current_ms_timestamp"
```

## 3. 获取当前时间的秒时间戳

```bash
# 最简单的方法
current_s_timestamp=$(date +%s)
echo "当前秒时间戳: $current_s_timestamp"

# 或者从毫秒时间戳转换
current_ms=$(date +%s%3N)
current_s_timestamp=$((current_ms / 1000))
echo "当前秒时间戳: $current_s_timestamp"
```

## 4. 实用函数封装

```bash
#!/bin/bash

# 获取当前毫秒时间戳
get_current_ms_timestamp() {
    echo $(date +%s%3N)
}

# 获取当前秒时间戳
get_current_s_timestamp() {
    echo $(date +%s)
}

# 获取指定日期的毫秒时间戳
get_date_ms_timestamp() {
    local date_str="$1"
    echo $(date -d "$date_str" +%s)000
}

# 获取明天凌晨的毫秒时间戳
get_tomorrow_midnight_ms() {
    echo $(date -d "tomorrow 00:00:00" +%s)000
}

# 使用示例
echo "当前毫秒时间戳: $(get_current_ms_timestamp)"
echo "当前秒时间戳: $(get_current_s_timestamp)"
echo "明天凌晨毫秒时间戳: $(get_tomorrow_midnight_ms)"
echo "2024-01-01 的毫秒时间戳: $(get_date_ms_timestamp "2024-01-01 00:00:00")"
```

## 5. 常用时间格式转换

```bash
# 时间戳转换为可读格式
timestamp_to_date() {
    local timestamp="$1"
    # 如果是毫秒时间戳，需要除以1000
    if [ ${#timestamp} -eq 13 ]; then
        timestamp=$((timestamp / 1000))
    fi
    date -d "@$timestamp" "+%Y-%m-%d %H:%M:%S"
}

# 使用示例
current_ms=$(date +%s%3N)
echo "当前时间戳: $current_ms"
echo "对应时间: $(timestamp_to_date $current_ms)"
```

## 6. 注意事项

1. **精度说明**：
   - `%s`：秒级时间戳（10位）
   - `%s%3N`：毫秒级时间戳（13位）
   - `%s%6N`：微秒级时间戳（16位）
   - `%s%9N`：纳秒级时间戳（19位）

2. **兼容性**：
   - `date +%s%3N` 在大多数现代 Linux 发行版中可用
   - 对于老版本系统，可能需要使用纳秒除法的方式

3. **性能考虑**：
   - 直接使用 `date +%s%3N` 比多次调用 `date` 命令更高效
   - 避免在循环中频繁获取时间戳

## 7. 完整示例脚本

```bash
#!/bin/bash

echo "=== Linux 时间戳获取示例 ==="
echo

# 当前时间信息
current_readable=$(date "+%Y-%m-%d %H:%M:%S")
current_s=$(date +%s)
current_ms=$(date +%s%3N)

echo "当前时间: $current_readable"
echo "当前秒时间戳: $current_s"
echo "当前毫秒时间戳: $current_ms"
echo

# 明天凌晨时间戳
tomorrow_midnight_s=$(date -d "tomorrow 00:00:00" +%s)
tomorrow_midnight_ms=$((tomorrow_midnight_s * 1000))
tomorrow_readable=$(date -d "tomorrow 00:00:00" "+%Y-%m-%d %H:%M:%S")

echo "明天凌晨时间: $tomorrow_readable"
echo "明天凌晨秒时间戳: $tomorrow_midnight_s"
echo "明天凌晨毫秒时间戳: $tomorrow_midnight_ms"
```

这个优化版本提供了更清晰的结构、更多的方法选择和实用的函数封装，方便在实际项目中使用。
