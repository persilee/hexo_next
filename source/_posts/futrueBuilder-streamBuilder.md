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

![no-shadow](https://cdn.lishaoy.net/fureBuilderStreamBuilder/list-data.png "list data")

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

继续，我们来完善它，正常从后端获取数据，后端应该会给我们返回不同的状态，以及数据加载中的状态，如：

- BusyState(加载中)：我们在界面上显示一个加载指示器
- DataFetchedState(数据加载完成)：我们延迟2秒，来模拟数据加载完成
- ErrorState(错误)：显示错误提示
- NoData(没有数据)：请求成功，但没有数据，显示提示

先来处理 **BusyState** 加载指示器，如下：

```dart
bool get _fetchingData => _pageData == null; // 判断数据是否为空

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Base Stateful Demo'),
      ),
      body: _fetchingData
          ? Center(
              child: CircularProgressIndicator( // 加载指示器 
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow), // 设置指示器颜色
                backgroundColor: Colors.yellow[100],  // 设置背景色
              ),
            )
          : ListView.builder(
              itemCount: _pageData.length,
              itemBuilder: (buildContext, index) {
                return getListDataUi(index);
              },
            ),
    );
  }
```

效果如图：

<div style="width: 36%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/fureBuilderStreamBuilder/indicator.png "indicator")

</div>

接着，我们来处理 **ErrorState** ，我给 `_getListData()` 添加 `hasError` 参数来模拟后端，如下

```dart
  Future<List<String>> _getListData({bool hasError = false}) async {
    await Future.delayed(Duration(seconds: 1)); // 1秒之后返回数据

    if (hasError) {
      return Future.error('获取数据出现问题，请再试一次');
    }

    return List<String>.generate(10, (index) => '$index content');
  }
```

然后，在 `initState()` 方法中捕获异常更新数据，如下：

```dart
  @override
  void initState() {
    _getListData(hasError: true)
        .then((data) => setState(() {
              _pageData = data;
            }))
        .catchError((error) => setState(() {
              _pageData = [error];
            }));
    super.initState();
  }
```

效果如图( *当然这里可以使用一个错误页面来展示* )：

<div style="width: 36%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/fureBuilderStreamBuilder/error.png "error")

</div>

接着，我们来处理 **NoData** ，我给 `_getListData()` 添加 `hasError` 参数来模拟后端，如下：

```dart
  Future<List<String>> _getListData(
      {bool hasError = false, bool hasData = true}) async {
    await Future.delayed(Duration(seconds: 1));

    if (hasError) {
      return Future.error('获取数据出现问题，请再试一次');
    }

    if (!hasData) {
      return List<String>();
    }

    return List<String>.generate(10, (index) => '$index content');
  }
```

然后，在 `initState()` 方法更新数据，如下：

```dart
  @override
  void initState() {
    _getListData(hasError: false, hasData: false)
        .then((data) => setState(() {
              if (data.length == 0) {
                data.add('No data fount');
              }
              _pageData = data;
            }))
        .catchError((error) => setState(() {
              _pageData = [error];
            }));
    super.initState();
  }
```

效果如图：

<div style="width: 36%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/fureBuilderStreamBuilder/no-data.png "error")

</div>