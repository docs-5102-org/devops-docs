---
title: mkdir命令-创建目录
# icon: folder-plus
category:
  - Linux
  - 文件及目录管理
tag:
  - mkdir
  - 文件管理
  - 目录创建
date: 2022-07-26

---

# mkdir命令-创建目录

## 概述

`mkdir` 命令来自英文词组 "make directories" 的缩写，是 Linux 系统中用于创建目录的基础命令。该命令简单易用，但功能强大，支持递归创建多级目录、设置权限、批量创建等高级功能。

## 语法格式

```bash
mkdir [选项] 目录名...
```

## 常用参数

| 参数 | 功能 |
|------|------|
| `-p` | 递归创建多级目录，如果父目录不存在则自动创建 |
| `-m MODE` | 创建目录时设置权限模式 |
| `-v` | 显示创建过程的详细信息（verbose） |
| `-z` | 设置 SELinux 安全上下文 |
| `--parents` | 等同于 `-p` 参数 |
| `--mode=MODE` | 等同于 `-m` 参数 |
| `--verbose` | 等同于 `-v` 参数 |
| `--help` | 显示帮助信息 |
| `--version` | 显示版本信息 |

## 基础用法示例

### 1. 创建单个目录
```bash
mkdir mydir
```

### 2. 创建多个目录
```bash
mkdir dir1 dir2 dir3
```

### 3. 递归创建多级目录
```bash
# 创建嵌套目录结构
mkdir -p /path/to/deep/directory/structure

# 创建项目目录结构
mkdir -p project/{src,docs,tests,config}
```

### 4. 创建目录并设置权限
```bash
# 创建目录并设置权限为 755
mkdir -m 755 public_dir

# 创建私有目录，仅所有者可访问
mkdir -m 700 private_dir

# 创建共享目录，组用户可写入
mkdir -m 775 shared_dir
```

### 5. 显示创建过程
```bash
mkdir -v new_directory
# 输出：mkdir: created directory 'new_directory'

mkdir -pv /path/to/deep/nested/dirs
# 输出：mkdir: created directory '/path/to'
#       mkdir: created directory '/path/to/deep'
#       mkdir: created directory '/path/to/deep/nested'
#       mkdir: created directory '/path/to/deep/nested/dirs'
```

## 高级用法和技巧

### 1. 批量创建带编号的目录
```bash
# 创建 dir1 到 dir10
mkdir dir{1..10}

# 创建 test001 到 test100
mkdir test{001..100}

# 创建按日期命名的目录
mkdir backup_$(date +%Y%m%d)

# 创建按年月命名的目录
mkdir logs_{2023..2025}_{01..12}
```

### 2. 创建复杂的目录结构
```bash
# 创建标准项目结构
mkdir -p myproject/{src/{main,test},docs/{api,user},config/{dev,prod},logs}

# 创建 Web 项目结构
mkdir -p webapp/{public/{css,js,images},src/{components,pages,utils},tests/{unit,integration}}

# 创建数据分析项目结构
mkdir -p data_project/{data/{raw,processed,external},notebooks,src,reports/{figures,presentations}}
```

### 3. 结合其他命令使用
```bash
# 创建目录并立即进入
mkdir newdir && cd newdir

# 创建目录并添加说明文件
mkdir project && echo "# Project Description" > project/README.md

# 创建目录并设置环境
mkdir -p ~/workspace/project/{src,tests} && cd ~/workspace/project && git init
```

### 4. 条件创建目录
```bash
# 仅在目录不存在时创建
[ ! -d "mydir" ] && mkdir mydir

# 脚本中的安全创建
if [ ! -d "/path/to/directory" ]; then
    mkdir -p "/path/to/directory"
    echo "目录已创建"
else
    echo "目录已存在"
fi
```

## 权限模式详解

### 数字权限模式
```bash
# 常用权限组合
mkdir -m 755 public_dir    # rwxr-xr-x (所有者全权限，其他用户读取执行)
mkdir -m 750 group_dir     # rwxr-x--- (所有者全权限，组用户读取执行)
mkdir -m 700 private_dir   # rwx------ (仅所有者全权限)
mkdir -m 775 shared_dir    # rwxrwxr-x (所有者和组用户全权限，其他用户读取执行)
mkdir -m 777 temp_dir      # rwxrwxrwx (所有用户全权限，不推荐)
```

### 符号权限模式
```bash
# 使用符号设置权限
mkdir -m u=rwx,g=rx,o=rx public_dir
mkdir -m u=rwx,g=rwx,o= group_dir
mkdir -m u=rwx,g=,o= private_dir
```

## 实际应用场景

### 1. 系统管理
```bash
# 创建日志目录结构
sudo mkdir -p /var/log/myapp/{error,access,debug}

# 创建备份目录
sudo mkdir -p /backup/$(hostname)/{daily,weekly,monthly}

# 创建用户工作目录
sudo mkdir -p /home/newuser/{Documents,Downloads,Pictures,Videos}
sudo chown -R newuser:newgroup /home/newuser
```

### 2. 开发环境搭建
```bash
# 创建标准开发目录
mkdir -p ~/Development/{projects,tools,libraries,documentation}

# 创建特定语言项目结构
mkdir -p python_project/{src,tests,docs,requirements,data}
mkdir -p nodejs_project/{src,public,tests,node_modules}
mkdir -p java_project/{src/{main/{java,resources},test/{java,resources}},target}
```

