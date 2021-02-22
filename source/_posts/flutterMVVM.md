---
title: Flutter 使用 Riverpod+Retrofit 构建MVVM开发模式
tags:
  - riverpod
  - provider
  - retrofit
  - mvvm
  - dart
copyright: true
comments: true
date: 2021-02-21 15:51:54
categories: Dart
top: 122
photos:
---

{% li https://cdn.lishaoy.net/rxjava/rxjava_cover.png, RxJava,RxJava %}

最近，在使用 **Flutter** 做一个图片分享的应用，自己创建出一套 **Flutter** 版的 **MVVM** 开发模式，觉得还挺好用，所以在此分享出来。

<!-- more -->

在介绍这套 **MVVM** 开发模式之前，我们首先需要了解 `riverpod` 和 `retrofit` 是什么怎么用。

下面我们来分别了解他们是什么。

### riverpod

**riverpod** 是 **Flutter** 状态管理库，flutter 的状态管理库有很多，例如： `Redux`、 `Bloc`、 `Provider` 等，flutter 官方推荐我们使用 `provider`，一般我们使用 `provider` 的时候，会结合 `ChangeNotifier` 、 `StateNotifier`、 `freezed` 去使用，而 `riverpod` 是 `provider` 的一个升级加强版，解决了 `provider` 一些疑难杂症，在这里就不过多介绍，如想了解更多 `riverpod` 信息，可以访问 [riverpod官网](https://riverpod.dev/) ；也可以了解我之前写的以下[Demo](https://github.com/persilee/flutter_pro/tree/master/lib/demo/provider_demo) 。

### retrofit

**retrofit** 是一个网络请求库，做过 android 的同学应该比较熟悉，可以用注解的方式生成请求 Rest Api 的各种方法，如，以下的简单的用法：

```dart
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://api.lishaoy.net')
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  /**
   * 获取首页推荐文章
   */
  @GET('/posts')
  Future<PostModel> getPosts(
      @Query('pageIndex') String pageIndex, @Query('pageSize') String pageSize,
      {@Query('sort') String sort = 'recommend'});

  /**
   * 获取文章详情
   */
  @GET('/posts/{postId}')
  Future<SinglePostModel> getPostsById(@Path('postId') int postId,
      {@Query('notView') bool notView});

  /**
   * 登录
   */
  @POST('/login')
  Future<LoginModel> login(@Body() Login login);

}
```

更多详情可以访问 [pub.dev retrofit](https://pub.dev/packages/retrofit) 。

### 目录结构

接下来我们来看看项目的目录结构，如下：

```bash
.
├── android  ## 原生android目录
│   ├── app
│   └── gradle
├── assets  ## 资源文件目录
│   ├── fonts
│   ├── images
│   └── json
├── ios ## 原生iOS目录
│   ├── Flutter
│   ├── Frameworks
│   ├── Pods
│   ├── Runner
│   ├── Runner.xcodeproj
│   └── Runner.xcworkspace
└── lib ## 项目文件目录
    ├── http ##对网格请求相关的封装
    │   ├── api_client.dart ## rest api 请求类
    │   ├── api_client.g.dart ## retrofit 自动生成的类
    │   ├── base_dio.dart ## 对dio封装类
    │   ├── base_error.dart ## 服务端基本错误类型封装类
    │   └── header_interceptor.dart  ##网络请求拦截器
    ├── models ## json序列化的model类，相对于MVVM的 M 层
    ├── pages ## 主要的UI页面目录，相对于MVVM的 V 层
    ├── utils ## 一些工具类
    │   ├── date_util.dart
    │   ├── screen_util.dart
    │   ├── status_bar_util.dart
    │   ├── timeline_util.dart
    │   └── widget_util.dart
    ├── view_model ## 处理数据状态，业务逻辑，相对于 MVVM的 VM 层
    │   ├── details_view_model.dart
    │   ├── login_view_model.dart
    │   ├── posts_view_model.dart
    │   └── profile_view_model.dart
    └── widgets ##公用或自定义组件
        ├── cache_image.dart
        ├── custom_circular_rect_angle.dart
        ├── custom_indicator.dart
        ├── custom_tabs.dart
        ├── error_page.dart
        ├── gradient_button.dart
        ├── icon_animation_widget.dart
        ├── iconfont.dart
        ├── image_paper.dart
        ├── over_scroll_behavior.dart
        ├── page_state.dart
        ├── per_flexible_space_bar.dart
        ├── pic_swiper.dart
        └── refresh.dart
```

从目录结构可知， `models`、 `pages`、`view_model` 分别是 MVVM 开发模式的 M(数据层)、 V(视图层)、 VM(通过riverpod的StateNotifier将数据层和视图层绑定，state变化时数据层也跟着变化，当然这里也可以处理一些页面逻辑)。