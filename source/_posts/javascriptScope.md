---
title: 浅谈JavaScript作用域
date: 2018-04-01 01:03:45
tags:
    - javascript
    - scope
    - 变量提升
    - 预编译
categories: JavaScript
copyright: true
top: 107
comments: true
photos:
---

{% fi javascriptScope/javascriptScope01.png, ,  %}

我们在面试时，总会碰到一些奇奇怪怪的关于 **作用域** 的面试题，其实弄清楚原理，万变不离其宗，大部分的面试题都可以得 '姐'。 

所以，今天我们来谈谈 `JavaScript` 的 **作用域(javascript scope)** ，这是老生常谈的话题，这里我们会从 **作用域** 开始，会延伸到 **预解析规则（预编译） 、 变量提升 、函数提升 、表达式 、语句 、IIFE 、 匿名函数表达式 、 具名函数表达式** 等，彻底搞明白作用域这些事 🤓

---

<!-- more -->

### 变量提升和函数提升

在开始阐述之前，我们来看一段代码，看看结果是什么？

```javascript
alert(a);
function a(){ alter(2); }
alert(a);
var a = 1
alert(a);
var a = 3;
alert(a);
function a(){ alter(4); }
alert(a);
a();
```

这里先揭晓答案：
{% note success %} 
- 第一个 `alert(a)`  弹出 `function a(){ alter(4); }` 函数体
- 第二个 `alter(a)`  弹出 `function a(){ alter(4); }` 函数体
- 第三个 `alter(a)`  弹出 **1**
- 第四个 `alter(a)`  弹出 **3**
- 第五个 `alter(a)`  弹出 **3**
- 最后一行报错 `a is not a function`
{% endnote %}  

下面来分析一下这段代码：
其实在 `javascript` 开始执行代码之前，有一个 **预解析（预编译）** 的过程，这个过程会产生 **变量提升** 和 **函数提升** ，其实整个执行过程可以分为两部分，方便理解：

1. **预解析**
这个过程，会把 关键字 `var` 、 `function` 、 **参数** 提取出来

上面这段代码 **预解析** 的过程是：

```javascript
// 第1行，没有关键字 ， 不解析
// 第2行，遇到 function 关键字，解析到全局的头部
a = function a(){ alter(2); }
// 第3行，没有关键字 ， 不解析
// 第4行，遇到关键字 var ， 解析到全局的头部
a = undefined
// 第5行，没有关键字 ， 不解析
// 第6行，遇到关键字 var ， 解析到全局的头部
a = undefined
// 第8行，遇到 function 关键字，解析到全局的头部
a = function a(){ alter(4); }
// 第9行，没有关键字 ， 不解析
// 第10行，a() 函数调用
```

此时这里有4个同名变量 a ，依循规则是：`function` 优先与 `var`, 同名的后面覆盖前面的
因此，`a = function a(){ alter(2); }` 替换掉下面的2个 ~~`a = undefined`~~ ，`a = function a(){ alter(4); }` 又替换掉 ~~`a = function a(){ alter(2); }`~~ ,最终只剩下 `a = function a(){ alter(4); }`

**预解析（预编译）** 后的代码样子是这样的

```javascript
var a = function a(){ alter(4); }
alert(a);
alert(a);
a = 1
alert(a);
a = 3;
alert(a);
alert(a);
a();
```

2. 执行代码，就是执行的这段代码，依次从上到下执行，最后的 `a()` 函数调用，这时的 `a` 已被 **表达式** 赋值成 **3** ，而报错 `a is not a function`

----

### 全局作用域和局部作用域

再看这段代码

```javascript
var a = 1;
function fn1(){
    alert(a);
    var a = 2;
}
fn1();
alert(a);
```

这里先揭晓答案：
{% note success %}
- 第一个 `alert(a)` 弹出 `undefined`
- 第二个 `alert(a)` 弹出 **1**
{% endnote %}