### 3. 数据组织
```bash
# 创建数据处理管道目录
mkdir -p data_pipeline/{input,processing,output,archive,logs}

# 创建多媒体文件组织结构
mkdir -p media/{photos/{2023,2024}/{01..12},videos/{raw,edited},audio/{music,podcasts}}
```

### 4. 服务器配置
```bash
# 创建 Web 服务器目录
sudo mkdir -p /var/www/{html,logs,ssl,backup}

# 创建数据库目录
sudo mkdir -p /var/lib/database/{data,logs,backup,config}
```

## 脚本中的高级应用

### 1. 动态目录创建脚本
```bash
#!/bin/bash
# 智能项目目录创建脚本

create_project_structure() {
    local project_name=$1
    local project_type=$2
    
    case $project_type in
        "web")
            mkdir -p "$project_name"/{src/{components,pages,styles},public,tests,docs}
            ;;
        "python")
            mkdir -p "$project_name"/{src,tests,docs,data,notebooks,requirements}
            ;;
        "java")
            mkdir -p "$project_name"/src/{main/{java,resources},test/{java,resources}}
            ;;
        *)
            mkdir -p "$project_name"/{src,tests,docs}
            ;;
    esac
    
    echo "项目结构已创建: $project_name ($project_type)"
}

# 使用示例
create_project_structure "my_webapp" "web"
```

### 2. 批量用户目录创建
```bash
#!/bin/bash
# 批量创建用户主目录结构

create_user_dirs() {
    local username=$1
    local base_dir="/home/$username"
    
    # 创建标准用户目录
    mkdir -p "$base_dir"/{Desktop,Documents,Downloads,Music,Pictures,Videos,Public,Templates}
    
    # 创建开发相关目录
    mkdir -p "$base_dir"/Development/{projects,tools,workspace}
    
    # 设置权限
    chown -R "$username:$username" "$base_dir"
    chmod 755 "$base_dir"
    
    echo "用户目录已创建: $base_dir"
}
```

### 3. 定期清理和重建目录
```bash
#!/bin/bash
# 定期清理临时目录并重建

cleanup_and_rebuild() {
    local temp_dir="/tmp/myapp"
    
    # 清理旧目录
    if [ -d "$temp_dir" ]; then
        rm -rf "$temp_dir"
        echo "已清理旧目录: $temp_dir"
    fi
    
    # 重建目录结构
    mkdir -p "$temp_dir"/{cache,logs,uploads,sessions}
    chmod 777 "$temp_dir"/{cache,uploads,sessions}
    chmod 755 "$temp_dir/logs"
    
    echo "临时目录已重建: $temp_dir"
}
```

## 错误处理和故障排除

### 常见错误

1. **权限不足**
```bash
# 错误示例
mkdir /root/newdir
# mkdir: cannot create directory '/root/newdir': Permission denied

# 解决方法
sudo mkdir /root/newdir
```

2. **目录已存在**
```bash
# 错误示例
mkdir existingdir
# mkdir: cannot create directory 'existingdir': File exists

# 解决方法：使用条件检查
[ ! -d "existingdir" ] && mkdir existingdir || echo "目录已存在"
```

3. **路径过长**
```bash
# 某些文件系统有路径长度限制
# 解决方法：分步创建或使用相对路径
```

### 最佳实践

1. **总是使用 -p 参数创建深层目录**
2. **在脚本中检查目录是否已存在**
3. **适当设置目录权限**
4. **使用 -v 参数调试目录创建过程**

## 性能优化

### 1. 批量操作优化
```bash
# 不推荐：多次调用 mkdir
for i in {1..1000}; do
    mkdir "dir$i"
done

# 推荐：一次性创建
mkdir dir{1..1000}
```

### 2. 并行创建大量目录
```bash
# 使用 xargs 并行创建
echo {1..1000} | tr ' ' '\n' | xargs -n 1 -P 8 -I {} mkdir "dir{}"
```

## 安全考虑

### 1. 权限设置
```bash
# 创建敏感目录时立即设置正确权限
mkdir -m 700 sensitive_data
```

### 2. 路径验证
```bash
# 验证路径安全性
validate_path() {
    local path=$1
    # 检查路径是否包含危险字符
    if [[ "$path" =~ \.\. ]] || [[ "$path" =~ ^/ ]]; then
        echo "危险路径: $path"
        return 1
    fi
    return 0
}
```

## 相关命令

- `rmdir`：删除空目录
- `rm -r`：递归删除目录及其内容
- `ls -la`：查看目录详细信息
- `tree`：以树形结构显示目录
- `find`：查找目录
- `chmod`：修改目录权限
- `chown`：修改目录所有者
- `du`：查看目录大小

## 总结

`mkdir` 命令是 Linux 文件系统操作的基础命令之一。掌握其各种参数和使用技巧，特别是 `-p` 递归创建和 `-m` 权限设置功能，能够大大提高工作效率。在实际使用中，建议结合脚本自动化和错误处理机制，确保目录创建的可靠性和安全性。

无论是系统管理、开发环境搭建还是数据组织，`mkdir` 命令都是不可或缺的工具。通过合理的目录结构规划和权限设置，可以为后续的文件管理和系统维护奠定良好的基础。
