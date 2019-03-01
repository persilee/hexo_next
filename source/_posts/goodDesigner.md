---
title: 三招让你成为程序猿中优秀的设计师
tags:
  - IconFont
  - Lottie
  - Animate
  - AOS
copyright: true
comments: true
date: 2019-03-01 16:24:32
categories: 
  - [CSS]
  - [设计]
top: 113
photos:
---

{% li https://cdn.lishaoy.net/goodDesigner/goodDesigner.jpg, goodDesigner, goodDesigner %}

这篇文章总结一下之前项目中一些 **前端** 工具及技巧，主要包括 **Iconfont的正确使用姿势** 、 **如何使用酷炫漂亮的动画（Lottie）** 、 **如何加入页面滚动入场离场动画**。

<!-- more -->

## Iconfont的正确使用姿势 

[Iconfont](https://www.iconfont.cn) 是阿里巴巴打造的矢量图标库，图标丰富多彩（单色和彩色），使用方便快捷（可筛选图片创建自己项目图标库），支持在线使用，拜托了传统的图片的繁琐和css字体图标库引入的冗余。

下面介绍下如何使用 Iconfont

### 搜索选择图标

点击 [Iconfont](https://www.iconfont.cn) 打开页面如图，可以搜索 🔍 关键字，找到想要的图标

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont.png "Iconfont" )

例如，搜索 ‘image’ 关键字，如图

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont2.png "Iconfont" )

鼠标放到图标上会出现 **添加入库** 、 **收藏** 、 **下载图标** 选项，一般我会选择 **添加入库** ，之后统一添加到项目，生成在线地址引入项目（后面会介绍到）

右边的蓝色皇冠按钮可以进行 *精选* 、 *全部* 的筛选，红色的按钮可以进行 *单色* 、 *多色* 、 *全部* 的筛选

点击 下载 会弹出下载页面，可以进行图标的编辑和不同格式的下载，如图

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont3.1.png "Iconfont" )

### 添加入库生成在线连接

选择 **添加入库** 的图标，会在右上角的购物车显示数量，点击购物车图标，会弹出右侧栏，如图

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont4.png "Iconfont" )

可以批量下载和添加到项目，点击 **添加至项目** 如图

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont5.png "Iconfont" )

给项目取一个名字，点击确定，如图

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont6.png "Iconfont" )

可以看到有三种图标引入的方式，默认选中的是 **Font class** 的方式，也推荐使用这种方式

**Unicode** : 是以字体的方式引入，如下

```css
@font-face {
  font-family: 'iconfont';  /* project id 1066942 */
  src: url('//at.alicdn.com/t/font_1066942_yvi703p2pv.eot');
  src: url('//at.alicdn.com/t/font_1066942_yvi703p2pv.eot?#iefix') format('embedded-opentype'),
  url('//at.alicdn.com/t/font_1066942_yvi703p2pv.woff2') format('woff2'),
  url('//at.alicdn.com/t/font_1066942_yvi703p2pv.woff') format('woff'),
  url('//at.alicdn.com/t/font_1066942_yvi703p2pv.ttf') format('truetype'),
  url('//at.alicdn.com/t/font_1066942_yvi703p2pv.svg#iconfont') format('svg');
}
```

**Font class** : 是以Css的方式引入，如下

```html
//at.alicdn.com/t/font_1066942_yvi703p2pv.css
```

**Symbol** : 是以js的方式引入，如下

```html
//at.alicdn.com/t/font_1066942_yvi703p2pv.js
```

如想了解3中方式具体用法，可点击 [官方文档](https://www.iconfont.cn/help/detail?spm=a313x.7781069.1998910419.d8cf4382a&helptype=code)，这里我主要介绍 **Font class** 的方式

### 引入项目使用

