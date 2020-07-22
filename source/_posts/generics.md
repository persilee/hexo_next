---
title: Android：写了这么多代码，你真的理解泛型吗
tags:
  - Java
  - Generics
  - 泛型
copyright: true
comments: true
date: 2020-07-22 00:05:35
categories: Java
top: 117
photos:
---

{% li https://cdn.lishaoy.net/generics/generics.png, Generics, Generics %}

在我们的实际工作中 **泛型(Generics)** 是无处不在的，我们也写过不少，看到的更多，如，源码、开源框架... 随处可见，但是，我们真正理解泛型吗？理解多少呢？例如：`Box` 、`Box<Object>` 、`Box<?>` 、`Box<T>` 、`Box<? extends T>` 、`Box<? super T>` 之间的区别是什么？本篇文章将会对 **泛型(Generics)** 进行全面的解析，让我们对泛型有更深入的理解。

<hr />

<!-- more -->

## Lucy 喜欢吃🍊（为什么要使用泛型）

首先，通过一个盘子装水果小故事来打开我们的泛型探索之旅（我们为什么要使用泛型），故事场景如下：

{% note info %} Lucy 到 James 家做客，James 需要招待客人，且知道 Lucy 喜欢吃橘子🍊，于是使用水果盘装满了🍊来招待客人 {% endnote %} 

这个场景怎么用代码表现呢，我们来新建几个类，如下：

Fruit：水果类

```java
package entity;

public class Fruit {

    @Override
    public String toString() {

        return "This is Fruit";
    }
}
```

Apple：苹果类，继承水果类

```java
package entity;

public class Apple extends Fruit {

    @Override
    public String toString() {

        return " Apple 🍎";
    }
}
```

Orange：橘子类，继承水果类

```java
package entity;

public class Orange extends Fruit {

    @Override
    public String toString() {

        return " Orange 🍊";
    }
}
```

Plate：水果盘接口

```java
package entity;

public interface Plate<T> {

    public void set(T t);

    public T get();

}
```

FruitPlate：水果盘类，实现水果盘接口

```java
package entity;

import java.util.ArrayList;
import java.util.List;

public class FruitPlate implements Plate {

    private List items = new ArrayList(6);

    @Override
    public void set(Object o) {
        items.add(o);
    }

    @Override
    public Fruit get() {
        int index = items.size() - 1;
        if(index >= 0) return (Fruit) items.get(index);
        return null;
    }

}
```

AiFruitPlate：智能水果盘，实现水果盘接口

```java
package entity;

import java.util.ArrayList;
import java.util.List;
/**
 * 使用泛型类定义
 * @param <T>
 */
public class AiFruitPlate<T> implements Plate<T> {

    private List<T> fruits = new ArrayList<T>(6);
    @Override
    public void set(T t) {
        fruits.add(t);
    }

    @Override
    public T get() {
        int index = fruits.size() - 1;
        if(index >= 0) return fruits.get(index);
        return null;
    }
}
```

Person：人类

```java
package entity;

public class Person {

}
```

Lucy：Lucy类，继承 Person 类

```java
import entity.Orange;
import entity.Person;

public class Lucy extends Person {

    public void eat(Orange orange) {

        System.out.println("Lucy like eat" + orange);

    }

}
```

James：James类，继承 Person 类

```java
import entity.*;

public class James extends Person {

    public FruitPlate getPlate() {
        return new FruitPlate();
    }

    public AiFruitPlate getAiFruitPlate() {
        return new AiFruitPlate();
    }

    public void addFruit(FruitPlate fruitPlate, Fruit fruit) {
        fruitPlate.set(fruit);
    }

    public void add(AiFruitPlate<Orange> aiFruitPlate, Orange orange) {
        aiFruitPlate.set(orange);
    }

}
```

Scenario：测试类

```java
import entity.*;

public class Scenario {

    public static void main(String[] args) {
        scenario1();
        scenario2();
    }
    //没有使用泛型
    private static void scenario1() {
        James james = new James();
        Lucy lucy = new Lucy();
        FruitPlate fruitPlate = james.getPlate(); // James 拿出水果盘
        james.addFruit(fruitPlate,new Orange()); // James 往水果盘里装橘子
        lucy.eat((Orange) fruitPlate.get());
    }
    //使用了泛型
    private static void scenario2() {
        James james = new James();
        Lucy lucy = new Lucy();
        AiFruitPlate<Orange> aiFruitPlate = james.getAiFruitPlate(); // James 拿出智能水果盘（知道你需要装橘子）
        james.add(aiFruitPlate, new Orange()); // James 往水果盘里装橘子（如果，装的不是橘子会提醒）
        lucy.eat(aiFruitPlate.get());
    }

}
```

运行结果，如下：

```bash
Lucy like eat  Orange 🍊
Lucy like eat  Orange 🍊

Process finished with exit code 0
```

我们可以很明显的看出，使用了泛型之后，不需要类型转换，如果，我们把 `scenario1()` 方法，稍微改下，如下：

```java
    private static void scenario1() {
        James james = new James();
        Lucy lucy = new Lucy();
        FruitPlate fruitPlate = james.getPlate();
        james.addFruit(fruitPlate,new Orange()); //new Orange() 改成 new Orange()
        lucy.eat((Orange) fruitPlate.get());
    }
```

编译器不会提示有问题，但是运行之后报错，如下：

```bash
Exception in thread "main" java.lang.ClassCastException: entity.Apple cannot be cast to entity.Orange
	at Scenario.scenario1(Scenario.java:21)
	at Scenario.main(Scenario.java:7)

Process finished with exit code 1
```

而，我们把 `scenario2()` （使用了泛型）做出同样的修改，如下：

```java
    private static void scenario2() {
        James james = new James();
        Lucy lucy = new Lucy();
        AiFruitPlate<Orange> aiFruitPlate = james.getAiFruitPlate();
        james.add(aiFruitPlate, new Apple());
        lucy.eat(aiFruitPlate.get());
    }
```

编译器，会提示我们有错误，如图：

<div style="width: 86%; margin:auto">

![error](https://cdn.lishaoy.net/generics/error.png "error")

</div>

通过以上案例，很清晰的知道我们为什么要使用泛型，如下：

- 消除类型转换
- 在编译时进行更强的类型检查
- 增加代码的复用性

## 泛型类(Generic Class)

泛型类是通过类型进行参数化的类，这样说可能不是很好理解，之后我们用代码演示。

### 简单类(A Simple Class)

首先，我们来定义一个简单的类，如下：

```java
package definegeneric;

public class SimpleClass {

    private Object object;

    public Object getObject() {
        return object;
    }

    public void setObject(Object object) {
        this.object = object;
    }
}
```

它的 `get` 、`set` 方法接受和返回一个 `Object`，所以，我们可以随意的传递任何类型。在编译时无法检查类型的使用，我们可以传入 `Integer` 且取出 `Integer`，也可以传入 `String` ，从而容易导致运行时错误。

### 泛型类(A Generic Class)

泛型类的定义格式如下：

```java
class name<T1,T2,...,Tn>{
  ...
}
```

在类名之后的 `<>` 尖括号，称之为类型参数(类型变量)，定义一个泛型类就是使用 `<>` 给它定义类型参数：T1、T2 ... Tn。

然后，我们把 `SimpleClass` 改成泛型类，如下：

```java
package definegeneric;

public class GenericClass<T> {

    private T t;

    public T getT() {
        return t;
    }

    public void setT(T t) {
        this.t = t;
    }
}
```