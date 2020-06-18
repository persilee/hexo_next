---
title: Android Flutter 混合开发高仿大厂App
tags:
  - Flutter
  - iOS
  - Android
  - Dart
copyright: true
comments: true
date: 2020-06-17 15:54:43
categories: Dart
top: 115
photos:
---

{% li https://cdn.lishaoy.net/flutterCtrip/iOS-andorid.png, Flutter, Flutter %}

自上篇 [Flutter 10天高仿大厂App及小技巧积累总结](https://h.lishaoy.net/flutterctrip) 的续篇，这次更是干货满满。

这篇文章将概述 **Android组件化的架构搭建** 及 **Flutter** 和 **Android** 如何混合开发 *(整个App只有首页是用原生Android完成，其他页面都是引入之前的做好的Flutter页面)* ，主宿主程序由 Android 搭建，采用了组件化的架构搭建整个 **App** ，不同业务，对应不同的 module 工程，业务之间采用接口通信 *(ARouter)* ，以 module 的形式混入 Flutter，通过 MethodChannel 和 Flutter 端进行数据通信等，且这些功能实现源码开源，感兴趣的小伙伴可以移步至 [GitHub](https://github.com/persilee/android_ctrip)。

<hr />

<!-- more -->

以下博文会分为4个部分概述：
- 项目完成的功能预览
- 项目组件化结构分析
- 项目功能详细概述（所用知识点）
- Android Flutter 混合开发

## 项目完成的功能预览

首先，我们还是通过一个视频来快速预览下项目完成的功能和运行效果，如下

<video id="flutter" class="video-js vjs-default-skin" controls preload="auto" poster="https://cdn.lishaoy.net/ctrip/android_ctripb_bg.png"
    data-setup="{'example_option':true}">
    <source src="https://cdn.lishaoy.net/ctrip/android_ctrip.mp4" type='video/mp4' />
</video>

{% note warning %} 
<i class="fa fa-fw fa-bell  faa-horizontal animated faa-slow" style="color: #faab33;"></i> 如视频播放失败， [请移步这里点击观看](https://www.bilibili.com/video/BV1W54y1B72U/)
{% endnote %}

看完视频后，其实大部被功能和之前的 [纯flutter项目](https://h.lishaoy.net/flutterctrip) 相同，只是首页新增了4个tab推荐页面及携程二楼和布局改变。


## 项目组件化结构分析

### 项目结构图预览

其次，分析梳理下项目结构，项目的大概结构如图：

![no-shadow](https://cdn.lishaoy.net/ctrip/android/project.png "project structure")

### 项目结构分析

#### 业务工程

把具体独立的业务都拆分成单独的 module 减小项目的维护压力

- ft_home: 首页模块，这个模块其实还可以继续拆分，可把4个 tab *(精选、附近、景点、美食)* 页都拆成模块，这里我暂时没有拆分，后续会完成
- ft_destination: 目的地模块，这个其实并没有，因为直接引入了之前做好的 flutter 页面
- ft_travel: 旅拍模块，同样也使用了 flutter 页面
- flutter: flutter模块，这个模块是从 flutter_module 中自动生成的，后面介绍到

### 基础库工程

把具体的功能都封装成独立的库供业务模块使用，降低项目的维护成本及代码之间耦合性

- lib_network: 网络库，使用 [okhttp](https://github.com/square/okhttp) 插件二次封装，业务层简单的调用即可
- lib_webview: 打开网页的webview库，使用了 [agentweb](https://github.com/Justson/AgentWeb) 插件二次封装，业务层只需要一句代码即可完成网页的跳转
- lib_image_loader: 图片加载库，使用了 [glide](https://github.com/bumptech/glide) 插件二次封装，业务层只需一句代码即可加载不同参数的图片
- lib_asr: 百度AI语音库，通过 Android 集成好供 Flutter 端使用
- lib_common_ui: 公共UI库，重复多次使用的页面集中管理
- lib_base: 基础库，通过 [ARouter](https://github.com/alibaba/ARouter) 的 service 功能暴露接口提供服务给业务层，当然业务层也可以在这里暴露接口供外界使用

这里有一些使用的插件并没有在项目结构图里体现出来(结构图空间有限)。

### 插件

在这里把项目使用的插件整理列举出来供大家参考：

- [magicindicator](https://github.com/hackware1993/MagicIndicator) 强大、可定制、易扩展的 ViewPager 指示器框架，首页的4个 tab *(精选、附近、景点、美食)* 就是用这个实现的。
- [immersionbar](https://github.com/gyf-dev/ImmersionBar) 一句代码轻松实现状态栏、导航栏沉浸式管理
- [pagerBottomTabStrip](https://github.com/tyzlmjj/PagerBottomTabStrip) 页面底部和侧边的导航栏，首页、目的地、旅拍、我的页面切换就是用这个实现的。
- [rxjava/rxandroid](https://github.com/ReactiveX/RxAndroid) 异步和链式编程
- [butterknife](https://github.com/JakeWharton/butterknife) view注入插件，配合Android插件使用，可快速自动生成 init view的代码，不用写一句 `findViewById` 的代码。
- [gson](https://github.com/google/gson) json解析，配合Android插件使用，可快速生成实体类
- [smartRefreshLayout](https://github.com/scwang90/SmartRefreshLayout) 智能下拉刷新框架，携程二楼及下拉刷新加载更多就是用这个实现的
- [eventbus](https://github.com/greenrobot/EventBus) 发布/订阅事件总线，优雅的完成组件之间通信
- [arouter](https://github.com/alibaba/ARouter) 依赖注入、路由跳转、注册service，优雅的完成模块之间的通信
- [okhttp](https://github.com/square/okhttp) 网络请求插件
- [agentweb](https://github.com/Justson/AgentWeb) webview框架，进行简单的二次封装可优雅的进行网页跳转
- [glide](https://github.com/bumptech/glide) 高性能、可扩展的图片加载插件

基本就是这些了，应该没有漏的，插件的详细使用，请进入各插件的 GitHub 主页。

在此，把我项目的插件引入代码及版本管理的 `gradle` 代码贴出来，如下：

插件引入代码：

```bash
dependencies {
    implementation fileTree(dir: 'libs', include: ['*.jar'])

    implementation rootProject.depsLibs.appcompat
    implementation rootProject.depsLibs.legacy
    implementation rootProject.depsLibs.recyclerview
    implementation rootProject.depsLibs.constraintlayout
    implementation rootProject.depsLibs.cardview

    //tab指示器
    implementation rootProject.depsLibs.magicindicator
    //沉浸式
    implementation rootProject.depsLibs.immersionbar
    //导航栏
    implementation rootProject.depsLibs.pagerBottomTabStrip
    //rxjava
    implementation rootProject.depsLibs.rxjava
    //rxandroid
    implementation rootProject.depsLibs.rxandroid
    //view 注入
    implementation rootProject.depsLibs.butterknife
    //view 注入
    annotationProcessor rootProject.depsLibs.butterknifeCompiler
    //gson
    implementation rootProject.depsLibs.gson
    //banner
    implementation rootProject.depsLibs.banner
    //smartRefreshLayout 上下拉刷新
    implementation rootProject.depsLibs.smartRefreshLayout
    implementation rootProject.depsLibs.refreshHeader
    implementation rootProject.depsLibs.refreshHeaderTwoLevel
    implementation rootProject.depsLibs.refreshFooter
    //eventbus
    implementation rootProject.depsLibs.eventbus
    //arouter库
    implementation(rootProject.depsLibs.arouterapi) {
        exclude group: 'com.android.support'
    }
    annotationProcessor rootProject.depsLibs.aroutercompiler

    //引入home模块
    implementation project(':ft_home')
    //引入图片加载库
    implementation project(':lib_image_loader')
    //引入网络库
    implementation project(':lib_network')
    //webview
    implementation project(':lib_webview')
    //引入基础ui库
    implementation project(':lib_common_ui')
    //base库
    implementation project(':lib_base')
    //引入flutter模块
    implementation project(':flutter')
    //引入百度AI语音库
    implementation project(':lib_asr')
}
```

版本管理代码 *(统一管理版本号)* : 

```bash
ext {
    android = [
            compileSdkVersion: 29,
            buildToolsVersion: "29.0.0",
            minSdkVersion    : 19,
            targetSdkVersion : 29,
            applicationId    : 'net.lishaoy.android_ctrip',
            versionCode      : 1,
            versionName      : '1.0',
            multiDexEnabled  : true,
    ]

    depsVersion = [
            appcompat            : '1.1.0',
            legacy               : '1.0.0',
            recyclerview         : '1.0.0',
            constraintlayout     : '1.1.3',
            cardview             : '1.0.0',
            magicindicator       : '1.5.0',
            immersionbar         : '3.0.0',
            pagerBottomTabStrip  : '2.3.0X',
            glide                : '4.11.0',
            glidecompiler        : '4.11.0',
            butterknife          : '10.2.1',
            butterknifeCompiler  : '10.2.1',
            rxjava               : '3.0.0',
            rxandroid            : '3.0.0',
            okhttp               : '4.7.2',
            okhttpLogging        : '4.7.2',
            gson                 : '2.8.6',
            banner               : '2.0.10',
            smartRefreshLayout   : '2.0.1',
            refreshHeader        : '2.0.1',
            refreshFooter        : '2.0.1',
            refreshHeaderTwoLevel: '2.0.1',
            eventbus             : '3.2.0',
            agentweb             : '4.1.3',
            arouterapi           : '1.5.0',
            aroutercompiler      : '1.2.2',

    ]

    depsLibs = [
            appcompat            : "androidx.appcompat:appcompat:${depsVersion.appcompat}",
            legacy               : "androidx.legacy:legacy-support-v4:${depsVersion.legacy}",
            recyclerview         : "androidx.recyclerview:recyclerview:${depsVersion.recyclerview}",
            constraintlayout     : "androidx.constraintlayout:constraintlayout:${depsVersion.constraintlayout}",
            cardview             : "androidx.cardview:cardview:${depsVersion.cardview}",
            magicindicator       : "com.github.hackware1993:MagicIndicator:${depsVersion.magicindicator}",
            immersionbar         : "com.gyf.immersionbar:immersionbar:${depsVersion.immersionbar}",
            pagerBottomTabStrip  : "me.majiajie:pager-bottom-tab-strip:${depsVersion.pagerBottomTabStrip}",
            glide                : "com.github.bumptech.glide:glide:${depsVersion.glide}",
            glidecompiler        : "com.github.bumptech.glide:compiler:${depsVersion.glidecompiler}",
            butterknife          : "com.jakewharton:butterknife:${depsVersion.butterknife}",
            butterknifeCompiler  : "com.jakewharton:butterknife-compiler:${depsVersion.butterknifeCompiler}",
            rxjava               : "io.reactivex.rxjava3:rxjava:${depsVersion.rxjava}",
            rxandroid            : "io.reactivex.rxjava3:rxandroid:${depsVersion.rxandroid}",
            okhttp               : "com.squareup.okhttp3:okhttp:${depsVersion.okhttp}",
            okhttpLogging        : "com.squareup.okhttp3:logging-interceptor:${depsVersion.okhttpLogging}",
            gson                 : "com.google.code.gson:gson:${depsVersion.gson}",
            banner               : "com.youth.banner:banner:${depsVersion.banner}",
            smartRefreshLayout   : "com.scwang.smart:refresh-layout-kernel:${depsVersion.smartRefreshLayout}",
            refreshHeader        : "com.scwang.smart:refresh-header-classics:${depsVersion.refreshHeader}",
            refreshHeaderTwoLevel: "com.scwang.smart:refresh-header-two-level:${depsVersion.refreshHeader}",
            refreshFooter        : "com.scwang.smart:refresh-footer-classics:${depsVersion.refreshFooter}",
            eventbus             : "org.greenrobot:eventbus:${depsVersion.eventbus}",
            agentweb             : "com.just.agentweb:agentweb:${depsVersion.agentweb}",
            arouterapi           : "com.alibaba:arouter-api:${depsVersion.arouterapi}",
            aroutercompiler      : "com.alibaba:arouter-compiler:${depsVersion.aroutercompiler}",
    ]
}
```

## 项目功能详细概述（所用知识点）

这里主要对首页功能及知识点进行概述，由于其他页面是引用了之前的 Flutter页面， 功能在 [Flutter 10天高仿大厂App及小技巧积累总结](https://h.lishaoy.net/flutterctrip) 已经介绍过了，在这就不再阐述。

首页重点概述以下功能的实现：

- 下拉刷新、携程二楼
- 搜索appBar
- 渐变色网格导航
- banner组件
- 多状态的tab指示器 *(滚动固定顶部)*

### 下拉刷新、携程二楼

首先，看看具体的效果图，如图：

![no-shadow](https://cdn.lishaoy.net/ctrip/android/second_floor.gif "second floor" )

下拉刷新和携程二楼是使用 [smartRefreshLayout](https://github.com/scwang90/SmartRefreshLayout) 插件完成的，实现代码如下：

```java
private void initRefreshMore() {
    homeHeader.setRefreshHeader(new ClassicsHeader(getContext()), -1, (int) Utils.dp2px(76)); //设置下拉刷新及二楼header的高度
    homeHeader.setFloorRate(1.6f); //设置二楼触发比率
    homeRefreshContainer.setPrimaryColorsId(R.color.colorPrimary, R.color.white); //设置下拉刷新及二楼提示文字颜色
    homeRefreshContainer.setOnMultiListener(new SimpleMultiListener() {
        @Override
        public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
            loadMore(refreshLayout); //加载更多
        }

        @Override
        public void onRefresh(@NonNull RefreshLayout refreshLayout) {
            refreshLayout.finishRefresh(1600); //设置下拉刷新延迟
        }

        @Override
        public void onHeaderMoving(RefreshHeader header, boolean isDragging, float percent, int offset, int headerHeight, int maxDragHeight) {
            homeSecondFloorImg.setVisibility(View.VISIBLE);  //隐藏二楼背景图
            homeSearchBarContainer.setAlpha(1 - Math.min(percent, 1)); //改变searchBar透明度
        }

        @Override
        public void onStateChanged(@NonNull RefreshLayout refreshLayout, @NonNull RefreshState oldState, @NonNull RefreshState newState) {
            if (oldState == RefreshState.ReleaseToTwoLevel) {  //即将去往二楼状态处理
                homeSecondFloorImg.setVisibility(View.GONE);
                homeHeaderContent.animate().alpha(1).setDuration(666);
            } else if (newState == RefreshState.PullDownCanceled) { //下拉取消状态处理
                homeHeaderContent.animate().alpha(0).setDuration(666);
            } else if (newState == RefreshState.Refreshing) { //正在刷新状态处理
                homeHeaderContent.animate().alpha(0).setDuration(666);
            } else if (oldState == RefreshState.TwoLevelReleased) { // 准备去往二楼完成状态处理，这里打开webview
                WebViewImpl.getInstance().gotoWebView("https://m.ctrip.com/webapp/you/tsnap/secondFloorIndex.html?isHideNavBar=YES&s_guid=feb780be-c55a-4f92-a6cd-2d81e04d3241", true);
                homeHeader.finishTwoLevel();
            } else if (oldState == RefreshState.TwoLevel) { //到达二楼状态处理
                homeCustomScrollView.setVisibility(View.GONE);
                homeHeaderContent.animate().alpha(0).setDuration(666);
            } else if (oldState == RefreshState.TwoLevelFinish) { //二楼完成状态处理
                homeCustomScrollView.setVisibility(View.VISIBLE);
                homeCustomScrollView.animate().alpha(1).setDuration(666);
            }
        }

    });

}
```

`XML` 页面配置文件代码如下：

```xml
<com.scwang.smart.refresh.layout.SmartRefreshLayout
    android:id="@+id/home_refresh_container"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:clipChildren="false"
    app:srlAccentColor="@color/colorPrimary"
    app:srlPrimaryColor="@color/colorPrimary">
    <com.scwang.smart.refresh.header.TwoLevelHeader
        android:id="@+id/home_header"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="top">

        <ImageView
            android:id="@+id/home_second_floor_img"
            android:layout_width="match_parent"
            android:layout_height="460dp"
            android:layout_alignTop="@+id/home_header"
            android:scaleType="fitXY"
            android:src="@drawable/second_floor"
            android:visibility="gone"/>
        <FrameLayout
            android:id="@+id/home_header_content"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:alpha="0">
            <ImageView
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:scaleType="fitXY"
                android:src="@drawable/second_floor" />
        </FrameLayout>

    </com.scwang.smart.refresh.header.TwoLevelHeader>
    
    ...

    <com.scwang.smart.refresh.footer.ClassicsFooter
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />

</com.scwang.smart.refresh.layout.SmartRefreshLayout>
```

具体实现详情，可移步 [GitHub](https://github.com/persilee/android_ctrip) 查看源码。

### 搜索appBar

搜索栏的滚动的 placeholder