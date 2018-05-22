---
title: 前端性能优化
tags:
  - 性能优化
  - web
copyright: true
comments: true
date: 2018-05-10 12:55:59
categories: 性能
top: 107
photos:
---

{% fi https://cdn.lishaoy.net/webOptimize/Optimize.png, web optimize, web optimize %}

关于 **性能优化** 是个大的面，这篇文章主要涉及到 **前端** 的几个点，如 **前端性能优化** 的流程、常见技术手段、工具等。

提及 **前端性能优化** ，大家应该都会想到 **雅虎军规**，本文会结合 **雅虎军规** 融入自己的了解知识，进行的总结和梳理 😜

<!-- more -->

首先，我们先来看看 👀 **雅虎军规** 的 **35** 条。

{% note info %} 
1. 尽量减少 **HTTP** 请求个数——须权衡
2. 使用 **CDN**（内容分发网络）
3. 为文件头指定 `Expires` 或 `Cache-Control` ，使内容具有缓存性。
4. 避免空的 `src` 和 `href`
5. 使用 `gzip` 压缩内容
6. 把 `CSS` 放到顶部
7. 把 `JS` 放到底部
8. 避免使用 `CSS` 表达式
9. 将 `CSS` 和 `JS` 放到外部文件中
10. 减少 **DNS** 查找次数
11. 精简 `CSS` 和 `JS`
12. 避免跳转
13. 剔除重复的 `JS` 和 `CSS`
14. 配置 **ETags**
15. 使 **AJAX** 可缓存
16. 尽早刷新输出缓冲
17. 使用 **GET** 来完成 **AJAX** 请求
18. 延迟加载
19. 预加载
20. 减少 **DOM** 元素个数
21. 根据域名划分页面内容
22. 尽量减少 `iframe` 的个数
23. 避免 **404**
24. 减少 `Cookie` 的大小
25. 使用无 `cookie` 的域
26. 减少 **DOM** 访问
27. 开发智能事件处理程序
28. 用 `<link>` 代替 `@import`
29. 避免使用滤镜
30. 优化图像
31. 优化 `CSS Spirite`
32. 不要在 `HTML` 中缩放图像——须权衡
33. favicon.ico要小而且可缓存
34. 保持单个内容小于25K
35. 打包组件成复合文本
{% endnote %}  

如对 **雅虎军规** 的具体细则内容不是很了解，可自行去各搜索 🔍 引擎 ，搜索 **雅虎军规** 了解详情。

### 压缩 合并

对于 **前端性能优化** 自然要关注 **首屏** 打开速度，而这个速度，很大因素是花费在网络请求上，那么怎么减少网络请求的时间呢？

- 减少网络请求次数 
- 减小文件体积
- 使用 `CDN` 加速

所以 **压缩、合并** 就是一个解决方案，当然可以用 `gulp` 、 `webpack` 、 `grunt` 等构建工具 **压缩、合并**

#### `JS、CSS` 压缩 合并

例如：`gulp js、css` 压缩、合并代码如下 👇

```javascript javascript https://lishaoy.net/webOptimize.html gulpfile.js
//压缩、合并js
gulp.task('scripts', function () {
    return gulp.src([
        './public/lib/fastclick/lib/fastclick.min.js',
        './public/lib/jquery_lazyload/jquery.lazyload.js',
        './public/lib/velocity/velocity.min.js',
        './public/lib/velocity/velocity.ui.min.js',
        './public/lib/fancybox/source/jquery.fancybox.pack.js',
        './public/js/src/utils.js',
        './public/js/src/motion.js',
        './public/js/src/scrollspy.js',
        './public/js/src/post-details.js',
        './public/js/src/bootstrap.js',
        './public/js/src/push.js',
        './public/live2dw/js/perTips.js',
        './public/live2dw/lib/L2Dwidget.min.js',
        './public/js/src/love.js',
        './public/js/src/busuanzi.pure.mini.js',
        './public/js/src/activate-power-mode.js'
    ]).pipe(concat('all.js')).pipe(minify()).pipe(gulp.dest('./public/dist/'));
});

// 压缩、合并 CSS 
gulp.task('css', function () {
    return gulp.src([
        './public/lib/font-awesome/css/font-awesome.min.css',
        './public/lib/fancybox/source/jquery.fancybox.css',
        './public/css/main.css',
        './public/css/lib.css',
        './public/live2dw/css/perTips.css'
    ]).pipe(concat('all.css')).pipe(minify()).pipe(gulp.dest('./public/dist/'));
});
```
然后，再把 **压缩、合并** 的 `JS、CSS` 放入 `CDN` , 👀 看看效果如何

如图：* **压缩、合并** 且放入 `CND` 之后的效果 *

<img src="https://cdn.lishaoy.net/webOptimize/concatJs.png" alt="Netlity" width="100%" title="首页请求速度(js)" align="center" />

<img src="https://cdn.lishaoy.net/webOptimize/concatCss.png" alt="Netlity" width="100%" title="首页请求速度(css)" align="center" />

以上是 [lishaoy.net](https://lishaoy.net) 清除缓存后的 **首页** 请求速度。

可见，请求时间是 **4.59 s** ，总请求个数 **51** ， 而 `js` 的请求个数是 **8** ，`css` 的请求个数是 **3** _（其实就 all.css 一个，其它 2 个是 Google浏览器加载的）_， 而没使用 **压缩、合并** 时候，请求时间是 **10** 多秒，总请求个数有 **70** 多个，`js` 的请求个数是 **20** 多个 ，对比请求时间 **性能** 提升 **1倍** 多

如图：*有缓存下的首页效果*

<img src="https://cdn.lishaoy.net/webOptimize/concatJs2.png" alt="Netlity" width="100%" title="首页请求速度（缓存）" align="center" />

基本都是秒开 😝

{% note warning %}
*Tips：在 `压缩、合并` 后，单个文件控制在 25 ~ 30 KB左右，同一个域下，最好不要多于5个资源*
{% endnote %} 

#### 图片压缩、合并 

例如：`gulp` 图片压缩代码如下 👇

```javascript javascript https://lishaoy.net/webOptimize.html gulpfile.js
//压缩image
gulp.task('imagemin', function () {
    gulp.src('./public/**/*.{png,jpg,gif,ico,jpeg}')
        .pipe(imagemin())
        .pipe(gulp.dest('./public'));
});
```

图片的合并可以采用 `CSS Spirite`，方法就是把一些小图用 `PS` 合成一张图，用 `css` 定位显示每张图片的位置

```css css
.top_right .phone {
	background: url(../images/top_right.png) no-repeat 7px -17px;
	padding: 0 38px;
}

.top_right .help {
	background: url(../images/top_right.png) no-repeat 0 -47px;
	padding: 0 38px;
}
```

然后，把 **压缩** 的图片放入 `CDN` , 👀 看看，效果如何

<img src="https://cdn.lishaoy.net/webOptimize/minImages.png" alt="Netlity" width="100%" title="首页请求速度（images）" align="center" />

可见，请求时间是 **1.70 s** ,总请求个数 **50** ， 而 `img` 的请求个数是 **15** _（这里因为首页都是大图，就没有合并，只是压缩了）_ ，但是，效果很好 😀 ，从 **4.59 s** 缩短到 **1.70 s**, 性能又提升一倍。

再看看有缓存情况如何 😏

<img src="https://cdn.lishaoy.net/webOptimize/minImages1.png" alt="Netlity" width="100%" title="首页请求速度（images 缓存）" align="center" />

请求时间是 **1.05 s** ，有缓存和无缓存基本差不多

{% note warning %}
*Tips：大的图片在不同终端，应该使用不同分辨率，而不应该使用缩放（百分比）*
{% endnote %} 

整个 **压缩、合并** _（js、css、img）_ 再放入 `CDN` ，请求时间从 **10** 多秒 ，到最后的 **1.70 s** ，性能提升 **5** 倍多，可见，这个操作必要性。

### 缓存

缓存会根据请求保存输出内容的副本，例如 **页面、图片、文件**，当下一个请求来到的时候:如果是相同的`URL`，缓存直接使 用本地的副本响应访问请求，而不是向源服务器再次发送请求。因此，可以从以下 **2** 个方面提升性能。

- 减少相应延迟，提升相应时间
- 减少网络带宽消耗，节省流量

### 未完，待续。。。 😜
