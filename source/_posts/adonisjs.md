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

## Nodejs 框架

这个应用的开发我选择的是 `Adonisjs` 框架，他和 `PHP` 的 `Laravel` 有些像，`Adonisjs` 是在操作系统上运行的 `Node.js` **MVC** 框架。

接下来，来看看 `Adonisjs` 框架有哪些特性：

### 环境安装简单

不管是开发环境还是生产环境，安装 `Adonisjs` 运行环境都是非常简单，先来看看开发环境的安装，生产环境后面会提到。

首先，我们的电脑上需要安装好 `Node.js`大于 *8.00* 版本，管理 `Node.js` 可以使用 `nvm`

其次，就可以使用 `npm` 安装 `Adonis CLI` 命令行工具（管理 `npm` 使用源可以使用 `nrm`）

```bash
npm i -g @adonisjs/cli
```

这样就可以在全局使用 `adonis` 命令

再次，可以是 `adonis new` 命令创建项目

```bash
adonis new adonis_pro
```

在 `cd` 进入项目，执行 `adonis serve --dev` 运行项目

```bash
cd adonis_pro
adonis serve --dev
```

这样您的开发环境就搭建完成。

### RMVC

`RMVC` 就是路由、模型、视图、控制器。

#### 路由

创建一条路由非常简单，如 

```js
Route.get('liked/:userId/:postId', 'LikedController.liked')
```

这条路由就是用来处理上面提到的点赞功能的

当然，`Adonisjs` 提供了 **资源路由** 以便您更方便的创建路由，例如

```js
Route.resource('posts', 'PostController').middleware(
	new Map([
		[ [ 'create', 'store', 'edit', 'update', 'destroy' ], [ 'auth' ] ],
		[ [ 'update', 'destroy', 'edit' ], [ 'own:post' ] ]
	])
).validator(new Map([
  [['posts.update', 'posts.store'], ['StorePost']]
]))
```

这个路由是来处理上面应用提到的文章的 *增、删、改、查* ，这个可能有些复杂，使用了 **中间件** 来处理用户登录状态和操作权限，使用了 **验证器** 来处理表单验证，这里不介绍的太复杂，如想了解这些具体功能，可以需要花点时间了解学习。

我们可以去掉 **中间件** 和 **验证器** ，如下：

```js
Route.resource('posts', 'PostController')
```

这条资源路由，其实就包含了以下路由：

```js
Route.get(url, closure)
Route.post(url, closure)
Route.put(url, closure)
Route.patch(url, closure)
Route.delete(url, closure)
```

`Adonisjs` 还提供了路由组和其他一些功能，路由组如下：

```js
Route.group(() => {
	Route.get('profile', 'ProfileController.edit').as('profile.edit')
	Route.post('profile', 'ProfileController.update').as('profile.update').validator('UpdateProfile')
	Route.get('password', 'PasswordController.edit').as('password.edit')
	Route.post('password', 'PasswordController.update').as('password.update').validator('UpdatePassword')
})
	.prefix('settings')
	.middleware([ 'auth' ])
```

使用 `.prefix` 和 `Route.group` 来创建路由组，这条路由组是处理 个人信息设置 功能的，这样访问页面是就统一要带上 `settings/**` 。

#### 控制器

`Adonisjs` 提供了命令行来创建控制器，如

```bash
adonis make:controller User --type http
```

这样就创建了一个 `User` 控制器,自动生成代码如下：

```js
'use strict'

class UserController {
}

module.exports = UserController
```

当然，我们还可以使用 `--resource` 创建资源类型的控制器

```bash
adonis make:controller Post --resource
```

自动生成代码，代码如下：

```js
'use strict'

class PostController {
 /**
   * Show a list of all profiles.
   * GET posts
   */
async index ({ request, response, view }) {}

 /**
   * Render a form to be used for creating a new profile.
   * GET posts/create
   */
async create ({ request, response, view }) {}

 /**
   * Create/save a new profile.
   * POST posts
   */
async store ({ request, response, view }) {}
 /**
   * Display a single profile.
   * GET posts/:id
   */
async show ({ request, response, view }) {}

 /**
   * Render a form to update an existing profile.
   * GET posts/:id/edit
   */
async edit ({ request, response, view }) {}

 /**
   * Update profile details.
   * PUT or PATCH posts/:id
   */
async update ({ request, response, view}) {}

 /**
   * Delete a profile with id.
   * DELETE posts/:id
   */
async destroy ({ params, request, response }) {}
}

module.exports = PostController
```

和上面的资源路由是对应的，如用 `GET` 请求访问 *posts* 就会调用 `index` 方法（一般用来显示） ，再如：用 `DELETE` 请求访问 *posts/1* 就会执行 `destroy` 方法（一般用来删除）。

#### 模型

`Adonisjs` 提供了两种模式来处理数据，`Query builder` 和 `LUCID`

首先，我们可以通过 `adonis make:migration` 来创建数据表

```js
adonis make:migration users
```

会自动生成代码，如下：

