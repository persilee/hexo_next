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
1. 自定义了一个 Hello 的 StatelessWidget 类型的 widget
2. 新增了 MaterialApp ，这里面就有我们需要用的 AppBar （MaterialApp 里面有很多 Material Design 风格的组件，后面的文章提到）
3. Scaffold 可以理解为 MaterialApp 布局的架子，Material Design 风格的组件都会放到这里面
4. AppBar 就是顶部蓝色这部分，加了一个 title 转为大写和词间距
5. body 主体下面白色部分，放的是我们自定义的 Hello 小部件
{% endnote %}  

## 未完待续...