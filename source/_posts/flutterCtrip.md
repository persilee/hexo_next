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

我们再来看看二级目录，如下 (重点关注下lib目录)

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