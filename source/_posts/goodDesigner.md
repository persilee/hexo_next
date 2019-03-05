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

这篇文章总结一下之前项目中一些 **前端** 工具及技巧，主要包括 **Iconfont的正确使用姿势** 、 **如何使用酷炫漂亮的动画（Lottie）** 、 **如何加入页面滚动入场离场动效**。

<!-- more -->

## Iconfont的正确使用姿势 

[Iconfont](https://www.iconfont.cn) 是阿里巴巴打造的矢量图标库，图标丰富多彩（单色和彩色），使用方便快捷（可筛选图片创建自己项目图标库），支持在线使用，摆脱了传统的图片的繁琐和css字体图标库引入的冗余。

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

首先，把生成的链接引入到页面中，如下

```css
<link rel="stylesheet" href="//at.alicdn.com/t/font_1066942_yvi703p2pv.css">
```

其次，用 `<i class="iconfont icon-Userselect"></i>` 在页面中使用，大小颜色都可以用 `css` 调整

阿里在代码的复制、图标的搜索、编辑、下载、筛选等一些操作上做的很到位，使用起来方便快捷

我在之前的项目里也使用过，还是很漂亮的 [https://a.lishaoy.net](https://a.lishaoy.net) ，如图是我在项目里使用的一些图标，每个图标是不是都做的很精致

![Iconfont](https://cdn.lishaoy.net/goodDesigner/Iconfont7.png "Iconfont" )

## Lottie开源动画库

**Lottie** 是Airbnb开源的一个面向 iOS、Android、React Native 的动画库，能够直接把 **AE** 导出的动画文件（json），引入到页面使用，以下是官方给出的效果图

![no-shadow](https://cdn.lishaoy.net/goodDesigner/lottie.gif "Lottie" )

![no-shadow](https://cdn.lishaoy.net/goodDesigner/lottie2.gif "Lottie" )

**Lottie** 支持 iOS、Android、React Native 、Web ，这里主要介绍 lottie-Web 是如何使用，更多使用方法可以参考 [http://airbnb.io/lottie/](http://airbnb.io/lottie/)

首先，在页面中引入 `CDN` 上的文件，如下

```js
<script src="https://cdnjs.cloudflare.com/ajax/libs/bodymovin/5.4.2/lottie.min.js" type="text/javascript"></script>
```

其次，使用 **AE** 制作动画（UI提供或者自己制作）导出的 `json`，或者可以在 [Lottie Files](https://lottiefiles.com/featured) 下载 （[Lottie Files](https://lottiefiles.com/featured) 是一个拥有高质量 **Lottie** 文件格式动画的网站，不仅设计师可以在上面陈列他们的动画而且还提供免费下载）

以下是我在项目里使用的效果图（上传图片中会加重动画，上传成功动画停止），具体效果可以去我的项目上传图片体验 [上传图片动画效果](https://a.lishaoy.net/posts/56)

![Lottie](https://cdn.lishaoy.net/adonisjs/image_upload4.gif "Lottie" )

具体的代码如下，在页面中创建需要加重动画的容器（`HTML` 代码）

```html
<div class="image-load d-flex justify-content-center align-items-center">
  <div class="box">
    <div class="lottie"></div>
    <div class="text text-muted text-center">The picture is being uploaded ...</div>
  </div>
</div>
```

然后，用 `js` 初始化动画，如下

```js
    let anim = lottie.loadAnimation({
      container: $('.image-load .lottie')[0], //动画容器的元素
      renderer: 'svg', //支持 svg 和 canvas
      loop: true, //是否循环
      autoplay: false, // 是否自动播放
      path: '/EmojiReaction.json' //动画json文件的位置
    })
    anim.addEventListener('loopComplete', () => {  // 监听 `loopComplete` 事件，每次播放完成执行
      anim.pause() //停止播放
      $('.image-load').removeClass('loading') //隐藏容器
      $('.image-load .box .text').text('The picture is being uploaded...').removeClass('text-success').addClass('text-muted') //改变说明文字状态及颜色
    })
```

更多的参数和事件可查阅官方文档 [Lottie-Web](http://airbnb.io/lottie/web/web.html)

## 如何加入页面滚动入场离场动效

首先，让我们来先看看效果，如图（效果来源我的博客 [https://lishaoy.net](https://lishaoy.net/laboratory/)）

![Lottie](https://cdn.lishaoy.net/goodDesigner/lottie3.gif "Lottie" )

以上动效就是用的 **AOS** 这个库，具体的使用方法也很简单

在页面上引入 `css` 和 `js` 文件

```html
<link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css"/>

<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
```

然后，用 `AOS.init()` 初始化，这样初始化，使用的是默认设置，具体有很多参数可以调整，详情可查阅 [项目文档](https://github.com/michalsnik/aos)，如

```js
AOS.init({
  // Global settings:
  disable: false, // accepts following values: 'phone', 'tablet', 'mobile', boolean, expression or function
  startEvent: 'DOMContentLoaded', // name of the event dispatched on the document, that AOS should initialize on
  initClassName: 'aos-init', // class applied after initialization
  animatedClassName: 'aos-animate', // class applied on animation
  useClassNames: false, // if true, will add content of `data-aos` as classes on scroll
  disableMutationObserver: false, // disables automatic mutations' detections (advanced)
  debounceDelay: 50, // the delay on debounce used while resizing window (advanced)
  throttleDelay: 99, // the delay on throttle used while scrolling the page (advanced)
  

  // Settings that can be overridden on per-element basis, by `data-aos-*` attributes:
  offset: 120, // offset (in px) from the original trigger point
  delay: 0, // values from 0 to 3000, with step 50ms
  duration: 400, // values from 0 to 3000, with step 50ms
  easing: 'ease', // default easing for AOS animations
  once: false, // whether animation should happen only once - while scrolling down
  mirror: false, // whether elements should animate out while scrolling past them
  anchorPlacement: 'top-bottom', // defines which position of the element regarding to window should trigger the animation

});
```

最后，在页面上使用即可，如

```html
<div data-aos="fade-in"></div>
```

或者，也可以单独给元素设置参数，使用 `data-aos-*` ，如

```html
<div data-aos="fade-in"
  data-aos-offset="200"
  data-aos-delay="50"
  data-aos-duration="1000"
  data-aos-easing="ease-in-out"
></div>
```

更多的载入效果可以参考官方给出的 [示例](http://michalsnik.github.io/aos/)

如在您做的页面或应用中使用了这三招，**精致小图标** 、 **炫酷的动画** 、 **页面滚动载入动效** ，那么瞬间让您的页面或应用高大上且生动活泼起来。