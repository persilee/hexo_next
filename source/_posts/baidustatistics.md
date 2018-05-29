---
title: 百度统计
tags:
  - 统计
  - null
copyright: true
comments: true
date: 2018-05-30 03:48:15
categories: hexo
top: 107
photos:
---

{% fi https://cdn.lishaoy.net/baidustatistics/lishaoy.net.1.png, lishaoy.net, lishaoy.net %}

前天，把 **站点**（[lishaoy.net](https://lishaoy.net)） 接入了 **百度统计**，看了看这些统计的数据，还是挺有意思 🐶

<!-- more -->

**站点** 接入 **百度统计**，还是挺简单的：

- 首先，去 [百度统计](https://tongji.baidu.com/web/welcome/login) 注册账号，根据提示绑定自己站点域名
- 之后，把提供的 `js` 代码放到自己站点

```javascript 
  //百度统计
  var _hmt = _hmt || [];
  (function () {
    var hm = document.createElement("script");
    hm.src = "https://hm.baidu.com/hm.js?5fd52c901f2213883f51a476eab3914b";
    var l = document.getElementsByTagName("script").length;
    var s = document.getElementsByTagName("script")[l - 1];
    s.parentNode.insertBefore(hm, s);
  })();
```

这些设置好之后，就可以看到统计数据了，来看看 👀 _2018-05-29_ 当天的统计数据情况如何

#### 今日流量

纵轴分别是 _今日、昨日、预计今日_ ，横轴分别是 _PV、UV、IP、跳出率、平均访问时长_ 等 （预计今日的数据，不是很靠谱）

<img src="https://cdn.lishaoy.net/baidustatistics/1.png" alt="今日流量" width="100%" title="今日流量" align="center" />


#### 来源网站

会列出访客从哪儿来到你的**站点**，以及会统计访问时长等

<img src="https://cdn.lishaoy.net/baidustatistics/2.png" alt="来源网站" width="100%" title="来源网站" align="center" />

#### 受欢迎页面

会统计每个页面的 _浏览量、退出次数、平均停留时间_ 等

<img src="https://cdn.lishaoy.net/baidustatistics/3.png" alt="受欢迎页面" width="100%" title="受欢迎页面" align="center" />

#### 新老访客

会统计新老访客 _浏览量、平均访问时长、平均访问页数_ 等

<img src="https://cdn.lishaoy.net/baidustatistics/4.png" alt="新老访客" width="100%" title="新老访客" align="center" />

#### 地域分布

会统计访客来自哪个 _国家、省份、城市、网络运营商_ 等

<img src="https://cdn.lishaoy.net/baidustatistics/5.png" alt="新老访客" width="100%" title="新老访客" align="center" />

这里我只展示部分统计功能，如想了解其它更多功能，可去 [百度统计](https://tongji.baidu.com/web/welcome/login) 网站查看。