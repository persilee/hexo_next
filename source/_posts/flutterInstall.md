---
title: Flutter：手拉手带你极速构建漂亮的跨平台(iOS/Android)移动应用 ✿ 环境搭建
tags:
  - Flutter
  - iOS
  - Android
  - Dart
copyright: true
comments: true
date: 2018-11-08 10:22:29
categories: Dart
top: 109
photos:
---

{% li https://cdn.lishaoy.net/flutterInstall/flutterCover8.png, Flutter, Flutter %}

上篇文章带大家认识了 `Flutter` ，想必大家已迫不及待的想练练手，所以要行动起来，现在这篇文章就带您搭建一个 `Flutter` 运行及开发环境。

<hr />

<!-- more -->

## 安装 Flutter SDK

想要在本地电脑上运行 **Flutter** ，需要安装 **Flutter SDK** 才可以运行， **SDK** 里面有一些用于创建、构建、测试和编译应用程序的命令行工具等，这些在开发的时候会用到。

首先，我们有 2 种方法获取 **SDK**

- 可以到 [下载 Flutter SDK ](https://flutter.io/docs/development/tools/sdk/archive#macos) 本地电脑
- 可以用 `git clone` 命令下载到本地电脑

```bash
git clone -b master https://github.com/flutter/flutter.git
```

其次，把下载下来的 **Flutter SDK** 解压，放到系统的某个目录，比如我是放到： `/Applications/flutter` ，如图：

![no-shadow](https://cdn.lishaoy.net/flutterInstall/flutterSDK.png "Flutter SDK")

## 配置环境变量

配置环境变量的目的是为了让 **Flutter SDK** 命令行工具在全局范围都起作用，以便开发使用。

首先，您可以用编辑器打开主目录下的 `.bash_profile`，或者用 `vi` 命令编辑，我习惯用 `vi` 命令，如下

```bash
vi $HOME/.bash_profile
```

新增以下配置

```
export PATH=$PATH:/Applications/flutter/bin
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```
{% note warning %} 
**Tips：** <br/>
第一行 `export PATH=$PATH:/Applications/flutter/bin` 中的 `/Applications/flutter/bin` 就是刚才下载的 **Flutter SDK** 解压后放在本地电脑的目录，您要根据自己操作更改为自己电脑对应的目录。<br/>
第二、三行为解决国内下载或更新资源慢的国内镜像，配置这个下载或更新资源会快一些。
{% endnote %}  

再执行 `source $HOME/.bash_profile` 命令刷新当前命令行窗口，或者关掉当前命令行窗口重新打开，效果一样

```bash
source $HOME/.bash_profile
```

再执行 `flutter --help`，来测试环境变量是否配置成功，如图：

![no-shadow](https://cdn.lishaoy.net/flutterSDK3.png "flutter help")

{% note warning %} 
**Tips：** 如果你使用的是 `zsh`，需要在 ~/.zshrc 文件中添加：`source ~/.bash_profile` ，否则 `flutter` 命令将无法运行。
{% endnote %} 

## 配置 iOS 开发环境

想用 **Flutter** 为 iOS 平台开发应用，需要安装 Xcode，我们可以去苹果应用商店下载。

安装好 Xcode 后，你需要打开一次 Xcode 同意许可协议（会提示），或者执行 `sudo xcodebuild -license` 同意许可协议。

然后执行 `open -a Simulator` 命令，就可以打开一个模拟器，来运行和测试 **Flutter** 程序，如图

![no-shadow](https://cdn.lishaoy.net/flutterInstall/Simulator2.png "Simulator" )

## 配置 Android 开发环境

想用 **Flutter** 为 Android 平台开发应用，需要下载安装 [Android Studio](https://developer.android.com/studio/)。

安装好 Android Studio 后，启动它，首次启动会安装最新的 **Android SDK** ，但是你可能会遇到这样的问题，如图：

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio.png" alt="Android Studio" width="50%" title="Android Studio" align="center" />

如果遇到这个问题应该就是网络问题（需要科学上网），**Setup Proxy** 来设置代理，如图：

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio1.png" alt="Android Studio" width="50%" title="Android Studio" align="center" />

如一切正常，就会提示你需要下载一些东西，如图

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio2.png" alt="Android Studio" width="85%" title="Android Studio" align="center" />

点击 Finish 按钮后就会下载安装以上列表的东西,下载安装完 SDK 后，如图：

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio3.png" alt="Android Studio" width="85%" title="Android Studio" align="center" />

需要我们打开一个项目，我们可以用刚才已经配置好的 **Flutter SDK** 的命令行创建一个 Flutter 项目，如执行以下命令

```bash
cd ~/desktop
flutter create new_flutter
```

命令执行完成后，在桌面就会生成一个 Flutter 项目，再用 Android Studio 打开，项目打开后会提示安装 Flutter 插件和依赖 Dart ，安装完之后我们可以去创建一个模拟器。

打开 **Tools>AVD Manager** ，点击 `Create Virtual Device...` 来创建一个模拟器，选择一个设备，点击 Next，如图

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio4.png" alt="Android Studio" width="85%" title="Android Studio" align="center" />

为模拟器选择一个系统镜像（我选择的是第一个），点击 Download ，下载完成后，点击 Next 后，如图

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio5.png" alt="Android Studio" width="85%" title="Android Studio" align="center" />

最后，在模拟性能这里选择 **Hardware - GLES 2.0** 启动硬件加速，点击 Finish 完成

<img src="https://cdn.lishaoy.net/flutterInstall/AndroidStudio6.png" alt="Android Studio" width="85%" title="Android Studio" align="center" />


## 配置编辑器

前面我们已经配置好了 **Flutter SDK** 、**iOS 模拟器** 、**Android 模拟器** ，最后我们还需要配置一下编辑器，当然您可以选择 `Android Studio` 或者 `VS Code`，这里我选择的是轻量级的 `VS Code`。

打开终端进入我们刚才新建的 Flutter 项目

```bash
cd new_flutter
```

再用 VS Code 打开项目

```bash
code ./
```

打开项目之后 <kbd>⌘</kbd> - <kbd>⇧</kbd> - <kbd>X</kbd> ,打开扩展，安装 **Flutter** 插件，如图


