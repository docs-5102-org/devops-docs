---
title: vi/vim编辑器命令
category:
  - Linux
  - 文本处理
tag:
  - vi
  - vim
  - 编辑器
  - 文本编辑
date: 2022-08-11

---

# vi/vim编辑器命令

## 概述

`vi` 是 Linux 系统中最经典和广泛使用的文本编辑器之一，而 `vim`（Vi IMproved）是 vi 的增强版本。它是一个功能强大的字符界面文本编辑工具，能够编辑任何 ASCII 格式文件，支持创建、查找、替换、修改、删除、复制、粘贴等各种文本操作。


### 特点
- 轻量级，启动速度快
- 在所有 Unix/Linux 系统中都可用
- 强大的文本处理能力
- 支持正则表达式
- 可扩展性强
- 支持语法高亮和自动缩进
- 学习 vim 并且其会成为你最后一个使用的文本编辑器

## 安装

### Ubuntu/Debian 系统
```bash
# 安装完整版 vim
sudo apt-get install vim-full

# 或者安装基础版本
sudo apt-get install vim
```

### CentOS/RHEL 系统
```bash
# 安装 vim
sudo yum install vim

# 或者使用 dnf (较新版本)
sudo dnf install vim
```

## 语法格式

```bash
vi [参数] 文件名
vim [参数] 文件名
```

## 命令行参数

| 参数 | 功能描述 |
|------|----------|
| `-s` | 静默模式 |
| `--cmd<命令>` | 加载任何 vimrc 文件之前执行指定命令 |
| `-R` | 只读模式 |
| `-v` | Vi 模式 |
| `-e` | Ex 模式 |
| `-y` | 简易模式 |
| `-c<命令>` | 加载第一个文件之后执行指定命令 |
| `-s<脚本输入文件>` | 从指定脚本输入文件阅读普通模式命令 |
| `-w<脚本输出文件>` | 追加所有类型的命令写入脚本输出文件 |
| `-W<脚本输出文件>` | 写入所有类型的命令到指定脚本输出文件 |
| `+<行数>` | 从指定行开始 |
| `--noplugin` | 不要加载插件脚本 |
| `-p<数量>` | 打开指定数量的标签页（带文件名） |
| `-r<文件名>` | 恢复崩溃的会话 |
| `-L` | 等同于 -r |
| `-r` | 列出交换文件并退出 |
| `-u<vimrc>` | 使用指定 vimrc，而不是 .vimrc |
| `-T<终端>` | 设置使用指定终端 |
| `-o<数量>` | 打开指定数量的窗口 |
| `-n` | 不使用交换文件，只用内存 |
| `-Z` | 受限模式 |
| `-m` | 不允许修改（写入） |
| `-b` | 二进制模式 |
| `-M` | 在文本中不允许修改 |

## Vi/Vim 的三种模式

### 1. 命令模式（Normal Mode）
这是 vi 的默认模式，用于执行各种编辑命令。启动 vim 后默认处于此模式。

#### 基本光标移动
| 命令 | 功能 |
|------|------|
| `h` | 光标左移一个字符 |
| `j` | 光标下移一行（像下箭头） |
| `k` | 光标上移一行 |
| `l` | 光标右移一个字符 |
| `w` | 光标移到下一个单词开头 |
| `e` | 光标移到下一个单词结尾 |
| `b` | 光标移到上一个单词开头 |
| `0` | 光标移到行首 |
| `^` | 光标移到本行第一个非空白字符 |
| `$` | 光标移到行尾 |
| `g_` | 光标移到本行最后一个非空白字符 |
| `G` | 光标移到文件末尾 |
| `gg` | 光标移到文件开头 |
| `:<行号>` | 跳转到指定行 |
| `NG` | 跳转到第 N 行 |

#### 高级光标移动
| 命令 | 功能 |
|------|------|
| `f<字符>` | 在当前行向前查找指定字符 |
| `F<字符>` | 在当前行向后查找指定字符 |
| `t<字符>` | 移动到指定字符前一个位置 |
| `T<字符>` | 向后移动到指定字符后一个位置 |
| `*` | 查找光标所在单词的下一个匹配 |
| `#` | 查找光标所在单词的上一个匹配 |
| `%` | 匹配括号移动（包括 (), {}, []） |
| `;` | 重复上次的 f, t, F, T 命令 |
| `,` | 反向重复上次的 f, t, F, T 命令 |

