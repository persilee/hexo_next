---
title: Flutter：手拉手带你极速构建漂亮的跨平台移动应用 ✿ 初体验（实战）
tags:
  - Flutter
  - iOS
  - Android
  - Dart
copyright: true
comments: true
date: 2018-11-11 01:04:15
categories: Dart
top: 109
photos:
---

{% li https://cdn.lishaoy.net/fristFlutter/flutterCover7.png, Flutter, Flutter %}

我们上篇文章已经把 **Flutter** 的开发运行环境搭建好了 [Flutter：环境搭建](https://h.lishaoy.net/flutterInstall.html) ，本篇文章将完成您的第一个 **Flutter** 小应用，不用但是不会，跟着文章做就行，开始不必太纠结这些代码细节，明白它是干什么的就行，只是一个开放体验，体验 **Flutter** 框架给你带来的开发感受，后面会有具体的组件（widget）的文章。

<hr />

<!-- more -->

## 创建项目

在上篇文章我们已经创建了一个 Flutter 项目 `new_flutter`，如果您还没有创建，可以在终端执行以下命令：

```bash
cd ~/desktop #进入桌面
flutter create new_flutter #创建 Flutter 项目
cd new_flutter #进入项目
code ./ #用 VS Code 打开
```

用 VS Code 打开项目后，按 **F5** 选择模拟器运行项目看看效果，这些操作在上篇文章都已经做过了，您应该有些印象，如成功的话，会看到如图效果：

![no-shadow](https://cdn.lishaoy.net/flutterInstall/demo.png "Flutter run" )

这个是 `flutter create` 命令创建项目时，给我们的案例（计数器），这些代码在 *lib->main.dart* 文件里，如你关注的话可以看看这些代码都做了些什么，不过现在我们不需要这些代码，<kbd>⌘</kbd> - <kbd>A</kbd> 全选删除，我们需要自己写。

```dart Dart https://h.lishaoy.net/fristFlutter.html#创建项目 main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    Center(
      child: Text(
        'Hello',
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 36.0),
      ),
    )
  );
}
```

写上以上代码，按 <kbd>⌘</kbd> - <kbd>⇧</kbd> - <kbd>P</kbd> 打开 VS Code 的命令面板，搜索 `hot restart` 执行命令，效果如图：

<div style="padding: 0 30%;">![no-shadow](https://cdn.lishaoy.net/fristFlutter/flutter_hello.png "hello" )</div>

`main()` 是 Flutter 的入口函数，我们一般不会把代码写在里面，我们来修改下代码（自定义已 widget）：

```dart Dart https://h.lishaoy.net/fristFlutter.html#创建项目 main.dart
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello',
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 36.0),
      ),
    );
  }
}
```

运行效果是一样的，这里我们自定义了一个 `StatelessWidget` 类型的 widget。

## 新增 Material AppBar

我们再来修改下代码，让我们的应用去使用 Material Design 的 AppBar

```dart Dart https://h.lishaoy.net/fristFlutter.html#新增-Material-AppBar main.dart
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'lishaoy.net'.toUpperCase(),
            style: TextStyle(letterSpacing: 3.0),
          ),
        ),
        body: Hello(),
      ),
    );
  }
}

class Hello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello',
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 36.0),
      ),
    );
  }
}
```

运行效果如图：

<div style="padding: 0 30%;">![no-shadow](https://cdn.lishaoy.net/fristFlutter/Appbar.png "hello" )</div>

{% note success %}
<i class="fa fa-fw fa-bell faa-horizontal animated faa-slow" style="color: #009688;"></i>**Tip：**
1. 自定义了一个 Hello 的 {% label info@StatelessWidget %} 类型的 widget
2. 新增了 MaterialApp ，这里面就有我们需要用的 AppBar （MaterialApp 里面有很多 {% label info@Material Design %} 风格的组件，后面的文章提到）
3. Scaffold 可以理解为 MaterialApp 布局的架子，{% label info@Material Design %} 风格的组件都会放到这里面
4. AppBar 就是顶部蓝色这部分，加了一个 title 转为大写和增加词间距
5. body 主体下面白色部分，放的是我们自定义的 Hello 小部件
{% endnote %}  

## 新增列表视图（ListView）

在新增列表视图（ListView）之前，我们需要准备一些数据，我们可以在 lib 目录下新建一个目录 model 和文件 post.dart ，如图：

<img src="https://cdn.lishaoy.net/fristFlutter/model.png" alt="post.dart" width="26%" title="post.dart" align="center">

然后，把我 {% label success@GitHub %} 准备好的 [post.dart](https://github.com/persilee/flutter_pro/blob/master/lib/model/post.dart) 数据放到里面。

现在我们再来改进下代码，让它更具有维护性，我们把 `home` 属性下的 Scaffold 放到单独的 widget ，取名为 {% label default@HomePage %}

```dart Dart https://h.lishaoy.net/fristFlutter.html#新增列表视图（ListView） main.dart
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'lishaoy.net'.toUpperCase(),
            style: TextStyle(letterSpacing: 3.0),
          ),
        ),
        body: Hello(),
      );
  }
}
```

接下来，我们来创建 {% label primary@视图列表 %} 

首先，在头部引入刚才创建的数据 `post.dart` 

```Dart
import './model/post.dart';
```

然后，再把 `body` 下的 Hello() 换成 `ListView`，如下：

```dart Dart https://h.lishaoy.net/fristFlutter.html#新增列表视图（ListView） main.dart
class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'lishaoy.net'.toUpperCase(),
            style: TextStyle(letterSpacing: 3.0),
          ),
        ),
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) => Text(posts[index].title),
        ),
      );
  }
}
```

效果如图：

<div style="padding: 0 30%;">![no-shadow](https://cdn.lishaoy.net/fristFlutter/listView.png "ListView" )</div>

## 完善列表项目

现在，数据已经呈现在应用界面上了，接下来要做的是让数据展示更友好一点。

我们再来改造一下 `itemBuilder` 下的方法：

```dart Dart https://h.lishaoy.net/fristFlutter.html#完善列表项目 main.dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'lishaoy.net'.toUpperCase(),
          style: TextStyle(letterSpacing: 3.0),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) => Container(
              margin: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Image.network(
                    posts[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    posts[index].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    posts[index].author,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
```

运行效果如图：

<div style="padding: 0 30%;">![no-shadow](https://cdn.lishaoy.net/fristFlutter/listView1.png "ListView" )</div>

{% note success %}
<i class="fa fa-fw fa-bell faa-horizontal animated faa-slow" style="color: #009688;"></i>**Tip：**
1. {% label info@itemBuilder %} 属性是个方法，可以传 2 个参数，context（内容）、index（索引）
2. 我们用了 {% label info@Container %} 的 widget 来装载我们的项目，因为 {% label info@Container %} 有很多属性，例如 margin、padding、color、width、height等，后面我们会慢慢的熟悉它
3. 我们用了一个 {% label info@Column %} 的 widget 来布局，因为我们的图片、标题、小标题要纵向排列（Row、Column等一些布局的 widget 我们会经常用到）
4. 用了 {% label info@Image.network %} 来加载一个来自网络的图片（Image.asset可以加载本地图像）
5. {% label info@Theme.of(context).textTheme.title%} 是用 {% label info@Material Design %} 主题里的标题样式
{% endnote %}  

最后，为了可阅读性和维护性考量，我们再可以调整一下代码 {% label success@ListView.builder %} 方法单独提炼出来：

```dart Dart https://h.lishaoy.net/fristFlutter.html#完善列表项目 main.dart
class HomePage extends StatelessWidget {
  Widget _listItemBuilder(BuildContext context, int index) => Container(
        margin: EdgeInsets.all(8.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Image.network(
              posts[index].imageUrl,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              posts[index].title,
              style: Theme.of(context).textTheme.title,
            ),
            Text(
              posts[index].author,
              style: Theme.of(context).textTheme.subhead,
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'lishaoy.net'.toUpperCase(),
          style: TextStyle(letterSpacing: 3.0),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: _listItemBuilder,
      ),
    );
  }
}
```

现在，第一个漂亮的界面已经完成，后面的文章我们一起来完成其他部分。

## 未完待续...