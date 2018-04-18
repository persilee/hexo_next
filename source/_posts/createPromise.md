---
title: Promise诞生记
tags:
  - es6
  - Promise
copyright: true
comments: true
date: 2018-04-18 01:34:09
categories:
top: 106
photos:
---

{% fi createPromise/promise.png, Promise, Promise %}

{% centerquote %}blah blah blah{% endcenterquote %}

前端近年的兴起，有大部分是因为 `NodeJS` 的诞生，而 `NodeJS` 是个适用于 **异步IO** 密集型的语言，一些基于 `NodeJS` 的框架，比喻 *KOA2、Adonis* 就有大量的 `async` 和 `await` 语法，`async`的函数的返回值就是 `Promise` 对象，我们可以用 `async` 和 `await` 语法，写出优雅的异步代码，来替换难看且难维护的回调函数。

这里我们会渐进式的来创建一个 `Promise` 的实现，如果，你还不了解 `Promise` ，赶快移步 [Promise](http://es6.ruanyifeng.com/#docs/promise) 了解学习，当然这个实现会符合 [Promise/A+](https://promisesaplus.com) 规范，`JavaScript` 中有很多第三方的 `Promise` 库，[bluebird](http://bluebirdjs.com/docs/getting-started.html) 就是一个第三方 `Promise` 类库，相比其它第三方类库或标准对象来说，其有以下优点：功能更齐全而不臃肿、浏览器兼容性更好,大家可以了解下。

<!-- more -->

废话不多说，直接开干。。。 😠


### 未完待续。。。