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

### 普通类(A Simple Class)

首先，我们来定义一个普通的类，如下：

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

所以的 `object` 都替换成为 `T`，类型参数可以定义为任何的费基本类型，如：class类型、interface类型、数组类型、甚至是另一个类型参数。


### 调用和实例化泛型类型(nvoking and Instantiating a Generic Type)

要想使用泛型类，必须执行泛型类调用，如：

```java
GenericClass<String> genericClass;
```

泛型类的调用类似于方法的调用(传递了一个参数)，但是，我们没有将参数传递给方法，而是，将类型参数(String)传递给了 `GenericClass` 类本身。

此代码不会创建新的 `GenericClass` 对象，它只是声明了 `genericClass` 将保存对 `String` 的引用

要实例化此类，要使用 `new` 关键字，如：

```java
GenericClass<String> genericClass = new GenericClass<String>();
```

或者

```java
GenericClass<String> genericClass = new GenericClass<>();
```
在 Java SE 7 或更高的版本中，编译器可以从上下文推断出类型参数，因此，可以使用 `<>` 替换泛型类的构造函数所需的类型参数

### 类型参数命名规范(Type Parameter Naming Conventions)

我们的类型参数是否一定要写成 `T` 呢，按照规范，类型参数名称是单个大写字母。

常用的类型参数名称有，如：

| 类型参数 |  含义     |
|:------:| :-------: |
| E      |  Element |
| K      |  Key     |
| N      |  Number  |
| V      |  Value   |
| S,U,V...  |  2nd, 3rd, 4th type   |

### 多类型参数(Multiple Type Parameters)

泛型类可以有多个类型参数，如：

```java
public interface MultipleGeneric<K,V> {
    public K getKey();
    public V getValue();
}

public class ImplMultipleGeneric<K, V> implements MultipleGeneric<K, V> {

    private K key;
    private V value;

    public ImplMultipleGeneric(K key, V value) {
        this.key = key;
        this.value = value;
    }

    @Override
    public K getKey() {
        return key;
    }

    @Override
    public V getValue() {
        return value;
    }

    public static void main(String[] args) {
        MultipleGeneric<String, Integer> m1 = new ImplMultipleGeneric<String, Integer>("per",6);
        System.out.println("key:" + m1.getKey() + ", value:" + m1.getValue());

        MultipleGeneric<String,String> m2 = new ImplMultipleGeneric<String, String>("per","lsy");
        System.out.println("key:" + m2.getKey() + ", value:" + m2.getValue());
    }
}
```

输出结果：

```bash
key:per, value:6
key:per, value:lsy

Process finished with exit code 0
```

如上代码，`new ImplMultipleGeneric` 将 `K` 实例化为 `String`，将 `V` 实例化为 `Integer` ，因此， `ImplMultipleGeneric` 构造函数参数类型分别为 `String` 和 `Integer`,在编写 `new ImplMultipleGeneric` 代码时，编辑器会自动填写 `<>` 的值

由于，Java 编译器会从声明 `ImplMultipleGeneric` 推断出 `K` 和 `V` 的类型，以此我们可以简写为，如下：

```java
MultipleGeneric<String, Integer> m1 = new ImplMultipleGeneric<>("per",6);
System.out.println("key:" + m1.getKey() + ", value:" + m1.getValue());

MultipleGeneric<String,String> m2 = new ImplMultipleGeneric<>("per","lsy");
System.out.println("key:" + m2.getKey() + ", value:" + m2.getValue());
```

## 泛型接口(Generic Interface)

定义泛型接口和定义泛型类相似(泛型类的技术可同用于泛型接口)，如下：

```java
interface name<T1,T2,...,Tn>{
  ...
}
```

我们来定义一个泛型接口，如下：

```java
package definegeneric;

public interface Genertor<T> {
    public T next();
}
```

那么，如何实现一个泛型接口呢，我们使用两种方式来实现泛型接口，如下：

使用泛型类，实现泛型接口，且不指定确切的类型参数，所以，实现的 `next()` 返回值自动变成 `T`

```java
package definegeneric.impl;

import definegeneric.Genertor;

public class ImplGenertor<T> implements Genertor<T> {

    @Override
    public T next() {
        return null;
    }
}
```

使用普通类，实现泛型接口，且指定确切的类型参数为 `String`，所以，实现的 `next()` 返回值自动变成 `String`

```java
package definegeneric.impl;

import definegeneric.Genertor;

public class ImplGenertor2 implements Genertor<String> {

    @Override
    public String next() {
        return null;
    }
}
```

