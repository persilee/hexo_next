---
title: PHP ThinkPHP 初识
date: 2018-04-06 15:59:52
tags:
    - php
    - thinkPHP
categories: PHP
copyright: true
top: 102
comments: true
photos:
---

{% fi phpThinkPHPBasis/php.png, php && thinkPHP 基础, php && thinkPHP 基础 %}

这篇文章主要带大家认识一下 `PHP` 、 `thinkPHP` ，都是一下基础，其中包括 **PHP语法（变量、字符串、数组、表单、数据库）** 、**面向对象（Class创建、属性、继承、访问控制、抽象、接口等）** 、 **thinkPHP（控制器、视图、模型等）** 😝

---

<!-- more -->

## PHP基础知识
以下知识点所有内容都是来自官方提供的 **PHP** 文档《[PHP手册][1]》，更多细节及知识点可以查看《[PHP手册][2]》。

如果你平时用 **Windows** 系统，可以使用 [WAMP][3] 来搭建一个本地的开发环境。如果你是 **OSX** ，可以使用 [MAMP][4] 来搭建一个开发环境。
### PHP语法
#### 认识PHP
PHP 代码被包含在特殊的起始符和结束符 `<?php` 和 `?>` 中，使得可以进出“PHP 模式”。如果文件都是 **PHP** 代码，可以省略结束标记，但是必须以 `;` 结束。

```html
<body>
  <h1>php</h1>
  <?php
    echo "lishaoying";
    $name = '李少颖';
    echo "hello: " . $name ;
  ?>
</body>
```
结果会输出：`lishaoyinghello: 李少颖`, **PHP** 解析器会解析开始`<?php` 和结束标记 `?>` 之间的内容。

---
#### 变量
**PHP** 中的变量用一个美元符号后面跟变量名来表示。变量名是区分大小写的。
```php
<?php

$name = 'lishaoy.net';
echo "hello $name \r\n";
```
结果会输出：`hello lishaoy.net `。

---
#### 字符串
在 **PHP** 里面定义一个字符串，可以使用单引号`' '`或者双引号`" "`。
```php
<?php

$email = "persilee@foxmail.com<br />";
```
第三种表达字符串的方法是用 **heredoc** 句法结构：`<<<`。

```php
$word = <<< WORD
这是一个测试 - $name 。 . <br />
今天，天气不错，我们出去玩吧！ . <br />
WORD;

echo $word;
```
结果会输出： `这是一个测试 - lishaoy.net 。`

---
#### 数组
可以用 `array()` 语言结构来新建一个数组。它接受任意数量用逗号分隔的 键（**key**） `=>` 值（**value**）对。

```php
<?php
$tracks = array(
  0 => '长城',
);

echo var_dump(
  $tracks[0]
);
```
结果会输出： `string(6) "长城"`。

---
#### 表单
`$_GET`，还有 `$_POST`，这两个东西里面会存储使用不同的方法提交的表单的内容，`$_GET` 里面存储的是用 **GET** 方法提交的表单内容。

```html
<body>
  <form class="" action="process.php" method="get">
    <input type="text" name="user_name" value="" placeholder="用户名">
    <input type="email" name="email" value="" placeholder="Email">
    <button type="submit">提 交</button>
  </form>
</body>
```
**process.php**文件内容：

```php
<?php
echo '<pre>';
  var_dump(
    $_GET['user_name']
  );
echo '</pre>';
```
点提交之后会把文本框的内容传递到**process.php**文件处理，这里会输出文本框的输入内容。

---
#### 数据库
**PDO** 类，代表 **PHP** 和数据库服务之间的一个连接。

```php
$db_handle = new PDO('mysql:host=127.0.0.1;dbname=msg;port=8889;charset=utf8','msg_test','123');
```
这样就可以创建一个和数据库的连接。
```php
<?php

try {
  $db_handle = new PDO('mysql:host=127.0.0.1;dbname=msg;port=8889;charset=utf8','msg_test','123');

$statement = $db_handle->prepare(
  'insert into posts(title, content) values (:title, :content)'
);

$title = 'Wall-e';
$content = 'wall-e已经在地球上孤独生活了几百年，他爱上了。。。';

$statement->bindParam(':title', $title);
$statement->bindParam(':content', $content);

$statement->execute();

} catch (Exception $e) {
  echo $e->getMessage();
}
```
可以向数据库的**posts**表插入一条数据。

