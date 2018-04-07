---
title: 如何使用 markdown 语法写博客
tags:
  - markdown
copyright: true
comments: true
date: 2018-04-07 07:25:19
categories: 工具（Tools）
top: 104
photos:
---

{% fi markdownGrammar/markdown.webp, markdown, markdown %}

平时我写日记、文档和博客都会用到 `markdown` 语法，我用的是 `马克飞象` 先在本地写好，而且可以和 `印象笔记` 同步，如果知识积累的多了，也会总结下，分享到社区，直接 <kbd>⌘ -  C</kbd>  然后 <kbd>⌘ -  V</kbd>  就可以了，特别方便。 🙂

---

<!-- more -->

### 什么是Markdown语法
`Markdown` 是一种轻量级标记语言，目标是实现「易读易写」。

> Markdown 是一种轻量级标记语言，它允许人们使用易读易写的纯文本格式编写文档，然后转换成格式丰富的HTML页面。    —— [维基百科](https://zh.wikipedia.org/wiki/Markdown)

---

### 标题
**在 `Markdown` 中，你只需要在文本前面加上 `#` 即可，同理、你还可以增加二级标题、三级标题、四级标题、五级标题和六级标题，总共六级，只需要增加 `#` 即可，标题字号相应降低。例如：**

```
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题
```

效果如下 ：

# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题

---
### 引用
**`Markdown` 标记区块引用是使用类似 email 中用的引用方式，只需要在整个段落的第一行最前面加上 > 。**
例如：
```
>这是一个引用示例
```
效果如下：

>这是一个引用示例

**区块引用可以嵌套，只要根据层次加上不同数量的 > ：**

```vim
> 这是第一级引用。
>
> > 这是第二级引用。
>
> 现在回到第一级引用。
```
效果如下：
> 这是第一级引用。
>
> > 这是第二级引用。
>
> 现在回到第一级引用。

---
### 列表
**Markdown 支持有序列表和无序列表。**

1. 无序列表使用星号、加号或是减号作为列表标记：

```vim
*   Red
*   Green
*   Blue
```
等同于
```vim
+   Red
+   Green
+   Blue
```
也等同于
```vim
-   Red
-   Green
-   Blue
```
效果如下：
-   Red
-   Green
-   Blue

----

2. 有序列表则使用数字接着一个英文句点：

```vim
1.  Bird
2.  McHale
3.  Parish
```
效果如下：
1.  Bird
2.  McHale
3.  Parish

如果你的列表标记写成：
```vim
1.  Bird
1.  McHale
1.  Parish
```
效果是：
1.  Bird
1.  McHale
1.  Parish

甚至是：
```vim
3. Bird
1. McHale
8. Parish
```
效果是：
3. Bird
1. McHale
8. Parish

可以看到，数字还是正常的，所以，你可以让 `Markdown` 文件的列表数字和输出的结果相同，或是你懒一点，你可以完全不用在意数字的正确性。

如果要在列表项目内放进引用，那 > 就需要缩进：
```vim
*   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.
```
效果如下：
*   A list item with a blockquote:

    > This is a blockquote
    > inside a list item.

---

### 代码区块

只要把你的代码块包裹在  <code>\`\`\`</code>  之间，你就不需要通过无休止的缩进来标记代码块了。 在围栏式代码块中，你可以指定一个可选的语言标识符，然后我们就可以为它启用语法着色了。 举个例子，这样可以为一段 `Ruby` 代码着色：


```ruby
```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html

```


效果如下：

```ruby
    require 'redcarpet'
    markdown = Redcarpet.new("Hello World!")
    puts markdown.to_html
```

---

### 强调
在 `Markdown` 中，可以使用 \* 和 \_ 来表示斜体和加粗。

斜体：

```vim
*Coding，让开发更简单*
_Coding，让开发更简单_
```
效果如下：

*Coding，让开发更简单*
_Coding，让开发更简单_

加粗：

```vim
**Coding，让开发更简单**
__Coding，让开发更简单__
```
效果如下：

**Coding，让开发更简单**
__Coding，让开发更简单__

---

### 代码
如果要标记一小段行内代码，你可以用反引号把它包起来 <code>\`\`\`</code> ，例如：

```vim
Use the `printf()` function.
```
效果如下：

Use the `printf()` function.

---

### 自动链接
`Markdown` 支持以比较简短的自动链接形式来处理网址和电子邮件信箱，只要是用尖括号包起来，`Markdown` 就会自动把它转成链接。一般网址的链接文字就和链接地址一样，例如：
```css
<http://example.com/>
```
效果如下：

<http://example.com/>

### 链接
`Markdown` 支持两种形式的链接语法： *行内式* 和 *参考式* 两种形式。我个人比较喜欢用 *参考式* 。

不管是哪一种，链接文字都是用 [方括号] 来标记。

1. *行内式* 的链接，只要在方块括号后面紧接着圆括号并插入网址链接即可，如果你还想要加上链接的 `title` 文字，只要在网址后面，用双引号把 `title` 文字包起来即可，例如：

```
This is [an example](http://example.com/ "Title") inline link.
```
效果如下：

This is [an example](http://example.com/ "Title") inline link.

---

### 图片
`Markdown` 使用一种和链接很相似的语法来标记图片，同样也允许两种样式： *行内式* 和 *参考式* 。

1. 行内式的图片语法看起来像是：

```
![Alt text](/path/to/img.jpg)

![Alt text](/path/to/img.jpg "Optional title")
```
详细叙述如下：

- 一个惊叹号 `!`
- 接着一个方括号，里面放上图片的替代文字
- 接着一个普通括号，里面放上图片的网址，最后还可以用引号包住并加上 选择性的 `title` 文字。

---

2. 参考式的图片语法则长得像这样：

```lasso
![Alt text][id]
```
`id` 是图片参考的名称，图片参考的定义方式则和连结参考一样：
```lasso
[id]: url/to/image  "Optional title attribute"
```
`Markdown` 还没有办法指定图片的宽高，如果你需要的话，你可以使用普通的 `<img>`  标签。

---

### LaTeX 公式

可以创建行内公式，例如 :
```
$\Gamma(n) = (n-1)!\quad\forall n\in\mathbb N$
```
效果如下：

$\Gamma(n) = (n-1)!\quad\forall n\in\mathbb N$

或者块级公式：
```
$$	x = \dfrac{-b \pm \sqrt{b^2 - 4ac}}{2a} $$
```
效果如下：

$$ x = \dfrac{-b \pm \sqrt{b^2 - 4ac}}{2a} $$

---

### 表格

```lasso
| Item      |    Value | Qty  |
| :-------- | --------:| :--: |
| Computer  | 1600 USD |  5   |
| Phone     |   12 USD |  12  |
| Pipe      |    1 USD | 234  |
```

效果如下：

| Item      |    Value | Qty  |
| :-------- | --------:| :--: |
| Computer  | 1600 USD |  5   |
| Phone     |   12 USD |  12  |
| Pipe      |    1 USD | 234  |


---

### 流程图

<code>
\`\`\`flow </br>
st=>start: Start </br>
e=>end </br>
op=>operation: My Operation </br>
cond=>condition: Yes or No? </br>       
st->op->cond </br>
cond(yes)->e </br>
cond(no)->op </br>
\`\`\`
</code>

效果如下：

```flow
st=>start: Start
e=>end
op=>operation: My Operation
cond=>condition: Yes or No?

st->op->cond
cond(yes)->e
cond(no)->op
```

以及时序图:

<code>
\`\`\`sequence </br>
Alice->Bob: Hello Bob, how are you? </br>
Note right of Bob: Bob thinks </br>
Bob-->Alice: I am good thanks! </br>
\`\`\`
</code>

效果如下：

```sequence
Alice->Bob: Hello Bob, how are you?
Note right of Bob: Bob thinks
Bob-->Alice: I am good thanks!
```

### 复选框

使用 `- [ ]` 和 `- [x]` 语法可以创建复选框，实现 todo-list 等功能。例如：

```lasso
- [x] 已完成事项
- [ ] 待办事项1
- [ ] 待办事项2
```
效果如下：
- [x] 已完成事项
- [ ] 待办事项1
- [ ] 待办事项2

---

### 分割线
在 `Markdown` 中，可以制作分割线，例如：

```lasso
    ---
```
效果如下：

--- 

### 反斜杠

`Markdown` 可以利用反斜杠来插入一些在语法中有其它意义的符号，例如：如果你想要用星号加在文字旁边的方式来做出强调效果（但不用 `<em>` 标签），你可以在星号的前面加上反斜杠：
```
\*literal asterisks\*
```
效果如下：

\*literal asterisks\*

`Markdown` 支持以下这些符号前面加上反斜杠来帮助插入普通的符号：

```vim
\   反斜线
`   反引号
*   星号
_   底线
{}  花括号
[]  方括号
()  括弧
#   井字号
+   加号
-   减号
.   英文句点
!   惊叹号
```