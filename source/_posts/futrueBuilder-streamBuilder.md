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

{% li https://cdn.lishaoy.net/fureBuilderStreamBuilder/cover.png, Flutter, Flutter %}

本篇文章将介绍从 `setState` 开始，到 `futureBuilder` 、 `streamBuilder` 来优雅的构建你的项目，而不引发 `setState` 带来的副作用，如对文章感兴趣，请 [点击查看源码](https://github.com/persilee/flutter_pro)。

<hr />

<!-- more -->



## 基础的setState更新数据

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

{% note success %}
这就是通过 `setState()` 来更新数据，是不是很简单，通常情况下我们这么使用是没什么问题，但是，如果我们的页面足够复杂，要处理的状态足够多，我们需要使用更多的 `setState()` ，意味着我们需要更多的代码来更新数据，而且，我们每次 `setState()` 的时候 `build()` 方法就会重新执行一次( *这就是上文提到的副作用* )。

其实，**Flutter** 已经提供了更优雅的方式来更新我们的数据及处理状态，它就是我们接下来要讲的 `futureBuilder`。
{% endnote %}

## FutureBuilder

`FutureBuilder` 通过 **future:** 参数可以接收一个 `Future` ，并且通过 **builder:** 参数来构建 **UI** ，**builder:** 参数是一个函数，它提供了一个 `snapshot` 参数里面带着我们需要的状态和数据。

接下来，我们将上面的 `StatefulWidget` 改成 `StatelessWidget` ，并使用 `FutureBuilder` 替换，如下:

```dart
class FutureBuilderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder Demo'),
      ),
      body: FutureBuilder(
        future: _getListData(),
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            return _getInfoMessage(snapshot.error);
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                backgroundColor: Colors.yellow[100],
              ),
            );
          }
          var listData = snapshot.data;
          if (listData.length == 0) {
            return _getInfoMessage('No data found');
          }

          return ListView.builder(
            itemCount: listData.length,
            itemBuilder: (buildContext, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(listData[index]),
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  ...
```

我们使用 `_getInfoMessage()` 方法来处理状态提示，如下：

```
  Widget _getInfoMessage(String msg) {
    return Center(
      child: Text(msg),
    );
  }
```

就这样我们不使用任何一个 `setState()` 就能完成和上面一样的效果，并且不会产生副作用，是不是很给力 💪。

{% note info %}
但是，它并不是完美的，比如，我们想刷新数据，我们需要重新调用 `_getListData()` 方法，结果它并没有刷新。
{% endnote %}  

## StreamBuilder

`StreamBuilder` 通过 **stream:** 参数可以接收一个 `stream` ，同样，通过 **builder:** 参数来构建 **UI** ，和 `futureBuilder` 用法类似，唯一的好处就是，我们可以随意控制 `stream` 的输入输出，添加任何的状态来更新指定状态下的 **UI** 。

首先，我们使用 `enum` 来表示我们的状态，在文件的头部添加它，如下：

```dart
enum StreamViewState { Busy, DataRetrieved, NoData }
```

接着，使用 `StreamController` 创建一个流控制器，把 `FutureBuilder` 替换成 `StreamBuilder` ，把 **future:** 参数 改成 **stream:** 参数，如下：

```dart

final StreamController<StreamDemoState> _stateController = StreamController<StreamDemoState>();

@override
  Widget build(BuildContext context) {
    return Scaffold(

      ...

      body: StreamBuilder(
        stream: model.homeState,
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            return _getInfoMessage(snapshot.error);
          }
          // 使用 枚举的 Busy 来更新数据
          if (!snapshot.hasData || StreamViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                backgroundColor: Colors.yellow[100],
              ),
            );
          }
          //使用 枚举的 NoData 来更新数据
          if (listItems.length == StreamViewState.NoData) {
            return _getInfoMessage('No data found');
          }

          return ListView.builder(
            itemCount: listItems.length,
            itemBuilder: (buildContext, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(listItems[index]),
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
```

只是新增了枚举值来判断是否需要更新数据，其他基本保持不变。

接下来，我需要修改 `_getListData()` 方法，使用流控制器添加状态及数据，如下：

```dart
  Future _getListData({bool hasError = false, bool hasData = true}) async {
    _stateController.add(StreamViewState.Busy);
    await Future.delayed(Duration(seconds: 2));

    if (hasError) {
      return _stateController.addError('error'); // 往 stream 里新增 error 数据
    }

    if (!hasData) {
      return _stateController.add(StreamViewState.NoData); // 往 stream 里新增无数据状态
    }

    _listItems = List<String>.generate(10, (index) => '$index content');
    _stateController.add(StreamViewState.DataRetrieved); // 往 stream 里新增数据获取完成状态
  }
```

此时我们并没有返回数据，所以我们需要创建 `listItems` 存储数据，然后把 `StatelessWidget` 改成 `StatefulWidget` ，以便我们根据 `stream` 的输出来更新数据，这个转换非常方便，**VS Code** 编辑器可以使用 `Option + Shift + R` （Mac）或者 `Ctrl + Shift + R` (Win)快捷键 ，**Android Studio** 使用`Option + Enter` 快捷键，之后在 `initState()` 方法中初始化数据，如下：

```dart
List<String> listItems;

@override
void initState() {
  _getListData();
  super.initState();
}
```

到这里我们已经解决了 `FutureBuilder` 的局限性问题，我们可以新增一个 `FloatingActionButton` 来刷新数据，如下：

```dart
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Builder Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.cached,
          color: Colors.black87,
        ),
        onPressed: () {
          model.dispatch(FetchData());
        },
      ),
      body: StreamBuilder(

        ...
        
      ),
    );
  }
```

现在，我们的 `listItems` 数据并没真正的更新，点击 `FloatingActionButton` 只是更新的加载状态而已，而且我们的业务逻辑代码和 **UI** 代码还在同一个文件中，但是，他们已经解耦，所以，我们可以继续完善它，将业务逻辑代码和 **UI** 代码分离出来。

## 分离业务逻辑代码和 **UI** 代码

我们可以把处理 `stream` 的代码抽离成一个类，如下：

```dart
import 'dart:async';
import 'dart:math';

import 'package:pro_flutter/demo/stream_demo/stream_demo_event.dart';
import 'package:pro_flutter/demo/stream_demo/stream_demo_state.dart';


enum StreamViewState { Busy, DataRetrieved, NoData }

class StreamDemoModel {
  final StreamController<StreamDemoState> _stateController = StreamController<StreamDemoState>();

  List<String> _listItems;

  Stream<StreamDemoState> get streamState => _stateController.stream;

  void dispatch(StreamDemoEvent event){
    print('Event dispatched: $event');
    if(event is FetchData) {
      _getListData(hasData: event.hasData, hasError: event.hasError);
    }
  }

  Future _getListData({bool hasError = false, bool hasData = true}) async {
    _stateController.add(BusyState());
    await Future.delayed(Duration(seconds: 2));

    if (hasError) {
      return _stateController.addError('error');
    }

    if (!hasData) {
      return _stateController.add(DataFetchedState(data: List<String>()));
    }

    _listItems = List<String>.generate(10, (index) => '$index content');
    _stateController.add(DataFetchedState(data: _listItems));
  }
}
```

然后，把状态也封装成一个文件且将数据和状态关联，如下：

```dart
class StreamDemoState{}

class InitializedState extends StreamDemoState {}

class DataFetchedState extends StreamDemoState {
  final List<String> data;

  DataFetchedState({this.data});

  bool get hasData => data.length > 0;
}

class ErrorState extends StreamDemoState{}

class BusyState extends StreamDemoState{}
```

再封装一个事件文件，如下：

```dart
class StreamDemoEvent{}

class FetchData extends StreamDemoEvent{
  final bool hasError;
  final bool hasData;

  FetchData({this.hasError = false, this.hasData = true});

  @override
  String toString() {
    return 'FetchData { hasError: $hasError, hasData: $hasData }';
  }
}
```

最后，我们 **UI** 部分的代码如下：

```dart
class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  final model = StreamDemoModel(); // 创建 model

  @override
  void initState() {
    model.dispatch(FetchData(hasData: true)); // 获取 model 里的数据
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      ...

      body: StreamBuilder(
        stream: model.streamState,
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            return _getInformationMessage(snapshot.error);
          }

          var streamState = snapshot.data;

          if (!snapshot.hasData || streamState is BusyState) {  // 通过封装的状态类来判断是否更新UI
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                backgroundColor: Colors.yellow[100],
              ),
            );
          }

          if (streamState is DataFetchedState) { // 通过封装的状态类来判断是否更新UI
            if (!homeState.hasData) {
              return _getInformationMessage('not found data');
            }
          }
          return ListView.builder(
            itemCount: streamState.data.length,  // 此时，数据不再是本地数据，而是从 stream 中输出的数据
            itemBuilder: (buildContext, index) =>
                _getListItem(index, streamState.data),
          );
        },
      ),
    );
  }

  ...

}
```

此时，业务逻辑代码和 **UI** 代码已完全分离，且可扩展性和维护增强。