---
### 面向对象
#### 创建Class
每个类的定义都以关键字 `class` 开头，后面跟着类名，后面跟着一对花括号，里面包含有类的属性与方法的定义。
```php
class Track
{
    
}
```

---
#### 增加属性
类的变量成员叫做“**属性**”，或者叫“**字段**”、“**特征**”，在本文档统一称为“**属性**”。
```php
class Track
{
    public $track_name;
    public $track_artist;
}
```

---
#### 继承
**继承** 将会影响到类与类，对象与对象之间的关系。

比如，当扩展一个类，子类就会**继承**父类所有公有的和受保护的方法。除非子类覆盖了父类的方法，被**继承**的方法都会保留其原有功能。
```php
<?php

class Player extends Track
{

}
```

---
#### 访问控制
对属性或方法的访问控制，是通过在前面添加关键字 `public`（公有），`protected`（受保护）或 `private`（私有）来实现的。被定义为公有的类成员可以 **在任何地方被访问**。被定义为受保护的类成员则可以 **被其自身以及其子类和父类访问**。被定义为私有的类成员则 **只能被其定义所在的类访问**。

---
#### 静态属性与方法
声明类属性或方法为**静态**( `static` )，就可以不实例化类而直接访问。静态属性不能通过一个类已实例化的对象来访问（但静态方法可以）。
```php
class Track
{
    public static $track_name = 'Magic';
    public $track_artist;
    
    public static function track_playing() {
        return '正在播放' . self::$track_name;
    }
}
```

---
#### 构造函数
具有**构造函数**( `__construct` )的类会在每次创建新对象时先调用此方法，所以非常适合在使用对象之前做一些初始化工作。
```php
<?php

class Track
{
    public $track_name;
    public $track_artist;
    
    public function __construct() {
        echo '初始化数据...';
    }
    
    public function track_playing() {
        return '正在播放' . $this->$track_name;
    }
}
```

---
#### 构造器与获取器
在给不可访问属性赋值时，`__set()` 会被调用。
读取不可访问属性的值时，`__get()` 会被调用。
```php
<?php

class Track
{      
    private $track_name;
    private $track_artist;

    public function __set($name, $value) {
        if (property_exists($this, $name)) {
            $this->$name = $value;
        }
    }
    
    public function __get($name) {
        return $this->$name;
    }

    public function track_playing() {
        return '正在播放' . $this->$track_name;
    }
}
```

---
#### 抽象类
**定义为抽象的类不能被实例化**( `abstract` )。任何一个类，如果它里面至少有一个方法是被声明为抽象的，那么这个类就必须被声明为抽象的。被定义为抽象的方法只是声明了其调用方式（参数），不能定义其具体的功能实现。
```php
<?php

abstract class Entity
{
    protected $entity_type;
    public function get_entity_type() {
        return $this->entity_type;
    }
    
    abstract public function save();
}

class User extends Entity
{
    protected $entity_type = 'user';
    
    public function save() {
        return $this->entity_type . '：保存成功！';
    }
}
```

---
#### 接口
使用 **接口**（ `interface `），可以指定某个类必须实现哪些方法，但不需要定义这些方法的具体内容。

**接口** 是通过 `interface` 关键字来定义的，就像定义一个标准的类一样，但其中定义所有的方法都是空的。

**接口** 中定义的所有方法都必须是公有，这是接口的特性。
```php
<?php

interface DataInterface 
{
    public function get_data();
}

interface EntityInterface
{
    public function get_entity_type();
}

class Entity implements DataInterface, EntityInterface
{
    public function get_data() {
        return '数据...';
    }
    
    public function get_entity_type() {
        return '类型...';
    }
}
```

---
## ThinkPHP
以下内容基本都是来自**ThinkPHP**[官方文档][5]，更多细节及知识点可查看 [官方文档][5]。
### 基础
#### 环境要求
**PHP版本要求**
- PHP5.3以上版本

**支持的服务器和数据库环境**
- 支持Windows/Unix服务器环境
- 可运行于包括Apache、IIS和nginx在内的多种WEB服务器和模式
- 支持Mysql、MsSQL、PgSQL、Sqlite、Oracle、Ibase、Mongo以及PDO等多种数据库和连接

