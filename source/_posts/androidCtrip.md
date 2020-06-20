---
title: Android Flutter 混合开发高仿大厂App
tags:
  - Flutter
  - iOS
  - Android
  - Dart
copyright: true
comments: true
date: 2020-06-19 06:36:43
categories: Dart
top: 115
photos:
---

{% li https://cdn.lishaoy.net/ctrip/android/android_ctrip_h.png, Flutter, Flutter %}

自上篇 [Flutter 10天高仿大厂App及小技巧积累总结](https://h.lishaoy.net/flutterctrip) 的续篇，这次更是干货满满。

这篇文章将概述 **Android组件化的架构搭建** 及 **Flutter** 和 **Android** 如何混合开发 *(整个App只有首页是用原生Android完成，其他页面都是引入之前的做好的Flutter页面)* ，主宿主程序由 Android 搭建，采用了组件化的架构搭建整个 **App** ，不同业务，对应不同的 module 工程，业务之间采用接口通信 *(ARouter)* ，以 module 的形式混入 Flutter，通过 **MethodChannel** 和 **Flutter** 端进行数据通信等，且这些功能实现源码开源，感兴趣的小伙伴可以移步至 [GitHub](https://github.com/persilee/android_ctrip)。

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
<i class="fa fa-fw fa-bell  faa-horizontal animated faa-slow" style="color: #faab33;"></i> 如视频播放失败， [请移步这里点击观看](https://www.bilibili.com/video/BV1W54y1B72U/) *(点击齿轮 --> 更多播放设置，可以隐藏黑边)*
{% endnote %}

看完视频后，其实大部分功能和之前的 [纯flutter项目](https://h.lishaoy.net/flutterctrip) 功能相同，只是首页新增了4个tab推荐页面及携程二楼和布局改变。

大家也可扫描，安装体验：

<div style="width:166px; margin:auto">![no-shadow](https://www.pgyer.com/app/qrcode/AsHK?sign=&amp;auSign=&amp;code= "手机扫描二维码安装")</div>


## 项目组件化结构分析

### 项目结构图预览

其次，分析梳理下项目结构，项目的结构大致如图，还有一些细枝末节的没有体现在图里：

![no-shadow](https://cdn.lishaoy.net/ctrip/android/project.png "project structure")

### 项目结构分析

#### 业务工程

把具体独立的业务都拆分成单独的 module 减小项目的维护压力

- ft_home: 首页模块，这个模块其实还可以继续拆分，可把4个 tab *(精选、附近、景点、美食)* 页都拆成模块，这里我暂时没有拆分，后续会完成
- ft_destination: 目的地模块，其实并没有建立这个模块，因为直接引入了之前做好的 flutter 页面
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
- [banner](https://github.com/youth5201314/banner) 图片轮播控件

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

这里主要对首页功能及知识点进行概述，由于其他页面是引入了之前的 Flutter 页面， 具体功能在 [Flutter 10天高仿大厂App及小技巧积累总结](https://h.lishaoy.net/flutterctrip) 已经介绍过了，在这就不再阐述。

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

`XML` 页面布局文件代码如下：

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

搜索栏的滚动的 placeholder 文字是使用 [banner](https://github.com/youth5201314/banner) 插件实现的，点击搜索框可跳转到搜索页面 *(flutter写的搜索页面)* ，跳转页面后可以把 placeholder 文字带到 flutter 搜索页面。

效果如图：

![no-shadow](https://cdn.lishaoy.net/ctrip/android/searchBar.gif "search bar" )

滚动的placeholder文字实现代码如下 *(搜索框的实现就不再这里展示都是一些XML布局代码)*：

```java
        homeSearchBarPlaceholder
                .setAdapter(new HomeSearchBarPlaceHolderAdapter(homeData.getSearchPlaceHolderList())) // 设置适配器
                .setOrientation(Banner.VERTICAL) // 设置滚动方向
                .setDelayTime(3600) // 设置间隔时间
                .setOnBannerListener(new OnBannerListener() {
                    @Override
                    public void OnBannerClick(Object data, int position) {  //点击打开 flutter 搜索页面
                        ARouter.getInstance()
                                .build("/home/search")
                                .withString("placeHolder", ((Home.SearchPlaceHolderListBean) data).getText())
                                .navigation();
                    }
                });
    }
```

searchBar的具体功能不过多阐述，和之前的项目一致。

### 渐变色网格导航

渐变色网格导航基本都是一些 `XML` 页面布局代码，只是我把它封装成了单独的组件，效果如图

<img src="https://cdn.lishaoy.net/ctrip/android/gridBar.png" alt="GridNav" width="36%" title="GridNav" align="center">

封装之后的引入就非常简单，代码如下：

```xml
<LinearLayout
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="vertical"
    android:background="@color/white">

    <!-- 网格导航 -->
    <net.lishaoy.ft_home.GridNavView
        android:id="@+id/home_grid_nav_container"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />

    ...

</LinearLayout>
```

具体实现详情，可移步 [GitHub](https://github.com/persilee/android_ctrip) 查看源码。

### banner组件

banner组件也是用 [banner](https://github.com/youth5201314/banner) 插件实现的，如图

![no-shadow](https://cdn.lishaoy.net/ctrip/android/banner.gif "banner")

实现代码如下：

```java
private void initBanner() {
    homeBanner.addBannerLifecycleObserver(this)
            .setAdapter(new HomeBannerAdapter(homeData.getBannerList())) //设置适配器
            .setIndicator(new EllipseIndicator(getContext()))           //设置指示器，如图的指示器是我自定义的插件里并没有提供
            .setIndicatorSelectedColorRes(R.color.white)                //设置指示器颜色
            .setIndicatorSpace((int) BannerUtils.dp2px(10))             //设置间距
            .setBannerRound(BannerUtils.dp2px(6));                      //设置圆角

}
```

### 多状态的tab指示器

多状态的tab指示器的实现需要注意很多细节，因为它是在首页的 `fragment` 的 `ScrollView` 里嵌入 `viewPaper`，首先你会发现 viewPaper 不显示的问题，其次是滚动不流畅的问题，这两个问题我的解决方案是：

- viewPaper 不显示的问题：使用自定义的 `ViewPager` 重写 `onMeasure` 方法，重新计算高度
- 滚动不流畅的问题：使用自定义的 `ScrollView`，重写 `computeScroll` 和 `onScrollChanged` 重新获取滚动距离

实现效果如图：

![no-shadow](https://cdn.lishaoy.net/ctrip/android/tab_bar.gif "tab page")

这个功能实现代码过多不便在这里展示，具体实现详情，可移步 [GitHub](https://github.com/persilee/android_ctrip) 查看源码。

## Android Flutter 混合开发

这个项目的实现只有首页是用 Android 原生实现，其他的页面均是 Flutter 实现的，之前 [纯Flutter项目](https://h.lishaoy.net/flutterctrip)。

Android 引入 Flutter 进行混合开发，需要以下几个步骤

- 建立一个flutter module
- 编写flutter代码 *(创建 flutter 路由)*
- flutter 和 android 之间相互通信

下面依次概述这几部分是如何操作实现的。

### 建立一个flutter module

这个应该不用过多描述，基本操作大家都会 File --> New --> New Module 如图：

![no-shadow](https://cdn.lishaoy.net/ctrip/android/flutter_module.png "flutter module")

新建完成之后，android studio 会自动生成配置代码到 gradle 配置文件里，且生成一个 flutter 的 library 模块。

{% note warning %} 
<i class="fa fa-fw fa-bell  faa-horizontal animated faa-slow" style="color: #faab33;"></i> **Tips：** <br \>
新建的时候最好 flutter module 和 android 项目放到同级目录下；<br \>
新版的 android studio 才会自动生成 gradle 配置代码，老版本貌似需要手动配置

{% endnote %}

如，没有生成 gradle 配置代码，你需要在根项目的 `settings.gradle` 文件里手动加入如下配置：

```java
setBinding(new Binding([gradle: this]))
evaluate(new File(
  settingsDir, //设置根路径，根据具体flutter module路径配置
  'flutter_module/.android/include_flutter.groovy'
))

include ':flutter_module'
```

还需在宿主工程 *(没改名的话都是app)* 的 `build.gradle` 引入 flutter， 如下：

```java
dependencies {
    ...
    //引入flutter模块
    implementation project(':flutter')
    ...
}
```

### 编写flutter代码

编写flutter代码，在 flutter module 里按照正常 flutter 开发流程编写 flutter 代码即可。 *(我项目里的 flutter 的代码是之前项目都写好的，复制过来，改改包的引入问题，就可以运行了。)*

这里需要注意的是，flutter 有且只有一个入口，就是 `main()` 函数，我们需要在这里处理好 flutter 页面的跳转问题。

在 android 端，创建 flutter 页面，代码如下：

```java
    Flutter.createView(getActivity(),getLifecycle(),"destination");
```

`Flutter.createView` 需要3个参数 `activity` 、`lifecycle` 、`route` ，这个 route 就是要传递到 flutter 端的，当然，它是 String 类型的，我们可以自由发挥传递普通字符串或 json 字符串等。

我们也可以通过其他的方式创建 flutter 页面，如： `Flutter.createFragment()` 、 `FlutterActivity.withNewEngine()`、 `FlutterFragment.createDefault()` 等。

具体的使用，可前往 [Flutter官方文档](https://flutter.dev/docs/development/add-to-app/android) 查阅。

那么，flutter 端如何接收这个 route 参数，是通过 `window.defaultRouteName`，此项目里管理 flutter 端路由代码如下：

```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter model',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'PingFang',
      ),
      home: _widgetRoute(window.defaultRouteName), // 通过 window.defaultRouteName 接收 android 端传来的参数
    );
  }
}

Widget _widgetRoute(String defaultRouteName) {
    Map<String, dynamic> params = convert.jsonDecode(defaultRouteName); //解析参数
    defaultRouteName = params['routeName'];
    placeHolder = params['placeHolder'];

    switch (defaultRouteName) { // 根据参数返回对应的页面
        ...
        case 'destination/search':
            return DestinationSearchPage(
                hideLeft: false,
        );
        ...
        default:
            return Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Text('not found $defaultRouteName',
                        textDirection: TextDirection.ltr),
                ],
                ),
            );
    }
}
```

其实，flutter 端接收这个 route 参数，还有一种方法，就是通过 `onGenerateRoute`，它是 MaterialApp 里的一个方法。

代码如下：

```dart
onGenerateRoute: (settings){ //通过 settings.name 获取android端传来的参数
    return _widgetRoute(settings.name);
},
```

### flutter 和 android 之间相互通信

flutter 端可以调用 android 端的方法及相互传递数据是如何实现的，flutter 官方提供了3个方法可以实现，分别是：

- EventChannel：单向的持续通信，如：网络变化、传感器等。
- MethodChannel：一次性通信，一般适用如方法的调用。
- BasicMessageChannel：持续的双向通信。

此项目里采用了 `MethodChannel` 方法进行通信，如：flutter 端调用 android 端的AI智能语音方法以及 flutter 打开 android 端页面就是用 `MethodChannel` 实现的。

flutter 端调用 android 端的AI智能语音方法代码如下：

```dart
class AsrManager {
  static const MethodChannel _channel = const MethodChannel('lib_asr');
  //开始录音
  static Future<String> start({Map params}) async {
    return await _channel.invokeMethod('start', params ?? {});
  }
  //停止录音
    ...
  //取消录音
    ...
  //销毁
    ...
}
```

flutter 打开 android 端页面代码如下：

```dart
class MethodChannelPlugin {

  static const MethodChannel methodChannel = MethodChannel('MethodChannelPlugin');

  static Future<void> gotoDestinationSearchPage() async {
    try {
      await methodChannel.invokeMethod('gotoDestinationSearchPage'); //gotoDestinationSearchPage 参数会传到android端
    } on PlatformException {
      print('Failed go to gotoDestinationSearchPage');
    }
  }
    ...
}
```

android 接收也是通过 `MethodChannel` ，具体实现代码如下：

```java
public class MethodChannelPlugin implements MethodChannel.MethodCallHandler {

    private static MethodChannel methodChannel;
    private Activity activity;

    private MethodChannelPlugin(Activity activity) {
        this.activity = activity;
    }

    //调用方通过 registerWith 来注册flutter页面
    public static void registerWith(FlutterView flutterView) {
        methodChannel = new MethodChannel(flutterView, "MethodChannelPlugin");
        MethodChannelPlugin instance = new MethodChannelPlugin((Activity) flutterView.getContext());
        methodChannel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("gotoDestinationSearchPage")) { // 收到消息进行具体操作
            EventBus.getDefault().post(new GotoDestinationSearchPageEvent());
            result.success(200);
        } 
        ...
        else {
            result.notImplemented();
        }
    }
}
```

android flutter 混合开发基本就是这3个步骤，其他一些细节及具体的流程请参考 [GitHub](https://github.com/persilee/android_ctrip) 项目源码。