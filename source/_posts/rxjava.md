---
title: Android响应式编程之RxJava，看这一篇就够了
tags:
  - Java
  - RxJava
copyright: true
comments: true
date: 2020-08-04 15:19:44
categories: Java
top: 121
photos:
---

{% li https://cdn.lishaoy.net/serializable/serializable.png, Serializable,Serializable %}

本篇文章将概述 **Android** 响应式编程 **RxJava**，会从设计模式、使用到原理结合案例，由浅到深、由表到里、循序渐进的概述，不怕你不懂！

<hr />

<!-- more -->

## 观察者模式(Observer pattern)

在使用 **RxJava** 之前，我们需要先理解观察者设计模式，因为，**RxJava** 就使用了观察者设计模式。

### 定义

观察者模式(又被称为发布-订阅 Publish/Subscribe 模式)，属于行为型模式的一种，它定义了一对多的依赖关系，让多个观察者对象同时监听某一个被观察者对象，被观察者对象在状态变化时，会通知所有的观察者对象，使他们能够自动更新。

### 结构

观察者模式结构，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/rxjava/UML.png "UML")

</div>

一般我们写一个观察者模式都需要定义如下角色：

- Observable(被观察者)：一般为抽象类，用于保存观察者对象和新增、删除、通知观察者的方法。
- ConcreteObservable(具体的被观察者)：继承 Observable 类，实现 `notifyObservers()` 方法，当被观察者发生变化时，通知所有的观察者。
- Observer(观察者)：一般为接口，包含 `update()` 方法，当收到具体的被观察者通知时被调用。
- ConcreteObserver(具体的观察者)：实现 Observer 接口，重写 `update()` 方法，以便更新自身状态。

### 案例

接下来，我们来实现一个简单的观察者模式的案例，案例情景，如下：

{% note info %} 小明的水果店里的 🍊 非常甜，所以很快就卖光了，但是，接二连三的有顾客过来买 🍊，于是，小明告诉顾客：🍊已经卖完了，你们可以扫下这个公众号，订阅之后，等 🍊有货了会自动通知你们！ {% endnote %}

这种场景我们就可以使用观察者模式，我们先创建一个 `Observer` 接口(观察者)，如下：

```java
public interface Observer {
    void update();
}
```

再创建一个 `Customer` 客户类(具体的观察者)，如下：

```java
// 实现 Observer 接口
public class Customer implements Observer {

    private String name;

    public Customer(String name) {
        this.name = name;
    }

    // 重新 Observer 的 update() 方法
    @Override
    public void update() {
        System.out.println(name + " 购买了 🍊");
    }
}
```

之后创建一个 `Observable` 抽象类(被观察者)，如下：

```java
public abstract class Observable {
    // 观察者
    protected List<Observer> observers = new ArrayList<>();
    // 新增观察者
    public void add(Observer observer) {
        observers.add(observer);
    }
    // 移除观察者
    public void remove(Observer observer) {
        observers.remove(observer);
    }
    // 通知观察者
    public abstract void notifyObservers();
}
```

最后创建一个 `FruitStore` 水果店类(具体的被观察者)，如下：

```java
// 继承 Observable 类
public class FruitStore extends Observable {
    // 重写 notifyObservers() 通知所有的观察者
    @Override
    public void notifyObservers() {
        for (Observer observer: observers) {
            observer.update();
        }
    }

    public void run() {
        this.notifyObservers();
    }
}
```

我们再创建一个 `Client` 进行测试，如下：

```java
public class Client {
    public static void main(String[] args) {
        // 创建一个水果店实例(被观察者)
        FruitStore fruitStore = new FruitStore();
        fruitStore.add(new Customer("lsy")); // 新增观察者
        fruitStore.add(new Customer("per")); // 新增观察者
        fruitStore.add(new Customer("zimu")); // 新增观察者
        fruitStore.run(); // 通知所有观察者
    }
}
```

运行结果如下：

```bash
lsy 购买了 🍊
per 购买了 🍊
zimu 购买了 🍊

Process finished with exit code 0
```

可见，使用观察者模式可以降低观察者和被观察者之间的耦合性，可以建立一套触发机制；当然，Java JDK 已经提供了 `Observer`、`Observable`，我们使用它们同样可以实现功能。

## RxJava的使用

通过上文的对观察者模式的理解之后，再来看看 **RxJava** 是如何使用的，它同样有如下几个角色，如下：

- Observable : 被观察者，也就是事件的发生者
- Observer：观察者，也就是事件的接受者
- subscribe：两者产生订阅关系

具体的使用如下：

```java
public class UseRxJava {

    public static void main(String[] args) {
        // 创建 Observable 被观察者
        Observable observable = Observable.create(new ObservableOnSubscribe<String>() {
            @Override
            public void subscribe(@NonNull ObservableEmitter<String> emitter) throws Throwable {
                emitter.onNext("🍊 到货了！");
                emitter.onNext("大家可以来买 🍊 了！");
                emitter.onError(new Throwable("🍊 又卖完了！"));
                emitter.onNext("WOW！🍊 卖光了");
                emitter.onComplete();
                emitter.onComplete();
                emitter.onNext("🍊 加急进货中...");
            }
        });

        // 创建 Observer 观察者
        Observer<String> observer = new Observer<String>() {
            @Override
            public void onSubscribe(@NonNull Disposable d) {
                System.out.println("onSubscribe:" + d.isDisposed());
            }

            @Override
            public void onNext(@NonNull String s) {
                System.out.println("onNext:" + s);
            }

            @Override
            public void onError(@NonNull Throwable e) {
                System.out.println("onError:" + e.getMessage());
            }

            @Override
            public void onComplete() {
                System.out.println("onComplete");
            }
        };
        // 关联订阅关系
        observable.subscribe(observer);
    }

}
```

