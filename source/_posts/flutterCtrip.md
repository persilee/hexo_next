---
title: 10天高仿大厂App及小技巧积累总结
tags:
  - Flutter
  - iOS
  - Android
  - Dart
copyright: true
comments: true
date: 2020-05-08 22:53:05
categories: Dart
top: 114
photos:
---

{% li /flutterCtrip/flutter-ctrip.jpg, Flutter, Flutter %}

之前，也写过几篇关于 `Flutter` 的博文，最近，又花了一些时间学习研究 `Flutter`，完成了高仿大厂 **App** 项目 *(项目使用的接口都是来自线上真实App抓包而来，可以做到和上线项目相同的效果)*，也总结积累了一些小技巧和知识点，所以，在这里记录分享出来，也希望 `Flutter` 生态越来越好 *（flutter开发App效率真的很高，开发体验也是很好的 🙂）*。

<hr />

<!-- more -->

以下博文会分为4个部分概述：
- 项目完成的功能预览
- 项目结构分析
- 项目功能详细概述（所用知识点）
- 小技巧积累总结

## 项目完成的功能预览

首先，我们来通过一个视频来快速预览下项目完成的功能和运行效果，如下

<video id="flutter" class="video-js vjs-default-skin" controls preload="auto" poster="/flutterCtrip/ctrip.png"
    data-setup="{'example_option':true}">
    <source src="/flutterCtrip/ctrip.mp4" type='video/mp4' />
</video>

大家看完视频，大概了解到，完成度基本可以和线上的 **App** 相差无异了，大家如果对项目感兴趣，想了解具体怎么实现的，可以去我的 [GitHub](https://github.com/persilee) clone 源码查看。

本视频是用真机录屏的，因为，语音搜索功能需要录音，模拟器无法录音，当然, `iOS` 和 `Andorid`都可以运行，效果是一样的，如图：

![no-shadow](/flutterCtrip/iOS-andorid.png "iOS Andorid")

## 项目结构分析

其次，梳理下项目的目录结构，理解每个文件都是干什么的，我们先来看看一级目录，如下：

```bash
├── README.md  # 描述文件
├── android    # android 宿主环境
├── build      # 项目构建目录，由flutter自动完成
├── flutter_ctrip.iml
├── fonts      # 自己创建的目录，用于存放字体
├── images     # 自己创建的目录，用于存放图片
├── ios        # iOS 宿主环境
├── lib        # flutter 执行文件，自己写的代码都在这
├── pubspec.lock # 用来记录锁定插件版本
├── pubspec.yaml # 插件及资源配置文件
└── test       # 测试目录
```

这个就不用多解释，大多是 flutter 生成及管理的，我们需要关注的是 **lib** 目录。

我们再来看看二级目录，如下 *(重点关注下lib目录)*

```bash
├── README.md
├── android
│   ├── android.iml
  ...
│   └── settings.gradle
├── build
│   ├── app
  ...
│   └── snapshot_blob.bin.d.fingerprint
├── flutter_ctrip.iml
├── fonts
│   ├── PingFang-Italic.ttf
│   ├── PingFang-Regular.ttf
│   └── PingFang_Bold.ttf
├── images
│   ├── grid-nav-items-dingzhi.png
  ...
│   └── yuyin.png
├── ios
│   ├── Flutter
  ...
│   └── ServiceDefinitions.json
├── lib
│   ├── dao           # 请求接口的类
│   ├── main.dart     # flutter 入口文件
│   ├── model         # 实体类，把服务器返回的 json 数据，转换成 dart 类
│   ├── navigator     # bottom bar 首页底部导航路由
│   ├── pages         # 所以的页面
│   ├── plugin        # 封装的插件
│   ├── util          # 工具类，避免重复代码，封装成工具类以便各个 page 调用
│   └── widget        # 封装的组件
├── pubspec.lock
├── pubspec.yaml
└── test
    └── widget_test.dart
```

再来看看，**lib** 目录下二级目录，看看整个项目创建了多少个文件，写了多少代码，如下 *（其实，并不是很多）*

```bash
├── dao/
│   ├── destination_dao.dart*
│   ├── destination_search_dao.dart*
│   ├── home_dao.dart
│   ├── search_dao.dart*
│   ├── trave_hot_keyword_dao.dart*
│   ├── trave_search_dao.dart*
│   ├── trave_search_hot_dao.dart*
│   ├── travel_dao.dart*
│   ├── travel_params_dao.dart*
│   └── travel_tab_dao.dart*
├── main.dart
├── model/
│   ├── common_model.dart
│   ├── config_model.dart
│   ├── destination_model.dart
│   ├── destination_search_model.dart
│   ├── grid_nav_model.dart
│   ├── home_model.dart
│   ├── sales_box_model.dart
│   ├── seach_model.dart*
│   ├── travel_hot_keyword_model.dart
│   ├── travel_model.dart*
│   ├── travel_params_model.dart*
│   ├── travel_search_hot_model.dart
│   ├── travel_search_model.dart
│   └── travel_tab_model.dart
├── navigator/
│   └── tab_navigater.dart
├── pages/
│   ├── destination_page.dart
│   ├── destination_search_page.dart
│   ├── home_page.dart
│   ├── my_page.dart
│   ├── search_page.dart
│   ├── speak_page.dart*
│   ├── test_page.dart
│   ├── travel_page.dart
│   ├── travel_search_page.dart
│   └── travel_tab_page.dart*
├── plugin/
│   ├── asr_manager.dart*
│   ├── side_page_view.dart
│   ├── square_swiper_pagination.dart
│   └── vertical_tab_view.dart
├── util/
│   └── navigator_util.dart*
└── widget/
    ├── grid_nav.dart
    ├── grid_nav_new.dart
    ├── loading_container.dart
    ├── local_nav.dart
    ├── sales_box.dart
    ├── scalable_box.dart
    ├── search_bar.dart*
    ├── sub_nav.dart
    └── webview.dart
```

整个项目就是以上这些文件了 *（具体的就不一个一个分析了，如，感兴趣，大家可以 clone 源码运行起来，自然就清除了）*。

## 项目功能详细概述（所用知识点）

首先，来看看首页功能及所用知识点，首页重点看下以下功能实现：

- 渐隐渐现的 **appBbar** 
- 搜索组件的封装
- banner组件
- 浮动的 icon 导航
- 渐变不规则带有背景图的网格导航

### 渐隐渐现的 appBbar

先来看看具体效果，一睹芳容，如图：

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/appBar.gif "appBar" )</div>

