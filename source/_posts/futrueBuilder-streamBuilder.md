---
title: 优雅的使用 FutureBuilder and StreamBuilder 构建项目
tags:
  - Flutter
  - Dart
  - Future
  - Stream
copyright: true
comments: true
date: 2020-06-29 11:59:16
categories: Dart
top: 116
photos:
---

{% li https://cdn.lishaoy.net/ctrip/android/android_ctrip_h.png, Flutter, Flutter %}

本篇文章将介绍从 `setState` 开始，到 `futureBuilder` 、 `streamBuilder` 来优雅的构建你的项目，而不引发 `setState` 带来的副作用。

<hr />

<!-- more -->

## 基础的setState

首页，我们使用基础的 `StatefulWidget` 来创建页面，如下：

```dart
class BaseStatefulDemo extends StatefulWidget {
  @override
  _BaseStatefulDemoState createState() => _BaseStatefulDemoState();
}

class _BaseStatefulDemoState extends State<BaseStatefulDemo> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

然后，我们使用 `Future` 来创建一些数据，来模拟网络请求，如下：

```dart
  Future<List<String>> _getListData() async {
    await Future.delayed(Duration(seconds: 1)); // 1秒之后返回数据
    return List<String>.generate(10, (index) => '$index content');
  }
```

在 `initState()` 方法中调用 `_getListData()` 来初始化数据，如下：

```dart
  List<String> _pageData = List<String>();

  @override
  void initState() {
    _getListData().then((data) => setState(() {
              _pageData = data;
            }));
    super.initState();
  }
```

使用 `ListView.builder` 来处理这些数据构建UI，如下：

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base Stateful Demo'),
      ),
      body: ListView.builder(
        itemCount: _pageData.length,
        itemBuilder: (buildContext, index) {
          return Column(
            children: <Widget>[
              ListTile(
                title: Text(_pageData[index]),
              ),
              Divider(),
            ],
          );
        },
      ),
    );
  }
```

最后，我们就可以看到界面了 😎 ，如图：

<div style="width: 36%; margin:auto">
![no-shadow](https://cdn.lishaoy.net/fureBuilderStreamBuilder/list-data.png "")
</div>

当然，你也可以将 **UI** 显示单独提取成一个方法，方便后期维护，使代码层次更清晰，如下：

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base Stateful Demo'),
      ),
      body: ListView.builder(
        itemCount: _pageData.length,
        itemBuilder: (buildContext, index) {
          return getListDataUi(int index);
        },
      ),
    );
  }

  Widget getListDataUi(int index) {
    return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(_pageData[index]),
                  ),
                  Divider(),
                ],
              );
  }
```