#### 删除命令
| 命令 | 功能 |
|------|------|
| `x` | 删除光标所在字符 |
| `X` | 删除光标前一个字符 |
| `dd` | 删除当前行 |
| `dw` | 删除一个单词 |
| `d$` | 删除到行尾 |
| `d0` | 删除到行首 |
| `<n>dd` | 删除 n 行 |
| `dt<字符>` | 删除到指定字符前 |
| `df<字符>` | 删除到指定字符（包含该字符） |

#### 复制和粘贴
| 命令 | 功能 |
|------|------|
| `yy` | 复制当前行 |
| `yw` | 复制一个单词 |
| `y$` | 复制到行尾 |
| `y0` | 复制到行首 |
| `<n>yy` | 复制 n 行 |
| `p` | 在光标后粘贴 |
| `P` | 在光标前粘贴 |

#### 撤销和重做
| 命令 | 功能 |
|------|------|
| `u` | 撤销上一次操作 |
| `U` | 撤销对当前行的所有修改 |
| `Ctrl+r` | 重做 |
| `.` | 重复上一次命令 |

#### 重复操作
| 命令 | 功能 |
|------|------|
| `N<命令>` | 重复命令 N 次 |
| `2dd` | 删除 2 行 |
| `3p` | 粘贴 3 次 |
| `100idesu [ESC]` | 插入 "desu" 100 次 |
| `.` | 重复上一个命令 |
| `3.` | 重复上一个命令 3 次 |

### 2. 插入模式（Insert Mode）
用于输入和编辑文本内容。

#### 进入插入模式
| 命令 | 功能 |
|------|------|
| `i` | 在光标前插入 |
| `I` | 在行首插入 |
| `a` | 在光标后插入 |
| `A` | 在行尾插入 |
| `o` | 在当前行下方新建一行并插入 |
| `O` | 在当前行上方新建一行并插入 |
| `s` | 删除光标字符并插入 |
| `S` | 删除整行并插入 |
| `cw` | 替换从光标到单词结尾的字符 |

#### 插入模式下的特殊功能
| 命令 | 功能 |
|------|------|
| `Ctrl+n` | 自动补全（下一个匹配） |
| `Ctrl+p` | 自动补全（上一个匹配） |
| `Ctrl+x Ctrl+l` | 整行补全 |
| `Ctrl+x Ctrl+f` | 文件名补全 |

#### 退出插入模式
- 按 `Esc` 键返回命令模式

### 3. 命令行模式（Command-line Mode）
用于执行复杂的编辑命令和文件操作。

#### 进入命令行模式
- 在命令模式下按 `:` 进入

#### 文件操作
| 命令 | 功能 |
|------|------|
| `:w` | 保存文件 |
| `:w <文件名>` | 另存为指定文件 |
| `:q` | 退出 vi |
| `:q!` | 强制退出，不保存 |
| `:wq` | 保存并退出 |
| `:x` | 保存并退出（同 :wq） |
| `ZZ` | 保存并退出（不需要输入冒号） |
| `:e <文件名>` | 打开指定文件 |
| `:r <文件名>` | 读入指定文件内容 |
| `:saveas <文件名>` | 另存为 |

#### 查找和替换
| 命令 | 功能 |
|------|------|
| `/<关键词>` | 向下搜索关键词 |
| `?<关键词>` | 向上搜索关键词 |
| `n` | 重复上次搜索 |
| `N` | 反向重复上次搜索 |
| `:s/old/new` | 替换当前行第一个 old 为 new |
| `:s/old/new/g` | 替换当前行所有 old 为 new |
| `:%s/old/new/g` | 替换全文所有 old 为 new |
| `:%s/old/new/gc` | 替换全文所有 old 为 new（需确认） |
| `:nohl` | 取消搜索高亮 |

#### 行号和显示
| 命令 | 功能 |
|------|------|
| `:set nu` | 显示行号 |
| `:set nonu` | 隐藏行号 |
| `:set hlsearch` | 高亮搜索结果 |
| `:set nohlsearch` | 取消搜索高亮 |

## 高级功能

### 可视化选择模式（Visual Mode）
| 命令 | 功能 |
|------|------|
| `v` | 字符可视化选择 |
| `V` | 行可视化选择 |
| `Ctrl+v` | 块可视化选择 |
| `gv` | 重新选择上次的可视化区域 |

