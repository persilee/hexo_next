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

![no-shadow](/flutterCtrip/iOS-andorid.png "Hot reload")

## 项目结构分析