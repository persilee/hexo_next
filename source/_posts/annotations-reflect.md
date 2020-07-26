---
title: Android coder 需要理解的注解、反射和动态代理
tags:
  - Android
  - 注解
  - 反射
  - 动态代理
copyright: true
comments: true
date: 2020-07-25 00:33:01
categories: Java
top: 118
photos:
---

{% li https://cdn.lishaoy.net/generics/generics.png, Generics, Generics %}

注解我们经常使用它，很多框架也提供了很多注解给我们使用，如 `ARouter` 的 `@Route(path = "/test/activity")` 、`butterknife` 的 `@BindView(R.id.user) EditText username;` 等，但是，你有没有自定义过注解，写过自己的注解处理器呢？反射听起来很高大上，但是实际上你真的了解他之后，只是一些API的调用而已；动态代理其实只是在静态代理(代理模式)基础上使用了反射技术；本篇文章将带领大家对注解、反射及动态代理有更清晰的认知。

<hr />

<!-- more -->

## 注解

注解(Annotations)，元数据的一种形式，提供有关于程序但不属于程序本身的数据。注解对它们注解的代码的操作没有直接影响。

注解有多种用途，例如：

- 为编译器提供信息：编译器可以使用注解来检查错误或抑制警告
- 编译或部署时处理：可以生成代码、XML、文件等
- 运行时处理：注解可以在运行时检查

### 注解的格式

注解的格式如下：

```java
@Persilee
class MyClass { ... }
```

注解已 `@` 开头后面跟上内容，注解可以包含元素，例如：

```java
@Persilee(id=666, value = "lsy")
class MyClass { ... }
```

如果，只有一个 `value` 元素，则可以省略该名称，如果，没有元素，则可以省略括号，例如

```java
@Persilee("lsy") // 只有一个 value 元素
class MyClass { ... }

@Persilee // 没有元素
class MyClass { ... }
```

如果，注解有相同的类型，则是重复注解，如

```java
@Persilee("lsy")
@Persilee("zimu")
class MyClass { ... }
```

### 注解声明

注解的定义类似于接口的定义，在关键字 `interface` 前加上 `@`，如：

```java
@interface Persilee {
    int id();
    String value();
}
```

### 注解类型

`int id()` 和 `String value()` 是注解类型(annotation type)，它们也可以定义可选的默认值，如：

```java
@interface Persilee {
    int id();
    String value() default "lsy";
}
```

在使用注解时，如果定义的注解的注解类型没有默认值，则必须进行赋值，如：

```java
@Persilee(id = 666) // id 必须要赋值，如，@Persilee 会提示 id 必须赋值
class MyClass { ... }
```

### 元注解

在注解上面的注解称为元注解(meta-annotations)，如

```java
@Target({ElementType.TYPE, ElementType.METHOD})
@Retention(RetentionPolicy.SOURCE)
@interface Persilee {
    int id();
    String value() default "lsy";
}
```

在 `java.lang.annotation` 中定义了几种元注解类型(常使用的是 @Retention、@Target)，如

**@Retention** 指定注解的存储方式，我们由 `RetentionPolicy.java` (是一个枚举)可知，如：

```java
public enum RetentionPolicy {
    SOURCE, // 标记的注解仅保留在源级别中，并被编译器忽略。
    CLASS, // 标记的注解在编译时由编译器保留，但 Java 虚拟机(JVM)会忽略。
    RUNTIME // 标记的注解由 JVM 保留，因此运行时环境可以使用它。
}
```

**@Target** 指定注解可以使用的范围，我们由 `ElementType.java` (是一个枚举)可知使用范围，如下：

```java
public enum ElementType {
    TYPE, // 类
    FIELD, // 字段或属性
    METHOD, // 方法
    PARAMETER, // 参数
    CONSTRUCTOR, // 构造方法
    LOCAL_VARIABLE, // 局部变量
    ANNOTATION_TYPE, // 也可以使用在注解上
    PACKAGE, // 包
    TYPE_PARAMETER, // 类型参数
    TYPE_USE // 任何类型
}
```

对于 `TYPE_PARAMETER` (类型参数) 、 `TYPE_USE` (任何类型名称) 可能不是很好理解，如果把 `Target` 设置成 `@Target({ElementType.TYPE_PARAMETER})`，表示可以使用在泛型(上篇文章有介绍过[泛型](https://h.lishaoy.net/generics.html))的类型参数上，如：

```java
public class TypeParameterClass<@Persilee T> {
    public <@Persilee T> T foo(T t) {
        return null;
    }
}
```

如果把 `Target` 设置成 `@Target({ElementType.TYPE_USE})`，表示可以使用在任何类型上，如：

```java
TypeParameterClass<@Persilee String> typeParameterClass = new TypeParameterClass<>();
@Persilee String text = (@Persilee String)new Object();
```

**@Documented** 注解表示使用了指定的注解，将使用 Javadoc 工具记录这些元素。

**@Inherited** 注解表示注解类型可以从超类继承。

**@Repeatable** 注解表明标记的注解可以多次应用于同一声明或类型使用。

### 注解应用场景

根据 `@Retention` 元注解定义的存储方式，注解一般可以使用在以下3种场景中，如：

|  级别  |  技术   |    说明    |
|:-----|:------|:---------|
| 源码 | APT | 在编译期能获取注解与注解声明的类和类中所有成员信息，一般用于生成额外的辅助类。|
| 字节码 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  | 字节码增强 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 在编译出Class后，通过修改Class数据以实现修改代码逻辑目的，对于是否需要修改的区分或者修改为不同逻辑的判断可以使用注解。 |
| 运行时 |  反射  | 在程序运行时，通过反射技术动态获取注解与其元素，从而完成不同的逻辑判断。 |

### 小案例(使用注解实现语法检查)

我们定义一个 `weekDay` 字段，类型是 `WeekDay` 枚举类型，方便我们设置枚举中指定的值，如：

```java
class WeekDayDemo {

    private static WeekDay weekDay;

    enum WeekDay {
        SATURDAY,SUNDAY
    }

    public static WeekDay getWeekDay() {
        return weekDay;
    }

    public static void setWeekDay(WeekDay weekDay) {
        WeekDayDemo.weekDay = weekDay;
    }

    public static void main(String[] args) {
        setWeekDay(WeekDay.SATURDAY);
        System.out.println(getWeekDay());
    }
}
```

众所周知，在 Java 中枚举的实质是特殊的静态成员变量，在运行时候，所有的枚举会作为单例加载到内存中，非常消耗内存，那么，有没有什么优化的方案呢，在此，我们使用注解来取代枚举。

我们使用常量和 `@intDef` (语法检查)元注解去代替枚举，如：

```java
class IntdefDemo {

    private static final int SATURDAY = 0;
    private static final int SUNDAY = 1;

    private static int weekDay;

    @IntDef({SATURDAY, SUNDAY})
    @Target({ElementType.FIELD, ElementType.PARAMETER})
    @Retention(RetentionPolicy.SOURCE)
    @interface WeekDay { //自定义一个 WeekDay 注解

    }

    public static void setWeekDay(@WeekDay int weekDay) { // 使用 WeekDay 注解限制参数类型
        IntdefDemo.weekDay = weekDay;
    }

    public static void main(String[] args) {
        setWeekDay(SATURDAY); // 只能 传入 SATURDAY, SUNDAY
    }
}
```

### APT注解处理器

APT(Annotation Processor Tools) 注解处理器，用于处理注解，编写好的 Java 文件，需要经过 Javac 的编译，编译为虚拟机能够加载的字节码(Class)文件，注解处理器是 Javac 自带的一个工具，用来在编译时期处理注解信息。

上文中我们已自定义好了 `@Persilee` 注解，下面我们来编写一个简单的注解处理器来处理 `@Persilee` 注解，我们可以新建一个 Java 的 Module，创建一个 `PersileeProcessor` 的类，如：

```java
@SupportedAnnotationTypes("net.lishaoy.anreprdemo.Persilee")  //指定要处理的注解
public class PersileeProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> set, RoundEnvironment roundEnvironment) {
        Messager messager = processingEnv.getMessager(); //
        messager.printMessage(Diagnostic.Kind.NOTE, "APT working ...");
        for (TypeElement typeElement: set) {
            messager.printMessage(Diagnostic.Kind.NOTE,"===>" + typeElement.getQualifiedName());
            Set<? extends Element> elements = roundEnvironment.getElementsAnnotatedWith(typeElement);
            for (Element element: elements) {
                messager.printMessage(Diagnostic.Kind.NOTE,"===>" + element.getSimpleName());
            }
        }

        return false;
    }
}
```

然后，在 `main` 目录下新建 `resources` 目录，如图：

<div style="width: 86%; margin:auto">

![annotation](https://cdn.lishaoy.net/annotations-reflect/annotations1.png "annotation")

</div>

这个目录结构是规定死的，必须这样写，然后在 `javax.annotation.processing.Processor` 文件里注册需要处理的注解处理器，如

```java
net.lishaoy.aptlib.PersileeProcessor
```

最后，在 `app` 的 `build.gradle` 文件引入模块，如

```java
dependencies {
  ...

  annotationProcessor project(':aptlib')
}
```

在你 Build 工程时候，会在 `Task :app:compileDebugJavaWithJavac` 任务打印我们在注解处理程序的日志信息，如：

```bash
注: APT working ...
注: ===>net.lishaoy.anreprdemo.Persilee
注: ===>MainActivity
```

因为，我们只在 `MainActivity` 中使用了 `@Persilee` 注解，如下：

```java
@Persilee(id = 666, value = "lsy")
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);
    }
}
```

## 反射

一般情况下，我们使用某个类时必定知道它是什么类，用来做什么的。于是我们直接对这个类进行实例化，之后使用这个类对象进行操作。

```java
Cook cook = new Cook(); // 实例化一个对象，标准用法
cook.cookService("🍅");
```

反射是一开始并不知道初始化的类对象是什么，也不能使用 `new` 关键字来创建对象，反射是在运行的时才知道要操作的类是什么，并且可以在运行时获取类的完整构造，调用对应的方法。

Java 反射机制主要提供了以下功能:

- 在运行时构造任意一个类的对象
- 在运行时获取或修改任意一个类所具有的成员变量和方法
- 在运行时调用任意一个对象的方法(属性)

### Class类

Class是一个类，封装了当前对象所对应的类的信息，我们写的每一个类都可以看成一个对象，是 java.lang.Class 类的对象，Class是用来描述类的类。

### 获得Class对象

Class对象的获取有3种方式，如下：

- 通过类名获取 类名.class
- 通过对象获取 对象名.getClass()
- 通过全类名获取 Class.forName(全类名)

```java
Cook cook = new Cook();
Class cookClass = Cook.class;
Class cookClass1 = cook.getClass();
Class cookClass2 = Class.forName("net.lishaoy.reflectdemo.Cook");
```

### 创建实例

我们可以通过反射来生成对象的实例，如：

```java
Class cookClass = Cook.class;
Cook cook1 = (Cook) cookClass.newInstance();
```

### 获取构造器

获取构造器的方法有，如下：

- Constructor getConstructor(Class[] params)：获得使用特殊的参数类型的public构造函数(包括父类)
- Constructor[] getConstructors()：获得类的所有公共构造函数
- Constructor getDeclaredConstructor(Class[] params)：获得使用特定参数类型的构造函数(包括私有)
- Constructor[] getDeclaredConstructors()：获得类的所有构造函数(与接入级别无关)

我们来新建一个 `Person` ，以便我们的演示，如：

```java
public class Person {

    String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public Person() {
        super();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    private void privateMethod(){
        System.out.println("the private method!");
    }
}
```

很常规的一个类，里面有私有的属性和方法。

下面，我们新建一个 `GetConstructor` 的类来演示，获取构造器方法如何使用，如：

```java
class GetConstructor {

    public static void main(String[] args) throws
            ClassNotFoundException,
            NoSuchMethodException,
            IllegalAccessException,
            InvocationTargetException,
            InstantiationException {

        String className = "net.lishaoy.reflectdemo.entity.Person";
        Class<Person> personClass = (Class<Person>) Class.forName(className);

        //获取全部的constructor对象
        Constructor<?>[] constructors = personClass.getConstructors();
        for (Constructor<?> constructor: constructors) {
            System.out.println("获取全部的constructor对象: " + constructor);
        }

        //获取某一个constructor对象
        Constructor<Person> constructor = personClass.getConstructor(String.class, int.class);
        System.out.println("获取某一个constructor对象: " + constructor);

        //调用构造器的 newInstance() 方法创建对象
        Person person = constructor.newInstance("lsy", 66);
        System.out.println(person.getName() + ", " + person.getAge() );
    }

}
```

输出结果，如下：

```bash
获取全部的constructor对象: public net.lishaoy.reflectdemo.entity.Person(java.lang.String,int)
获取全部的constructor对象: public net.lishaoy.reflectdemo.entity.Person()
获取某一个constructor对象: public net.lishaoy.reflectdemo.entity.Person(java.lang.String,int)
lsy, 66
```

### 获取方法

获取方法的方法有，如下：

- Method getMethod(String name, Class[] params)：使用特定的参数类型，获得命名的公共方法
- Method[] getMethods()：获得类的所有公共方法
- Method getDeclaredMethod(String name, Class[] params)：使用特写的参数类型，获得类声明的命名的方法
- Method[] getDeclaredMethods()：获得类声明的所有方法

我们新创建一个 `GetMethod` 来演示如何来获取和调用方法，如：

```java
class GetMethod {

    public static void main(String[] args) throws 
            ClassNotFoundException, 
            NoSuchMethodException, 
            IllegalAccessException, 
            InstantiationException, 
            InvocationTargetException {

        Class<?> aClass = Class.forName("net.lishaoy.reflectdemo.entity.Person");

        //获取所有的public方法(包含从父类继承的方法)
        Method[] methods = aClass.getMethods();
        for (Method method: methods) {
            System.out.println("获取所有public方法： " + method.getName() + "()");
        }

        System.out.println("===========================");

        //获取所有方法(不包含父类方法)
        methods = aClass.getDeclaredMethods();
        for (Method method: methods) {
            System.out.println("获取所有方法: " + method.getName() + "()");
        }

        System.out.println("===========================");

        //获取指定的方法
        Method method = aClass.getDeclaredMethod("setAge", int.class);
        System.out.println("获取指定的方法:" + method);

        //调用方法
        Person person = (Person) aClass.newInstance();
        method.invoke(person, 66);
        System.out.println(person.getAge());

        //调用私有方法
        method = aClass.getDeclaredMethod("privateMethod");
        method.setAccessible(true); // 需要调用此方法并设置成 true
        method.invoke(person);

    }

}
```

运行结果，如下：

```bash
获取所有public方法： getName()
获取所有public方法： setName()
获取所有public方法： getAge()
获取所有public方法： setAge()
获取所有public方法： wait()
获取所有public方法： wait()
获取所有public方法： wait()
获取所有public方法： equals()
获取所有public方法： toString()
获取所有public方法： hashCode()
获取所有public方法： getClass()
获取所有public方法： notify()
获取所有public方法： notifyAll()
===========================
获取所有方法: getName()
获取所有方法: setName()
获取所有方法: getAge()
获取所有方法: setAge()
获取所有方法: privateMethod()
===========================
获取指定的方法:public void net.lishaoy.reflectdemo.entity.Person.setAge(int)
66
the private method!

BUILD SUCCESSFUL in 412ms
```