#### 可视化模式下的操作
| 命令 | 功能 |
|------|------|
| `d` | 删除选中内容 |
| `y` | 复制选中内容 |
| `c` | 更改选中内容 |
| `>` | 右缩进 |
| `<` | 左缩进 |
| `=` | 自动缩进 |
| `J` | 合并选中的行 |
| `u` | 转换为小写 |
| `U` | 转换为大写 |

### 区域选择
使用格式：`<action>a<object>` 或 `<action>i<object>`

- `action` 可以是：`d`（删除）、`y`（复制）、`c`（更改）、`v`（选择）
- `object` 可以是：`w`（单词）、`s`（句子）、`p`（段落）、`"`（双引号）、`'`（单引号）、`)`（圆括号）、`}`（花括号）、`]`（方括号）

例如：
- `vi"` → 选择双引号内的内容
- `va"` → 选择包含双引号的内容
- `di(` → 删除圆括号内的内容
- `ya{` → 复制包含花括号的内容

### 块操作
块操作用于在多行的相同列位置进行编辑：

1. `Ctrl+v` → 进入块选择模式
2. 使用方向键选择块区域
3. `I` → 在选中块的开头插入内容
4. `A` → 在选中块的末尾追加内容
5. 输入内容后按 `Esc` 应用到所有选中行

### 宏录制
| 命令 | 功能 |
|------|------|
| `q<字母>` | 开始录制宏到指定寄存器 |
| `q` | 停止录制宏 |
| `@<字母>` | 执行指定寄存器的宏 |
| `@@` | 重复执行上次的宏 |
| `<n>@<字母>` | 执行宏 n 次 |

### 分屏操作
| 命令 | 功能 |
|------|------|
| `:split` 或 `:sp` | 水平分屏 |
| `:vsplit` 或 `:vsp` | 垂直分屏 |
| `:split <文件名>` | 分屏并打开文件 |
| `Ctrl+w+w` | 循环切换窗口 |
| `Ctrl+w+h/j/k/l` | 切换到指定方向的窗口 |
| `Ctrl+w+_` | 最大化当前窗口高度 |
| `Ctrl+w+\|` | 最大化当前窗口宽度 |
| `Ctrl+w+=` | 均分窗口大小 |
| `Ctrl+w+c` | 关闭当前窗口 |

### 标签页操作
| 命令 | 功能 |
|------|------|
| `:tabnew` | 新建标签页 |
| `:tabnew <文件名>` | 在新标签页打开文件 |
| `:tabclose` | 关闭当前标签页 |
| `:tabnext` 或 `gt` | 下一个标签页 |
| `:tabprev` 或 `gT` | 上一个标签页 |
| `:tabfirst` | 第一个标签页 |
| `:tablast` | 最后一个标签页 |

### 多文件编辑
```bash
# 同时打开多个文件
vi file1.txt file2.txt file3.txt

# 在 vi 中切换文件
:n          # 下一个文件
:prev       # 上一个文件
:first      # 第一个文件
:last       # 最后一个文件
:bn         # 下一个缓冲区
:bp         # 上一个缓冲区
```

### 标记和跳转
| 命令 | 功能 |
|------|------|
| `m<字母>` | 在当前位置设置标记 |
| `'<字母>` | 跳转到指定标记的行首 |
| `` `<字母> `` | 跳转到指定标记的精确位置 |
| `''` | 跳转到上次跳转前的位置 |
| ``` `` ``` | 跳转到上次编辑的位置 |

## 配置文件和语法高亮

### 配置文件位置
- **系统全局配置**：`/etc/vim/vimrc` 或 `/etc/vimrc`
- **用户个人配置**：`~/.vimrc`

### 语法高亮设置

#### 方法一：临时启用
在命令模式下输入：
```vim
:syntax on
```
或者
```vim
:syntax enable
```

#### 方法二：永久启用
1. 编辑配置文件：
```bash
sudo vim /etc/vim/vimrc
```

2. 添加以下内容：
```vim
" 启用语法高亮
syntax on
```

3. 如果语法高亮仍然不生效，在 `/etc/profile` 中添加：
```bash
export TERM=xterm-color
```

### 自动缩进配置

在 `.vimrc` 文件中添加以下配置：

```vim
" ========== 基本设置 ==========
" 显示行号
set number

