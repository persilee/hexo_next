---
title: Flutter：手拉手带你极速构建漂亮的跨平台(iOS/Android)移动应用 ✿ 初识
tags:
  - Flutter
  - iOS
  - Android
  - Dart
copyright: true
comments: true
date: 2018-11-05 10:41:09
categories: Dart
top: 109
photos:
---

{% li https://cdn.lishaoy.net/beautifulFlutter/flutter_750x400.png, Flutter, Flutter %}

最近，学习了一些 `Flutter` 相关的知识，做了如下的小移动应用，当然是一套代码即可在 `iOS` 平台运行,也可以在 `Android` 运行。

下面我将手拉手带您快速构建出漂亮的移动应用界面（如下👇小视频）

<video id="flutter" class="video-js vjs-default-skin" controls preload="auto" poster="https://cdn.lishaoy.net/flutter_start/flutter5.1.png"
    data-setup="{'example_option':true}">
    <source src="https://cdn.lishaoy.net/flutter_start/flutter7.mp4" type='video/mp4' />
</video>

<hr />

<!-- more -->

## 初识 Flutter

[Flutter](https://flutterchina.club) 是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。

Google 推出 Flutter 移动应用框架已经有三年，直到今年的 Google I/O 开发大会才正式介绍 `Flutter` 且发布 Beta 版本, [Flutter Google I/O 视频](https://www.youtube.com/watch?v=w2TcYP8qiRI) 这个是 `Flutter` 在油管（YouTube）的 Google I/O 开发者大会的视频，请自行观看。

再来看看更加生动的视频介绍，加速您的初识 `Flutter`

<video id="IntroducingFlutter" class="video-js vjs-default-skin" controls preload="auto" poster="https://cdn.lishaoy.net/beautifulFlutter/IntroducingFlutter1.png"
    data-setup="{'example_option':true}">
    <source src="https://cdn.lishaoy.net/beautifulFlutter/IntroducingFlutter.mp4" type='video/mp4' />
</video>

<hr />

Google 的广告应用 Adwords，阿里的闲鱼 App 都是基于 `Flutter` 框架开发的。

以下是阿里巴巴用 Flutter 打造了5000多万用户闲鱼 App (Flutter Developer Story) 的故事视频

<video id="FlutterDeveloperStory" class="video-js vjs-default-skin" controls preload="auto" poster="https://cdn.lishaoy.net/beautifulFlutter/FlutterDeveloperStory2.png"
    data-setup="{'example_option':true}">
    <source src="https://cdn.lishaoy.net/beautifulFlutter/FlutterDeveloperStory.mp4" type='video/mp4' />
</video>

<hr />

`Flutter` 作为谷歌推出的跨平台开发框架，一经推出便吸引了不少注意,在 GitHub 上的 Star 数已超过 **4W+** 。

[CMTC全球大前端技术大会 ㄧ Flutter视频](https://www.bilibili.com/video/av27857568/) 这是 Google中国在 **bilibili** 上发布的视频，请自行观看。

## Flutter 特性

通过以上的视频，对于 `Flutter` 已有所认识，下面再来看看 `Flutter` 的以下特性

### 热重载

当你修改了代码 <kbd>⌘</kbd> - <kbd>S</kbd> ，可立刻看到效果，而且可以保持界面状态不变（如文本框输入的信息不会改变），如图：

![no-shadow](https://cdn.lishaoy.net/beautifulFlutter/HotReload1.gif "Hot reload")

### 设计

`Flutter` 自带 Google 推行的设计系统：[Material Design](https://www.material.io) ，它提供了丰富的 **Material Design** 风格的组件（比如：按钮、输入框、对话框、导航栏、边栏等），而且也提供了丰富的 **iOS（Cupertino）** 风格的组件，利用这些风格的组件能够快速的构建应用，如图

![no-shadow](https://cdn.lishaoy.net/beautifulFlutter/Material.jpg "Material Design")

### widget

**widget** 是 `Flutter` 应用程序基本构建块, `Flutter` 既不使用 WebView，也不使用操作系统的原生控件，相反 `Flutter` 使用自己的高性能渲染引擎来绘制**widget** ， `Flutter` 的中心思想是用 **widget** 构建你的 UI（**一切皆为 widget**） ，如图是官网给出的框架图：

![no-shadow](https://cdn.lishaoy.net/beautifulFlutter/widget.png "widget")

在这个架构里，你可以实现 `Flutter` 提供的所有现成的 **widget** ，也可以创建自己定制的 **widget** ，每个 **widget** 都是公开的，你可以从高层次且统一的 **widget** 中获得开发效率优势，这个设计的目标是为了用更少的代码做更多的事情。

### 语言

`Flutter` 使用 C、C ++、Dart 和 Skia（2D渲染引擎）技术构建，如上图，底层（engine）是用 C ++ ，框架是用 Dart ，当然我们开发使用的也是 Dart。

Dart 是 Google 发布的一种高效、简洁、拥有完整类型系统的 `结构化的Web编程` 语言， `Flutter` 官方给出为什么选择 Dart 作为开发语言的原因，如下

- 开发人员的效率
- 面向对象
- 可预测，高性能
- 快速内存分配

对于开发者（语言使用者）来说，不必太担心，Dart 和 Java 、 JavaScript 比较类似，有一些程序语言基础，便可拿来即用（不清楚的看看语法、关键字、类型即可）。

现在想必您对 `Flutter` 已经有了一定的认识，在之后的篇幅了会手拉手带你极速构如文头小视频的小应用。

## 未完待续...

<img class="hidden" src="https://cdn.lishaoy.net/beautifulFlutter/flutter_750x400.png" alt="VS Code" width="100%" title="VS Code" align="center">