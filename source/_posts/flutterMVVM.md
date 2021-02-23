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

## riverpod

**riverpod** 是 **Flutter** 状态管理库，flutter 的状态管理库有很多，例如： `Redux`、 `Bloc`、 `Provider` 等，flutter 官方推荐我们使用 `provider`，一般我们使用 `provider` 的时候，会结合 `ChangeNotifier` 、 `StateNotifier`、 `freezed` 去使用，而 `riverpod` 是 `provider` 的一个升级加强版，解决了 `provider` 一些疑难杂症，在这里就不过多介绍，如想了解更多 `riverpod` 信息，可以访问 [riverpod官网](https://riverpod.dev/) ；也可以了解我之前写的以下[Demo](https://github.com/persilee/flutter_pro/tree/master/lib/demo/provider_demo) 。

## retrofit

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

## 目录结构

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

## 网络请求模块

首先，我们来对网络请求模块封装一把，让它能够通话易用。

**retrofit** 是依赖网络请求库的，我们可以选择不同的库，例如：`http`、`Dio` 等。

在这里我们选择 `Dio` ，如下，是官方提供的案例代码：

```dart
@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/tasks")
  Future<List<Task>> getTasks();
}
```

### Dio的封装

它需要传一个 Dio 的实例和一个可选的 baseUrl，我们需要对这里重新封装一下，实现使用者不用传递任何参数就可以使用，也可以选择使用不同的网络库和 baseUrl；所以，我们要封装一个 `baseDio` 单例类，如果用户没有传，我们就传递一个默认的 `baseDio` 类，代码大概是这样的：

```dart
@RestApi(baseUrl: 'https://api.lishaoy.net')
abstract class ApiClient {
  factory ApiClient({Dio dio, String baseUrl}) {
    dio ??= BaseDio.getInstance().getDio();
    return _ApiClient(dio, baseUrl: baseUrl);

  @POST('/login')
  Future<LoginModel> login(@Body() Login login);
}  
```

所以我要对 `Dio` 进行一次封装，代码如下：

```dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:pro_flutter/http/base_error.dart';
import 'package:pro_flutter/http/header_interceptor.dart';

class BaseDio {
  BaseDio._(); // 把构造方法私有化

  static BaseDio _instance; 

  static BaseDio getInstance() {  // 通过 getInstance 获取实例
    _instance ??= BaseDio._();

    return _instance;
  }

  Dio getDio() {
    final Dio dio = Dio();
    dio.options = BaseOptions(receiveTimeout: 66000, connectTimeout: 66000); // 设置超时时间等 ...
    dio.interceptors.add(HeaderInterceptor()); // 添加拦截器，如 token之类，需要全局使用的参数
    dio.interceptors.add(PrettyDioLogger(  // 添加日志格式化工具类
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

    return dio;
  }

  BaseError getDioError(Object obj) {  // 这里封装了一个 BaseError 类，会根据后端返回的code返回不同的错误类
    switch (obj.runtimeType) {
      case DioError:
        if ((obj as DioError).type == DioErrorType.RESPONSE) {
          final response = (obj as DioError).response;
          if (response.statusCode == 401) {
            return NeedLogin();
          } else if (response.statusCode == 403) {
            return NeedAuth();
          } else if (response.statusCode == 408) {
            return UserNotExist();
          } else if (response.statusCode == 409) {
            return PwdNotMatch();
          } else if (response.statusCode == 405) {
            return UserNameEmpty();
          } else if (response.statusCode == 406) {
            return PwdEmpty();
          } else {
            return OtherError(
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
            );
          }
        }
    }

    return OtherError();
  }
}
```

### BaseError的封装

以上代码中的 `BaseError` 类是一个抽象类，我们可以实现这个抽象类，告诉UI不同的错误类型，UI只需要用实现类就可以访问错误码和错误消息，代码如下：

```dart
abstract class BaseError {
  final int code;
  final String message;

  BaseError({this.code, this.message});
}

class NeedLogin implements BaseError {
  @override
  int get code => 401;

  @override
  String get message => "请先登录";
}

class NeedAuth implements BaseError {
  @override
  int get code => 403;

  @override
  String get message => "非法访问，请使用正确的token";
}

class UserNotExist implements BaseError {
  @override
  int get code => 408;

  @override
  String get message => "用户不存在";
}

class UserNameEmpty implements BaseError {
  @override
  int get code => 405;

  @override
  String get message => "用户名不能为空";
}

class PwdNotMatch implements BaseError {
  @override
  int get code => 409;

  @override
  String get message => "用户密码不正确";
}

class PwdEmpty implements BaseError {
  @override
  int get code => 406;

  @override
  String get message => "用户密码不能为空";
}

class OtherError implements BaseError {

  final int statusCode;
  final String statusMessage;

  OtherError({this.statusCode, this.statusMessage});

  @override
  int get code => statusCode;

  @override
  String get message => statusMessage;

}
```

### 网络模块的使用

这样我们的一个网络请求模块基本就封装好了，使用起来非常简单，首先我们需要定义接口，代码如下： 

```dart
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

  /**
   * 点赞
   */
  @POST('/posts/{postId}/like')
  Future<BaseModel> like(@Path('postId') int postId);

  ...
```

然后，我们会在 view model 使用它，如下：

```dart
  /**
   * 点赞
   */
  Future<void> clickLike(int postId, int index) async {
    try {
      BaseModel data = await ApiClient().like(postId); // 使用非常简单一句代码即可
      if (data.message == 'success') {
        updatePostById(postId, index);
      }
    } catch (e) {
      state = state.copyWith(
          pageState: PageState.errorState,
          error: BaseDio.getInstance().getDioError(e));
    }
  }
```

## View Model 模块

View Model 模块主要处理数据和状态的绑定、业务逻辑等。

我们首先需要创建一个状态类，来存放，数据状态和页面状态等，如下：

```dart
/// 存储页面状态和数据状态（如，缺省页、错误页、加载中...）
class PostState {
  final List<Post> posts;
  final List<Category> categories;
  final int pageIndex;
  final PageState pageState; // 页面状态类
  final BaseError error; // 根据后端返回的错误的错误类

  PostState(
      {this.posts,
      this.categories,
      this.pageIndex,
      this.pageState,
      this.error});

  PostState.initial()
      : posts = [],
        categories = [],
        pageIndex = 1,
        pageState = PageState.initializedState,
        error = null;

  PostState copyWith({
    List<Post> posts,
    List<Category> categories,
    int pageIndex,
    PageState pageState,
    BaseError error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      categories: categories ?? this.categories,
      pageIndex: pageIndex ?? this.pageIndex,
      pageState: pageState ?? this.pageState,
      error: error ?? this.error,
    );
  }
}
```

当然这个状态类也可以用 `freezed` 自动生成。

我们会返回这个状态类给UI，riverpod 的 StateNotifier 会监听这个状态类里的所有成员变量，当我们更改这些数据之后，UI会自动刷新，代码如下：

```dart
/**
   * 获取文章列表
   */
  Future<void> getPosts(int categoryId, {bool isRefresh = false}) async {
    if (state.pageState == PageState.initializedState) {
      state = state.copyWith(pageState: PageState.busyState); // UI收到这个状态可以呈现loading页面
    }
    try {
      if (isRefresh) {  // 下拉刷新
        PostModel postModel;
        if(categoryId == -2) {
          state = state.copyWith(pageState: PageState.emptyDataState); // UI收到这个状态，可以显示缺省页空数据
          return;
        } else if (categoryId == -1) {
          postModel = await ApiClient().getPosts('1', '10'); // 请求网络接口
        } else {
          postModel =
              await ApiClient().getPostsByCategoryId('1', '10', categoryId);
        }
        if (postModel.data.posts.isEmpty && state.pageIndex == 1) {
          state = state.copyWith(pageState: PageState.emptyDataState);
        } else {
          initPostState();
          state = state.copyWith(
            posts: [...postModel.data.posts],  // 把数据发给UI
            pageState: PageState.refreshState, // 更改页面状态为刷新
            pageIndex: 2,
          );
        }
      } else {  // 下拉加载更多
        PostModel postModel;
        if(categoryId == -2) {
          state = state.copyWith(pageState: PageState.emptyDataState); // UI收到这个状态可以呈现loading页面
          return;
        } else if (categoryId == -1) {
          postModel =
              await ApiClient().getPosts(state.pageIndex.toString(), '10'); // 请求网络接口
        } else {
          postModel = await ApiClient().getPostsByCategoryId(
              state.pageIndex.toString(), '10', categoryId);
        }
        if (postModel.data.posts.isEmpty && state.pageIndex == 1) {
          state = state.copyWith(pageState: PageState.emptyDataState);
        } else {
          state = state.copyWith(
              posts: [...state.posts, ...postModel.data.posts],  // 把数据发给UI
              pageIndex: state.pageIndex + 1,
              pageState: PageState.dataFetchState); // 更改页面状态
          if (postModel.data.posts.isEmpty ||
              postModel.data.posts.length < 10) {
            state = state.copyWith(pageState: PageState.noMoreDataState);
          }
        }
      }
    } catch (e) {
      state = state.copyWith(
          pageState: PageState.errorState,  // 如果发生错误，更改页面状态
          error: BaseDio.getInstance().getDioError(e));
    }
  }
```

以上一个方面就完成了应用首页的所有列表数据请求和页面状态处理，在UI层，不需要写 setState() 和 请求数据的任何代码，UI层只是呈现UI。

## View 模块

那么在UI层怎么处理这些状态呢？

这也非常简单，代码如下：

```dart
// 创建provider，返回viewModel
final postsProvider = StateNotifierProvider.family<PostsViewModel, int>(
    (ref, categoryId) => PostsViewModel(categoryId));

class PostsPageCategory extends ConsumerWidget {  // 继承 ConsumerWidget

  final int categoryId;
  final ScrollController scrollController;
  final RefreshController refreshController;

  PostsPageCategory(
      {this.categoryId, this.scrollController, this.refreshController});

  @override
  Widget build(BuildContext context, ScopedReader watch) { 
    final postsViewModel = watch(postsProvider(categoryId)); // 使用 watch 来监听Provider
    final postState = watch(postsProvider(categoryId).state); // 使用 watch 来监听Provider的状态
    return Refresh(
      controller: refreshController,
      onLoading: () async {  // 加载更多处理
        await postsViewModel.getPosts(categoryId);
        if (postState.pageState == PageState.noMoreDataState) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      },
      onRefresh: () async { // 刷新处理
        await context
            .read(postsProvider(categoryId))
            .getPosts(categoryId, isRefresh: true);
        refreshController.refreshCompleted();
        refreshController.footerMode.value = LoadStatus.canLoading;
      },
      content: _createContent(postState, context),
    );
  }

  Widget _createContent(PostState postState, BuildContext context) {
    if (postState.pageState == PageState.busyState ||
        postState.pageState == PageState.initializedState) {  // loading 状态处理
      return Center(
        child: Lottie.asset(
          'assets/json/loading2.json',
          width: 126,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      );
    }

    if (postState.pageState == PageState.emptyDataState) {
      return ErrorPage( // 错误处理
        isEmptyPage: true,
        icon: Lottie.asset(
          'assets/json/empty3.json',
          width: ScreenUtil.instance.width / 1.8,
          height: 220,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
        desc: '暂 无 数 据',
        buttonAction: () => context.refresh(postsProvider(categoryId)),
      );
    }

    if (postState.pageState == PageState.errorState) {
      return ErrorPage(
        title: postState.error is NeedLogin
            ? '😮 你竟然忘记登录 😮'
            : postState.error.code?.toString(),
        desc: postState.error.message,
        buttonAction: () async {
          if (postState.error is NeedLogin) {
            LoginState loginState = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FlareSignInDemo()));
            if (loginState.isLogin) {
              context.refresh(postsProvider(categoryId));
            }
          } else {
            context.refresh(postsProvider(categoryId));
          }
        },
        buttonText: postState.error is NeedLogin ? '登录' : null,
      );
    }
    return ListView.separated(  // 加载数据，现在页面
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return Padding(padding: EdgeInsets.only(top: 12));
      },
      padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
      reverse: false,
      itemCount: postState.posts.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        return PostsPageItem(
          post: postState.posts[index],
          index: index,
          categoryId: categoryId,
        );
      },
    );
  }
}
```

是不是非常简单，不需要写 setState() 和 请求数据的任何代码，代码结构也非常清晰。