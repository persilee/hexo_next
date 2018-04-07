---
title: CSSModules
tags:
  - css
  - modules
copyright: true
comments: true
date: 2018-04-07 09:58:11
categories: CSS
top: 104
photos:
---

{% fi CSSModules/cssmodules.png, CSS Modules, CSS Modules %}

这篇文章来一起了解 `css` 模块化的用法和原理 ，**dome** 地址：[css modules](https://github.com/persilee/webpack_test) 😮

---

<!-- more -->

#### 局部作用域

一般我们引入页面的 `CSS` 的作用域都是全局的，都是对这个页面起作用，产生局部的作用域，就是使用一个独一无二的 `class` 的名称，不会和其它选择器重名的， **`CSS Modules`** 就是这个原理。下面我们看一段代码

```javascript
import $ from 'jquery';
import styles from './main.css';
import test from './test.html';

$('body').append($('<div><h1>我会变绿</h1></div>'));
$('div h1').addClass(styles.testGreen);
$('body').append(test).find('h2').addClass(styles.testBlue);
```

上面的代码我把 `main.css` 输入到 `style` 对象，然后下面用了 `styles.testGreen` 对象的属性形式调用，就会应用 `main.css` 里的样式

```css
.testGreen {
  color: green;
}
```

构建工具（ `webpack` ）编译成一个哈希字符串

```vbscript-html
<div>
    <h1 class="_305zeUSoiGREv3GqPa9H8F">我会变绿</h1>
</div>
```

`main.css` 也会同时编译

```css
._305zeUSoiGREv3GqPa9H8F {
  color: #aaf200;
}
```

这样一来，这个类名就是独一无二的了，只对应用的组件有效。
**`CSS Modules`** 支持不同的构建工具，这里我使用的是 `webpack` ,下文都是以 `webpack` 为例。

下面我们来看下 **`webpack.config.js`**

```javascript
module.exports = {
  context: __dirname + '/src',
  devtool: 'eval-source-map', //配置生成Source Maps，选择合适的选项
  entry: {
    app: ['./app.js', './test.js'],
  },
  output: {
    path: __dirname + '/dist',
    filename: 'bundle.js',
    publicPath: '/assets',
  },
  module: {
    loaders: [
      {test: /\.json$/,loader: 'json-loader'},
      {test: /\.js$/,exclude: /node_modules/,loader: 'babel-loader'},
      {test: /\.css$/,loader: ExtractTextPlugin.extract({
          fallbackLoader: "style-loader",
          loader: {
            loader: "css-loader",
            query: {
              modules: true
            }
          }
        })
      },
      {test: /\.html$/,loader: 'html-loader'},
    ]
  },
  plugins: [
    new ExtractTextPlugin('style.css')
  ]
};
```

上面的代码可以看到，`query:{modules:true}` 代表开启 **`CSS Modules`** 模块，这里还配置了把所以得 `css` 合并一个文件，具体的可以了解 `webpack` 的 `extract-text-webpack-plugin`插件。

#### 全局作用域

**`CSS Modules`** 允许用 `:global(.className)` 的语法声明一个全局的作用域。加了 `:global` 的不会被编译成哈希值。

```css
:global(.title) {
  color: black;
}

.title {
  color: red;
}
```

`test.js` 使用普通的写法，就会引用全局的 `.title` 的样式

```javascript
import $ from 'jquery';
import styles from './main.css';
import test from './test.html';

$('body').append($('<div><h1>我是title</h1></div>'));
$('div h1').addClass('title');
```

结果 `h1` 的title显示黑色。

#### Class的组合

在 **`CSS Modules`** 里，一个选择器可以继承另一个选择器。

在 `mian.css` 里，我让 `.testBlue` 继承 `.testBg` 类

```css
.testBg {
  background-color: red;
}

.testBlue {
  color: blue;
  composes: testBg;
}

```
不用修改 `test.js` ,应用了 `.testBlue` 就会有一个红色的背景。

编译结果：

```css
.eh33VC37uFHXkCZ8LfKYd {
  background-color: #ff0000;
}

.xrmZso54fTBX29J9G65Ai {
  color: #0c77f8;
}
```

相应的 `html` 代码：

```html
<h3 class="xrmZso54fTBX29J9G65Ai eh33VC37uFHXkCZ8LfKYd _2gsuNWm9029FHPYJP62C-t">
    我会变蓝
</h3>
```

#### 输入变量

**`CSS Modules`** 支持使用变量，不过要安装 **PsotCSS** 和 **postcss-modules-values**。

```vim
$ npm install --save postcss-loader postcss-modules-values
```

把 `postcss-loader` 加入 `webpack.config.js` .

```javascript
{
    test: /\.css$/,
    loader: 'style-loader!css-loader?modules!postcss-loader'
},
```

然后我在 `colors.css` 里定义了一些变量。

```css
@value blue: #0c77f8;
@value red: #ff0000;
@value green: #aaf200;
```

在 `main.css` 里可以这样引用变量

```css
@value colors: "./color.css";
@value blue, red, green from colors;

.title {
  color: red;
}

.testBg {
  background-color: red;
}

.testGreen {
  color: green;
}

.testBlue {
  color: blue;
  composes: testBg;
  composes: div;
}
```

这样就可以把 `colors.css` 的变量拿过来用了，是不是很神奇。