滚动的时候 **appBar** 背景色从透明变成白色或白色变成透明，这里主要用来 **flutter** 的 `NotificationListener` 组件，它回去监听组件树冒泡时间，当被它包裹的的组件*（子组件）* 发生变化时，`Notification` 回调函数会被触发，所以，通过它可以去监听页面的滚动，来动态改变 **appBar** 的透明度*（alpha）*，代码如下：

```dart
NotificationListener(
  onNotification: (scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification &&
        scrollNotification.depth == 0) {
      _onScroll(scrollNotification.metrics.pixels);
    }
    return true;
  },
  child: ...
```

{% note warning %} 
<i class="fa fa-fw fa-bell  faa-horizontal animated faa-slow" style="color: #faab33;"></i> **Tips：** 
{% label danger@scrollNotification.depth %}的值 0 表示其子组件*(只监听子组件，不监听孙组件)*；
{% label danger@scrollNotification is ScrollUpdateNotification %}来判断组件是否已更新，**ScrollUpdateNotification** 是 notifications 的生命周期，分别有一下几种：
- ScrollStartNotification 组件开始滚动
- ScrollUpdateNotification 组件位置已经发生改变
- ScrollEndNotification 组件停止滚动
- UserScrollNotification 不清楚

这里，我们不探究太深入，如想了解可多查看源码。

{% endnote %} 

**_onScroll** 方法代码如下：

```dart
  void _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;  // APPBAR_SCROLL_OFFSET 常量，值：100；offset 滚动的距离

    //把 alpha 值控制值 0-1 之间
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(alpha);
  }
```

### 搜索组件的封装

搜索组件效果如图：

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/searchBar.gif "searchBar" )</div>

以下是首页调用 `searchBar` 的代码：

