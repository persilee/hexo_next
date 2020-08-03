---
title: Android coder 需要理解的注解、反射和动态代理
tags:
  - Android
  - 注解
  - 反射
  - 动态代理
copyright: true
comments: true
date: 2020-07-28 06:33:01
categories: Java
top: 118
photos:
---

{% li https://cdn.lishaoy.net/annotations-reflect/annotations-reflect-proxy2.png, annotations reflect proxy, annotations reflect proxy %}

<section id="nice" data-tool="mdnice编辑器" data-website="https://www.mdnice.com" style="padding: 0 10px; line-height: 1.6; word-spacing: 0px; word-break: break-word; word-wrap: break-word; text-align: left; font-family: Optima-Regular, Optima, PingFangSC-light, PingFangTC-light, 'PingFang SC', Cambria, Cochin, Georgia, Times, 'Times New Roman', serif; font-size: 15px; letter-spacing: 0.05em; color: #595959;"><p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">注解我们经常使用它，很多框架也提供了很多注解给我们使用，如 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ARouter</code> 的 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Route(path = "/test/activity")</code> 、<code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">butterknife</code> 的 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@BindView(R.id.user) EditText username;</code> 等，但是，你有没有自定义过注解，写过自己的注解处理器呢？反射听起来很高大上，但是实际上你真的了解他之后，只是一些API的调用而已；动态代理其实只是在静态代理(代理模式)基础上使用了反射技术；本篇文章将带领大家对注解、反射及动态代理有更清晰的认知。</p>
<hr data-tool="mdnice编辑器" style="height: 1px; margin-top: 10px; margin-bottom: 10px; border-top: 1px solid black; border: 1px solid #35b378; margin: 1.5em auto;background: white;"></section>

<!-- more -->

<section id="nice" data-tool="mdnice编辑器" data-website="https://www.mdnice.com" style="padding: 0 10px; line-height: 1.6; word-spacing: 0px; word-break: break-word; word-wrap: break-word; text-align: left; font-family: Optima-Regular, Optima, PingFangSC-light, PingFangTC-light, 'PingFang SC', Cambria, Cochin, Georgia, Times, 'Times New Roman', serif; font-size: 15px; letter-spacing: 0.05em; color: #595959;"><p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">本篇文章的示例代码放在 <a href="https://github.com/persilee/android_practice" style="text-decoration: none; word-wrap: break-word; font-weight: bold; color: #35b378; border-bottom: 1px solid #35b378;">Github</a> 上，所有知识点，如图：</p>
<div style="width: 100%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations-reflect-proxy.png" alt="no-shadow" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<h2 data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; bmin-height: 32px; line-height: 32px; border-bottom: solid 1px #000000; color: #35b378; display: inline-block; border-bottom-width: 0px; border-bottom-style: solid; border-color: #35b378; padding-top: 5px; padding-right: 0.5em; padding-left: 0.5em; font-size: 23px; margin: 1em 0 0rem 0; padding: 0.5em 0; text-align: leftt; font-weight: bold;"><span class="prefix" style="display: none;"></span><span class="content">注解</span><span class="suffix"></span></h2>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">注解(Annotations)，元数据的一种形式，提供有关于程序但不属于程序本身的数据。注解对它们注解的代码的操作没有直接影响。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">注解有多种用途，例如：</p>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">为编译器提供信息：编译器可以使用注解来检查错误或抑制警告</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">编译或部署时处理：可以生成代码、XML、文件等</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">运行时处理：注解可以在运行时检查</section></li></ul>
<h3 id="注解的格式" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">注解的格式</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">注解的格式如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>
<span/><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MyClass</span> </span>{ ... }
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">注解以 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@</code> 开头后面跟上内容，注解可以包含元素，例如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>(id=<span class="hljs-number" style="color: #986801; line-height: 26px;">666</span>, value = <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"lsy"</span>)
<span/><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MyClass</span> </span>{ ... }
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">如果，只有一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">value</code> 元素，则可以省略该名称，如果，没有元素，则可以省略括号，例如</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"lsy"</span>) <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 只有一个 value 元素</span>
<span/><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MyClass</span> </span>{ ... }
<span/>
<span/><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span> <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 没有元素</span>
<span/><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MyClass</span> </span>{ ... }
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">如果，注解有相同的类型，则是重复注解，如</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"lsy"</span>)
<span/><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"zimu"</span>)
<span/><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MyClass</span> </span>{ ... }
<span/></code></pre>
<h3 id="注解声明" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">注解声明</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">注解的定义类似于接口的定义，在关键字 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">interface</code> 前加上 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@</code>，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@interface</span> Persilee {
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">id</span><span class="hljs-params" style="line-height: 26px;">()</span></span>;
<span/>    <span class="hljs-function" style="line-height: 26px;">String <span class="hljs-title" style="color: #4078f2; line-height: 26px;">value</span><span class="hljs-params" style="line-height: 26px;">()</span></span>;
<span/>}
<span/></code></pre>
<h3 id="注解类型" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">注解类型</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">int id()</code> 和 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">String value()</code> 是注解类型(annotation type)，它们也可以定义可选的默认值，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@interface</span> Persilee {
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">id</span><span class="hljs-params" style="line-height: 26px;">()</span></span>;
<span/>    <span class="hljs-function" style="line-height: 26px;">String <span class="hljs-title" style="color: #4078f2; line-height: 26px;">value</span><span class="hljs-params" style="line-height: 26px;">()</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">default</span> "lsy"</span>;
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在使用注解时，如果定义的注解的注解类型没有默认值，则必须进行赋值，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>(id = <span class="hljs-number" style="color: #986801; line-height: 26px;">666</span>) <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// id 必须要赋值，如，@Persilee 会提示 id 必须赋值</span>
<span/><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MyClass</span> </span>{ ... }
<span/></code></pre>
<h3 id="元注解" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">元注解</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在注解上面的注解称为元注解(meta-annotations)，如</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Target</span>({ElementType.TYPE, ElementType.METHOD})
<span/><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Retention</span>(RetentionPolicy.SOURCE)
<span/><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@interface</span> Persilee {
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">id</span><span class="hljs-params" style="line-height: 26px;">()</span></span>;
<span/>    <span class="hljs-function" style="line-height: 26px;">String <span class="hljs-title" style="color: #4078f2; line-height: 26px;">value</span><span class="hljs-params" style="line-height: 26px;">()</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">default</span> "lsy"</span>;
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">java.lang.annotation</code> 中定义了几种元注解类型(常使用的是 @Retention、@Target)，如</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><strong style="font-weight: bold; color: #35b378;">@Retention</strong> 指定注解的存储方式，我们由 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">RetentionPolicy.java</code> (是一个枚举)可知，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">enum</span> RetentionPolicy {
<span/>    SOURCE, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 标记的注解仅保留在源级别中，并被编译器忽略。</span>
<span/>    CLASS, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 标记的注解在编译时由编译器保留，但 Java 虚拟机(JVM)会忽略。</span>
<span/>    RUNTIME <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 标记的注解由 JVM 保留，因此运行时环境可以使用它。</span>
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><strong style="font-weight: bold; color: #35b378;">@Target</strong> 指定注解可以使用的范围，我们由 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ElementType.java</code> (是一个枚举)可知使用范围，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">enum</span> ElementType {
<span/>    TYPE, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 类</span>
<span/>    FIELD, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 字段或属性</span>
<span/>    METHOD, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 方法</span>
<span/>    PARAMETER, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 参数</span>
<span/>    CONSTRUCTOR, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 构造方法</span>
<span/>    LOCAL_VARIABLE, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 局部变量</span>
<span/>    ANNOTATION_TYPE, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 也可以使用在注解上</span>
<span/>    PACKAGE, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 包</span>
<span/>    TYPE_PARAMETER, <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 类型参数</span>
<span/>    TYPE_USE <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 任何类型</span>
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">对于 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">TYPE_PARAMETER</code> (类型参数) 、 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">TYPE_USE</code> (任何类型名称) 可能不是很好理解，如果把 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Target</code> 设置成 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Target({ElementType.TYPE_PARAMETER})</code>，表示可以使用在泛型(上篇文章有介绍过<a href="https://h.lishaoy.net/generics.html" style="text-decoration: none; word-wrap: break-word; font-weight: bold; color: #35b378; border-bottom: 1px solid #35b378;">泛型</a>)的类型参数上，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">TypeParameterClass</span>&lt;@<span class="hljs-title" style="color: #c18401; line-height: 26px;">Persilee</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">T</span>&gt; </span>{
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> &lt;<span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span> T&gt; <span class="hljs-function" style="line-height: 26px;">T <span class="hljs-title" style="color: #4078f2; line-height: 26px;">foo</span><span class="hljs-params" style="line-height: 26px;">(T t)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>;
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">如果把 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Target</code> 设置成 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Target({ElementType.TYPE_USE})</code>，表示可以使用在任何类型上，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">TypeParameterClass&lt;<span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span> String&gt; typeParameterClass = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> TypeParameterClass&lt;&gt;();
<span/><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span> String text = (<span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span> String)<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> Object();
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><strong style="font-weight: bold; color: #35b378;">@Documented</strong> 注解表示使用了指定的注解，将使用 Javadoc 工具记录这些元素。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><strong style="font-weight: bold; color: #35b378;">@Inherited</strong> 注解表示注解类型可以从超类继承。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><strong style="font-weight: bold; color: #35b378;">@Repeatable</strong> 注解表明标记的注解可以多次应用于同一声明或类型使用。</p>
<h3 id="注解应用场景" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">注解应用场景</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">根据 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Retention</code> 元注解定义的存储方式，注解一般可以使用在以下3种场景中，如：</p>
<section class="table-container" data-tool="mdnice编辑器" style="overflow-x: auto;"><table style="display: table; text-align: left;">
<thead>
<tr style="border: 0; border-top: 1px solid #ccc; background-color: white;">
<th style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; font-weight: bold; background-color: #f0f0f0; min-width: 85px; text-align: left;">级别</th>
<th style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; font-weight: bold; background-color: #f0f0f0; min-width: 85px; text-align: left;">技术</th>
<th style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; font-weight: bold; background-color: #f0f0f0; min-width: 85px; text-align: left;">说明</th>
</tr>
</thead>
<tbody style="border: 0;">
<tr style="border: 0; border-top: 1px solid #ccc; background-color: white;">
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">源码</td>
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">APT</td>
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">在编译期能获取注解与注解声明的类和类中所有成员信息，一般用于生成额外的辅助类。</td>
</tr>
<tr style="border: 0; border-top: 1px solid #ccc; background-color: #F8F8F8;">
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">字节码 </td>
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">字节码增强 </td>
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">在编译出Class后，通过修改Class数据以实现修改代码逻辑目的，对于是否需要修改的区分或者修改为不同逻辑的判断可以使用注解。</td>
</tr>
<tr style="border: 0; border-top: 1px solid #ccc; background-color: white;">
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">运行时</td>
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">反射</td>
<td style="font-size: 16px; border: 1px solid #ccc; padding: 5px 10px; min-width: 85px; text-align: left;">在程序运行时，通过反射技术动态获取注解与其元素，从而完成不同的逻辑判断。</td>
</tr>
</tbody>
</table>
</section><h3 id="小案例(使用注解实现语法检查)" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">小案例(使用注解实现语法检查)</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们定义一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">weekDay</code> 字段，类型是 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">WeekDay</code> 枚举类型，方便我们设置枚举中指定的值，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">WeekDayDemo</span> </span>{
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> WeekDay weekDay;
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">enum</span> WeekDay {
<span/>        SATURDAY,SUNDAY
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> WeekDay <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getWeekDay</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> weekDay;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">setWeekDay</span><span class="hljs-params" style="line-height: 26px;">(WeekDay weekDay)</span> </span>{
<span/>        WeekDayDemo.weekDay = weekDay;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> </span>{
<span/>        setWeekDay(WeekDay.SATURDAY);
<span/>        System.out.println(getWeekDay());
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">众所周知，在 Java 中枚举的实质是特殊的静态成员变量，在运行时候，所有的枚举会作为单例加载到内存中，非常消耗内存，那么，有没有什么优化的方案呢，在此，我们使用注解来取代枚举。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们使用常量和 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@intDef</code> (语法检查)元注解去代替枚举，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">IntdefDemo</span> </span>{
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">final</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> SATURDAY = <span class="hljs-number" style="color: #986801; line-height: 26px;">0</span>;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">final</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> SUNDAY = <span class="hljs-number" style="color: #986801; line-height: 26px;">1</span>;
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> weekDay;
<span/>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@IntDef</span>({SATURDAY, SUNDAY})
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Target</span>({ElementType.FIELD, ElementType.PARAMETER})
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Retention</span>(RetentionPolicy.SOURCE)
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@interface</span> WeekDay { <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//自定义一个 WeekDay 注解</span>
<span/>
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">setWeekDay</span><span class="hljs-params" style="line-height: 26px;">(@WeekDay <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> weekDay)</span> </span>{ <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 使用 WeekDay 注解限制参数类型</span>
<span/>        IntdefDemo.weekDay = weekDay;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> </span>{
<span/>        setWeekDay(SATURDAY); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 只能 传入 SATURDAY, SUNDAY</span>
<span/>    }
<span/>}
<span/></code></pre>
<h3 id="APT注解处理器" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">APT注解处理器</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">APT(Annotation Processor Tools) 注解处理器，用于处理注解，编写好的 Java 文件，需要经过 Javac 的编译，编译为虚拟机能够加载的字节码(Class)文件，注解处理器是 Javac 自带的一个工具，用来在编译时期处理注解信息。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">上文中我们已自定义好了 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Persilee</code> 注解，下面我们来编写一个简单的注解处理器来处理 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Persilee</code> 注解，我们可以新建一个 Java 的 Module，创建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">PersileeProcessor</code> 的类，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@SupportedAnnotationTypes</span>(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.anreprdemo.Persilee"</span>)  <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//指定要处理的注解</span>
<span/><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">PersileeProcessor</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">extends</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">AbstractProcessor</span> </span>{
<span/>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Override</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">boolean</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">process</span><span class="hljs-params" style="line-height: 26px;">(Set&lt;? extends TypeElement&gt; set, RoundEnvironment roundEnvironment)</span> </span>{
<span/>        Messager messager = processingEnv.getMessager(); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//</span>
<span/>        messager.printMessage(Diagnostic.Kind.NOTE, <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"APT working ..."</span>);
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (TypeElement typeElement: set) {
<span/>            messager.printMessage(Diagnostic.Kind.NOTE,<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"===&gt;"</span> + typeElement.getQualifiedName());
<span/>            Set&lt;? extends Element&gt; elements = roundEnvironment.getElementsAnnotatedWith(typeElement);
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (Element element: elements) {
<span/>                messager.printMessage(Diagnostic.Kind.NOTE,<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"===&gt;"</span> + element.getSimpleName());
<span/>            }
<span/>        }
<span/>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">false</span>;
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">然后，在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">main</code> 目录下新建 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">resources</code> 目录，如图：</p>
<div style="width: 86%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations1.png" alt="no-shadow" title="annotation" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">这个目录结构是规定死的，必须这样写，然后在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">javax.annotation.processing.Processor</code> 文件里注册需要处理的注解处理器，如</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">net.lishaoy.aptlib.PersileeProcessor
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">最后，在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">app</code> 的 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">build.gradle</code> 文件引入模块，如</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">dependencies {
<span/>  ...
<span/>
<span/>  <span class="hljs-function" style="line-height: 26px;">annotationProcessor <span class="hljs-title" style="color: #4078f2; line-height: 26px;">project</span><span class="hljs-params" style="line-height: 26px;">(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">':aptlib'</span>)</span>
<span/>}
<span/></span></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在你 Build 工程时候，会在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Task :app:compileDebugJavaWithJavac</code> 任务打印我们在注解处理程序的日志信息，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">注: APT working ...
<span/>注: ===&gt;net.lishaoy.anreprdemo.Persilee
<span/>注: ===&gt;MainActivity
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">因为，我们只在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">MainActivity</code> 中使用了 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@Persilee</code> 注解，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Persilee</span>(id = <span class="hljs-number" style="color: #986801; line-height: 26px;">666</span>, value = <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"lsy"</span>)
<span/><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MainActivity</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">extends</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">AppCompatActivity</span> </span>{
<span/>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Override</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">protected</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">onCreate</span><span class="hljs-params" style="line-height: 26px;">(Bundle savedInstanceState)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">super</span>.onCreate(savedInstanceState);
<span/>
<span/>        setContentView(R.layout.activity_main);
<span/>    }
<span/>}
<span/></code></pre>
<h2 data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; bmin-height: 32px; line-height: 32px; border-bottom: solid 1px #000000; color: #35b378; display: inline-block; border-bottom-width: 0px; border-bottom-style: solid; border-color: #35b378; padding-top: 5px; padding-right: 0.5em; padding-left: 0.5em; font-size: 23px; margin: 1em 0 0rem 0; padding: 0.5em 0; text-align: leftt; font-weight: bold;"><span class="prefix" style="display: none;"></span><span class="content">反射</span><span class="suffix"></span></h2>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">一般情况下，我们使用某个类时必定知道它是什么类，用来做什么的。于是我们直接对这个类进行实例化，之后使用这个类对象进行操作。</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">Cook cook = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> Cook(); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 实例化一个对象，标准用法</span>
<span/>cook.cookService(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"🍅"</span>);
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">反射是一开始并不知道初始化的类对象是什么，也不能使用 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">new</code> 关键字来创建对象，反射是在运行的时才知道要操作的类是什么，并且可以在运行时获取类的完整构造，调用对应的方法。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">Java 反射机制主要提供了以下功能:</p>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">在运行时构造任意一个类的对象</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">在运行时获取或修改任意一个类所具有的成员变量和方法</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">在运行时调用任意一个对象的方法(属性)</section></li></ul>
<h3 id="Class类" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">Class类</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">Class是一个类，封装了当前对象所对应的类的信息，我们写的每一个类都可以看成一个对象，是 java.lang.Class 类的对象，Class是用来描述类的类。</p>
<h3 id="获得Class对象" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">获得Class对象</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">Class对象的获取有3种方式，如下：</p>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">通过类名获取 类名.class</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">通过对象获取 对象名.getClass()</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">通过全类名获取 Class.forName(全类名)</section></li></ul>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">Cook cook = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> Cook();
<span/>Class cookClass = Cook.class;
<span/>Class cookClass1 = cook.getClass();
<span/>Class cookClass2 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.reflectdemo.Cook"</span>);
<span/></code></pre>
<h3 id="创建实例" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">创建实例</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们可以通过反射来生成对象的实例，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">Class cookClass = Cook.class;
<span/>Cook cook1 = (Cook) cookClass.newInstance();
<span/></code></pre>
<h3 id="获取构造器" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">获取构造器</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">获取构造器的方法有，如下：</p>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Constructor getConstructor(Class[] params)：获得使用特殊的参数类型的public构造函数(包括父类)</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Constructor[] getConstructors()：获得类的所有公共构造函数</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Constructor getDeclaredConstructor(Class[] params)：获得使用特定参数类型的构造函数(包括私有)</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Constructor[] getDeclaredConstructors()：获得类的所有构造函数(与接入级别无关)</section></li></ul>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们来新建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Person</code> ，以便我们的演示，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">Person</span> </span>{
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> String name;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> age;
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">Person</span><span class="hljs-params" style="line-height: 26px;">(String name, <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> age)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.name = name;
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.age = age;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">Person</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">super</span>();
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> String <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getName</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"get name: "</span> + name);
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> name;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">setName</span><span class="hljs-params" style="line-height: 26px;">(String name)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.name = name;
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"set name: "</span> + <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.name);
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getAge</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"get age: "</span> + age);
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> age;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">setAge</span><span class="hljs-params" style="line-height: 26px;">(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> age)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.age = age;
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"set age: "</span> + <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.age);
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">privateMethod</span><span class="hljs-params" style="line-height: 26px;">()</span></span>{
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"the private method!"</span>);
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">很常规的一个类，里面有私有的属性和方法。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">下面，我们新建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">GetConstructor</code> 的类来演示，获取构造器方法如何使用，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">GetConstructor</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span>
<span/>            ClassNotFoundException,
<span/>            NoSuchMethodException,
<span/>            IllegalAccessException,
<span/>            InvocationTargetException,
<span/>            InstantiationException </span>{
<span/>
<span/>        String className = <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.reflectdemo.entity.Person"</span>;
<span/>        Class&lt;Person&gt; personClass = (Class&lt;Person&gt;) Class.forName(className);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//获取全部的constructor对象</span>
<span/>        Constructor&lt;?&gt;[] constructors = personClass.getConstructors();
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (Constructor&lt;?&gt; constructor: constructors) {
<span/>            System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取全部的constructor对象: "</span> + constructor);
<span/>        }
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//获取某一个constructor对象</span>
<span/>        Constructor&lt;Person&gt; constructor = personClass.getConstructor(String.class, <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span>.class);
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取某一个constructor对象: "</span> + constructor);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//调用构造器的 newInstance() 方法创建对象</span>
<span/>        Person person = constructor.newInstance(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"lsy"</span>, <span class="hljs-number" style="color: #986801; line-height: 26px;">66</span>);
<span/>        System.out.println(person.getName() + <span class="hljs-string" style="color: #50a14f; line-height: 26px;">", "</span> + person.getAge() );
<span/>    }
<span/>
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">输出结果，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">获取全部的constructor对象: public net.lishaoy.reflectdemo.entity.Person(java.lang.String,int)
<span/>获取全部的constructor对象: public net.lishaoy.reflectdemo.entity.Person()
<span/>获取某一个constructor对象: public net.lishaoy.reflectdemo.entity.Person(java.lang.String,int)
<span/>lsy, 66
<span/></code></pre>
<h3 id="获取方法" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">获取方法</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">获取方法的方法有，如下：</p>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Method getMethod(String name, Class[] params)：使用特定的参数类型，获得命名的公共方法</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Method[] getMethods()：获得类的所有公共方法</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Method getDeclaredMethod(String name, Class[] params)：使用特写的参数类型，获得类声明的命名的方法</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Method[] getDeclaredMethods()：获得类声明的所有方法</section></li></ul>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们新创建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">GetMethod</code> 来演示如何来获取和调用方法，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">GetMethod</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span>
<span/>            ClassNotFoundException,
<span/>            NoSuchMethodException,
<span/>            IllegalAccessException,
<span/>            InstantiationException,
<span/>            InvocationTargetException </span>{
<span/>
<span/>        Class&lt;?&gt; aClass = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.reflectdemo.entity.Person"</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//获取所有的public方法(包含从父类继承的方法)</span>
<span/>        Method[] methods = aClass.getMethods();
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (Method method: methods) {
<span/>            System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取所有public方法： "</span> + method.getName() + <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"()"</span>);
<span/>        }
<span/>
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"==========================="</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//获取所有方法(不包含父类方法)</span>
<span/>        methods = aClass.getDeclaredMethods();
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (Method method: methods) {
<span/>            System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取所有方法: "</span> + method.getName() + <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"()"</span>);
<span/>        }
<span/>
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"==========================="</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//获取指定的方法</span>
<span/>        Method method = aClass.getDeclaredMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"setAge"</span>, <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span>.class);
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取指定的方法:"</span> + method);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//调用方法</span>
<span/>        Object instance = aClass.newInstance();
<span/>        method.invoke(instance, <span class="hljs-number" style="color: #986801; line-height: 26px;">66</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//调用私有方法</span>
<span/>        method = aClass.getDeclaredMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"privateMethod"</span>);
<span/>        method.setAccessible(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">true</span>); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 需要调用此方法且设置为 true</span>
<span/>        method.invoke(instance);
<span/>
<span/>    }
<span/>
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">运行结果，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">获取所有public方法： getName()
<span/>获取所有public方法： setName()
<span/>获取所有public方法： setAge()
<span/>获取所有public方法： getAge()
<span/>获取所有public方法： <span class="hljs-built_in" style="color: #c18401; line-height: 26px;">wait</span>()
<span/>获取所有public方法： <span class="hljs-built_in" style="color: #c18401; line-height: 26px;">wait</span>()
<span/>获取所有public方法： <span class="hljs-built_in" style="color: #c18401; line-height: 26px;">wait</span>()
<span/>获取所有public方法： equals()
<span/>获取所有public方法： toString()
<span/>获取所有public方法： hashCode()
<span/>获取所有public方法： getClass()
<span/>获取所有public方法： notify()
<span/>获取所有public方法： notifyAll()
<span/>===========================
<span/>获取所有方法: getName()
<span/>获取所有方法: setName()
<span/>获取所有方法: setAge()
<span/>获取所有方法: privateMethod()
<span/>获取所有方法: getAge()
<span/>===========================
<span/>获取指定的方法:public void net.lishaoy.reflectdemo.entity.Person.setAge(int)
<span/><span class="hljs-built_in" style="color: #c18401; line-height: 26px;">set</span> age: 66
<span/>the private method!
<span/>
<span/>BUILD SUCCESSFUL <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">in</span> 395ms
<span/></code></pre>
<h3 id="获取成员变量" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">获取成员变量</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">获取成员变量的方法有，如下：</p>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Field getField(String name)：获得命名的公共字段</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Field[] getFields()：获得类的所有公共字段</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Field getDeclaredField(String name)：获得类声明的命名的字段</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">Field[] getDeclaredFields()：获得类声明的所有字段</section></li></ul>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们再来新建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">GetField</code> 的类来演示如何获取成员变量，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">GetField</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span>
<span/>            ClassNotFoundException,
<span/>            NoSuchFieldException,
<span/>            IllegalAccessException,
<span/>            InstantiationException </span>{
<span/>
<span/>        Class&lt;?&gt; aClass = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.reflectdemo.entity.Person"</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取所有字段(不包含父类字段)</span>
<span/>        Field[] fields = aClass.getDeclaredFields();
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (Field field: fields) {
<span/>            System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取所有字段: "</span> + field.getName());
<span/>        }
<span/>
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"================"</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取指定字段</span>
<span/>        Field name = aClass.getDeclaredField(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"name"</span>);
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取指定字段: "</span> + name.getName());
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 设置指定字段的值</span>
<span/>        Object instance = aClass.newInstance();
<span/>        name.set(instance, <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"per"</span>);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取指定字段的值</span>
<span/>        Object o = name.get(instance);
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取指定字段的值: "</span> + o);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 设置和获取私有字段的值</span>
<span/>        Field age = aClass.getDeclaredField(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"age"</span>);
<span/>        age.setAccessible(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">true</span>); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 需要调用此方法且设置为 true</span>
<span/>        age.set(instance, <span class="hljs-number" style="color: #986801; line-height: 26px;">66</span>);
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"获取私有字段的值: "</span> + age.get(instance));
<span/>
<span/>    }
<span/>
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">运行结果，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">获取所有字段: name
<span/>获取所有字段: age
<span/>================
<span/>获取指定字段: name
<span/>获取指定字段的值: per
<span/>获取私有字段的值: 66
<span/>
<span/>BUILD SUCCESSFUL <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">in</span> 395ms
<span/></code></pre>
<h2 data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; bmin-height: 32px; line-height: 32px; border-bottom: solid 1px #000000; color: #35b378; display: inline-block; border-bottom-width: 0px; border-bottom-style: solid; border-color: #35b378; padding-top: 5px; padding-right: 0.5em; padding-left: 0.5em; font-size: 23px; margin: 1em 0 0rem 0; padding: 0.5em 0; text-align: leftt; font-weight: bold;"><span class="prefix" style="display: none;"></span><span class="content">使用注解和反射实现自动findViewById(案例)</span><span class="suffix"></span></h2>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们已经对注解和反射有了更清晰的认知，下面我们通过一个小案例来巩固我们的学习：使用注解和反射完成类似 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">butterknife</code> 的自动 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">findViewById</code> 的功能。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">新建一个空的 Android 工程，在工程目录下新建 <strong style="font-weight: bold; color: #35b378;">inject</strong> 目录，在此目录下新建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">InjectView</code> 的类和 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">BindView</code> 的自定义注解，如：</p>
<h3 id="创建InjectView" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">创建InjectView</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">InjectView</code> 类通过反射完成 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">findViewById</code> 功能：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">InjectView</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">init</span><span class="hljs-params" style="line-height: 26px;">(Activity activity)</span> </span>{
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取 activity 的 class 对象</span>
<span/>        Class&lt;? extends Activity&gt; aClass = activity.getClass();
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取 activity 的所以成员变量</span>
<span/>        Field[] declaredFields = aClass.getDeclaredFields();
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 变量所以成员变量</span>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">for</span> (Field field: declaredFields) {
<span/>            <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 判断属性是否加上了 @BindView 注解</span>
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span>(field.isAnnotationPresent(BindView.class)){
<span/>                <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取注解 BindView 对象</span>
<span/>                BindView bindView = field.getAnnotation(BindView.class);
<span/>                <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取注解类型元素 id</span>
<span/>                <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> id = bindView.value();
<span/>                <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 通过资源 id 找到对应的 view</span>
<span/>                View view = activity.findViewById(id);
<span/>                <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 设置可以访问私有字段</span>
<span/>                field.setAccessible(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">true</span>);
<span/>                <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>                    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 给字段赋值</span>
<span/>                    field.set(activity,view);
<span/>                } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (IllegalAccessException e) {
<span/>                    e.printStackTrace();
<span/>                }
<span/>            }
<span/>        }
<span/>    }
<span/>}
<span/></code></pre>
<h3 id="创建@BindView注解" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">创建@BindView注解</span><span class="suffix" style="display: none;"></span></h3>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Retention</span>(RetentionPolicy.RUNTIME)
<span/><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Target</span>(ElementType.FIELD)
<span/><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@interface</span> BindView {
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@IdRes</span> <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">value</span><span class="hljs-params" style="line-height: 26px;">()</span></span>; <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// @IdRes 只能传 id 资源</span>
<span/>}
<span/></code></pre>
<h3 id="使用@BindView注解" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">使用@BindView注解</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">MainActivity</code> 里使用 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">@BindView</code> 注解，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">MainActivity</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">extends</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">AppCompatActivity</span> </span>{
<span/>
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 使用注解</span>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@BindView</span>(R.id.text_view)
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> TextView textView;
<span/>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Override</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">protected</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">onCreate</span><span class="hljs-params" style="line-height: 26px;">(Bundle savedInstanceState)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">super</span>.onCreate(savedInstanceState);
<span/>
<span/>        setContentView(R.layout.activity_main);
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 初始化 InjectView，完成自动 findViewById 功能</span>
<span/>        InjectView.init(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>);
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 测试 R.id.text_view 是否自动赋值给 textView</span>
<span/>        textView.setText(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"通过 @BindView 注解自动完成 findViewById"</span>);
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">运行结果，如图：</p>
<div style="width: 36%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations2.png" alt="no-shadow" title="small case" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">是不是很简单，一个类就完成了自动 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">findViewById</code> 的功能。</p>
<h2 data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; bmin-height: 32px; line-height: 32px; border-bottom: solid 1px #000000; color: #35b378; display: inline-block; border-bottom-width: 0px; border-bottom-style: solid; border-color: #35b378; padding-top: 5px; padding-right: 0.5em; padding-left: 0.5em; font-size: 23px; margin: 1em 0 0rem 0; padding: 0.5em 0; text-align: leftt; font-weight: bold;"><span class="prefix" style="display: none;"></span><span class="content">动态代理</span><span class="suffix"></span></h2>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在了解动态代理之前，我们先来回顾下静态代理。</p>
<h3 id="静态代理" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">静态代理</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">代理模式给某一个对象提供一个代理对象，并由代理对象控制对原对象的引用，如，我们生活中常见的中介。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">代理模式一般会有3个角色，如图：</p>
<div style="width: 86%; margin:26px auto;" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations3.png" alt="no-shadow" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">抽象角色：指代理角色和真实角色对外提供的公共方法，一般为一个接口</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">真实角色：需要实现抽象角色接口，定义了真实角色所要实现的业务逻辑，以便供代理角色调用</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">代理角色：需要实现抽象角色接口，是真实角色的代理，通过真实角色的业务逻辑方法来实现抽象方法，并可以附加自己的操作</section></li></ul>
<h3 id="为什么要使用代理模式" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">为什么要使用代理模式</span><span class="suffix" style="display: none;"></span></h3>
<ul data-tool="mdnice编辑器" style="margin-top: 8px; margin-bottom: 8px; padding-left: 25px; color: black; list-style-type: disc;">
<li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">可以间接访问对象，防止直接访问对象来的不必要复杂性</section></li><li><section style="margin-top: 5px; margin-bottom: 5px; line-height: 26px; text-align: left; color: rgb(1,1,1); font-weight: 500; margin: 10px 0;">通过代理对象对访问进行控制</section></li></ul>
<h3 id="静态代理案例" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">静态代理案例</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">场景如下：</p>
<blockquote data-tool="mdnice编辑器" style="display: block; font-size: 0.9em; overflow: auto; overflow-scrolling: touch; padding-top: 10px; padding-bottom: 10px; padding-left: 20px; padding-right: 10px; margin-bottom: 20px; margin-top: 20px; margin: 10px 5px; border-left: 3px solid #35b378; border-right: 0px solid #35b378; color: #616161; quotes: none; background: #FBF9FD;">
<p style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; margin: 0px; color: black; line-height: 26px;">小明可以在某网站上购买国内的东西，但是，不能买海外的东西，于是，他找了海外代购帮他买东西。</p>
</blockquote>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">如何用代码描述呢？根据代理模式的3个角色，我们分别定义1个接口2个类，如：<code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">OrderService</code> 接口(抽象角色)、<code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ImplJapanOrderService</code> 类(真实角色)、<code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ProxyJapanOrder</code> 类(代理角色)</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">OrderService</code> 接口(抽象角色)，代码如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">interface</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">OrderService</span> </span>{
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">saveOrder</span><span class="hljs-params" style="line-height: 26px;">()</span></span>;
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ImplJapanOrderService</code> 类(真实角色)，代码如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 实现抽象角色接口</span>
<span/><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">ImplJapanOrderService</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">implements</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">OrderService</span> </span>{
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Override</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">saveOrder</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        System.out.println(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"下单成功，订单号为：888888"</span>);
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> <span class="hljs-number" style="color: #986801; line-height: 26px;">888888</span>;
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;"><code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ProxyJapanOrder</code> 类(代理角色)，代码如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 实现抽象角色接口</span>
<span/><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">ProxyJapanOrder</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">implements</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">OrderService</span> </span>{
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> OrderService orderService; <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 持有真实角色</span>
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> OrderService <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getOrderService</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> orderService;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">setOrderService</span><span class="hljs-params" style="line-height: 26px;">(OrderService orderService)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.orderService = orderService;
<span/>    }
<span/>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Override</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">saveOrder</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        System.out.print(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"日本代购订单，"</span>);
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> orderService.saveOrder(); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 调用真实角色的行为方法</span>
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在创建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Client</code> 类来测试我们的代码，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">Client</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> </span>{
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 日本代购订单</span>
<span/>        OrderService orderJapan = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplJapanOrderService();
<span/>        ProxyJapanOrder proxyJapanOrder = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ProxyJapanOrder();
<span/>        proxyJapanOrder.setOrderService(orderJapan);
<span/>        proxyJapanOrder.saveOrder();
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">运行结果，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">日本代购订单，下单成功，订单号为：888888
<span/>
<span/>BUILD SUCCESSFUL <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">in</span> 1s
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">如果，需要购买韩国的东西，需要新增一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ImplKoreaOrderService</code> 类(韩国服务商) 和 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ProxyKoreaOrder</code> 类(韩国代理)，如还需要购买其他国家的东西，需要新增不同的类，则会出现静态代理对象量多、代码量大，从而导致代码复杂，可维护性差的问题，如是，我们需要使用动态代理。</p>
<h3 id="动态代理" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">动态代理</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">动态代理是在运行时才创建代理类和其实例，因此，我们可以传不同的真实角色，实现一个代理类完成多个真实角色的行为方法，当然，其效率比静态代理低。那么如何实现动态代理呢，JDK已为我们提供了 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Proxy</code> 类 和 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">InvocationHandler</code> 接口来完成这件事情。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们来创建一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ProxyDynamicOrder</code> 类(动态代理类)，代码如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">ProxyDynamicOrder</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">implements</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">InvocationHandler</span> </span>{
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> Object orderService; <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 持有真实角色</span>
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> Object <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getOrderService</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> orderService;
<span/>    }
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">setOrderService</span><span class="hljs-params" style="line-height: 26px;">(Object orderService)</span> </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.orderService = orderService;
<span/>    }
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 通过 Proxy 动态创建真实角色</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> Object <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getProxyInstance</span><span class="hljs-params" style="line-height: 26px;">()</span></span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> Proxy.newProxyInstance(
<span/>                orderService.getClass().getClassLoader(),
<span/>                orderService.getClass().getInterfaces(),
<span/>                <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>
<span/>                );
<span/>    }
<span/>
<span/>    <span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@Override</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> Object <span class="hljs-title" style="color: #4078f2; line-height: 26px;">invoke</span><span class="hljs-params" style="line-height: 26px;">(Object o, Method method, Object[] objects)</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span> Throwable </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> method.invoke(orderService, objects); <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 通过反射执行真实角色的行为方法</span>
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">在来看看，<code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Client</code> 类里如何调用，代码如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">Client</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">main</span><span class="hljs-params" style="line-height: 26px;">(String[] args)</span> </span>{
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 静态代理模式</span>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 国内订单</span>
<span/>        OrderService order = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplOrderService();
<span/>        order.saveOrder();
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 日本代购订单</span>
<span/>        OrderService orderJapan = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplJapanOrderService();
<span/>        ProxyJapanOrder proxyJapanOrder = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ProxyJapanOrder();
<span/>        proxyJapanOrder.setOrderService(orderJapan);
<span/>        proxyJapanOrder.saveOrder();
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 韩国代购订单</span>
<span/>        OrderService orderKorea = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplKoreaOrderService();
<span/>        ProxyKoreaOrder proxyKoreaOrder = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ProxyKoreaOrder();
<span/>        proxyKoreaOrder.setOrderService(orderKorea);
<span/>        proxyKoreaOrder.saveOrder();
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 动态代理模式</span>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 国内订单</span>
<span/>        ProxyDynamicOrder proxyDynamicOrder = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ProxyDynamicOrder();
<span/>        OrderService orderService = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplOrderService();
<span/>        proxyDynamicOrder.setOrderService(orderService);
<span/>        OrderService orderService1 = (OrderService) proxyDynamicOrder.getProxyInstance();
<span/>        orderService1.saveOrder();
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 日本代购订单</span>
<span/>        OrderService japanOrderService = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplJapanOrderService();
<span/>        proxyDynamicOrder.setOrderService(japanOrderService);
<span/>        OrderService japanOrderService1 = (OrderService) proxyDynamicOrder.getProxyInstance();
<span/>        japanOrderService1.saveOrder();
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 韩国代购订单</span>
<span/>        OrderService koreaOrderService = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> ImplKoreaOrderService();
<span/>        proxyDynamicOrder.setOrderService(koreaOrderService);
<span/>        OrderService koreaOrderService1 = (OrderService) proxyDynamicOrder.getProxyInstance();
<span/>        koreaOrderService1.saveOrder();
<span/>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 生成动态代理生成的class文件</span>
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">//ProxyUtil.generateClassFile(koreaOrderService.getClass(), koreaOrderService1.getClass().getSimpleName());</span>
<span/>
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">运行结果，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">下单成功，订单号为：666666
<span/>日本代购订单，下单成功，订单号为：888888
<span/>韩国代购订单，下单成功，订单号为：666888
<span/>下单成功，订单号为：666666
<span/>下单成功，订单号为：888888
<span/>下单成功，订单号为：666888
<span/>
<span/>BUILD SUCCESSFUL <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">in</span> 1s
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">只需要一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ProxyDynamicOrder</code> 代理类即可完成 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ImplOrderService</code> 、 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ImplJapanOrderService</code> 、<code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ImplKoreaOrderService</code> 真实角色提供的服务。</p>
<h3 id="动态代理原理" data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; font-size: 20px; margin: 1.2em 0 1em; padding: 0; font-weight: bold; color: #35b378;"><span class="prefix" style="display: none;"></span><span class="content">动态代理原理</span><span class="suffix" style="display: none;"></span></h3>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们在 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">proxyDynamicOrder.getProxyInstance()</code> 代码上打个断点，通过调试模式发现，如图：</p>
<div style="width: 100%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations4.png" alt="no-shadow" title="proxy" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">代理类的名字是 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">$Proxy0@507</code>，为什么是这个名字，我们在编译后的目录里也找不到 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">$Proxy0@507</code> 类文件，如图：</p>
<div style="width: 56%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations5.png" alt="no-shadow" title="proxy" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">我们通过查看 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Proxy.newProxyInstance</code> 方法源码，可知，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-meta" style="color: #4078f2; line-height: 26px;">@CallerSensitive</span>
<span/><span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Object <span class="hljs-title" style="color: #4078f2; line-height: 26px;">newProxyInstance</span><span class="hljs-params" style="line-height: 26px;">(ClassLoader var0, Class&lt;?&gt;[] var1, InvocationHandler var2)</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span> IllegalArgumentException </span>{
<span/>    Objects.requireNonNull(var2);
<span/>    Class[] var3 = (Class[])var1.clone();
<span/>    SecurityManager var4 = System.getSecurityManager();
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span> (var4 != <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>) {
<span/>        checkProxyAccess(Reflection.getCallerClass(), var0, var3);
<span/>    }
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取代理类的 class 对象</span>
<span/>    Class var5 = getProxyClass0(var0, var3);
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span> (var4 != <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>) {
<span/>            checkNewProxyPermission(Reflection.getCallerClass(), var5);
<span/>        }
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 获取代理类的构造器</span>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">final</span> Constructor var6 = var5.getConstructor(constructorParams);
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span> (!Modifier.isPublic(var5.getModifiers())) {
<span/>            AccessController.doPrivileged(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> PrivilegedAction&lt;Void&gt;() {
<span/>                <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> Void <span class="hljs-title" style="color: #4078f2; line-height: 26px;">run</span><span class="hljs-params" style="line-height: 26px;">()</span> </span>{
<span/>                    var6.setAccessible(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">true</span>);
<span/>                    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>;
<span/>                }
<span/>            });
<span/>        }
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 创建代理类的示例</span>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> var6.newInstance(var2);
<span/>    } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (InstantiationException | IllegalAccessException var8) {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> InternalError(var8.toString(), var8);
<span/>    } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (InvocationTargetException var9) {
<span/>        Throwable var7 = var9.getCause();
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span> (var7 <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">instanceof</span> RuntimeException) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> (RuntimeException)var7;
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">else</span> {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> InternalError(var7.toString(), var7);
<span/>        }
<span/>    } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (NoSuchMethodException var10) {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> InternalError(var10.toString(), var10);
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">然后，跟进 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">getProxyClass0(var0, var3)</code> 看看是如何获取代理类的 class 对象的，点击进入，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Class&lt;?&gt; getProxyClass0(ClassLoader var0, Class&lt;?&gt;... var1) {
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span> (var1.length &gt; <span class="hljs-number" style="color: #986801; line-height: 26px;">65535</span>) {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> IllegalArgumentException(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"interface limit exceeded"</span>);
<span/>    } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">else</span> {
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 缓存了代理类的 class 对象</span>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> (Class)proxyClassCache.get(var0, var1);
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">然后，我们来看看这个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">var1</code> 是个什么东西，我们往上找了找，果然发现，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// var1 就是我们实现的 InvocationHandler 接口</span>
<span/><span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">protected</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">Proxy</span><span class="hljs-params" style="line-height: 26px;">(InvocationHandler var1)</span> </span>{
<span/>    Objects.requireNonNull(var1);
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>.h = var1;
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">然后，我们点进 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">proxyClassCache.get(var0, var1)</code> 方法，如图：</p>
<div style="width: 100%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations6.png" alt="no-shadow" title="proxy" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">使用关键代码 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">this.subKeyFactory.apply(var1, var2)</code> 去获取我们的代理类的 class 对象，我们进入 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">apply</code> 实现类 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">ProxyClassFactory</code>，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> Class&lt;?&gt; apply(ClassLoader var1, Class&lt;?&gt;[] var2) {
<span/>    IdentityHashMap var3 = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> IdentityHashMap(var2.length);
<span/>    Class[] var4 = var2;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> var5 = var2.length;
<span/>
<span/>    ...
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">if</span> (var16 == <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>) {
<span/>        var16 = <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"com.sun.proxy."</span>;
<span/>    }
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">long</span> var19 = nextUniqueNumber.getAndIncrement();
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 生成代理类的类名</span>
<span/>    String var23 = var16 + <span class="hljs-string" style="color: #50a14f; line-height: 26px;">"$Proxy"</span> + var19;
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 生成代理类的字节码</span>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">byte</span>[] var22 = ProxyGenerator.generateProxyClass(var23, var2, var17);
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>        <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 生成代理类的 class 对象</span>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> Proxy.defineClass0(var1, var23, var22, <span class="hljs-number" style="color: #986801; line-height: 26px;">0</span>, var22.length);
<span/>    } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (ClassFormatError var14) {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> IllegalArgumentException(var14.toString());
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">然后，我们点进 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">Proxy.defineClass0</code> 方法，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">native</span> Class&lt;?&gt; defineClass0(ClassLoader var0, String var1, <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">byte</span>[] var2, <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> var3, <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> var4);
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">是一个 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">native</code> 方法，所以涉及到 C 或 C++ ，我们就不往后追踪。</p>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">那么，代理的 Class 文件到底存在哪儿呢，由一个类的生命周期，如图：</p>
<div style="width: 100%; margin:auto" data-tool="mdnice编辑器">
<figure style="margin: 0; margin-top: 10px; margin-bottom: 10px; flex-direction: column; justify-content: center; align-items: center; display: block;"><img src="https://cdn.lishaoy.net/annotations-reflect/annotations7.png" alt="no-shadow" title="proxy" style="display: block; margin: 0 auto; max-width: 100%; border-radius: 6px;"></figure>
</div>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">代理的 Class 文件通过反射存在内存中，所以我们可以通过 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">byte[]</code> 写入文件，我们新建一个工具类来把内存中的 class 字节码写入文件，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">ProxyUtil</span> </span>{
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">void</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">generateClassFile</span><span class="hljs-params" style="line-height: 26px;">(Class aClass, String proxyName)</span> </span>{
<span/>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">byte</span>[] proxyClassFile = ProxyGenerator.generateProxyClass(
<span/>                proxyName,
<span/>                <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> Class[]{aClass}
<span/>        );
<span/>        String path = aClass.getResource(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"."</span>).getPath();
<span/>        System.out.println(path);
<span/>        FileOutputStream outputStream = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>;
<span/>
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>            outputStream = <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> FileOutputStream(path + proxyName + <span class="hljs-string" style="color: #50a14f; line-height: 26px;">".class"</span>);
<span/>            outputStream.write(proxyClassFile);
<span/>            outputStream.flush();
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (IOException e) {
<span/>            e.printStackTrace();
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">finally</span> {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>                outputStream.close();
<span/>            } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (IOException e) {
<span/>                e.printStackTrace();
<span/>            }
<span/>        }
<span/>    }
<span/>}
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">通过输出的 <code style="font-size: 14px; word-wrap: break-word; padding: 2px 4px; border-radius: 4px; margin: 0 2px; background-color: rgba(27,31,35,.05); font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; word-break: break-all; color: #35b378; box-shadow: none;">path</code> 路径，找到文件，如：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;">/Users/lishaoying/Documents/APP/Android/practice/annotation_reflect/anRePrDemo/proxyDemo/build/classes/java/main/net/lishaoy/proxydemo/service/impl/
<span/></code></pre>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">文件代码，如下：</p>
<pre class="custom" data-tool="mdnice编辑器" style="margin-top: 10px; margin-bottom: 10px; border-radius: 6px; padding: 0px; background: #fff;"><code class="hljs" style="overflow-x: auto; padding: 16px; color: #383a42; background: #fafafa; display: block; font-family: Operator Mono, Consolas, Monaco, Menlo, monospace; font-size: 12px; -webkit-overflow-scrolling: touch; border-radius: 6px;"><span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 继承了 Proxy 实现了 ImplKoreaOrderService 接口</span>
<span/><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">final</span> <span class="hljs-class" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">class</span> $<span class="hljs-title" style="color: #c18401; line-height: 26px;">Proxy0</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">extends</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">Proxy</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">implements</span> <span class="hljs-title" style="color: #c18401; line-height: 26px;">ImplKoreaOrderService</span> </span>{
<span/>
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 生成了各种方法</span>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m1;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m8;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m3;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m2;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m5;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m4;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m7;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m9;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m0;
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">private</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> Method m6;
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> $Proxy0(InvocationHandler var1) <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span>  {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">super</span>(var1);
<span/>    }
<span/>
<span/>    ...
<span/>
<span/>    <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// 生成了 真实角色的 saveOrder 方法</span>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">final</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">int</span> <span class="hljs-title" style="color: #4078f2; line-height: 26px;">saveOrder</span><span class="hljs-params" style="line-height: 26px;">()</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span>  </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>            <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// h 是什？，点进去发现就是我们 传入的 InvocationHandler 接口</span>
<span/>            <span class="hljs-comment" style="color: #a0a1a7; font-style: italic; line-height: 26px;">// m3 是什么？ 下面 static 代码块，就是我们的 saveOrder 方法</span>
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> (Integer)<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">super</span>.h.invoke(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>, m3, (Object[])<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>);
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (RuntimeException | Error var2) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> var2;
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (Throwable var3) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> UndeclaredThrowableException(var3);
<span/>        }
<span/>    }
<span/>
<span/>    ...
<span/>
<span/>    <span class="hljs-function" style="line-height: 26px;"><span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">public</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">final</span> Class <span class="hljs-title" style="color: #4078f2; line-height: 26px;">getClass</span><span class="hljs-params" style="line-height: 26px;">()</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throws</span>  </span>{
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">return</span> (Class)<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">super</span>.h.invoke(<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">this</span>, m7, (Object[])<span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">null</span>);
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (RuntimeException | Error var2) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> var2;
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (Throwable var3) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> UndeclaredThrowableException(var3);
<span/>        }
<span/>    }
<span/>
<span/>    ...
<span/>
<span/>    <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">static</span> {
<span/>        <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">try</span> {
<span/>            m1 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"java.lang.Object"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"equals"</span>, Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"java.lang.Object"</span>));
<span/>            m8 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"notify"</span>);
<span/>            m3 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"saveOrder"</span>);
<span/>            m2 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"java.lang.Object"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"toString"</span>);
<span/>            m5 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"wait"</span>, Long.TYPE);
<span/>            m4 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"wait"</span>, Long.TYPE, Integer.TYPE);
<span/>            m7 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"getClass"</span>);
<span/>            m9 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"notifyAll"</span>);
<span/>            m0 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"java.lang.Object"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"hashCode"</span>);
<span/>            m6 = Class.forName(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"net.lishaoy.proxydemo.service.impl.ImplKoreaOrderService"</span>).getMethod(<span class="hljs-string" style="color: #50a14f; line-height: 26px;">"wait"</span>);
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (NoSuchMethodException var2) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> NoSuchMethodError(var2.getMessage());
<span/>        } <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">catch</span> (ClassNotFoundException var3) {
<span/>            <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">throw</span> <span class="hljs-keyword" style="color: #a626a4; line-height: 26px;">new</span> NoClassDefFoundError(var3.getMessage());
<span/>        }
<span/>    }
<span/>}
<span/></code></pre>
<h2 data-tool="mdnice编辑器" style="margin-top: 30px; margin-bottom: 15px; bmin-height: 32px; line-height: 32px; border-bottom: solid 1px #000000; color: #35b378; display: inline-block; border-bottom-width: 0px; border-bottom-style: solid; border-color: #35b378; padding-top: 5px; padding-right: 0.5em; padding-left: 0.5em; font-size: 23px; margin: 1em 0 0rem 0; padding: 0.5em 0; text-align: leftt; font-weight: bold;"><span class="prefix" style="display: none;"></span><span class="content">使用注解、反射、动态代理完成简单的Retrofit</span><span class="suffix"></span></h2>
<p data-tool="mdnice编辑器" style="font-size: 16px; padding-top: 8px; padding-bottom: 8px; line-height: 26px; color: black; margin: 1em 4px;">由于文章篇幅已经很长，且使用注解、反射、动态代理完成简单的 Retrofit 的案例代码过多，所以就不再这里展示，感兴趣的小伙伴可以去 <a href="https://github.com/persilee/android_practice" style="text-decoration: none; word-wrap: break-word; font-weight: bold; color: #35b378; border-bottom: 1px solid #35b378;">GitHub</a> 查看源码。</p></section>