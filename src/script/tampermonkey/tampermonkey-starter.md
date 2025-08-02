---
title: 入门教程
category:
  - 脚本开发
tag:
  - 油猴脚本
date: 2023-02-10

---

# 油猴脚本入门教程

## 目录

[[toc]]

## 什么是Tampermonkey

Tampermonkey（油猴）是一个用户脚本管理器，允许用户在网页上运行JavaScript脚本来修改页面行为、添加新功能或自动化操作。它是最流行的用户脚本管理器之一，支持Chrome、Firefox、Safari、Edge等主流浏览器。

### 主要功能
- **网页功能增强**：为网站添加新功能
- **广告拦截**：去除页面广告和无用元素
- **自动化操作**：自动填表、自动点击等
- **界面美化**：修改网页样式和布局
- **数据提取**：从网页中提取有用信息

## 安装和配置

### 1. 安装Tampermonkey
- **Chrome**：访问Chrome Web Store搜索"Tampermonkey"
- **Firefox**：访问Firefox Add-ons搜索"Tampermonkey"
- **Edge**：访问Microsoft Edge Add-ons搜索"Tampermonkey"
- **Safari**：从App Store下载安装

### 2. 基本配置
1. 安装完成后，浏览器工具栏会出现Tampermonkey图标
2. 点击图标，选择"管理面板"进入主界面
3. 在"设置"中可以调整脚本运行模式、更新频率等

### 3. 界面介绍
- **已安装脚本**：显示所有已安装的用户脚本
- **获取新脚本**：链接到脚本分享网站
- **实用工具**：提供各种实用功能
- **设置**：配置Tampermonkey选项

## 基础概念

### 用户脚本（UserScript）
用户脚本是运行在网页上的JavaScript代码，通过特定的元数据头部来定义脚本的运行条件和权限。

### 脚本生命周期
1. **加载**：浏览器访问匹配的网页
2. **注入**：脚本被注入到页面中
3. **执行**：脚本开始运行
4. **监听**：监听页面事件和变化

### 运行时机
- **document-start**：HTML文档开始加载时
- **document-body**：HTML body元素出现时
- **document-end**：DOM构建完成时（默认）
- **document-idle**：页面完全加载后

## 脚本结构详解

### 基本结构
```javascript
// ==UserScript==
// @name         脚本名称
// @namespace    命名空间
// @version      版本号
// @description  脚本描述
// @author       作者
// @match        匹配网址
// @grant        权限声明
// ==/UserScript==

(function() {
    'use strict';
    
    // 脚本代码
    console.log('Hello Tampermonkey!');
})();
```

### 重要元数据标签

#### @name
脚本的显示名称，支持多语言：
```javascript
// @name         My Script
// @name:zh-CN   我的脚本
// @name:en      My Script
```

#### @match 和 @include
定义脚本运行的网页：
```javascript
// @match        https://example.com/*
// @match        https://*.google.com/*
// @include      /^https?://.*\.example\.com/.*$/
```

#### @exclude
排除特定网页：
```javascript
// @exclude      https://example.com/admin/*
```

#### @grant
声明脚本需要的权限：
```javascript
// @grant        GM_setValue
// @grant        GM_getValue
// @grant        GM_xmlhttpRequest
// @grant        none
```

#### @require
引入外部库：
```javascript
// @require      https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js
```

#### @resource
定义外部资源：
```javascript
// @resource     myCSS https://example.com/style.css
```

## 常用API和方法

### GM_* API

#### 数据存储
```javascript
// 存储数据
GM_setValue('key', 'value');

// 读取数据
const value = GM_getValue('key', 'defaultValue');

// 删除数据
GM_deleteValue('key');

// 列出所有键
const keys = GM_listValues();
```

#### HTTP请求
```javascript
GM_xmlhttpRequest({
    method: 'GET',
    url: 'https://api.example.com/data',
    headers: {
        'User-Agent': 'MyScript/1.0'
    },
    onload: function(response) {
        console.log(response.responseText);
    },
    onerror: function(error) {
        console.error('请求失败:', error);
    }
});
```