## 泛型方法(Generic Methods)

泛型方法使用了类型参数的方法，泛型方法比较独立，可以声明在 普通类、泛型类、普通接口、泛型接口中。

泛型方法定义格式，如下：

```java
public <K, V> boolean compare(Pair<K, V> p1, Pair<K, V> pw)
```

泛型方法的类型参数列表，在 `<>` 内，该列表必须在方法返回类型之前；对于静态的泛型方法，类型参数必须在 `static` 之后，方法返回类型之前。

### 普通类里定义泛型方法(Generic methods in a Simple Class)

我们在普通类中定义泛型方法，如下：

```java
package methodgeneric;

public class MethodGeneric {

    //定义一个泛型方法
    public <T> T genericMethod(T...t) {
        return t[t.length/2];
    }

    public static void main(String[] args) {
        MethodGeneric methodGeneric = new MethodGeneric();
        System.out.println(methodGeneric.<String>genericMethod("java","dart","kotlin"));
    }
}
```

`methodGeneric.<String>genericMethod("java","dart","kotlin")` 通常可以省略掉 `<>` 的内容，编译器将推断出所需的类型，和调用普通方法一样，如：

```java
methodGeneric.genericMethod("java","dart","kotlin")
```

### 泛型类里定义泛型方法(Generic methods in a Generic Class)

我们在泛型类中定义泛型方法，如下：

```java
package methodgeneric;

public class MethodGeneric2 {

    static class Fruit{

        @Override
        public String toString() {
            return "fruit";
        }
    }

    static class Apple extends Fruit {

        @Override
        public String toString() {
            return "Apple";
        }
    }

    static class Person{

        @Override
        public String toString() {
            return "person";
        }
    }

    static class ShowClass<T> {
        //定义了普通类
        public void show1(T t){
            System.out.println(t.toString());
        }
        //定义了泛型类
        public <E> void show2(E e) {
            System.out.println(e.toString());
        }
        //定义了泛型类
        public <T> void show3(T t) {
            System.out.println(t.toString());
        }
    }

    public static void main(String[] args) {

        Apple apple = new Apple();
        Person person = new Person();

        ShowClass<Fruit> showClass = new ShowClass<>();
        showClass.show1(apple);   //可以放入 apple，因为 apple 是 fruit 的子类
        showClass.show1(person); //此时，编译器会报错，因为 ShowClass<Fruit> 已经限定类型

        showClass.show2(apple); //可以放入，泛型方法 <E> 可以是任何类型
        showClass.show2(person);//可以放入，泛型方法 <E> 可以是任何类型

        showClass.show3(apple); //可以放入，泛型方法 <T> 和泛型类中的 <T> 不是同一条 T，可以是任何类型
        showClass.show3(person); //可以放入，泛型方法 <T> 和泛型类中的 <T> 不是同一条 T，可以是任何类型
    }
}
```

在泛型类中定义泛型方法时，需要注意，泛型类里的泛型参数 `<T>` 和泛型方法里的泛型参数 `<T>` 不是同一个。

## 限定类型参数(Bounded Type Parameters)

我们经常看到类似 `public <U extends Number> void inspect(U u)` 的代码，`<U extends Number>` 就是限制类型参数，只对数字进行操作且只接受 `Number` 或其子类。

要声明一个限定的类型参数，需要在参数类型后加上 `extends` 关键字，然后是其上限类型(类或接口)。

### 限定类型参数的泛型类(Generic Class of Bounded Type Parameters)

泛型类也可以使用限定类型参数，如下：

```java
package boundedgeneric;

public class BoundedClass<T extends Comparable> {

    private T t;

    public void setT(T t) {
        this.t = t;
    }

    public T min(T outter){
        if(this.t.compareTo(outter) > 0)
            return outter;
        else
            return this.t;
    }

    public static void main(String[] args) {
        BoundedClass<String> boundedClass = new BoundedClass<>(); //只能传入实现了 Comparable 接口的类型
        boundedClass.setT("iOS");
        System.out.println(boundedClass.min("android"));
    }
}
```

### 限定类型参数的泛型方法(Generic methods of Bounded Type Parameters)

泛型方法也可以使用限定类型参数，如下：

```java
package boundedgeneric;

public class BoundedGeneric {

    public static <T extends Comparable> T min(T a, T b) {
        if (a.compareTo(b) < 0)
            return a;
        else
            return b;
    }

    public static void main(String[] args) {
        System.out.println(BoundedGeneric.min(66,666));
    }
}
```

