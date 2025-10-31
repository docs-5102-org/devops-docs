---
title:  Gitea 关闭面板的注册功能
category:
  - Linux系统
tag:
  - 计划任务
  - 自动化
  - CI/CD
  - 持续集成
  - 持续交付
  - gitea
date: 2023-09-17
---

# Gitea 关闭面板的注册功能

## 目录

[[toc]]

## ✅ 方法一：直接禁用注册

1. 找到你的 `app.ini` 配置文件，通常路径在：
   * `/etc/gitea/app.ini`
   * 或者如果使用 Docker，在 `/your_path/data/gitea/conf/app.ini`（或 `custom/conf/app.ini`）([docs.gitea.com][1], [ihave.news][2])。
  

2. 编辑`app.ini`，找到 `[service]` 模块，添加或修改以下两项：

```ini
[service]
DISABLE_REGISTRATION = true
```  

3. 保存文件后，重启 Gitea 服务（如 Docker 重启容器）([ihave.news][2])。

这样设置后：

* 网站将不允许用户自助注册；
* 只有管理员可以手动创建账户。

---

  

## ⚙️ 方法二：使用后台设置（首次安装时）

  

在 Gitea 的安装初始页面，你可以在 “Optional settings” 中勾选 **Disable Self‑Registration**（关闭自助注册）([dizzytech.de][3])。如果已经安装完毕，需要使用方法一直接编辑配置。

<img src="/assets/images/Pasted%20image%2020250615112147.png" style="width: auto;"></img>

---

  

## 🛡️ 选项扩展 & 安全建议

* 如果想在允许注册的情况下进行审核，可以使用：

```ini
  [service]
  REGISTER_MANUAL_CONFIRM = true
  DISABLE_REGISTRATION = false
```  


  这样注册后需管理员审批，且 `REGISTER_EMAIL_CONFIRM` 必须关闭 ([forum.gitea.com][4])。

  

* 为进一步防止滥用，还可以配置如 `EMAIL_DOMAIN_ALLOWLIST`、`DEFAULT_USER_IS_RESTRICTED` 等高级选项 ([forum.cloudron.io][5])。

  

---



[1]: https://docs.gitea.com/zh-cn/administration/config-cheat-sheet "配置说明"
[2]: https://ihave.news/post/20240816161800.html "Docker Gitea关闭用户注册 - 天澄拾光"
[3]: https://dizzytech.de/posts/gitea "Host your own Git Service with Gitea - DizzyTech"
[4]: https://forum.gitea.com/t/how-can-i-require-admin-approval/2783 "How can I require admin approval? - Install/Maintain/Configure - Gitea"
[5]: https://forum.cloudron.io/topic/12186/prevent-external-users-joining-gitea-instance "Prevent external users joining gitea instance - Cloudron Forum"