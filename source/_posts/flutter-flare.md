---
title: Flutter(Flare) 最有趣用户交互动画没有之一
tags:
  - Flutter
  - Flare
copyright: true
comments: true
date: 2020-07-04 01:09:16
categories: Dart
top: 117
photos:
---

{% li https://cdn.lishaoy.net/flutterFlare/flutter-flare-cover.png, Flutter Flare, Flutter Flare %}

2019年12月12日，**Flutter** 在 **Flutter Interact '19** 上发布了如何使用 **Rive** 和 **Flutter** 制作动态可交互的动画经验分享，我看了之后，觉得非常有趣，因此，写了3个小 demo，把它写成文章记录分享给大家。

<hr />

<!-- more -->

## 名词理解

首先，我们来理解几个名词，不然后续文章，可能看着有些晕，如下：

- Flare：是 Flutter 的动画插件名称，完整名称是 `flare_flutter` 我们要在 `pubspec.yaml` 文件里引入
- Rive：是制作 Flare 动画的[网站](https://rive.app/about-rive)，它既是一个网站也是制作工具，在此网站里有很多用户分享 Flare 动画供我们下载使用、Flare API使用文档、制作 Flare 动画的视频教程（大家也可以通过学习制作自己喜欢的动画）等


## 交互动画预览

### 登录交互动画

登录交互动画，包含如下6种动画：

- idle：无任何操作时的状态（熊的身体会上下浮动和眨眼睛）
- test：当我们在 email 输入框中输入时的状态（熊会看向输入框，且随着你输入的长度旋转头部）
- hands_up：当我们在 password 输入框中输入时的状态 （熊会用手蒙上眼睛）
- hands_down：当我们在 password 输入框输入完成时的状态 （熊会放下双手）
- fail：当我们登录失败时的状态（熊会做出难过的表情）
- success：当我们登录成功时的状态（熊会做出高兴的表情）

以上6种状态，可以在 **Rive** 网站查看具体动画，[点击进入查看](https://rive.app/a/castor/files/flare/teddy-with-hands/preview)

下面，我们来看看案例里实现动画效果

idle：无任何操作时的状态，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/sign-in.gif "idle")

</div>

test：当我们在 email 输入框中输入时的状态，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/email.gif "test")

</div>

hands_up：当我们在 password 输入框中输入时的状态，hands_down：当我们在 password 输入框输入完成时的状态，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/password.gif "hands_up & hands_down")

</div>

fail：当我们登录失败时的状态，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/failure.gif "fail")

</div>

success：当我们登录成功时的状态，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/successful.gif "success")

</div>

### Button交互动画

button 交互动画，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/button.gif "button")

</div>

### Menu交互动画

menu 交互动画，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/flutterFlare/menu.gif "menu")

</div>

以上所有动画，也可以 [点击观看视频](https://www.bilibili.com/video/BV14p4y1U7YN/)

## 代码实现

如何用代码实现，分为以下2个步骤：

- 引入插件和资源：引入相关插件 `flare_flutter` 、 `smart_flare`
- 编写代码：编写相关代码

### 引入插件和资源

引入插件和资源，如下：

```bash
dependencies:
  ...
  flare_flutter: ^2.0.4  # flare 插件
  smart_flare: any  # 对 flare API进行封装的插件，使用少量的代码即可实现交互动画
  ...

assets:
  ...
  - assets/Teddy.flr
  - assets/button-animation.flr
  - assets/slideout-menu.flr
  ...
```

### 编写代码

由于，登录交互动画稍复杂一些，在此就不展示实现的代码，如感兴趣，可[移步GitHub查看源码](https://github.com/persilee/flutter_pro/blob/master/lib/demo/flare_demo/flare_sign_in_demo.dart)

### Button交互动画代码实现

button 交互动画代码实现如下：

```dart
import 'package:flutter/material.dart';
import 'package:smart_flare/actors/smart_flare_actor.dart';
import 'package:smart_flare/models.dart';

class FlareButtonDemo extends StatefulWidget {
  @override
  _FlareButtonDemoState createState() => _FlareButtonDemoState();
}

class _FlareButtonDemoState extends State<FlareButtonDemo> {
  @override
  Widget build(BuildContext context) {
    var animationWidth = 295.0;
    var animationHeight = 251.0;
    var animationWidthThirds = animationWidth / 3;
    var halfAnimationHeight = animationHeight / 2;

    var activeAreas = [

      ActiveArea(
        area: Rect.fromLTWH(0, 0, animationWidthThirds, halfAnimationHeight),
        debugArea: false,
        guardComingFrom: ['deactivate'],
        animationName: 'camera_tapped',
      ),

      ActiveArea(
          area: Rect.fromLTWH(animationWidthThirds, 0, animationWidthThirds, halfAnimationHeight),
          debugArea: false,
          guardComingFrom: ['deactivate'],
          animationName: 'pulse_tapped'),

      ActiveArea(
          area: Rect.fromLTWH(animationWidthThirds * 2, 0, animationWidthThirds, halfAnimationHeight),
          debugArea: false,
          guardComingFrom: ['deactivate'],
          animationName: 'image_tapped'),

      ActiveArea(
          area: Rect.fromLTWH(0, animationHeight / 2, animationWidth, animationHeight / 2),
          debugArea: false,
          animationsToCycle: ['activate', 'deactivate'],
          onAreaTapped: () {
            print('Button tapped!');
          })

    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flare Button Demo'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x3fffeb3b),
                Colors.orange,
              ]),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SmartFlareActor(
            width: animationWidth,
            height: animationHeight,
            filename: 'assets/button-animation.flr',
            startingAnimation: 'deactivate',
            activeAreas: activeAreas,
          ),
        ),
      ),
    );
  }
}
```

### Menu交互动画代码实现

menu 交互动画代码实现，如下：

```dart
import 'package:flutter/material.dart';
import 'package:smart_flare/smart_flare.dart';

class FlareSidebarMenuDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: Container(
        child: Align(
          alignment: Alignment.centerRight,
          child: PanFlareActor(
            width: MediaQuery.of(context).size.width / 2.366,
            height: MediaQuery.of(context).size.height,
            filename: 'assets/slideout-menu.flr',
            openAnimation: 'open',
            closeAnimation: 'close',
            direction: ActorAdvancingDirection.RightToLeft,
            threshold: 20.0,
            reverseOnRelease: true,
            completeOnThresholdReached: true,
            activeAreas: [
              RelativePanArea(
                  area: Rect.fromLTWH(0, .7, 1.0, .3), debugArea: false),
            ],
          ),
        ),
      ),
    );
  }
}
```

以上3个交互动画案例的源码，放在了我2年前写的一个 [Flutter案例](https://github.com/persilee/flutter_pro) 的项目里了，此项目现已维护起来，以后会长期更新，感兴趣的小伙伴可以收藏，没事时来看看可能会有新的发现 😲

此篇文章到此结束，下篇文章计划给大家分享，Flutter 里的路由，会总结归纳所有的路由使用方法，最后来封装一个优秀的路由管理类。