### 多重限定(Multiple Bounds)

限定类型参数，也可以为多个限定，如：

```java
<T extends B1 & B2 & B3>
```

多个限定参数，如果其中有类，类必须放在第一个位置，例如：

```java
interface A { ... }
interface B { ... }
class C { ... }

class D <T extends C & A & B>
```

## 泛型，继承和子类型(Generics, Inheritance, and Subtypes)

在前面的盘子装水果小故事里我们已经创建好了一些水果类，如下：

```java
public class Fruit {
    @Override
    public String toString() {
        return "This is Fruit";
    }
}

public class Apple extends Fruit {
    @Override
    public String toString() {
        return " Apple 🍎";
    }
}

public class Orange extends Fruit {
    @Override
    public String toString() {
        return " Orange 🍊";
    }
}

public class QIOrange extends Orange {
    @Override
    public String toString() {
        return "qi Orange 🍊";
    }
}
```

他们的继承关系，如图：

<div style="width: 56%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/generics/fruit.png "")

</div>

众所周知，我们可以把子类赋值给父类，例如：

```java
Apple apple = new Apple();
Fruit fruit = new Fruit();
fruit = apple;
```

泛型也是如此，我们定义一个水果盘子的泛型类，如下：

```java
public class FruitPlateGen<Fruit> implements Plate<Fruit> {

    private List<Fruit> fruits = new ArrayList<>(6);

    @Override
    public void set(Fruit fruit) {
        fruits.add(fruit);
    }

    @Override
    public Fruit get() {
        int index = fruits.size() - 1;
        if(index >= 0) return fruits.get(index);
        return null;
    }
}
```

所以，是 `Fruit` 的子类都可以放入水果盘里，如下：

```java
FruitPlateGen<Fruit> fruitPlate = new FruitPlateGen<Fruit>();
fruitPlate.set(new Apple());
fruitPlate.set(new Orange());
```

现在，James 可以获取盘子，如下：

```java
public class James extends Person {
    public FruitPlateGen getAiFruitPlateGen(FruitPlateGen<Fruit> plate) {
        return new FruitPlateGen();
    }
}
```

如是，James 想获取放橘子的盘子，如下：

```java
James james = new James();
james.getAiFruitPlateGen(new FruitPlateGen<Fruit>()); //获取成功
james.getAiFruitPlateGen(new FruitPlateGen<Orange>()); //编译器报错
```

虽然，`Orange` 是 `Fruit` 的子类，但是，`FruitPlateGen<Orange>` 不是 `FruitPlateGen<Fruit>` 的子类，所以，不能传递产生继承关系。

<div style="width: 86%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/generics/object.png "")

</div>

### 泛型类和子类型(Generic Classes and Subtyping)

我们可以通过继承(extends)或实现(implements)泛型类或接口，例如：

```java
private static class ExtendFruitPlate<Orange> extends FruitPlateGen<Fruit> {

}
```

此时，`ExtendFruitPlate<Orange>` 就是 `FruitPlateGen<Fruit>` 的子类，James 再去拿盘子，就不会有错误提示：

```java
james.getAiFruitPlateGen(new ExtendFruitPlate<Orange>());
```

## 通配符(Wildcards)

我们经常看到类似 `List<? extends Number>` 的代码，`?` 就是通配符，表示未知类型。

### 上限通配符(Upper Bounded Wildcards)

我们可以使用上限通配符来放宽对变量的限制，例如，上文提到的 `FruitPlateGen<Fruit>` 和 `FruitPlateGen<Orange>()` 就可以使用上限通配符。

我们来改写一下 `getAiFruitPlateGen` 方法，如下：

```java
public FruitPlateGen getAiFruitPlateGen2(FruitPlateGen<? extends Fruit> plate) {
    return new FruitPlateGen();
}
```

这时候，James 想获取放橘子的盘子，如下：

```java
James james = new James();
james.getAiFruitPlateGen2(new FruitPlateGen<Fruit>()); //获取成功
james.getAiFruitPlateGen2(new FruitPlateGen<Orange>()); //获取成功
```

上限通配符 `FruitPlateGen<? extends Fruit>` 匹配 `Fruit` 和 `Fruit` 的任何子类型，所以，我们可以传入 `Apple`、`Orange` 都没有问题。

### 下限通配符(Lower Bounded Wildcards)

上限通配符将未知类型限定为该类型或其子类型，使用 `extends` 关键字，而下限通配符将未知类型限定为该类型或其父类型，使用 `super` 关键字。