#### 样式操作
```javascript
// 添加CSS样式
GM_addStyle(`
    .my-custom-class {
        background-color: #f0f0f0;
        border: 1px solid #ccc;
    }
`);
```

#### 菜单注册
```javascript
// 注册右键菜单
GM_registerMenuCommand('执行操作', function() {
    alert('菜单被点击了！');
});
```

#### 通知系统
```javascript
// 显示通知
GM_notification({
    text: '操作完成！',
    title: '提示',
    timeout: 3000
});
```

### 页面操作

#### DOM操作
```javascript
// 等待元素出现
function waitForElement(selector, timeout = 10000) {
    return new Promise((resolve, reject) => {
        const startTime = Date.now();
        
        function check() {
            const element = document.querySelector(selector);
            if (element) {
                resolve(element);
            } else if (Date.now() - startTime > timeout) {
                reject(new Error(`元素 ${selector} 未找到`));
            } else {
                setTimeout(check, 100);
            }
        }
        
        check();
    });
}

// 使用示例
waitForElement('.target-class').then(element => {
    element.click();
});
```

#### 事件监听
```javascript
// 监听页面变化
const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (mutation.type === 'childList') {
            console.log('页面内容发生变化');
        }
    });
});

observer.observe(document.body, {
    childList: true,
    subtree: true
});
```

## 实战案例

### 案例1：自动签到脚本
```javascript
// ==UserScript==
// @name         自动签到助手
// @namespace    auto-checkin
// @version      1.0
// @description  自动完成网站签到
// @match        https://example.com/*
// @grant        GM_setValue
// @grant        GM_getValue
// ==/UserScript==

(function() {
    'use strict';
    
    // 检查今天是否已签到
    const today = new Date().toDateString();
    const lastCheckin = GM_getValue('lastCheckin', '');
    
    if (lastCheckin === today) {
        console.log('今天已经签到过了');
        return;
    }
    
    // 查找签到按钮
    const checkinBtn = document.querySelector('.checkin-btn');
    if (checkinBtn && !checkinBtn.disabled) {
        // 随机延迟1-5秒后点击
        const delay = Math.random() * 4000 + 1000;
        setTimeout(() => {
            checkinBtn.click();
            GM_setValue('lastCheckin', today);
            console.log('自动签到完成');
        }, delay);
    }
})();
```

### 案例2：广告屏蔽脚本
```javascript
// ==UserScript==
// @name         广告屏蔽器
// @namespace    ad-blocker
// @version      1.0
// @description  移除页面广告
// @match        https://example.com/*
// @grant        GM_addStyle
// ==/UserScript==

(function() {
    'use strict';
    
    // CSS方式隐藏广告
    GM_addStyle(`
        .ad-banner,
        .advertisement,
        [class*="ad-"],
        [id*="ad-"],
        iframe[src*="ads"] {
            display: none !important;
        }
    `);
    
    // JavaScript方式移除广告
    function removeAds() {
        const adSelectors = [
            '.ad-container',
            '.banner-ad',
            '.popup-ad'
        ];
        
        adSelectors.forEach(selector => {
            const ads = document.querySelectorAll(selector);
            ads.forEach(ad => ad.remove());
        });
    }
    
    // 页面加载完成后执行
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', removeAds);
    } else {
        removeAds();
    }
    
    // 监听动态添加的广告
    const observer = new MutationObserver(removeAds);
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
})();
```

