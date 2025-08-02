---
title: 入门教程
category:
  - 脚本开发
tag:
  - Shell
  - BAT
date: 2022-07-10

---

# BAT入门教程

## 目录

[[toc]]

## 简介

BAT（批处理）脚本是Windows系统中的一种脚本语言，可以通过编写简单的命令来自动化执行系统任务。本教程将介绍BAT脚本的基础语法和常用功能。

## 基本命令

### Echo命令 - 控制回显

Echo命令用于打开或关闭回显功能，或显示文本信息。

**语法格式：**
```bat
echo [{ on|off }]
echo 要显示的文本
```

**示例：**
```bat
@echo off  # 关闭命令回显，@符号防止显示该命令本身
echo Hello World!  # 显示文本
pause  # 暂停等待用户按键
```

## 变量操作

### 1. 定义普通变量

```bat
set var=value
echo %var%
```

### 2. 定义数字变量

使用`set /a`可以定义数字变量并进行数学运算：

```bat
set /a str3=0
echo %str3%

# 数学运算示例
set /a num1=10
set /a num2=20
set /a result=%num1%+%num2%
echo 结果是：%result%
```

### 3. 交互式输入

使用`set /p`可以让用户输入变量值：

```bat
@echo off
echo Please input the username
set /p user=
echo 您输入的用户名是：%user%
pause
```

### 4. 执行外部命令并赋值变量

可以将外部命令的执行结果赋值给变量：

```bat
for /f "delims=" %%t in ('命令字符串') do set str=%%t
echo %str%
```

**注意事项：**
- 当命令字符串中包含`%`符号时，需要使用`%%`进行转义
- 示例：获取图片尺寸信息

```bat
for /f "delims=" %%t in ('identify -format %%wx%%h demo.jpg') do set str=%%t
echo 图片尺寸：%str%
```

## FOR循环中的文件路径变量

在FOR循环中处理文件路径时，可以使用特殊的变量修饰符：

- `%%~ni` - 代表文件名（不含扩展名）
- `%%~xi` - 代表文件扩展名
- `%%~nxi` - 代表完整文件名（含扩展名）

**示例：**
```bat
@echo off
set var=f:\111\abc\文件名.扩展名
for /f "delims=" %%i in ("%var%") do (
    echo 文件名：%%~ni
    echo 扩展名：%%~xi
    echo 完整文件名：%%~nxi
)
pause
```

## 进程管理

### Windows系统杀死进程

使用`taskkill`命令可以强制结束进程：

```bat
# 根据进程名结束进程
taskkill /F /im 进程名.exe

# 示例
taskkill /F /im frontpg.exe
taskkill /F /im chromedriver.exe
```

**参数说明：**
- `/F` - 强制结束进程
- `/im` - 指定进程映像名称

### Linux系统杀死进程（对比参考）

```bash
# 批量杀死包含特定关键字的进程
ps aux|grep python|grep -v grep|cut -c 9-15|xargs kill -15

# 命令解析：
# ps aux - 查看所有进程
# grep python - 筛选包含python的进程
# grep -v grep - 排除grep进程本身
# cut -c 9-15 - 提取进程ID
# xargs kill -15 - 正常结束进程（-9为强制结束）
```

## 中文编码问题解决

在编写包含中文字符的BAT脚本时，经常会遇到乱码问题。

**解决方法：**
1. 右键点击bat文件，选择"编辑"打开
2. 另存为时，将编码格式从UTF-8改为ANSI格式
3. 保存后重新运行脚本即可正常显示中文

## 实用工具函数

以下是一些常用的字符串处理函数（VBScript风格，可在bat中调用）：

```vbscript
Function ENumber(str) '提取数字
    Dim i
    ENumber = ""
    For i = 1 To Len(str)
        If 58 > Asc(Mid(str, i, 1)) > 47 Then
            ENumber = ENumber & Mid(str, i, 1)
        End If
    Next
End Function

Function EChinese(str) '提取中文
    Dim i
    EChinese = ""
    For i = 1 To Len(str)
        If -2049 > Asc(Mid(str, i, 1)) > -20320 Then
            EChinese = EChinese & Mid(str, i, 1)
        End If
    Next
End Function

Function ELetter(str) '提取所有大小写字母
    Dim i
    ELetter = ""
    For i = 1 To Len(str)
        If 91 > Asc(Mid(str, i, 1)) > 64 Or 123 > Asc(Mid(str, i, 1)) > 96 Then
            ELetter = ELetter & Mid(str, i, 1)
        End If
    Next
End Function
```

## 常用语法结构

### 条件判断
```bat
if exist 文件名 (
    echo 文件存在
) else (
    echo 文件不存在
)
```

### 循环结构
```bat
# FOR循环遍历文件
for %%f in (*.txt) do (
    echo 处理文件：%%f
)

# FOR循环遍历数字范围
for /l %%i in (1,1,10) do (
    echo 数字：%%i
)
```

## 最佳实践

1. **总是使用 `@echo off`** - 在脚本开头关闭命令回显，让输出更清洁
2. **添加 `pause` 命令** - 在脚本末尾添加暂停，方便查看执行结果
3. **注意编码格式** - 包含中文时使用ANSI编码
4. **错误处理** - 使用条件判断检查关键操作的执行结果
5. **注释说明** - 使用 `rem` 或 `::` 添加注释说明

```bat
@echo off
rem 这是注释
:: 这也是注释
echo 脚本开始执行
pause
```

## 总结

BAT脚本虽然功能相对简单，但在Windows系统管理和自动化任务中非常实用。掌握变量操作、循环结构、进程管理等基本技能，就能编写出实用的自动化脚本。建议在实际应用中多加练习，逐步提高脚本编写水平。

## 参考资源

- 基本命令语法：[CSDN教程](https://blog.csdn.net/tuoni123/article/details/106524631)
- 基本符号语法：[CSDN教程](https://blog.csdn.net/tuoni123/article/details/106525706)
- 函数命令语法：[博客园教程](https://www.cnblogs.com/LiuYanYGZ/p/10984375.html)