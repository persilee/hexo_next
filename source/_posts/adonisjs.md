---
title: 用 Node.js 快速开发出多功能的多人在线的文章分享平台 
tags:
  - node
  - adonis
copyright: true
comments: true
date: 2018-12-17 02:03:27
categories: Node
top: 112
photos:
---

{% li https://cdn.lishaoy.net/adonisjs/adonisjs.png, Adonisjs, Adonisjs %}

最近在学习使用 `nodejs` 框架，边学习边使用，花了大概 **3周** 时间做完这个 **Web应用** 且在 <time>12月16</time> 凌晨左右上线成功（其实就是把开发环境搬到服务器）， 地址： [https://a.lishaoy.net](https://a.lishaoy.net)  

<hr />

<!-- more -->

## Web应用功能

首先，来看看用 **3周** 时间做出来的应用都有些什么功能，之后再看看选用的 `nodejs` 框架，最后看看 `nodejs` 项目如何部署到服务器。

### 登录、注册验证

**登录功能**

- 输入框没有输入点击登录会提示：用户名、密码不能为空
- 输入的用户错误或不存在会提示：用户不存在
- 输入的密码错误会提示：密码错误
- 登录后会重定向到用户上次访问的地址

![no-shadow](https://cdn.lishaoy.net/adonisjs/login.gif "Login" )

**注册功能**

- 输入框没有输入点击注册会提示：用户名、邮箱、密码不能为空
- 用户名和邮箱与其他用户相同会提示：用户名、邮箱已存在
- 密码小于6位数会提示：最小长度是6位
- 注册成功后会发送验证邮件到用户邮箱，需点击邮箱按钮验证

![no-shadow](https://cdn.lishaoy.net/adonisjs/register.gif "Register" )

### 文章列表

登录进来，会显示文章列表页面，显示内容如下：

- 文章标题：点击可进入文章详情页
- 作者头像、作者名称：点击可进入作者信息页
- 时间：显示创建时间（多久以前方式显示）
- 阅读次数、点赞次数
- 文章简要：自动摘取章头文章
- 缩略图：自动摘取文章第一张图片

![no-shadow](https://cdn.lishaoy.net/adonisjs/posts.png "Post List" )

### 文章详情

点击文章标题可进入文章详情页面，内容如下：

- 文章标题
- 作者头像、作者名称
- 发布时间
- 阅读次数和点赞次数
- 编辑按钮（仅作者可见）
- 左侧浮动工具栏（点赞、发送邮件到自己邮箱、返回顶部、分享）
- 点赞：文章被点赞后，作者可以收到消息通知，且将文章收录到点赞列表（支持匿名点赞，但不会记录通知，只会加点赞数）

![no-shadow](https://cdn.lishaoy.net/adonisjs/post.png "Post" )

### 编辑文章支持 Markdown

新建文章和修改文章都支持 **Markdown** 语法，且会每隔6秒钟自动保存

![no-shadow](https://cdn.lishaoy.net/adonisjs/post_edit.png "Post Edit" )

### 个人信息

个人信息页面显示内容如下

- 作者的头像、姓名、简介（支持emoji）
- 信息栏：GitHub 链接、个人网站链接、发布文章数、总阅读次数、总点赞次数
- 发布文章列表：个人发布的所有文章
- 已赞文章列表：点过赞的文章会记录在这里
- 关注者列表：关注你的用户（关注过的用户，关注按钮高亮显示）
- 已关注列表：你关注的用户（关注过的用户，关注按钮高亮显示）å
- 关注按钮：作者本人不可见，点击可关注，再次点击取消关注，关注后，用户会收到消息通知

![no-shadow](https://cdn.lishaoy.net/adonisjs/profile.gif "Profile" )

下面是我用另一个用户登录，进入到个人信息页面就会显示关注按钮，如图

![no-shadow](https://cdn.lishaoy.net/adonisjs/follow.png "Follow" )

### 文件上传

点击文件上传小图标可进入文件上传页面，点击 **Files** 链接可进入文件上传列表，显示内容如图：

![no-shadow](https://cdn.lishaoy.net/adonisjs/file_upload.png "File Upload" )

![no-shadow](https://cdn.lishaoy.net/adonisjs/file_list.png "File List" )

### 文件预览和编辑

从文件列表页面点击标题可进入文件预览页面，显示内容如下：

- 如果是图片显示图片，如果是视频显示视频
- 工具栏：发送邮件到自己邮箱（登录可见）、编辑按钮、删除按钮（登录自己上传可见）
- 文件名称
- 下载按钮
- 上传者头像

![no-shadow](https://cdn.lishaoy.net/adonisjs/file_show.gif "File Show" )

### 消息通知

点击铃铛小图标可进入消息通知页面，内容如下：

- 点赞消息列表：收到用户点赞通知，最新的未读消息会高亮显示，点击点赞者头像进入个人信息页面，点击文章标题进入你的文章详情页面
- 关注者列表：收到关注者的通知，最新未读消息会高亮显示，点关注按钮也可关注他，再点击取消关注
- 系统消息：目前还没有做功能实现

![no-shadow](https://cdn.lishaoy.net/adonisjs/notification.gif "Notification" )

### 工具栏列表

点击个人头像可展开工具栏列表，内容如下：

- 写文章：点击可新建文章编辑页面，和 ➕ 小图标是同样功能
- 上传文件：点击可打开文件上传页面，和上传小图标是同样功能
- 个人信息： 点击可进入个人信息页面
- 已赞：点击可查看已赞过得文章
- 设置：点击可打开个人设置页面
- 登出：点击退出登录

![no-shadow](https://cdn.lishaoy.net/adonisjs/tool_menu.png "Tool Menu" )

### 设置

点击工具栏上的设置按钮可以设置页面，内容如下：

**个人信息设置**

- 头像：头像是使用的 `Gravatar` 提供的功能，根据邮箱生成头像
- 用户名
- 邮箱：已验证通过会显示验证小图标，没有通过的会显示提示
- GitHub：只需填写有户名
- 个人简介：支持emoji
- 个人网站

![no-shadow](https://cdn.lishaoy.net/setting_profile.png "Setting Profile" )

**修改密码设置**

需填写原密码，新密码，再次输入密码

![no-shadow](https://cdn.lishaoy.net/setting_pwd.png "Setting Password" )

### 聊天室

点击 **Chatroom** 链接可进入聊天室，当然这个是用的 `websocket` 做的，内容如下：

- 状态图标：显示链接状态
- 活动用户：左侧黑色区域会动态显示活动用户
- 消息：会显示发送消息，进入、离开房间通知消息（支持匿名发送消息，但不会保存消息）
- 消息输入：消息输入框可输入消息，<kbd>Cmd</kbd> — <kbd>Enter</kbd> 换行（Windows会显示提示Ctrl+Enter），回车发送消息

![no-shadow](https://cdn.lishaoy.net/adonisjs/chatroom1.gif "Chart Room" )

加入房间和离开房间都有消息通知，如图

![no-shadow](https://cdn.lishaoy.net/adonisjs/chatroom.png "Chart Room" )