### 案例3：网页功能增强
```javascript
// ==UserScript==
// @name         网页功能增强
// @namespace    page-enhancer
// @version      1.0
// @description  为网页添加实用功能
// @match        https://example.com/*
// @grant        GM_addStyle
// @grant        GM_registerMenuCommand
// ==/UserScript==

(function() {
    'use strict';
    
    // 添加返回顶部按钮
    function addBackToTop() {
        const btn = document.createElement('div');
        btn.innerHTML = '↑';
        btn.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            background: #007bff;
            color: white;
            border-radius: 25px;
            text-align: center;
            line-height: 50px;
            cursor: pointer;
            font-size: 20px;
            z-index: 9999;
            display: none;
        `;
        
        btn.onclick = () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        };
        
        document.body.appendChild(btn);
        
        // 监听滚动事件
        window.addEventListener('scroll', () => {
            btn.style.display = window.pageYOffset > 300 ? 'block' : 'none';
        });
    }
    
    // 添加快捷键支持
    function addHotkeys() {
        document.addEventListener('keydown', (e) => {
            // Ctrl + J: 跳转到页面底部
            if (e.ctrlKey && e.key === 'j') {
                e.preventDefault();
                window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
            }
            
            // Ctrl + K: 跳转到页面顶部
            if (e.ctrlKey && e.key === 'k') {
                e.preventDefault();
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }
        });
    }
    
    // 注册菜单命令
    GM_registerMenuCommand('切换夜间模式', () => {
        document.body.style.filter = 
            document.body.style.filter === 'invert(1)' ? '' : 'invert(1)';
    });
    
    // 初始化功能
    addBackToTop();
    addHotkeys();
})();
```

## 进阶技巧

### 1. 异步处理
```javascript
// 使用async/await处理异步操作
async function fetchData(url) {
    return new Promise((resolve, reject) => {
        GM_xmlhttpRequest({
            method: 'GET',
            url: url,
            onload: response => resolve(JSON.parse(response.responseText)),
            onerror: error => reject(error)
        });
    });
}