`JavaScript` 的作用域只用两种，一个是全局的，一个是函数的，也称为 **全局作用域** 和 **局部作用域** ；**局部作用域** 可以访问 **全局作用域** 。但是 **全局作用域** 不能访问 **局部作用域** 

同样用 **预解析（预编译）** 的方法来分析这段代码
1. **预解析（预编译）** 全局作用域

```javascript
// 第1行，遇到 var 关键字，解析到全局的头部
a = undefined
// 第2行，遇到 function 关键字，解析到全局的头部
fn1 = function fn1(){
    alert(a);
    var a = 2;
}
// 第3行，没有遇到关键字，不解析
// 第4行，没有遇到关键字，不解析
```

2. 开始执行代码

第1行，遇到表达式 `a = 1`, **a** 被赋值成 **1** </br>
第6行，遇到函数调用 `fn1()` ,开始 **预解析（预编译）** 局部

3. **预解析（预编译）** 局部作用域

```javascript
// 第3行，没有遇到关键字，不解析
// 第4行，遇到 var 关键字，解析到局部
a = undefined
```
4. 开始执行 **局部** 代码

第3行，弹出 `undefined` 
第4行，遇到表达式，把局部 **a** 改成 **2**

5. 局部执行完成，继续执行全局

第7行，弹出 **1** ，因为全局和局部是两个独立的作用域

----

### 作用域链

如果，把上面👆代码，稍作修改

```javascript
var a = 1;
function fn1(){
    alert(a);
    a = 2;
}
fn1();
alert(a);
```

去掉了 `function` 里的 `var` ，结果就会不一样
这次，输出的是：
- 第一个 `alert` 弹出 **1**
- 第二个 `alert` 弹出 **2**
因为在解析局部是没有发现 `var a` ，如是在执行时，就会去全局查找，找到了全局的 `a = 1` ，所以 第一个 `alert` 弹出 **1** ，而不是 `undefined` ,这个就是 **作用域连**

----

### 表达式、语句 和 IIFE

在看下以下 👇 的代码

```javascript
var b = 10;
console.log(b);
(function b() {
    console.log(b);
    b = 20;
    console.log(b);
  }
)();
console.log(b);
function b() {
    b = 30;
    console.log(b);
}
```

先揭晓答案：
{% note success %}
- 第1个 `console.log(b)` 输出的是 **10**
- 第2个 `console.log(b)` 输出函数体 `b() {console.log(b); b = 20; console.log(b);}`
- 第3个 `console.log(b)` 输出函数体 `b() {console.log(b); b = 20; console.log(b);}`
- 第4个 `console.log(b)` 输出的是 **10**
- 第5个 没有任何输出
{% endnote %}

在分析这段代码之前，我们需要掌握一点知识，什么是 **语句** ，什么是 **表达式** 以及 **IIFE**
#### 表达式、语句

`JavaScript` 程序的执行单位为行 `（line）` ，也就是一行一行地执行。一般情况下，每一行就是一个语句。

语句 `（statement）` 是为了完成某种任务而进行的操作，比如下面就是一行赋值语句。

```javascript
var a = 1 + 3;
```

`1 + 3` 叫做表达式 `（expression）` ，指一个为了得到返回值的计算式。语句和表达式的区别在于，前者主要为了进行某种操作，一般情况下不需要返回值；后者则是为了得到返回值，一定会返回一个值。凡是 JavaScript 语言中预期为值的地方，都可以使用表达式。比如，赋值语句的等号右边，预期是一个值，因此可以放置各种表达式。

#### 立即执行函数 -- IIFE *（Immediately-Invoked Function Expression）*

在 `Javascript` 中，圆括号 `()` 是一种运算符，跟在 **函数名** 之后，表示调用该函数。例如： `a()`

有时，我们需要在定义函数之后，立即调用该函数。这时，你不能在函数的定义之后加上圆括号，这会产生语法错误。

```javascript
function(){ /* code */ }();
// SyntaxError: Unexpected token (
```

产生这个错误的原因是，`function` 这个关键字即可以当作语句，也可以当作表达式。