我们再来宽展一下 `getAiFruitPlateGen` 方法，如下：

```java
public FruitPlateGen getAiFruitPlateGen3(FruitPlateGen<? super Apple> plate) {
    return new FruitPlateGen();
}
```

这时候，James 只能获取 `FruitPlateGen<Fruit>` 和 `FruitPlateGen<Apple>` 的盘子，如下：

```java
James james = new James();
james.getAiFruitPlateGen3(new FruitPlateGen<Apple>());
james.getAiFruitPlateGen3(new FruitPlateGen<Fruit>());
```

下限通配符 `FruitPlateGen<? super Apple>` 匹配 `Apple` 和 `Apple` 的任何父类型，所以，我们可以传入 `Apple`、`Fruit`。

### 通配符和子类型(Wildcards and Subtyping)

在 [泛型，继承和子类型](http://h.lishaoy.net/generics.html#%E6%B3%9B%E5%9E%8B%EF%BC%8C%E7%BB%A7%E6%89%BF%E5%92%8C-%E5%AD%90%E7%B1%BB%E5%9E%8B-Generics-Inheritance-and-Subtypes) 章节有讲到，虽然，`Orange` 是 `Fruit` 的子类，但是，`FruitPlateGen<Orange>` 不是 `FruitPlateGen<Fruit>` 的子类。但是，你可以使用通配符在泛型类或接口之间创建关系。

我们再来回顾下 `Fruit` 的继承关系，如图：

<div style="width: 56%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/generics/fruit.png "")

</div>

代码，如下：

```java
Apple apple = new Apple();
Fruit fruit = apple;
```

这个代码是没有问题的，`Fruit` 是 `Apple` 的父类，所以，可以把子类赋值给父类。

代码如下：

```java
List<Apple> apples = new ArrayList<>();
List<Fruit> fruits = apples; // 编辑器报错
```

因为，`List<Apple>` 不是 `List<Fruit>` 的子类，实际上这两者无关，那么，它们的关系是什么？如图：

<div style="width: 56%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/generics/List%3C%3F%3E.png "")

</div>

`List<Apple>` 和 `List<Fruit>` 的公共父级是 `List<?>`。

我们可以使用上下限通配符，在这些类之间创建关系，如下：

```java
List<Apple> apples = new ArrayList<>();
List<? extends Fruit> fruits1 = apples; // OK
List<? super Apple> fruits2 = apples; // OK
```

下图展示了上下限通配符声明的几个类的关系，如图：

<div style="width: 56%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/generics/List%3C%3F%3E1.png "")

</div>


## 类型擦除(Type Erasure)

Java 语言使用类型擦除机制实现了泛型，类型擦除机制，如下：

- 编译器会把所有的类型参数替换为其边界(上下限)或 Object，因此，编译出的字节码中只包含普通类、接口和方法。
- 在必要时插入类型转换，已保持类型安全
- 生成桥接方法以在扩展泛型类时保持多态性

### 泛型类型的擦除(Erasure of Generic Types)

Java 编译器在擦除过程中，会擦除所有类型参数，如果类型参数是有界的，则替换为第一个边界，如果是无界的，则替换为 Object。

我们定义了一个泛型类，代码如下：

```java
public class Node<T> {
  private T data;
  private Node<T> next;
  public Node(T data, Node<T> next) { this.data = data;
  this.next = next;
}
  public T getData() { return data; }
  ...
}
```

由于类型参数 `T` 是无界的，因此，Java 编译器将其替换为 Object，如下：

```java
public class Node {
  private Object data;
  private Node next;
  public Node(Object data, Node next) { this.data = data;
  this.next = next;
}
  public Object getData() { return data; }
  ...
}
```

我们再来定义一个有界的泛型类，代码如下：

```java
public class Node<T extends Comparable<T>> {
  private T data;
  private Node<T> next;
  public Node(T data, Node<T> next) { this.data = data;
  this.next = next;
}
  public T getData() { return data; }
  ...
}
```

Java 编译器其替换为第一个边界 `Comparable`，如下：

```java
public class Node {
  private Comparable data;
  private Node next;
  public Node(Comparable data, Node next) { this.data = data;
  this.next = next;
}
  public Comparable getData() { return data; }
  ...
}
```

### 泛型方法的擦除(Erasure of Generic Methods)

Java 编译器同样会擦除泛型方法中的类型参数，例如：

```java
public static <T> int count(T[] anArray, T elem) {
  int cnt = 0;
  for (T e : anArray)
}
```

由于 `T` 是无界的，因此，Java 编译器将其替换为 Object，如下：

```java
public static int count(Object[] anArray, Object elem) {
  int cnt = 0;
  for (Object e : anArray) if (e.equals(elem))
}
```

如下代码：

```java
class Shape {  ...  }
class Circle extends Shape {  ...  } 
class Rectangle extends Shape {  ...  }
```

有一个泛型方法，如下：

```java
public static<T extends Shape> void draw(T shape){
  ...
}
```

Java 编译器将用第一个边界 `Shape` 替换 `T`，如下：

```java
public static void draw(Shape shape){
  ...
}
```

### 桥接方法(Bridge Methods)

有时类型擦除会导致无法预料的情况，如下：

```java
public class Node<T> {
  public T data;
  public Node(T data) { this.data = data; }
  public void setData(T data) { 
    System.out.println("Node.setData"); 
    this.data = data;
  } 
}
public class MyNode extends Node<Integer> {
  public MyNode(Integer data) { super(data); }
  public void setData(Integer data) { 
    System.out.println("MyNode.setData"); 
    super.setData(data);
  } 
}
```

类型擦除后，代码如下：

```java
public class Node {
  public Object data;
  public Node(Object data) { this.data = data; }
  public void setData(Object data) { 
    System.out.println("Node.setData"); 
    this.data = data;
  } 
}
public class MyNode extends Node {
  public MyNode(Integer data) { super(data); }
  public void setData(Integer data) { 
    System.out.println("MyNode.setData");
    super.setData(data);
  } 
}
```

此时，Node 的方法变为 `setData(Object data)` 和 MyNode 的 `setData(Integer data)` 不会覆盖。

为了解决此问题并保留泛型类型的多态性，Java 编译器会生成一个桥接方法，如下：

```java
class MyNode extends Node {
  // 生成的桥接方法
  public void setData(Object data) {
      setData((Integer) data);
  }
  public void setData(Integer data) { 
    System.out.println("MyNode.setData"); 
    super.setData(data);
  }
  ...
}
```

这样 Node 的方法 `setData(Object data)` 和 MyNode 生成的桥接方法 `setData(Object data)` 可以完成方法的覆盖。


## 泛型的限制(Restrictions on Generics)

为了有效的使用泛型，需要考虑以下限制：

- 无法实例化具有基本类型的泛型类型
- 无法创建类型参数的实例
- 无法声明类型为类型参数的静态字段
- 无法将Casts或instanceof与参数化类型一起使用
- 无法创建参数化类型的数组
- 无法创建，捕获或抛出参数化类型的对象
- 无法重载每个重载的形式参数类型都擦除为相同原始类型的方法

### 无法实例化具有基本类型的泛型类型

代码如下：

```java
class Pair<K, V> {
  private K key;
  private V value;
  public Pair(K key, V value) { 
    this.key = key;
    this.value = value; 
  }
  ...
}
```

创建对象时，不能使用基本类型替换参数类型：

```java
Pair<int, char> p = new Pair<>(8, 'a'); // error
```

### 无法创建类型参数的实例

代码如下：

```java
public static <E> void append(List<E> list) {
   E elem = new E(); // error 
   list.add(elem);
}
```

### 无法声明类型为类型参数的静态字段

代码如下：

```java
public class MobileDevice<T> {
  private static T os; // error
  ...
}
```

类的静态字段是所有非静态对象共享的变量，因此，不允许使用类型参数的静态字段。

### 无法将Casts或instanceof与参数化类型一起使用

代码如下：

```java
public static <E> void rtti(List<E> list) {
  if (list instanceof ArrayList<Integer>) { // error
    ...
  } 
}
```

Java 编译器会擦除所有类型参数，所有，无法验证在运行时使用的参数化类型。

### 无法创建参数化类型的数组

代码如下：

```java
List<Integer>[] arrayOfLists = new List<Integer>[2]; // error
```

### 无法创建，捕获或抛出参数化类型的对象

代码如下：

```java
class MathException<T> extends Exception {  ...  } // error
class QueueFullException<T> extends Throwable{ ... } // error
```

### 无法重载每个重载的形式参数类型都 擦除为相同原始类型的方法

代码如下：

```java
public class Example {
  public void print(Set<String> strSet) { }
  public void print(Set<Integer> intSet) { }
}
```

`print(Set<String> strSet)` 和 `print(Set<Integer> intSet)` 在类型擦除后是完全相同的类型，所以，无法重载。