" 启用语法高亮
syntax on

" 启用文件类型检测
filetype on
filetype plugin on
filetype indent on

" ========== 缩进设置 ==========
" 设置制表符宽度为 4
set tabstop=4

" 设置软制表符宽度为 4
set softtabstop=4

" 设置缩进宽度为 4
set shiftwidth=4

" 使用空格替代制表符
set expandtab

" 自动缩进
set autoindent

" 智能缩进
set smartindent

" C/C++ 语言缩进
set cindent

" C/C++ 语言缩进选项
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s

" ========== 搜索设置 ==========
" 搜索时高亮显示
set hlsearch

" 搜索时实时匹配
set incsearch

" 搜索时忽略大小写
set ignorecase

" 智能搜索（有大写字母时不忽略大小写）
set smartcase

" ========== 显示设置 ==========
" 显示匹配的括号
set showmatch

" 显示光标位置
set ruler

" 显示输入的命令
set showcmd

" 启用鼠标
set mouse=a

" 设置编码
set encoding=utf-8
set fileencoding=utf-8

" ========== 其他设置 ==========
" 不创建备份文件
set nobackup

" 不创建交换文件
set noswapfile

" 启用增量搜索
set incsearch

" 设置历史记录数
set history=1000

" 设置撤销级别
set undolevels=1000