// 使用示例
(async function() {
    try {
        const data = await fetchData('https://api.example.com/data');
        console.log(data);
    } catch (error) {
        console.error('获取数据失败:', error);
    }
})();
```

### 2. 配置管理
```javascript
// 创建配置管理系统
const Config = {
    defaults: {
        autoRun: true,
        delay: 3000,
        theme: 'light'
    },
    
    get(key) {
        return GM_getValue(key, this.defaults[key]);
    },
    
    set(key, value) {
        GM_setValue(key, value);
    },
    
    reset() {
        Object.keys(this.defaults).forEach(key => {
            GM_deleteValue(key);
        });
    }
};
```

### 3. 模块化开发
```javascript
// 工具模块
const Utils = {
    // 防抖函数
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },
    
    // 节流函数
    throttle(func, limit) {
        let inThrottle;
        return function() {
            const args = arguments;
            const context = this;
            if (!inThrottle) {
                func.apply(context, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    },
    
    // 随机延迟
    randomDelay(min = 1000, max = 3000) {
        return new Promise(resolve => {
            const delay = Math.random() * (max - min) + min;
            setTimeout(resolve, delay);
        });
    }
};
```

### 4. 错误处理
```javascript
// 全局错误处理
window.addEventListener('error', (e) => {
    console.error('脚本错误:', e.error);
    // 可以选择上报错误或显示友好提示
});

// 包装函数执行
function safeExecute(func, ...args) {
    try {
        return func.apply(this, args);
    } catch (error) {
        console.error('函数执行失败:', error);
        return null;
    }
}
```

## 调试和发布

### 调试技巧

#### 1. 控制台调试
```javascript
// 使用console.group组织日志
console.group('脚本初始化');
console.log('配置加载完成');
console.log('事件监听器已注册');
console.groupEnd();

// 使用console.table显示表格数据
console.table([
    { name: '设置A', value: 'true', type: 'boolean' },
    { name: '设置B', value: '100', type: 'number' }
]);
```

#### 2. 性能监控
```javascript
// 监控函数执行时间
function performanceTest(func, name) {
    return function(...args) {
        const start = performance.now();
        const result = func.apply(this, args);
        const end = performance.now();
        console.log(`${name} 执行时间: ${end - start}ms`);
        return result;
    };
}
```

### 脚本优化

#### 1. 内存管理
```javascript
// 及时清理事件监听器
const controller = new AbortController();

document.addEventListener('click', handler, {
    signal: controller.signal
});

// 在适当时机清理
// controller.abort();
```

#### 2. 性能优化
```javascript
// 使用requestAnimationFrame优化动画
function smoothScroll(target) {
    const start = window.pageYOffset;
    const distance = target - start;
    const duration = 500;
    let startTime = null;
    
    function animation(currentTime) {
        if (startTime === null) startTime = currentTime;
        const timeElapsed = currentTime - startTime;
        const progress = Math.min(timeElapsed / duration, 1);
        
        window.scrollTo(0, start + distance * easeInOutQuad(progress));
        
        if (progress < 1) {
            requestAnimationFrame(animation);
        }
    }
    
    requestAnimationFrame(animation);
}

function easeInOutQuad(t) {
    return t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
}
```

### 发布和分享

#### 1. 脚本信息完善
确保元数据完整：
```javascript
// ==UserScript==
// @name         脚本名称
// @name:zh-CN   中文名称
// @namespace    http://tampermonkey.net/
// @version      1.0.0
// @description  详细的脚本描述
// @description:zh-CN  中文描述
// @author       作者名
// @match        https://example.com/*
// @icon         https://example.com/favicon.ico
// @homepage     https://github.com/username/script
// @supportURL   https://github.com/username/script/issues
// @updateURL    https://example.com/script.meta.js
// @downloadURL  https://example.com/script.user.js
// @grant        GM_setValue
// @grant        GM_getValue
// @license      MIT
// ==/UserScript==
```

#### 2. 版本管理
- 使用语义化版本号（1.0.0）
- 在@updateURL中提供元数据文件
- 记录更新日志

#### 3. 分享平台
- [Greasy Fork](https://greasyfork.org/) - 最大的用户脚本分享平台
- [OpenUserJS](https://openuserjs.org/) - 开源用户脚本平台
- GitHub - 代码托管和协作

## 学习资源

### 官方资源
- [Tampermonkey官网](https://www.tampermonkey.net/)
- [油猴中文网](https://bbs.tampermonkey.net.cn/)
- [油猴脚本开发指南](https://bbs.tampermonkey.net.cn/thread-184-1-1.html)

### 第三方教程
- [CSDN教程1](https://blog.csdn.net/wangmx1993328/article/details/128649406)
- [CSDN教程2](https://blog.csdn.net/mukes/article/details/109727662)
- [CSDN教程3](https://blog.csdn.net/m0_59236602/article/details/124574318)

### 推荐书籍和文档
- MDN Web API文档
- JavaScript高级程序设计
- 浏览器扩展开发指南

### 社区和论坛
- Stack Overflow
- Reddit r/userscripts
- 油猴中文社区

### 实用工具
- **脚本编辑器**：VS Code + Tampermonkey Extension
- **调试工具**：浏览器开发者工具
- **代码格式化**：Prettier
- **代码检查**：ESLint

## 常见问题解答

### Q1: 脚本不生效怎么办？
- 检查@match规则是否正确
- 确认脚本已启用
- 查看浏览器控制台是否有错误信息
- 检查页面加载时机

### Q2: 如何处理跨域请求？
使用GM_xmlhttpRequest而不是fetch或XMLHttpRequest：
```javascript
GM_xmlhttpRequest({
    method: 'GET',
    url: 'https://api.example.com/data',
    onload: function(response) {
        // 处理响应
    }
});
```

### Q3: 脚本运行太慢怎么优化？
- 减少DOM查询次数
- 使用事件委托
- 避免不必要的循环
- 合理使用防抖和节流

### Q4: 如何保护用户隐私？
- 明确声明脚本功能
- 最小化权限申请
- 不收集不必要的数据
- 提供隐私设置选项

## 结语

Tampermonkey是一个强大的工具，可以让我们自定义网页体验，提高工作效率。通过本教程，您应该已经掌握了从基础到进阶的用户脚本开发技能。

记住，编写用户脚本时要：
- 遵守网站的使用条款
- 尊重用户隐私
- 编写高质量、可维护的代码
- 与社区分享有用的脚本

继续探索和学习，您将能够创建出更多有趣和实用的用户脚本！