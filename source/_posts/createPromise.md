---
title: Promise诞生记
tags:
  - es6
  - Promise
copyright: true
comments: true
date: 2018-04-18 01:34:09
categories: JavaScript
top: 107
photos:
---

{% fi createPromise/promise.png, Promise, Promise %}

前端近年的兴起，有大部分是因为 `NodeJS` 的诞生，而 `NodeJS` 是个适用于 **异步IO** 密集型的语言，一些基于 `NodeJS` 的框架，比喻 *KOA2、Adonis* 就有大量的 `async` 和 `await` 语法，`async`的函数的返回值就是 `Promise` 对象，我们可以用 `async` 和 `await` 语法，写出优雅的异步代码，来替换难看且难维护的回调函数。

这里我们会渐进式的来创建一个 `Promise` 的实现，如果，你还不了解 `Promise` ，赶快移步 [Promise](http://es6.ruanyifeng.com/#docs/promise) 了解学习，当然这个实现会符合 [Promise/A+](https://promisesaplus.com) 规范，`JavaScript` 中有很多第三方的 `Promise` 库，[bluebird](http://bluebirdjs.com/docs/getting-started.html) 就是一个第三方 `Promise` 类库，相比其它第三方类库或标准对象来说，其有以下优点：功能更齐全而不臃肿、浏览器兼容性更好,大家可以了解下。

---

<!-- more -->

废话不多说，直接开干。。。 😠

## 定义 Promise 类型

一个简单 `Promise` 语法，如下

```javascript
const promise = new Promise(function(resolve, reject) {
  // ... doSomething

  if (/* 异步操作成功 */){
    resolve(value);
  } else {
    reject(error);
  }
});

promise.then(function(value) {
  // success
}, function(error) {
  // failure
});
```

### 实现 resolve 和 then

首先我们以上 👆 的语法，自己定义一个 `Promise` 实例

```javascript
function Promise(fn) {
  var callback = null;
  //实现 then 方法 , 先一步一步来，实现传一个参数 -- resolve
  this.then = function(cb) {
    callback = cb;
  };

  //实现 resolve , value:异步操作的最终值
  function resolve(value) {
    callback(value);
  }
  //执行 function 参数
  fn(resolve);
}
```

一个简单的实例写好了，然后，来用一下,看看 👀 结果如何

```javascript
const p = new Promise(function(resolve){
  resolve(66);
});

p.then(function(value){
  console.log(value);
});
```


{% note info %}

执行结果是：`callback is not a function`

{% endnote %}

### 修改 callback 为异步

**这里就遇到一个问题： **  

** 发现 `resolve()` 在 `then()` 之前调用，在 `resolve()` 被调用的时候， `callback` 还是 `null` ，我们的代码是同步的，而不是异步的。</br> 如是，想办法解决掉这个问题，就是利用 `setTimeout` , 把 `callback` 加入异步队列** 

代码如下 👇

```javascript
function Promise(fn) {
  var callback = null;
  //实现 then 方法 , 先一步一步来，实现传一个参数 -- resolve
  this.then = function(cb) {
    callback = cb;
  };

  //实现 resolve , value:异步操作的最终值
  function resolve(value) {
    // 用 setTimeout 把 callback 加入到异步队列，这样就会，先执行 then() 方法
    setTimeout(function(){
      callback(value);
    },1)
  }
  //执行 function 参数
  fn(resolve);
}
```

然后，再来用一下,看看 👀 结果如何

```javascript
const p = new Promise(function(resolve){
  resolve(66);
});

p.then(function(value){
  console.log(value);
});
```

{% note info %}

执行结果是：`66`

{% endnote %}

## 未完待续。。。