运行结果，如下：

```bash
onSubscribe:false
onNext:🍊 到货了！
onNext:大家可以来买 🍊 了！
onError:🍊 又卖完了！

BUILD SUCCESSFUL in 328ms
```

通过简单的使用案例和运行结果，可知：

- `onNext()` 可以多次发送事件
- `onComplete()` 可以多次调用不会报错，但只执行一次
- `onError()` 只能发送一次，多次调用会报错，不可和 `onComplete()` 共存
- `onComplete()` 和 `onError()` 都存在时，只执行 `onError()`
- `onComplete()` 和 `onError()` 之后，观察者无法接收到发送事件
- `onSubscribe()` 是在订阅之后，发送事件之前执行

## RxJava的观察者模式与标准观察者模式

## RxJava编程思想

**RxJava** 是在 Java 上的响应式扩展，通过使用可观察序列，用于组成异步和基于事件编程的类库，也就是以响应式编程思维来进行编程的Java类库。

响应式编程是面向数据流的编程思想，在响应式编程思想下，一切皆数据流。响应式编程所侧重的是数据流的流动。

### 响应式编程案例

我们在理解响应式编程之前，先来使用我们传统的思想实现一个加载网络图片的案例：

```java
public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";
    private ImageView imageView;
    private final static String URL = "https://cdn.lishaoy.net/serializable/serializable.png";
    private final Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(@NonNull Message msg) {
            Log.i(TAG, "handleMessage: aaa");
            Bitmap bitmap = (Bitmap) msg.obj;
            imageView.setImageBitmap(bitmap);
            if (loading != null) loading.dismiss();
            return false;
        }
    });
    private ProgressDialog loading;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        imageView = findViewById(R.id.image_view);
    }

    public void loadImage(View view) {
        loading = ProgressDialog.show(this, "", "loading");
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    URL url = new URL(URL);
                    HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                    urlConnection.setConnectTimeout(6000);
                    int responseCode = urlConnection.getResponseCode();
                    if(responseCode == HttpURLConnection.HTTP_OK) {
                        InputStream inputStream = urlConnection.getInputStream();
                        Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
                        Message message = handler.obtainMessage();
                        message.obj = bitmap;
                        handler.sendMessage(message);
                    }
                } catch (MalformedURLException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }
}
```

如上，我们可能会用 `new Thread()` 和 `Handler` 来实现或者其他方法，每个人的实现方法可能都不同。如果，使用 **RxJava** 思想实现呢，必然实现方式要按照响应式编程数据流的编程思想，实现方式也就一致了。下面，我们再用 **RxJava** 来实现它，如下：

```java
public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";
    private ImageView imageView;
    private final static String URL = "https://cdn.lishaoy.net/image/112131.jpg";
    private ProgressDialog loading;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        imageView = findViewById(R.id.image_view);
    }

    public void rxJavaLoadImage(View view) {
        // Observable.just(URL) 创建被观察者
        Observable.just(URL)
                .map(new Function<String, Bitmap>() {
                    @Override
                    public Bitmap apply(String s) throws IOException {
                        URL url = new URL(URL);
                        HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                        urlConnection.setConnectTimeout(6000);
                        int responseCode = urlConnection.getResponseCode();
                        if (responseCode == HttpURLConnection.HTTP_OK) {
                            InputStream inputStream = urlConnection.getInputStream();
                            Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
                            return bitmap;
                        }
                        return null;
                    }
                })
                .subscribeOn(Schedulers.io()) // 上面的代码分配工作线程
                .observeOn(AndroidSchedulers.mainThread()) // 下面的代码分别UI线程
                // 链式调用 subscribe 绑定观察者
                .subscribe(new Observer<Bitmap>() {
                    // onSubscribe() 方法在发送事件之前执行
                    @Override
                    public void onSubscribe(Disposable d) {
                        loading = ProgressDialog.show(MainActivity.this, "", "loading");
                    }

                    // onNext() 在发送事件之后执行
                    @Override
                    public void onNext(Bitmap bitmap) {
                        imageView.setImageBitmap(bitmap);
                    }

                    @Override
                    public void onError(Throwable e) {
                        Log.e(TAG, "onError: " + e.getMessage(), e);
                    }

                    @Override
                    public void onComplete() {
                        if (loading != null) loading.dismiss();
                    }
                });
    }
}
```

运行结果如图：

<div style="width: 56%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/rxjava/load_image.png "")

</div>

**RxJava** 以链式调用，`Observable.just(URL)` 分发事件，`map()` 来加工数据流(可以使用多个map处理不同的业务)、`subscribeOn(Schedulers.io())` 切换工作线程、`observeOn(AndroidSchedulers.mainThread())` 切换主线程，数据流流向 `subscribe` 进行处理(下游的处理根据上游的数据流变化而变化)。

## RxJava与Retrofit(案例)

### 防抖

### 解决网络嵌套问题