如果你平时用 **Windows** 系统，可以使用 [WAMP][6] 来搭建一个本地的开发环境。如果你是 **OSX** ，可以使用 [MAMP][7] 来搭建一个开发环境。

---
#### 目录结构
初始的目录结构如下：
```vim
www  WEB部署目录（或者子目录）
├─index.php       入口文件
├─README.md       README文件
├─Application     应用目录
├─Public          资源文件目录
└─ThinkPHP        框架目录
```
其中框架目录**ThinkPHP**的结构如下：
```vim
├─ThinkPHP 框架系统目录（可以部署在非web目录下面）
│  ├─Common       核心公共函数目录
│  ├─Conf         核心配置目录 
│  ├─Lang         核心语言包目录
│  ├─Library      框架类库目录
│  │  ├─Think     核心Think类库包目录
│  │  ├─Behavior  行为类库目录
│  │  ├─Org       Org类库包目录
│  │  ├─Vendor    第三方类库目录
│  │  ├─ ...      更多类库目录
│  ├─Mode         框架应用模式目录
│  ├─Tpl          系统模板目录
│  ├─LICENSE.txt  框架授权协议文件
│  ├─logo.png     框架LOGO文件
│  ├─README.txt   框架README文件
│  └─ThinkPHP.php    框架入口文件
```

---
#### 入口文件
**ThinkPHP**采用单一入口模式进行项目部署和访问，无论完成什么功能，一个应用都有一个统一（但不一定是唯一）的入口。

**入口文件主要完成：**
- 定义框架路径、项目路径（可选）
- 定义调试模式和应用模式（可选）
- 定义系统相关常量（可选）
- 载入框架入口文件（**必须**）

```php
// 开启调试模式 建议开发阶段开启 部署阶段注释或者设为false
define('APP_DEBUG',true);

// 定义应用目录
define( 'APP_PATH', dirname(__FILE__).'/Application/' );

//生成后台模块
define('BIND_MODULE','Admin');

// 引入ThinkPHP入口文件
require dirname( __FILE__).'/ThinkPHP/ThinkPHP.php';
```

---
#### URL
入口文件是应用的单一入口，对应用的所有请求都定向到应用入口文件，系统会从URL参数中解析当前请求的模块、控制器和操作：

```vim
http://serverName/index.php/模块/控制器/操作
```

---
### 控制器
#### 控制器定义
一般来说，ThinkPHP的控制器是一个类，而操作则是控制器类的一个公共方法。
下面就是一个典型的控制器类的定义：
```php
namespace Admin\Controller;
use Think\Controller;

class LoginController extends Controller {
    public function hello(){
        echo 'hello,thinkphp!';
    }
}
```
在浏览器里访问：`http://msg:8899/index.php/Login/hello`，会显示：`hello,thinkphp!`。

---
#### AJAX返回
**ThinkPHP** 可以很好的支持AJAX请求，系统的\Think\Controller类提供了ajaxReturn方法用于AJAX调用后返回数据给客户端。
```php
<?php

namespace Admin\Controller;
use Think\Controller;

class LoginController extends Controller {
    public function login()
    {
      $data['status']  = 1;
      $data['content'] = 'content';
      $this->ajaxReturn($data);
    }
}
```

---
#### 跳转和重定向

**页面跳转**

在应用开发中，经常会遇到一些带有提示信息的跳转页面，例如操作成功或者操作错误页面，并且自动跳转到另外一个目标页面。系统的`\Think\Controller`类内置了两个跳转方法`success`和`error`，用于页面跳转提示，而且可以支持ajax提交。

```php
    public function jump()
    {
      $posts = D('posts'); //实例化User对象
      $data['title'] = 'cat';
      $data['content'] = '猫，属于猫科动物，分家猫、野猫，是全世界家庭中较为广泛的宠物。';
      $result = $posts->add($data);
      if($result){
          //设置成功后跳转页面的地址，默认的返回页面是$_SERVER['HTTP_REFERER']
          $this->success('新增成功','Login/login');
      } else {
          //错误页面的默认跳转页面是返回前一页，通常不需要设置
          $this->error('新增失败');
      }
    }
```