```js
'use strict'

const Schema = use('Schema')

class UsersSchema extends Schema {
  up () {
    this.create('users', (table) => {
      table.increments()
      table.timestamps()
    })
  }

  down () {
    this.drop('users')
  }
}

module.exports = UsersSchema
```

这是我们只需在其中添加想要的字段就行，如：

```js
'use strict'

const Schema = use('Schema')

class UsersSchema extends Schema {
  up () {
    this.create('users', (table) => {
      table.increments()
      table.string('username', 80).notNullable().unique()
      table.string('email', 254).notNullable().unique()
      table.string('password', 60).notNullable()
      table.timestamps()
    })
  }

  down () {
    this.drop('users')
  }
}

module.exports = UsersSchema
```

在执行 `adonis migration:run` 命令就可以在数据库生成数据表

再来看看，如何获取数据，可以使用 `Query builder` 和 `LUCID` 两种方式

先来看看 `Query builder`：

```js
const Database = use('Database')

class UserController {

  async index (request, response) {
    return await Database
      .table('users')
      .where('username', 'admin')
      .first()
  }

}
```

查询 `user` 表 `name` 是 `admin` 的用户

`Adonisjs` 提供了非常多的方法去操作数据，不是特复杂的关系都够用，如果，关系比较复杂，还可以用原生的 `sql` 操作，如

```js
'use strict'

const Database = use('Database')

  class NotificationController {
  async followNotice ({ auth, view }) {
    const notices = await Database.raw('select users.id as user_id,users.username,users.email,b.title,b.created_at,b.is_read,b.id as post_id from adonis.users , (select posts.id,posts.title, a.user_id,a.created_at,a.is_read from adonis.posts,(SELECT post_user.post_id, post_user.user_id, post_user.created_at, post_user.is_read FROM adonis.post_user where post_user.post_id in (SELECT posts.id FROM adonis.posts where user_id = ?)) as a where posts.id = a.post_id) as b where b.user_id = users.id and b.user_id <> ? order by b.created_at desc limit 50',[ auth.user.id, auth.user.id ])
  }
}

module.exports = NotificationController
```

使用 `Database.raw` 来运行原生的 `sql`，以上这条 `sql` 是用来查询所有用户给自己所有文章点赞的用户信息和文章信息用于消息通知。

再来看看，`LUCID` 的模式是如何操作数据的：

使用 `LUCID` 模式，我们先需要用命令行工具创建 `Models`，如：

```bash
adonis make:model User
```

自动生成代码如下：

```js
'use strict'

const Model = use('Model')

class User extends Model {
}

module.exports = User
```

模型和模型之间需要定义一些关系，如：

```js
const Model = use('Model')

class User extends Model {
  profile () {
    return this.hasOne('App/Models/Profile')
  }
}

module.exports = User
```

意思是 一个用户对应一个用户信息档案，**一对一** 的关系

定义好关系之后，就可以方便的获取数据，如：

```js
const User = use('App/Models/User')

const user = await User.find(1)
const userProfile = await user.profile().fetch()
```

意思是，从用户表和用户个人信息表里获取用户 `id` 是 `1` 的用户信息及个人信息，

其中，关系可以定义为 **3** 种 **一对一、一对多、多对多** ，多对多需要定义中间表

再来看看，上面的应用中的实际应用，如：

```js
async update ({ params, request, response, session, auth }) {
  const { title, content, user_id, tags } = request.all()

  const post = await Post.findOrFail(params.id)
  post.merge({ title, content})
  await post.save()

  await post.tags().sync(tags)

  session.flash({
    type: 'primary',
    message: 'Post updated successfully.'
  })

  return response.redirect(
    Route.url('PostController.show', {
      id: post.id
    })
  )
}
```

以上，是更新文章的方法，**文章** 和 **标签** 是 **多对多** 的关系，一个标签可以属于多篇文章，一篇文章可以有多个标签，`await post.tags().sync(tags)` 这句代码就可以通过 `Models` 里定义的关系自动把标签和文章关联起来保存到 `posts` 和 `tags` 表里且把关联关系保存到中间表 `post_tag`。

当然，`Adonisjs` 提供了很多方便的方法，想了解更多的话需要您花点时间去了解学习。

#### 视图

`Adonisjs` 框架里视图使用了 `edge` 模板，我们可以使用命令行工具创建视图文件，如：

```bash
adonis make:view post
```

我看可以看下简单的例子：

```html
@loggedIn
  <h2> You are logged in </h2>
@else
  <p> <a href="/login">Click here</a> to login </p>
@endloggedIn
```
视图模板里可以使用标签来做逻辑判断，视图模板就没什么好说的，基本都是通用的，关于 `edge` 视图模板更多语法 [Edge官方文档](https://edge.adonisjs.com/docs/syntax-guide)

最后，`Adonisjs` 框架还提供了很多其它的实用工具，如：`Middleware` 中间件、`Validator` 验证器、`Error Handling` 自定义异常、`Events` 事件、`Mails` 邮件、`Websocket` 等来处理各种问题。

## Node.js项目发布到阿里云服务器

## 未完待续...