```javascript
// 语句
function f() {}

// 表达式
var f = function f() {}
```

为了避免解析上的歧义，`JavaScript` 引擎规定，如果 `function` 关键字出现在行首，一律解释成语句。因此，`JavaScript` 引擎看到行首是 `function` 关键字之后，认为这一段都是函数的定义，不应该以圆括号结尾，所以就报错了。

解决方法就是不要让 `function` 出现在行首，让引擎将其理解成一个表达式。最简单的处理，就是将其放在一个圆括号里面。

```javascript
(function(){ /* code */ }());
// 或者
(function(){ /* code */ })();
```

上面两种写法都是以圆括号开头，引擎就会认为后面跟的是一个表示式，而不是函数定义语句，所以就避免了错误。这就叫做“立即调用的函数表达式” *（Immediately-Invoked Function Expression）* ，简称 **IIFE**。

了解这些知识之后，再来分析上面 👆 提到的这段代码

先拆开来分析下代码，把这段单独拿出来，看看 👀

```javascript
(function b() {
    console.log(b);
    b = 20;
    console.log(b);
  }
)();
```

其实这段是可以单独运行的，结果是

{% note success %}
- 第1个 `console.log(b)` 输出函数体 `b() {console.log(b); b = 20; console.log(b);}`
- 第2个 `console.log(b)` 输出函数体 `b() {console.log(b); b = 20; console.log(b);}`
{% endnote %}

再来分析下原因，很明显这个就是一个 **IIFE** , 由一个 **函数表达式** 和 圆括号 `()` 运算符组成，上面 👆 这段代码和下面 👇 是等价的

```javascript
var b = function b() {
    console.log(b);
    b = 20;
    console.log(b);
}();
```

再来分析，就比较容易理解了

- **首先开始解析**

```javascript
b = undefined; //第一行 遇到 var 关键字，变量提升
```
解析完之后的样子

```javascript
var b;
b = function b() {
    console.log(b);
    b = 20;
    console.log(b);
};
b();
```

- **执行代码**

第2行，遇到 **表达式语句** 将 `b(){console.log(b); b = 20; console.log(b);}` 赋值给 `b`
第7行，调用函数，开始局部解析

局部解析没有发现关键字 `var` 和 `function` ，没有任何动作

继续执行 **局部** 代码

第3行， `console.log(b)` 输出外部的 `b = b(){console.log(b); b = 20; console.log(b);}` </br>
第4行， 由第3行可知，此时， `b` 是个内部函数体，而不是外部变量 `b` ，解析器只会把 `b = 20;` 当成普通 **表达式** ，而不是 **表达式语句** ，不会进行赋值操作 </br>
第5行， `b` 的值没有任何改变，依然输出函数体 `b = b(){console.log(b); b = 20; console.log(b);}` </br>

最终，回到最开始代码本身

```javascript
var b = 10;
console.log(b);
(function b() {
    console.log(b);
    b = 20;
    console.log(b);
  }
)();
console.log(b);
function b() {
    b = 30;
    console.log(b);
}
```
**预解析：**

```javascript
b = undefined; //变量提升
b = function b() { //函数提升
    b = 30;
    console.log(b);
}
```

遵循，函数 `一等公民` 原则，函数优先级高于变量， ~~`b = undefined;`~~ 别干掉

预解析之后，应该是这个样子

```javascript
var b = function b() {
    b = 30;
    console.log(b);
}
b = 10;
console.log(b);
(function b() {
    console.log(b);
    b = 20;
    console.log(b);
})();
console.log(b);
```
再来看下答案，就很清楚了

{% note success %}
- 第1个 `console.log(b)` 输出的是 **10**
- 第2个 `console.log(b)` 输出函数体 `b() {console.log(b); b = 20; console.log(b);}`
- 第3个 `console.log(b)` 输出函数体 `b() {console.log(b); b = 20; console.log(b);}`
- 第4个 `console.log(b)` 输出的是 **10**
- 第5个 没有任何输出，由于函数提升，最终 被 `b = 10` 覆盖
{% endnote %}