**重定向**

`Controller`类的`redirect`方法可以实现页面的重定向功能。

```php
//重定向到New模块的Category操作
$this->redirect('New/category', array('cate_id' => 2), 5, '页面跳转中...');
```
上面的用法是停留5秒后跳转到`New`模块的`category`操作，并且显示页面跳转中字样，重定向后会改变当前的**URL**地址。

---

#### 输入变量

**获取变量**

`I`方法是**ThinkPHP**用于更加方便和安全的获取系统输入变量，可以用于任何地方，用法格式如下：
```php
I('变量类型.变量名/修饰符',['默认值'],['过滤方法'],['额外数据源'])
```

变量类型是指请求方式或者输入类型，包括：

|  变量类型   |   含义    |
| :-------- | :--------| 
| get    |   获取GET参数 | 
| post    |   获取POST参数 | 
| param    |   自动判断请求类型获取GET、POST或者PUT参数 | 
| request    |   获取REQUEST 参数 | 
| put    |   获取PUT 参数 | 
| session    |   获取 $_SESSION 参数 | 
| cookie    |   获取 $_COOKIE 参数 | 
| server    |   获取 $_SERVER 参数 | 
| globals    |   获取 $GLOBALS参数 |
| path    |   获取 PATHINFO模式的URL参数（3.2.2新增） |
| data    |   获取 其他类型的参数，需要配合额外数据源参数（3.2.2新增） |

我们以`GET`变量类型为例，说明下 `I` 方法的使用：

```php
public function variable()
{
    $data['title'] = I('get.title');
    $data['content'] = I('get.content');
    dump($data);
    $this->display();
}
```
输出结果：
```vim
array(2) {
  ["title"] => string(6) "啊啊"
  ["content"] => string(6) "啊啊"
}
```

---
### 视图
#### 模板定义

每个模块的模板文件是独立的，为了对模板文件更加有效的管理，**ThinkPHP**对模板文件进行目录划分，默认的模板文件定义规则是：
```php
视图目录/[模板主题]/控制器名/操作名+模板后缀
```
默认的视图目录是模块的 **View** 目录（模块可以有多个视图文件目录，这取决于你的应用需要），框架的默认视图文件后缀是`.html`。 新版模板主题默认是空（表示不启用模板主题功能）。

在每个模板主题下面，是以模块下面的控制器名为目录，然后是每个控制器的具体操作模板文件，例如：

例如**Login**下的**variable**，对应的模板文件：`Admin/View/Login/variable.html`

---
#### 模板赋值

如果要在模板中输出变量，必须在在控制器中把变量传递给模板，系统提供了assign方法对模板变量赋值，无论何种变量类型都统一使用assign赋值。
```php
public function variable()
    {
      $data['title'] = I('get.title');
      $data['content'] = I('get.content');
      $this->assign($data);
      $this->display();
    }
```
`assign`方法必须在`display`和`show`方法之前调用，并且系统只会输出设定的变量，其它变量不会输出（系统变量例外），一定程度上保证了变量的安全性。

赋值后，就可以在模板文件中输出变量了，如果使用的是内置模板的话，就可以这样输出： `{$title}`。

---
#### 渲染模板
渲染模板输出最常用的是使用`display`方法，调用格式：
```vim
display('[模板文件]'[,'字符编码'][,'输出类型'])
```
如果没有按照模板定义规则来定义模板文件（或者需要调用其他控制器下面的某个模板），可以使用：
```php
// 指定模板输出
$this->display('edit'); 
```
表示调用当前模块下面的`edit`模板
```php
$this->display('Member:read');
```
表示调用`Member`模块下面的`read`模板。

---
### 模型

#### 模型定义
> 模型类并非必须定义，只有当存在独立的业务逻辑或者属性的时候才需要定义。

模型类通常需要继承系统的\Think\Model类或其子类，下面是一个Home\Model\UserModel类的定义：
```php
<?php
namespace Admin\Model;
use Think\Model;

class PostsModel extends Model{
 
}
```
模型类的作用大多数情况是操作数据表的，如果按照系统的规范来命名模型类的话，大多数情况下是可以自动对应数据表。

#### 模型实例化
在ThinkPHP中，可以无需进行任何模型定义。

