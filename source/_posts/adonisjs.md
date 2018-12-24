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

{% li https://cdn.lishaoy.net/adonisjs/adonisjs1.png, Adonisjs, Adonisjs %}

最近在学习使用 `Node.js` 框架，边学习边使用，花了大概 **3周** 时间做完这个 **Web应用** 且在 <time>12月16</time> 凌晨左右上线成功（其实就是把开发环境搬到服务器）， 地址： [https://a.lishaoy.net](https://a.lishaoy.net)  

这个 **Web应用** 的代码是开源的，如对这个应用感兴趣，想知道代码是如何运行的，可以去我 **GitHub** 下载或 `clone` ：[应用源码](https://github.com/persilee/adonis_pro)

<hr />

<!-- more -->

首先，来看看用 **3周** 时间做出来的应用都有些什么功能，之后再看看选用的 `Node.js` 框架，最后看看 `Node.js` 项目如何部署到服务器。

## Web应用功能

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
- 发布文章列表：个人发布的所有文章(有删除和编辑按钮)
- 已赞文章列表：点过赞的文章会记录在这里
- 关注者列表：关注你的用户（关注过的用户，关注按钮高亮显示）
- 已关注列表：你关注的用户（关注过的用户，关注按钮高亮显示)
- 关注按钮：作者本人不可见，点击可关注，再次点击取消关注，关注后，用户会收到消息通知

![no-shadow](https://cdn.lishaoy.net/adonisjs/profile.gif "Profile" )

文章删除编辑快捷入口，如图

![no-shadow](https://cdn.lishaoy.net/adonisjs/edit_delete_post.gif "Edit && Delete post" )

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

## Node.js 框架

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
   * Show a list of all posts.
   * GET posts
   */
async index ({ request, response, view }) {}

 /**
   * Render a form to be used for creating a new posts.
   * GET posts/create
   */
async create ({ request, response, view }) {}

 /**
   * Create/save a new posts.
   * POST posts
   */
async store ({ request, response, view }) {}
 /**
   * Display a single posts.
   * GET posts/:id
   */
async show ({ request, response, view }) {}

 /**
   * Render a form to update an existing posts.
   * GET posts/:id/edit
   */
async edit ({ request, response, view }) {}

 /**
   * Update posts details.
   * PUT or PATCH posts/:id
   */
async update ({ request, response, view}) {}

 /**
   * Delete a posts with id.
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

首先，我们需要用 `ssh` 连接到阿里云（或者其他服务器供应商）的主机上，安装一些必要的工具。

### 工具安装

#### 安装 epel-release 软件包仓库

我们需要安装 `epel-release` 软件包仓库，`epel-release` 里面有很多最新的软件包，如，之后安装的 `git` 就会用到

```bash
sudo yum install epel-release - y
```

#### 安装 Git 版本控制命令行工具

```
sudo yum install git -y
```

### 准备 Node.js 运行环境

接下来，我们需要安装 `Node.js` 以便我们的 `Node.js` 项目能够跑起来，我们可以使用 `nvm` 安装和管理 `Node.js` ，使用 `nrm` 来管理切换安装源。

#### 安装 nvm

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```

安装好之后,我们需要配置下环境变量，以便能够在命令行使用 `nvm` 命令，用 `vi ~/.bash_profile` 编辑下配置文件

```bash
vi ~/.bash_profile
```

加入以下代码：

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

然后，在 `source ~/.bash_profile` 刷新下配置文件，让它生效

```bash
source ~/.bash_profile
```

此时，我们就可以使用 `nvm` 来安装 `Node.js`

```bash
nvm install node
```

安装好后，可以使用 `nvm list` 来查看有哪些版本可以使用

```bash
nvm list
```

结果：

```bash
->     v10.13.0
        v11.2.0
         system
default -> v10.13.0
node -> stable (-> v11.2.0) (default)
stable -> 11.2 (-> v11.2.0) (default)
iojs -> N/A (default)
lts/* -> lts/dubnium (-> v10.13.0)
lts/argon -> v4.9.1 (-> N/A)
lts/boron -> v6.14.4 (-> N/A)
lts/carbon -> v8.13.0 (-> N/A)
lts/dubnium -> v10.13.0
```

我使用的是 *v10.13.0* 的版本，默认安装的都是比较新的版本，可能是 *v11.2.0* 或 *v11.1.0*，所以我们也可以用 `nvm install v10.13.0` 来安装指定版本。

```bash
nvm install v10.13.0
```

然后，就可以使用 `nvm use  v10.13.0` 来使用指定版本

```bash
nvm use nvm v10.13.0
```

结果：

```bash
Now using node v10.13.0 (npm v6.4.1)
```

#### 安装 nrm 管理安装源

使用 npm 安装的程序包，默认的来源是 [http://registry.npmjs.org](http://registry.npmjs.org)，国内的下载速度会有些慢，我们可以是 `nrm` 来切换到 `taobao` 的源

**安装 nrm**

```bash
npm install nrm --global
```

**切换到 taobao 源**

```bash
nrm use taobao
```

### 准备项目

以上工作完成之后，我们的服务器就可以正常运行 `Node.js` 项目，现在我们需要把本地的项目上传到服务器，上传方法有很多，如：

- 可以使用 `git`，先把项目传到 **GitHub**，然后用 `git` 下载到服务器
- 可以是 **FTP** 工具
- 可以是命令上传 `scp -r 本地目录  root@服务器IP:/var/www/`

发项目文件上传到服务器的指定目录下，如：`www`

接下来，我们可以是 **PM2** 来管理 **Node** 进程，先需要安装 **PM2**

#### 安装PM2

```bash
npm install pm2@latest --global
```

这些工作作为之后，就可以来测试一下，启动项目，在本地访问服务器 `IP:PORT` 来测试是否可以访问

#### 测试项目是否可以运行

在测试之前，我们需要改下应用的配置文件，`adonisjs` 框架里是 `.env` 文件，修改下 `HOST` 的值：

```bash
HOST=0.0.0.0
PORT=3333
...
```

`HOST` 默认是 *127.0.0.1*，需要改成 *0.0.0.0* 这样就可以在自己电脑上用服务器 `IP:PORT` 来访问应用

改完后，进入到项目的根目录，运行应用，`adonisjs` 的启动文件是 `server.js`，如：

```bash
pm2 start server.js
```

如启动成功会提示：

```bash
[PM2] Applying action restartProcessId on app [server](ids: 0)
[PM2] [server](0) ✓
[PM2] Process successfully started
┌──────────┬────┬─────────┬──────┬──────┬────────┬─────────┬────────┬─────┬──────────┬──────┬──────────┐
│ App name │ id │ version │ mode │ pid  │ status │ restart │ uptime │ cpu │ mem      │ user │ watching │
├──────────┼────┼─────────┼──────┼──────┼────────┼─────────┼────────┼─────┼──────────┼──────┼──────────┤
│ server   │ 0  │ 4.1.0   │ fork │ 7171 │ online │ 30      │ 0s     │ 0%  │ 3.4 MB   │ root │ disabled │
└──────────┴────┴─────────┴──────┴──────┴────────┴─────────┴────────┴─────┴──────────┴──────┴──────────┘
 Use `pm2 show <id|name>` to get more details about an app
```

然后，在自己电脑上用服务器 `IP:PORT` 来访问应用。

### Nginx 代理

为了让服务器更好地处理网络请求，我们需要添加使用 **Nginx 反向代理** 把请求转发给 `Node.js` 应用

#### 安装 Nginx

```bash
sudo yum install nginx -y
```

如果你的服务之前安装过可不用安装，我的阿里云服务器运行了 4 个站点之前安装过，之后我只需添加配置就行。

#### 启动 Nginx

```bash
sudo systemctl start nginx
```

#### 配置 Nginx

一般情况 **Nginx** 安装好后会有 */etc/nginx/conf.d*  目录，进入这个目录，创建一个配置文件为 `Node.js` 而准备，名字可随意命名，如：`adonis.conf`

```bash
server {
  listen 80;
  location / {
      proxy_pass http://127.0.0.1:3333;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_cache_bypass $http_upgrade;
  }
}
```

然后，在 **Nginx** 的主配置文件里把刚才新创建的配置文件（*/etc/nginx/nginx.conf*） `include` 进去就可以,如：

```bash
include /etc/nginx/conf.d/*.conf;
```

因为，我的主机里运行了4个站点，`*` 的意思就是加载这个目录下的所有配置文件

然后，记得把刚才项目里的 *.env* 配置文件改成 *127.0.0.1* ，因为我们现在使用了代理，网络请求交给了 **Nginx**

再进入到项目的根目录下运行：

```bash
pm2 stop server.js #停止项目
pm2 start server.js #启动项目
```

这时候再用服务器 **IP** 访问就是用的 **Nginx** 去处理请求

#### 域名和SSL

如果你有域名可以去对应的供应商解析好，如想使用 `https` 协议，也可以去对应的供应商下载好证书（下载好的证书要放到服务器某个目录里）。

再修改下刚才创建的配置文件，让它能够支持 `https` 和 域名 访问：

```bash
server {
  listen 80;
      listen 443 ssl http2; #SSL
  server_name a.lishaoy.net; #域名
  ssl on;

  ssl_certificate /etc/letsencrypt/live/a.lishaoy.net/server.pem; #证书目录
  ssl_certificate_key /etc/letsencrypt/live/a.lishaoy.net/server.key; #证书目录
  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 10m;
  if ($ssl_protocol = "") {
    rewrite ^(.*) https://$host$1 permanent;
  }
  error_page 497  https://$host$request_uri;

  error_page 404 /404.html;
  error_page 502 /502.html;

  location / {
      proxy_pass http://localhost:3333;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_cache_bypass $http_upgrade;
  }
}
```

这样再重启 `Ningx` 服务和项目的服务，就大功告成了。