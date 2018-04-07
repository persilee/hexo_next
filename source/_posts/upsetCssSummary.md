---
title: 被遗忘的CSS
tags:
  - CSS
copyright: true
comments: true
date: 2018-04-07 06:45:52
categories: CSS
top: 103
photos:
---

{% fi upsetCssSummary/css.png, css, css %}

平时在工作中遇到一些比较偏门的 `css` ，用过一两次，但是老是记不住，于是又需要去 **baidu、 google** ，所以都积累起来，方便以后查看（持续更新...） 😀

---

<!-- more -->

#### `outline`  **当input选中的时候会出现一个边框**

```css
/*一般设置成 none*/
textarea:focus, input:focus{
    outline: none;
}
```
#### `contenteditable` **规定元素内容是否可编辑**

```vbscript-html
<div id="example-one" contenteditable="true">
```

```css
#example-one { 
    margin-bottom: 10px; 
}
[contenteditable="true"] { 
    padding: 10px; outline: 2px dashed #CCC; 
}
[contenteditable="true"]:hover { 
    outline: 2px dashed #0090D2; 
}
```
#### `webkit-playsinline` **video 都可以在页面中播放，而不是全屏播放**

```vbscript-html
<video id="myvideo" src="test.mp4" webkit-playsinline="true"></video>
```

#### `clearfix` **清除浮动**

```css
.clearfix {
    zoom: 1;
}
.clearfix:after {
     visibility: hidden;
     display: block;
     font-size: 0;
     content: " ";
     clear: both;
     height: 0;
 }
```
#### `user-select ` **禁止选中文本**

```css
p {
    -webkit-user-select: none; /* Chrome, Opera, Safari */
    -moz-user-select: none; /* Firefox 2+ */
    -ms-user-select: none; /* IE 10+ */
    user-select: none; /* Standard syntax */
}
```
#### `webkit-scrollbar` **自定义浏览器滚动条**

```css
/*定义滚动条宽高及背景，宽高分别对应横竖滚动条的尺寸*/

div::-webkit-scrollbar {
    width: 5px;
    height: 5px;
    background-color: rgba(245, 245, 245, 0.47);
}

/*定义滚动条的轨道，内阴影及圆角*/

div::-webkit-scrollbar-track {
    -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, .3);
    border-radius: 10px;
    background-color: #f5f5f5;
}

/*定义滑块，内阴影及圆角*/

div::-webkit-scrollbar-thumb {
    /*width: 10px;*/
    height: 20px;
    border-radius: 10px;
    -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, .3);
    background-color: rgba(85, 85, 85, 0.25);
}
```

#### `webkit-appearance` **去除默认样式**

```css
input, button, textarea, select {
    *font-size: 100%;
    -webkit-appearance:none;
}
```
#### **使用CSS transforms 或者 animations时可能会有页面闪烁的bug**

```css
elements {
     -webkit-backface-visibility: hidden; 
}
```
#### `transform-style: preserve-3d` **让元素支持3D**

```css
elements {
    -webkit-transform: rotateY(60deg); /* Chrome, Safari, Opera */
    -webkit-transform-style: preserve-3d; /* Chrome, Safari, Opera */
    transform: rotateY(60deg);
    transform-style: preserve-3d;
}
```
#### `perspective` **这个属性定义子元素会获得透视效果，而不是元素本身**

```vbscript-html
<div class="cube pers250">
    <div class="face front">1</div>
    <div class="face back">2</div>
    <div class="face right">3</div>
    <div class="face left">4</div>
    <div class="face top">5</div>
    <div class="face bottom">6</div>
</div>
```
```css
.cube {
  width: 100%;
  height: 100%;
  backface-visibility: visible;
  perspective-origin: 150% 150%;
  transform-style: preserve-3d;
  -webkit-backface-visibility: visible;
  -webkit-perspective-origin: 150% 150%;
  -webkit-transform-style: preserve-3d;
}
.pers250 {
  perspective: 250px;
  -webkit-perspective: 250px;
}
.face {
  display: block;
  position: absolute;
  width: 100px;
  height: 100px;
   border: none;
  line-height: 100px;
  font-family: sans-serif;
  font-size: 60px;
  color: white;
  text-align: center;
}
```
#### **css实现不换行、自动换行、强制换行**

```css
/*不换行*/
white-space:nowrap;

/*自动换行*/
word-wrap: break-word; 
word-break: normal; 

/*强制换行*/
word-break:break-all;
```

#### `font-smoothing` **设置字体平滑，会让字体看起来比较舒服**

```css
h1, .h1, h2, .h2, h3, .h3, h4, .h4, h5, .h5, h6, .h6, p, .navbar, .brand, a, .td-name, td {
    -moz-osx-font-smoothing: grayscale;
    -webkit-font-smoothing: antialiased;
    font-family: "Microsoft YaHei", "微软雅黑", 'Muli', "Helvetica", Arial, sans-serif;
}
```
#### `::selection` **修改选中文本颜色**

```css
::selection {
	color: white;
	background-color: rgba(0, 0, 0, 0.8);
}
::-webkit-selection {
	color: white;
	background-color: rgba(0, 0, 0, 0.8);
}
::-moz-selection {
	color: white;
	background-color: rgba(0, 0, 0, 0.8);
}
```