这里，可以把上面 👆 代码稍作改动，结果会不一样，如：

```javascript
var b = 10;
console.log(b);
(function b() {
    console.log(b);
    var b = 20;  // ++++ 加了 var
    console.log(b);
  }
)();
console.log(b);
function b() {
    b = 30;
    console.log(b);
}
```

这里就不揭晓答案了，感兴趣的，可自行思考 🤔 ，看看 👀 最终答案如何。。。

----
### 匿名函数表达式、具名函数表达式

在来看看这段代码👇

```javascript
var a = 3;
function fn() {
    foo();
    function foo() {
        console.log(1);
    }
    foo();
    var foo = function() {
        console.log(2);
    };
    foo();
    var bar = function foo() {
        if(a > 3) return;
        console.log(++a);
        foo();
    };
    foo();
    bar();
}
fn();
```
先揭晓答案：
{% note success %}
- 第1个 `foo()` 输出的是 **1**
- 第2个 `foo()` 输出的是 **1**
- 第3个 `foo()` 输出的是 **2**
- 第4个 `foo()` 输出的是 **2**
- 最后的 `bar()` 输出的是 **4**
{% endnote %}

以上代码包含了 **函数声明** 、 **匿名函数表达式** 、 **具名函数表达式** ，**匿名函数表达式** 、 **具名函数表达式** 是把函数体赋值给一个变量，因此拥有和变量相同的特性 **变量提升** ，而 **具名函数表达式** 的函数名只能在函数内部使用。

了解了这些，再来分析段代码

- **全局预解析**

```javascript
a = undefined
fn = function fn(){
    ...
}
```
- **执行代码**
第1行，遇到表达式,把 **a** 的值改变成3 </br>
最后行，遇到函数调用，重新 **预解析** 局部

- **局部预解析**

```javascript
// 第4行，遇到 function 关键字，解析到局部的头部
foo = function(){
    console.log(1);
}
// 第8行，遇到 var 关键字，解析到局部的头部
foo = undefined
// 第12行，遇到 var 关键字，解析到局部的头部
bar = undefined
```

由于有两个同名变量 `foo` ，遵循 `function` 优先 `var` 因此， ~~`foo = undefined`~~ 被干掉

**局部预解析** 完之后的代码应该是这个样子👇

```javascript
var a = 3
function fn() {
    var foo = function foo() {
        console.log(1);
    }
    var bar;
    foo();
    foo();
    foo = function foo() {
        console.log(2);
    };
    foo();
    bar = function foo() {
        if(a > 3) return;
        console.log(++a);
        foo();
    };
    foo();
    bar();
}
fn();
```

- **执行局部代码** </br>
第1个 `foo()` 输出的是 **1** </br>
第2个 `foo()` 输出的是 **1** </br>
第3个 `foo()` 输出的是 **2** </br>
第4个 `foo()` 输出的是 **2** ，注意这个 `foo()` 输出的是上面 `foo = function foo() {console.log(2);}` 的内容，因为 **具名函数表达式** 的函数名只能在函数内部使用，在外部无法访问。</br>
最后的 `bar()` 输出的是 **4** ，这里才是输出 `function foo() {if(a > 3) return;console.log(++a);foo();}` 里的内容，而且，这个函数体内也有自身的调用，结果 `a` 变量 **+1** ，说明可以调用，其实，可以用 `bar.name` 输出的就是 `foo`

**所以，注意：**

{% note danger %}
- `bar = function foo()` , 不要用这种写法 ，优雅的写法是 **变量名** 和 **函数名** 保持一致 `foo = function foo()`
- 不推荐使用 **匿名函数表达式** ，有以下 👇 几个缺点
    * 在追踪栈中没函数名，调试困难
    * 如果需要引用自身，只能用非标准的 `arguments.callee`（ES5严格模式禁用）
{% endnote %}