根据不同的模型定义，我们有几种实例化模型的方法，根据需要采用不同的方式：
**直接实例化**
可以和实例化其他类库一样实例化模型类，例如：
```php
$User = new \Home\Model\UserModel();
$Info = new \Admin\Model\InfoModel();
// 带参数实例化
$New  = new \Home\Model\NewModel('blog','think_',$connection);
```
**D方法实例化**
上面实例化的时候我们需要传入完整的类名，系统提供了一个快捷方法 **D** 用于数据模型的实例化操作。
```php
<?php
public function jump()
    {
      $posts = D('posts'); //实例化posts对象
    }
```

**M方法实例化模型**
**D** 方法实例化模型类的时候通常是实例化某个具体的模型类，如果你仅仅是对数据表进行基本的  **CURD** 操作的话，使用 **M** 方法实例化的话，由于不需要加载具体的模型类，所以性能会更高。

```php
// 使用M方法实例化
$User = M('User');
// 和用法 $User = new \Think\Model('User'); 等效
// 执行其他的数据操作
$User->select();
```
#### CURD操作
**ThinkPHP**提供了灵活和方便的数据操作方法，对数据库操作的四个基本操作（CURD）：创建、更新、读取和删除的实现是最基本的，也是必须掌握的，在这基础之上才能熟悉更多实用的数据操作方法。

**CURD** 操作通常是可以和连贯操作配合完成的。

**创建数据对象**

**ThinkPHP**可以帮助你快速地创建数据对象，最典型的应用就是自动根据表单数据创建数据对象，这个优势在一个数据表的字段非常之多的情况下尤其明显。

```php
// 实例化User模型
$User = M('User');
// 根据表单提交的POST数据创建数据对象
$User->create();
```

**数据写入**

**ThinkPHP**的数据写入操作使用`add`方法，使用示例如下：
```php
    public function jump()
    {
      $posts = D('posts'); //实例化User对象
      $data['title'] = 'cat';
      $data['content'] = '猫，属于猫科动物，分家猫、野猫，是全世界家庭中较为广泛的宠物。';
      $result = $posts->add($data);
```

**读取数据**

读取数据是指读取数据表中的一行数据（或者关联数据），主要通过`find`方法完成，例如：
```php
public function getPosts(){
      $posts = D('posts'); //实例化posts对象

      $posts->where('id=1')->find();

      dump($posts);
    }
```
`find`方法查询数据的时候可以配合相关的连贯操作方法，其中最关键的则是where方法。

**更新数据**

更新数据使用`save`方法，例如：
```php
public function savePosts(){
      $posts = D('posts'); //实例化posts对象
      $data['title'] = 'dog';
      $data['content'] = '狗，（拉丁文:Canis lupus familiaris,英文名称dog）中文亦称“犬”，狗属于食肉目，分布于世界各地。狗与马、牛、羊、猪、鸡并称“六畜”。有科学家认为狗是由早期人类从灰狼...';
      $posts->where('id=1')->save($data);
    }
```

**数据删除**

**ThinkPHP**删除数据使用`delete`方法，例如：
```php
public function deletePosts(){
      $posts = D('posts'); //实例化posts对象

      $posts->delete(4);
    }
```
表示删除主键为**4**的数据

#### 连贯操作
**ThinkPHP**模型基础类提供的连贯操作方法（也有些框架称之为链式操作），可以有效的提高数据存取的代码清晰度和开发效率，并且支持所有的**CURD**操作。

使用也比较简单， 假如我们现在要查询一个**User**表的满足状态为**1**的前**10**条记录，并希望按照用户的创建时间排序 ，代码如下：
```php
$User->where('status=1')->order('create_time')->limit(10)->select();
```
这里的`where`、`order`和`limit`方法就被称之为连贯操作方法，除了`select`方法必须放到最后一个外（因为select方法并不是连贯操作方法），连贯操作的方法调用顺序没有先后。

  [1]: http://php.net/manual/zh/index.php
  [2]: http://php.net/manual/zh/index.php
  [3]: http://wampserver.com
  [4]: https://www.mamp.info/en/
  [5]: http://document.thinkphp.cn/manual_3_2.html#preface
  [6]: http://wampserver.com
  [7]: https://www.mamp.info/en/