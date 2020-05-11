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

<div style="width:36%; margin:auto">![no-shadow](/flutterCtrip/banner.gif "searchBar" )</div>

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