```dart
SearchBar(
  searchBarType: appBarAlpha > 0.2  //searchBar 的类：暗色、亮色
      ? SearchBarType.homeLight
      : SearchBarType.home,
  inputBoxClick: _jumpToSearch,     //点击回调函数
  defaultText: SEARCH_BAR_DEFAULT_TEXT,   // 提示文字
  leftButtonClick: () {},           //左边边按钮点击回调函数
  speakClick: _jumpToSpeak,         //点击话筒回调函数
  rightButtonClick: _jumpToUser,    //右边边按钮点击回调函数
),
```
其实就是用 `TextField` 组件，再加一些样式，需要注意点是：**onChanged**，他是 **TextField** 用来监听文本框是否变化，通过它我们来监听用户输入，来请求接口数据;
具体的实现细节，请查阅源码： [点击查看searchBar源码](https://github.com/persilee/flutter_ctrip/blob/master/lib/widget/search_bar.dart)

### banner组件

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/banner.gif "banner" )</div>

`banner`使用的是flutter的 [flutter_swiper](https://pub.dev/packages/flutter_swiper) 插件，代码如下：

```dart
Swiper(
  itemCount: bannerList.length,              // 滚动图片的数量
  autoplay: true,                            // 自动播放
  pagination: SwiperPagination(              // 指示器
      builder: SquareSwiperPagination(
        size: 6,                             // 指示器的大小
        activeSize: 6,                       // 激活状态指示器的大小
        color: Colors.white.withAlpha(80),   // 颜色
        activeColor: Colors.white,           // 激活状态的颜色
      ),
    alignment: Alignment.bottomRight,        // 对齐方式
    margin: EdgeInsets.fromLTRB(0, 0, 14, 28), // 边距
  ),
  itemBuilder: (BuildContext context, int index) { // 构造器
    return GestureDetector(
      onTap: () {
        CommonModel model = bannerList[index];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebView(
              url: model.url,
            ),
          ),
        );
      },
      child: Image.network(
        bannerList[index].icon,
        fit: BoxFit.fill,
      ),
    );
  },
),
```

具体使用方法，可以去 flutter的官方插件库 [pub.dev](https://pub.dev/) 查看：[点击flutter_swiper查看](https://pub.dev/packages/flutter_swiper)。
{% note warning %} 
<i class="fa fa-fw fa-bell  faa-horizontal animated faa-slow" style="color: #faab33;"></i> **Tips：** 
需要注意的是，我稍改造了一下指示器的样式，`flutter_swiper` 只提供了 3 种指示器样式，如下：
- dots = const DotSwiperPaginationBuilder()，圆形
- fraction = const FractionPaginationBuilder()，百分数类型的,如：1/6，表示6页的第一页
- rect = const RectSwiperPaginationBuilder()，矩形

并没有上图的激活状态的长椭圆形，其实就是按葫芦画瓢，自己实现一个长椭圆类型，如知详情，可[点击查看长椭圆形指示器源码](https://github.com/persilee/flutter_ctrip/blob/master/lib/plugin/square_swiper_pagination.dart)
{% endnote %} 

### 浮动的 icon 导航

**icon导航**效果如图：

<img src="/flutterCtrip/iconBar.png" alt="iconBar" width="36%" title="iconBar" align="center">

**icon导航**浮动在banner之上，其实用的是 `flutter` 的 **Stack** 组件，Stack 组件能让其子组件堆叠显示，它通常和 **Positioned** 组件配合使用，布局结构代码如下：

```dart
ListView(
  children: <Widget>[
    Container(
      child: Stack(
        children: <Widget>[
          Container( ... ), //这里放的是banner的代码
          Positioned( ... ), //这个就是icon导航，通过 Positioned 固定显示位置
        ],
      ),
    ),
    Container( ... ), // 这里放的网格导航及其他
  ],
),
```

### 渐变不规则带有背景图的网格导航

网格导航效果如图：

<img src="/flutterCtrip/gridNav.png" alt="gridNav" width="46%" title="gridNav" align="center">

如图，网格导航分为三行四栏，而第一行分为三栏，每一行的第一栏宽度大于其余三栏，其余三栏均等，每一行都有渐变色，而且第一、二栏都有背景图;
`flutter` 里 **Column** 组件能让子组件竖轴排列， **Row** 组件能让子组件横轴排列，布局代码如下：

```dart
Column(                      // 最外面放在 Column 组件
  children: <Widget>[
    Container(               // 第一行包裹 Container 设置其渐变色
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [  //设置渐变色
          Color(0xfffa5956),
          Color(0xffef9c76).withAlpha(45)
        ]),
      ),
      child: Row( ... ),    // 第一行
    ),
    Padding(
      padding: EdgeInsets.only(top: 1),  // 设置行直接的间隔
    ),
    Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [  //设置渐变色
          Color(0xff4b8fed),
          Color(0xff53bced),
        ]),
      ),
      child: Row( ... ),  // 第二行
    ),
    Padding(
      padding: EdgeInsets.only(top: 1),   // 设置行直接的间隔
    ),
    Container(
      height: 72,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [  //设置渐变色
          Color(0xff34c2aa),
          Color(0xff6cd557),
        ]),
      ),
      child: Row( ... ),  // 第三行
    ),
  ],
),
```

其实，具体实现的细节还是很多的，比如：
- 怎么设置第一栏宽度偏大，其他均等；
- 第一行最后一栏宽度是其他的2倍；
- 第一、二栏的别截图及浮动的红色气泡tip等;

在这里就不细讲，否则篇幅太长，如想了解详情 [点击查看源码](https://github.com/persilee/flutter_ctrip/blob/master/lib/widget/grid_nav_new.dart)

其次，再来看看**目的地**页面功能及所用知识点，重点看下以下功能实现：

- 左右布局tabBarListView 
- 目的地搜索页面

### 左右布局tabBarListView 

具体效果如图：点击左边标签可以切换页面，左右滑动也可切换页面，点击展开显示更多等

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/destination.gif "destination" )</div>

其实官方已经提供了 **tabBar** 和 **TabBarView** 组件可以实现上下布局的效果*(旅拍页面就是用这个实现的)*，但是它无法实现左右布局，而且不太灵活，所以，我使用的是 [vertical_tabs](https://pub.dev/packages/vertical_tabs), 代码如下：

```dart
VerticalTabView(
    tabsWidth: 88,
    tabsElevation: 0,
    indicatorWidth: 0,
    selectedTabBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    tabTextStyle: TextStyle(
      height: 60,
      color: Color(0xff333333),
    ),
    tabs: tabs,
    contents: tabPages,
  ),
),
```

具体使用方法，在这里就不赘述了，[点击vertical_tabs查看](https://pub.dev/packages/vertical_tabs)

{% note warning %} 
<i class="fa fa-fw fa-bell  faa-horizontal animated faa-slow" style="color: #faab33;"></i> **Tips：** 
这里需要注意的是：**展开**显示更多span标签组件的实现，因为，这个组件在很多的其他组件里用到而且要根据接口数据动态渲染，且组件自身存在状态的变化，这种情况下，最后是把他单独封装成一个组件*(widget)*，否则，很难控制自身状态的变化，出现点击没有效果，或点击影响其他组件。 
{% endnote %} 

### 目的地搜索页面

效果如图：点击搜索结果，如：‘一日游‘，会搜索到‘一日游‘的相关数据

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/destination-search.gif "destination" )</div>

目的地搜索页面，大多都是和布局和对接接口的事情，在这里就不再赘述。

然后就是**旅拍页面**功能及所用知识点，重点看下以下功能实现：

- 左右布局tabBarListView
- 瀑布流卡片
- 旅拍搜索页

### 左右布局tabBarListView

效果如图：可左右滑动切换页面，上拉加载更多，下拉刷新等

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/travel.gif "travel" )</div>

这个是`flutter` 提供的组件，**tabBar** 和 **TabBarView**，代码如下：

```dart
Container(
  color: Colors.white,
  padding: EdgeInsets.only(left: 2),
  child: TabBar(
    controller: _controller,
    isScrollable: true,
    labelColor: Colors.black,
    labelPadding: EdgeInsets.fromLTRB(8, 6, 8, 0),
    indicatorColor: Color(0xff2FCFBB),
    indicatorPadding: EdgeInsets.all(6),
    indicatorSize: TabBarIndicatorSize.label,
    indicatorWeight: 2.2,
    labelStyle: TextStyle(fontSize: 18),
    unselectedLabelStyle: TextStyle(fontSize: 15),
    tabs: tabs.map<Tab>((Groups tab) {
      return Tab(
        text: tab.name,
      );
    }).toList(),
  ),
),
Flexible(
    child: Container(
  padding: EdgeInsets.fromLTRB(6, 3, 6, 0),
  child: TabBarView(
      controller: _controller,
      children: tabs.map((Groups tab) {
        return TravelTabPage(
          travelUrl: travelParamsModel?.url,
          params: travelParamsModel?.params,
          groupChannelCode: tab?.code,
        );
      }).toList()),
)),
```

### 瀑布流卡片

**瀑布流卡片** 用的是 [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) 插件，代码如下：

```dart
StaggeredGridView.countBuilder(
  controller: _scrollController,
  crossAxisCount: 4,
  itemCount: travelItems?.length ?? 0,
  itemBuilder: (BuildContext context, int index) => _TravelItem(
        index: index,
        item: travelItems[index],
      ),
  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
  mainAxisSpacing: 2.0,
  crossAxisSpacing: 2.0,
),
```

如下了解更多相关信息，[点击flutter_staggered_grid_view查看](https://pub.dev/packages/flutter_staggered_grid_view)。

### 旅拍搜索页

效果如图：首先显示热门旅拍标签，点击可搜索，输入关键字可搜索相关旅拍信息，地点、景点、用户等

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/travel-search.gif "travel-search" )</div>

旅拍搜索页，大多也是和布局和对接接口的事情，在这里就不再赘述。

## 小技巧积累总结

以下都是我在项目里使用的知识点，在这里记录分享出来，希望能帮到大家。

### PhysicalModel

**PhysicalModel** 可以裁剪带背景图的容器，如，你在一个 Container 里放了一张图片，你想设置图片圆角，这是设置 Container 的 decoration 的 borderRadius 是无效的，这时候就要用到 **PhysicalModel**，代码如下：

```dart
PhysicalModel(
  borderRadius: BorderRadius.circular(6),  // 设置圆角
  clipBehavior: Clip.antiAlias,            // 裁剪行为
  color: Colors.transparent,               // 颜色
  elevation: 5,                            // 设置阴影
  child: Container(
        child: Image.network(
          picUrl,
          fit: BoxFit.cover,
        ),
      ),
),
```

### LinearGradient

给容器添加渐变色，在网格导航、appBar等地方都使用到，代码如下：

```dart
Container(
  height: 72,
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [
      Color(0xff4b8fed),
      Color(0xff53bced),
    ]),
  ),
  child: ...
),
```

### Color(int.parse('0xff' + gridNavItem.startColor))

颜色值转换成颜色，如果，没有变量的话，也可直接 `Color(0xff53bced)`，
- ox：flutter要求，可固定不变
- ff：代表透明贴，不知的如何设置的话，可以用取色器，或者 withOpacity(opacity) 、 withAlpha(a)
- 53bced: 常规的6位RGB值

### Expanded、FractionallySizedBox

**Expanded** 可以让子组件撑满父容器，通常和 **Row** 及 **Column** 组件搭配使用
**FractionallySizedBox** 可以让子组件撑满或超出父容器，可以单独使用，大小受 widthFactor 和 heightFactor 宽高因子的影响

### MediaQuery.removePadding

**MediaQuery.removePadding** 可以移除组件的边距，有些组件自带有边距，有时候布局的时候，不需要边距，这时候就可以用 **MediaQuery.removePadding**，代码如下：

```dart
MediaQuery.removePadding(
  removeTop: true,
  context: context,
  child: ...
)
```

### MediaQuery.of(context).size.width

**MediaQuery.of(context).size.width** 获取屏幕的宽度，同理，**MediaQuery.of(context).size.height** 获取屏幕的高度；
如，想一行平均3等分： 0.3 * MediaQuery.of(context).size.width，在**目的地页面**的标签组件就使用到它，代码如下：

```dart
Container(
  alignment: Alignment.center,
  ...
  width: 0.3*MediaQuery.of(context).size.width - 12, // 屏幕平分三等分， - 12 是给每份中间留出空间 
  height: 40,
  ...
  child: ...
),
```

### Theme.of(context).platform == TargetPlatform.iOS

判断操作系统类型，有时候可能有给 Andorid 和 iOS 做出不同的布局，就需要用到它。

### with AutomaticKeepAliveClientMixin

`flutter` 在切换页面时候每次都会重新加载数据，如果想让页面保留状态，不重新加载，就需要使用 **AutomaticKeepAliveClientMixin**,代码如下：*（在旅拍页面就有使用到它，为了让tabBar 和 tabBarView在切换时不重新加载）*

```dart
class TravelTabPage extends StatefulWidget {
  ...
  //需要重写 wantKeepAlive 且 设置成 true
  @override
  bool get wantKeepAlive => true;
}
```

暂时只能想到这些知识点，以后如有新的会慢慢补充。