" 终端颜色设置
if &term=="xterm"
    set t_Co=8
    set t_Sb=^[[4%dm
    set t_Sf=^[[3%dm
endif
```

### 针对不同语言的配置

```vim
" ========== Python 设置 ==========
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" ========== JavaScript 设置 ==========
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" ========== HTML/CSS 设置 ==========
autocmd FileType html,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" ========== C/C++ 设置 ==========
autocmd FileType c,cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab cindent
```

### 颜色主题设置

```vim
" 设置颜色主题
colorscheme desert

" 或者其他主题
" colorscheme blue
" colorscheme darkblue
" colorscheme default
" colorscheme delek
" colorscheme elflord
" colorscheme evening
" colorscheme industry
" colorscheme koehler
" colorscheme morning
" colorscheme murphy
" colorscheme pablo
" colorscheme peachpuff
" colorscheme ron
" colorscheme shine
" colorscheme slate
" colorscheme torte
" colorscheme zellner
```

## 学习路径和技巧

### 第一级：生存（Survive）
掌握基本的生存技能：
- `i` → 进入插入模式
- `Esc` → 返回命令模式
- `x` → 删除字符
- `:wq` → 保存并退出
- `dd` → 删除行
- `p` → 粘贴
- `hjkl` → 移动光标

### 第二级：感觉良好（Feel comfortable）
掌握更多编辑命令：
- 各种插入模式：`a`, `o`, `O`, `cw`
- 简单移动：`0`, `^`, `$`, `g_`, `/pattern`
- 复制粘贴：`yy`, `p`, `P`
- 撤销重做：`u`, `Ctrl+r`

### 第三级：更好更强更快（Better, stronger, faster）
掌握重复和高效移动：
- `.` → 重复上一个命令
- `N<command>` → 重复命令 N 次
- `NG` → 跳转到第 N 行
- `gg`, `G` → 文件首尾
- 单词移动：`w`, `e`, `b`
- 括号匹配：`%`
- 搜索：`*`, `#`

### 第四级：超能力（Vim superpowers）
掌握高级功能：
- 行内移动：`0`, `^`, `$`, `f`, `t`, `F`, `T`
- 区域选择：`vi"`, `va"`, `vi)`, `va)`
- 块操作：`Ctrl+v`
- 自动补全：`Ctrl+n`, `Ctrl+p`
- 宏录制：`qa...q`, `@a`
- 分屏：`:split`, `:vsplit`

## 实用技巧和快捷操作

### 快速编辑技巧
```vim
" 快速移动
Ctrl+f    # 向下翻页
Ctrl+b    # 向上翻页
Ctrl+d    # 向下翻半页
Ctrl+u    # 向上翻半页

" 快速删除
daw       # 删除一个单词（包括空格）
diw       # 删除一个单词（不包括空格）
das       # 删除一个句子
dap       # 删除一个段落

" 快速更改
caw       # 更改一个单词
cas       # 更改一个句子
cap       # 更改一个段落
```

### 实用组合操作
```vim
" 组合命令示例
0y$       # 复制整行内容
ye        # 复制到单词结尾
y2/foo    # 复制到第二个 "foo" 之间
d2w       # 删除两个单词
c3w       # 更改三个单词
```

### 高效搜索替换
```vim
" 搜索替换技巧
:%s/\<old\>/new/g         # 精确匹配单词替换
:%s/old/new/gc            # 替换时确认
:5,10s/old/new/g          # 指定行范围替换
:.,$s/old/new/g           # 从当前行到文件末尾替换
```

## 使用示例

### 基本使用
```bash
# 创建或编辑文件
vim myfile.txt

# 从指定行开始编辑
vim +10 myfile.txt

# 从匹配的行开始编辑
vim +/pattern myfile.txt

# 以只读模式打开
vim -R myfile.txt

# 同时打开多个文件
vim file1.txt file2.txt file3.txt

# 在不同窗口中打开文件
vim -o file1.txt file2.txt  # 水平分屏
vim -O file1.txt file2.txt  # 垂直分屏
```

### 高级操作示例
```bash
# 执行命令后打开文件
vim -c ":%s/old/new/g" -c ":wq" file.txt

# 从命令行执行多个命令
vim -c "set nu" -c "syntax on" file.txt

# 以二进制模式打开文件
vim -b binaryfile

# 恢复意外关闭的文件
vim -r filename
```

## 常见问题和解决方案

### 1. 意外进入插入模式
**症状**：输入的字符直接显示在屏幕上
**解决方案**：按 `Esc` 键返回命令模式

### 2. 无法保存文件
**可能原因**：
- 文件权限不足
- 磁盘空间不足
- 文件被其他程序占用

**解决方案**：
```bash
:w !sudo tee %    # 以 sudo 权限强制保存
:w! filename      # 强制写入文件
```

### 3. 语法高亮不生效
**解决方案**：
```vim
:syntax on                    # 临时启用
:set filetype=python         # 设置文件类型
:set syntax=python           # 设置语法类型
```

### 4. 自动缩进问题
**解决方案**：
```vim
:set paste          # 粘贴模式，避免自动缩进
:set nopaste        # 退出粘贴模式
:set autoindent     # 启用自动缩进
:set smartindent    # 启用智能缩进
```

### 5. 文件过大导致响应缓慢
**解决方案**：
- 使用 `less` 或 `more` 查看大文件
- 分割大文件后再编辑
- 使用 `vim -n` 不创建交换文件

### 6. 意外关闭终端后恢复编辑
```bash
vim -r filename    # 恢复交换文件
:recover          # 在 vim 中恢复
```

### 7. 中文显示问题
**解决方案**：
```vim
:set encoding=utf-8
:set fileencoding=utf-8
:set termencoding=utf-8
```

## 与其他编辑器的比较

| 特性 | vi/vim | nano | emacs | VS Code |
|------|--------|------|-------|---------|
| 学习曲线 | 陡峭 | 平缓 | 中等 | 平缓 |
| 资源占用 | 低 | 极低 | 中等 | 高 |
| 功能丰富度 | 高 | 低 | 高 | 极高 |
| 可扩展性 | 高 | 低 | 高 | 极高 |
| 系统兼容性 | 优秀 | 良好 | 良好 | 良好 |
| 启动速度 | 快 | 极快 | 慢 | 中等 |
| 插件生态 | 丰富 | 有限 | 丰富 | 极丰富 |

## 推荐学习资源

### 交互式教程
```bash
# Vim 内置教程
vimtutor

# 在线练习
# https://vim-adventures.com/
# https://www.openvim.com/
```

### 参考文档
```bash
# 查看帮助
:help
:help usr_02.txt
:help tips
:help index

# 查看特定命令帮助
:help dd
:help :substitute
:help pattern

# 系统手册
man vim
man vi
```

### 配置文件示例
创建一个基础的 `.vimrc` 配置：

```bash
# 创建配置文件
vim ~/.vimrc
```

复制上面的配置内容，保存后重启 vim 即可生效。

## 总结

Vi/Vim 编辑器虽然学习曲线较陡，但掌握后能大大提高文本编辑效率。它的模式化设计和丰富的命令集使
