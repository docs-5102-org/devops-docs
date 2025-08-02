---
title: 脚本实战
category:
  - 脚本开发
tag:
  - BAT
date: 2022-02-10

---

# BAT脚本实战

## bat执行脚本调用Imagemagic执行转图的脚本

这是一个Windows批处理脚本，用于处理和清理某种项目文件夹结构。让我来分析一下它的功能和使用方法：

### 主要功能：
1. **图片格式转换**：将 `.jpg` 文件转换为 `.gif` 文件
2. **图片优化**：根据颜色数量自动选择压缩级别
3. **文件清理**：删除不需要的文件和文件夹

### 处理的文件夹结构：
```
源文件夹/
├── files/
│   ├── mobile/     (处理jpg转gif)
│   ├── thumb/      (处理jpg转gif) 
│   ├── extfiles/   (删除整个文件夹)
│   └── mobile-ext/ (删除整个文件夹)
└── mobile/
    ├── style/
    │   ├── icon/   (删除整个文件夹)
    │   ├── raw/    (删除整个文件夹)
    │   └── *.css   (删除多个CSS文件)
    └── javascript/
        └── *.js    (删除多个JS文件)
```

### 基本语法：
```batch
scriptname.bat "源文件夹路径"
```

### 使用示例：
```batch
# 处理D盘的project文件夹
convert.bat "D:\project"

# 处理当前目录下的myfiles文件夹  
convert.bat "C:\Users\Username\myfiles"
```

### 具体处理流程

#### 1. 图片转换（mobile和thumb文件夹）
- 扫描 `.jpg` 文件
- 使用ImageMagick的 `identify` 命令检测颜色数量
- 根据颜色数量选择压缩参数：
  - 颜色 < 256：使用 `convert -colors 8` 
  - 颜色 ≥ 256：使用 `convert -colors 32`
- 转换完成后删除原始 `.jpg` 文件

#### 2. 文件清理
删除以下文件和文件夹：
- `files\extfiles\` 文件夹
- `files\mobile-ext\` 文件夹  
- `mobile\style\icon\` 文件夹
- `mobile\style\raw\` 文件夹
- 多个CSS和JS文件

### 使用前提条件

1. **安装ImageMagick**：脚本使用 `convert` 和 `identify` 命令
2. **文件夹结构匹配**：目标文件夹需要有相应的子文件夹结构
3. **管理员权限**：可能需要管理员权限来删除某些文件

[run](./file/run.bat)