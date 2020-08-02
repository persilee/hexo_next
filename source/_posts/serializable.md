---
title: 解读Android中的序列化与Json解析
tags:
  - Java
  - Json
  - Serbalizable
copyright: true
comments: true
date: 2020-08-02 02:16:13
categories: Java
top: 120
photos:
---

{% li https://cdn.lishaoy.net/thread-concurrent/concurrent1.png, concurrent,concurrent %}

我们在日常工作中，网络数据传输最主流的的格式就是 `json`，我们常使用 **Gson** 开源框架来处理它，那么它们是如何工作的呢？本篇文章将解读 **Android** 中的序列化与 `json` 解析，如：Java 语言提供的 `Serializable`、Android 提供的 `Parceable`。

<hr />

<!-- more -->

## 序列化的定义及相关概念

在系统的底层，数据传输形式是字节序列形式传输，系统并不认识对象，只认识字节序列，那么我们如何进行进程间的通讯，我们需要先将数据序列化，就是将对象传化为字节序列；反序列化，当底层的字节序列传输到相应的进程时，就需要反序列化，就是字节序列转化为对象。

在进程间通讯、本地数据存储、网络数据传输都离不开序列化，对于不同的场景选择合适的序列化方案对应用的性能有着极大的影响。

### 序列化

数据结构或对象转换成二进制的过程，就是将数据结构或对象转换成可以存储或者传输的数据格式的过程。

### 反序列化

二进制串转换成数据结构或对象的过程，就是序列化生成的二进制串数据被还原成数据结构或对象的过程。

### 序列化和反序列化的目的

- 序列化：主要用于网络传输，数据持久化，一般序列化也称为编码(Encode)
- 反序列化：主要用于从网络，磁盘上读取字节数组还原成原始对象，一般反序列化也称为解码 (Decode)

## Serializable接口

`Serializable` 是 Java 提供的序列化接口，它非常简单，如下

```java
public interface Serializable {
}
```

`Serializable` 只是一个标记，用来被 `ObjectOutputStream` 序列化，被 `ObjectInputStream` 反序列化。

### Serializable的使用

我们先来新建一个 `Student` 类，代码如下：

```java
public class Student implements Serializable {

    private static final long serialVersionUID = 7911650650846382143L;
    private String name;
    private Integer age;
    private List<Course> courses;

    // 获取课程
    public List<Course> getCourses() {
        return courses;
    }
    // 新增课程
    public void addCourse(Course course) {
        this.courses.add(course);
    }

    // 用 transient 关键字标记的成员变量不参与序列化
    private transient Date createTime;
    // 静态成员变量属于类而不属于对象，也不参与序列化
    private static SimpleDateFormat dateFormat = new SimpleDateFormat();

    public Student(String name, Integer age) {
        this.name = name;
        this.age = age;
        courses = new ArrayList<>();
        createTime = new Date();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", courses=" + courses +
                ", createTime=" + createTime +
                '}';
    }
}
```

`Student` 类依赖于 `Course` 类，所以，我们再新建一个 `Course` 类，如下：

```java
public class Course implements Serializable {

    private static final long serialVersionUID = 7980496416494451794L;
    private String name;
    private float score;

    public Course(String name, float score) {
        this.name = name;
        this.score = score;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getScore() {
        return score;
    }

    public void setScore(float score) {
        this.score = score;
    }

    @Override
    public String toString() {
        return "Course{" +
                "name='" + name + '\'' +
                ", score=" + score +
                '}';
    }
}
```

我们再新建一个序列化的工具类，如下：

```java
public class SerializableUtil {

    private static String path = System.getProperty("user.dir") + "/serializable/src/main/java/net/lishaoy/serializable/serializable/out/student.out";

    public static synchronized boolean serializable(Object o) {
        if (o == null) {
            return false;
        }
        ObjectOutputStream outputStream = null;
        try {
            outputStream = new ObjectOutputStream(new FileOutputStream(path));
            outputStream.writeObject(o);
            outputStream.close();
            System.out.println("序列化成功！");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return false;
    }

    public static synchronized <T> T reverseSerializable() {
        ObjectInputStream inputStream = null;

        try {
            inputStream = new ObjectInputStream(new FileInputStream(path));
            Object object = inputStream.readObject();
            System.out.println("反序列化成功！\n"  + object);
            return (T) object;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (inputStream != null) {
                try {
                    inputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return null;
    }
}
```

我们使用 `SerializableUtil` 工具类，来序列化和反序列化我们的 `Student`，如下：

```java
public class UseSerializable {

    public static void main(String[] args) {
        Student student = new Student("lsy", 66);
        student.addCourse(new Course("英语",66));
        // 序列化
        SerializableUtil.serializable(student);
        // 反序列化
        SerializableUtil.reverseSerializable();
    }

}
```

运行结果，如下：

```bash
序列化成功！
反序列化成功！
Student{name='lsy', age=66, courses=[Course{name='英语', score=66.0}], createTime=null}
```

在使用 `Serializable` 时，可以发现以下几个特点：

- 需要现象 `Serializable` 的类，才可以序列化和反序列化
- 用 `transient` 关键字标记的成员变量不参与序列化
- 静态成员变量不参与序列化
- 一个实现序列化的类，它的子类也是可序列化的

### serialVersionUID与兼容性

**serialVersionUID的作用：** 用来表明类的不同版本间的兼容性。Java 序列化机制会通过判断类的 `serialVersionUID` 来验证版本一致性；在反序列化时，JVM 会把传来的字节流中的 `serialVersionUID` 与本地相应实体类的 `serialVersionUID` 进行比较。
**兼容性问题：** 为了在反序列化时，确保类版本的兼容性，最好在每个要序列化的类中加入 `private static final long serialVersionUID = XXX` 属性。如果不显式定义该属性，这个属 性值将由JVM根据类的相关信息计算，而修改后的类的计算 结果与修改前的类的计算结果往往不 同，从而造成对象的反序列化因为类版本不兼容而失败。

`serialVersionUID` 可以用 Android Studio 自动生成，如图：

<div style="width: 100%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/serializable/UID1.png "UID")

</div>

使用时按 <kbd>option</kbd> + <kbd>enter</kbd>，如图：

<div style="width: 66%; margin:auto">

![no-shadow](https://cdn.lishaoy.net/serializable/UID.png "UID")

</div>

### Externalizable接口

JDK 提供了 `Serializable` 接口外还提供了 `Externalizable` 接口，它继承了 `Serializable`，优先级高于 `Serializable`，源码如下：

```java
public interface Externalizable extends Serializable {
    void writeExternal(ObjectOutput var1) throws IOException;

    void readExternal(ObjectInput var1) throws IOException, ClassNotFoundException;
}
```

### Externalizable接口的使用

我们来看下简单的使用，代码如下：

```java
public class Course implements Externalizable {

    private static final long serialVersionUID = -342346458732794596L;
    private String name;
    private float score;

    public Course(){}

    public Course(String name, float score) {
        this.name = name;
        this.score = score;
        System.out.println("Course: " + "name " + name + " score " + score);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getScore() {
        return score;
    }

    public void setScore(float score) {
        this.score = score;
    }

    @Override
    public void writeExternal(ObjectOutput objectOutput) throws IOException {
        System.out.println("writeExternal ...");
        objectOutput.writeObject(name);
    }

    @Override
    public void readExternal(ObjectInput objectInput) throws IOException, ClassNotFoundException {
        System.out.println("readExternal ...");
        name = (String) objectInput.readObject();
    }

    @Override
    public String toString() {
        return "Course{" +
                "name='" + name + '\'' +
                ", score=" + score +
                '}';
    }

    public static void main(String[] args) throws IOException, ClassNotFoundException {
        Course course = new Course("数学",66);
        // 序列化
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream outputStream = new ObjectOutputStream(byteArrayOutputStream);
        outputStream.writeObject(course);
        byte[] bytes = byteArrayOutputStream.toByteArray();
        outputStream.close();

        // 反序列化
        ObjectInputStream inputStream = new ObjectInputStream(new ByteArrayInputStream(bytes));
        System.out.println((Course)inputStream.readObject());

    }
}
```

运行结果如下：

```bash
Course: name 数学 score 66.0
writeExternal ...
readExternal ...
Course{name='数学', score=0.0}

BUILD SUCCESSFUL in 576ms
```

可以看到，在序列化时会调用 `writeExternal` 方法，反序列化时会调用 `readExternal` 方法，也就是说我们可以灵活的控制想序列化的字段。

`Externalizable` 接口，在反序列化时，需要写默认的空构造函数，否则报错：`InvalidClassException`。

### 使用Serializable的注意点

#### 多引用写入

**多引用写入** 问题，我们来看如下代码：

```java
public static void main(String[] args) throws IOException, ClassNotFoundException {
    Course course = new Course("数学",66);
    // 序列化
    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
    ObjectOutputStream outputStream = new ObjectOutputStream(byteArrayOutputStream);
    outputStream.writeObject(course);
    course.setName("英语");
    outputStream.writeObject(course);
    byte[] bytes = byteArrayOutputStream.toByteArray();
    outputStream.close();

    // 反序列化
    ObjectInputStream inputStream = new ObjectInputStream(new ByteArrayInputStream(bytes));
    Course course1 = (Course) inputStream.readObject();
    Course course2 = (Course) inputStream.readObject();
    System.out.println(course1);
    System.out.println(course2);
}
```

运行结果如下：

```bash
Course: name 数学 score 66.0
writeExternal ...
readExternal ...
Course{name='数学', score=0.0}
Course{name='数学', score=0.0}

BUILD SUCCESSFUL in 557ms
```

我们 `course.setName("英语");` 把 `name` 修改后，重新 `outputStream.writeObject(course);` 但是结果并没有改变。这个就是多引用问题：对于一个实例的多个引用，为了节省空间，只会写入一次。

我们可以使用 `outputStream.reset();` 来解决问题。

#### 子类实现 Serializable，而父类没有实现 Serializable

**子类实现 Serializable，而父类没有实现 Serializable** 问题，我们新建一个 `Person` 类，代码如下：

```java
public class Person {
    private String name;

    public Person(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                '}';
    }
}
```

让 `Student` 类继承它，代码如下：

```java
public class Student extends Person implements Serializable {

    ...

    public Student(String name, Integer age) {
        super(name);
        this.name = name;
        this.age = age;
        courses = new ArrayList<>();
        createTime = new Date();
        System.out.println("Student: name:" + name + " age:" + age + " createTime:" + createTime);
    }

    ...

}
```

运行结果如下：

```bash
java.io.InvalidClassException: net.lishaoy.serializable.serializable.Student; no valid constructor
...
```

提示我们没有构造函数，我们需要在父类 `Person` 加入无参的构造函数，如下：

```java
public class Person {
    private String name;
    // 加入无参构造函数
    public Person(){}

    public Person(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                '}';
    }
}
```

#### 单例模式的序列化

序列化会导致单例失效，就是序列化前后会产生多个对象，代码如下：

```java
public class Single {

    public static class SingleClass implements Serializable {

        private static final long serialVersionUID = 9153534024695280942L;
        private static boolean flag = false;

        private static SingleClass singleClass;

        public static SingleClass getInstance() {

            if(singleClass == null) {
                synchronized (SingleClass.class) {
                    if (singleClass == null) {
                        singleClass = new SingleClass();
                    }
                }
            }

            return singleClass;
        }

        private SingleClass() {
            if (!flag) flag = true; else throw new RuntimeException("单例模式被侵犯！");
        }
    }

    public static void main(String[] args) {
        SingleClass singleClass = SingleClass.getInstance();
        // 序列化
        SerializableUtil.serializable(singleClass);
        // 反序列化
        SingleClass singleClass1 = SerializableUtil.reverseSerializable();
        System.out.println("序列化之前：" + singleClass.hashCode());
        System.out.println("序列化之后："+ singleClass1.hashCode());
    }

}
```

运行结果，如下：

```bash
序列化成功！
反序列化成功！
net.lishaoy.serializable.serializable.Single$SingleClass@41629346
序列化之前：1442407170
序列化之后：1096979270

BUILD SUCCESSFUL in 621ms
```


## Parcelable接口

## Parcelable与Serializable的性能比较