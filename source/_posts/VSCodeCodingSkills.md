---
title: VS Code：让你工作效率翻倍的23个插件和23个编辑技巧
tags:
  - VS Code
  - null
copyright: true
comments: true
date: 2018-10-13 15:39:44
categories: 工具
top: 108
photos:
---

{% li https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code.jpg, VS Code, VS Code %}

总结了一些平时常用且好用的 **VS Code** 的插件和编辑技巧分享出来。

<!-- more -->

## 外观

### 主题
这里我分享两款主题：

1. **[Material Theme](https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme)**

效果如图：

![no-shadow](https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_theme1.jpg "Material Theme")

2. **[An Old Hope Theme](https://marketplace.visualstudio.com/items?itemName=dustinsanders.an-old-hope-theme-vscode)**

效果如图：

![no-shadow](https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_theme2.jpg "An Old Hope Theme")

### 图标

3. **[Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme)**当然，这两款主题的文件管理器（左侧）的 icon 小图标使用的是 Material Icon Theme

### 字体及其他

其他和外观相关的设置如下：

```json
{
    "editor.multiCursorModifier": "ctrlCmd",
    "editor.formatOnPaste": false,
    "workbench.activityBar.visible": false,
    "workbench.iconTheme": "eq-material-theme-icons-darker",
    "workbench.colorCustomizations": {},
    "materialTheme.cache.workbench.settings": {
        "themeColours": "Darker",
        "accentPrevious": "Acid Lime"
    },
    "workbench.colorTheme": "Material Theme Darker",
    "material-icon-theme.angular.iconsEnabled": true,
    "material-icon-theme.folders.icons": "specific",
    "editor.lineHeight": 24,
    "editor.fontLigatures": true,
    "editor.fontFamily": "FiraCode-Medium"
}
```

特别注意的是 `"editor.lineHeight": 24,` 和 `"editor.fontFamily": "FiraCode-Medium"` 。

`"editor.lineHeight": 24,` ： 设置代码的行间距，这里比默认的稍大些，就这一点小小的改变，让代码看起来清爽整洁。

`"editor.fontFamily": "FiraCode-Medium"` ： 设置字体，这种字体会让代码看起来更形象生动，如下

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_code3.png" alt="FiraCode-Medium字体" width="100%" title="FiraCode-Medium字体" align="center" />

红色竖线左边是使用了 **FiraCode-Medium** 字体的效果，红色竖线右边是没有使用 **FiraCode-Medium** 字体的效果

关于 **FiraCode-Medium** 字体更多效果可查阅 [https://github.com/tonsky/FiraCode](https://github.com/tonsky/FiraCode) 地址。

## 代码管理

### 格式化

4. **[Beautify](https://marketplace.visualstudio.com/items?itemName=HookyQR.beautify)** ：格式化的时候，给出格式化文本选项，如下

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_Beatify.gif" alt="Beautify" width="100%" title="Beautify" align="center" />

5. **[Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)** ：个人比较喜欢这个，看起来代码更清晰，如下

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_Prettier.gif" alt="Prettier" width="100%" title="Prettier" align="center" />

{% note info %} 当然，大家可以自定义快捷键，也可以按 <kbd>⌘</kbd> - <kbd>⇧</kbd> - <kbd>P</kbd>  来搜索相关命令 {% endnote %}  

### 代码检查

6. [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) ：检查 `js` 语法规范，你可以使用不同的规范，如 [airbnb](https://www.npmjs.com/package/eslint-config-airbnb) 、[standard](https://github.com/standard/eslint-config-standard) 、[google](https://github.com/google/eslint-config-google)。
7. [TSLint](https://marketplace.visualstudio.com/items?itemName=eg2.tslint) ：检查 `typescript` 语法规范。
8. [Stylelint](https://marketplace.visualstudio.com/items?itemName=shinnn.stylelint) ：检查 `CSS/SCSS/Less` 语法规范。
9. [Markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint) ：检查 `markdown` 语法规范。

### 自动补全

以下插件点击链接可以查看gif动图，详细了解具体功能。
10. [Emmet](https://emmet.io) ：大家应该很熟悉这个插件了（很好用），VS Code 已经内置了，很到位。
11. [Auto Close Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag) ：自动闭合 `html` 等标签 （</...>）。
12. [Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag) ：修改 `html` 标签时，自动修改闭合标签。
13. [Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense) ：自动提示补全路径。

### 代码片段

14. **snippets** ：搭建可以自己安装各种代码片段（vue、react、angular等），这里就不列举。

## 功能扩展

以下的功能扩展插件大部分都有gif动图，可点击链接了解详细功能
15. [Bracket Pair Colorizer](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer) ：让代码的各种括号呈现不同的颜色。
16. [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) ：可以在编辑器里直接运行代码，查看结果。
17. [Color Picker](https://marketplace.visualstudio.com/items?itemName=anseki.vscode-color) ：可以直接在编辑器里打开色板，选择各种模式的颜色。
18. [Document This](https://marketplace.visualstudio.com/items?itemName=joelday.docthis) ：可以给函数、类等自动的加上详细的注释。
19. [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory) ：方便的查看git版本管理的详细信息。
20. [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) ：可以一键在本地启动服务器。
21. [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) ：重点介绍下这个插件，如果你有两台电脑（比如，家里和公司）都使用 VS Code ，可是在公司或家里对 VS Code 安装了插件或者修改了配置，回到家或公司又要重新弄一次，这个插件就能解决问题，同步多台电脑设置。

只需要把配置上传到GitHub，在另一个地方下载配置即可，如下

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_Sync.gif" alt="Settings Sync" width="100%" title="Settings Sync" align="center" />

22. [gi](https://marketplace.visualstudio.com/items?itemName=rubbersheep.gi) ：可以给 `.gitignore` 文件添加各种语言忽略文件配置。
23. [Polacode](https://marketplace.visualstudio.com/items?itemName=pnp.polacode) ：可以把代码生成图片（有些地方发代码结构会乱也没有代码高亮，这时候就可以生成图片再发）。

## 编辑技巧

### 光标

1. 把光标移到文件的首部或尾部

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_1.gif" alt="⌘ - ↑ 或 ⌘ - ↓" width="100%" title="⌘ - ↑ 或 ⌘ - ↓" align="center" />

2. 把光标移动到行的首部或者尾部

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_2.gif" alt="⌘ - ← 或 ⌘ - →" width="100%" title="⌘ - ← 或 ⌘ - →" align="center" />

3. 按单词移动

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_3.gif" alt="⌥ - ← 或 ⌥ - →" width="100%" title="⌥ - ← 或 ⌥ - →" align="center" />

4. 按单词大小写分解移动光标

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_4.gif" alt="⌥ - ⌃ - ← 或 ⌥ - ⌃ - →" width="100%" title="⌥ - ⌃ - ← 或 ⌥ - ⌃ - →" align="center" />

### 选择

5. 选择行以上或以下全部内容

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_5.gif" alt="⇧ - ⌘ - ↑ 或 ⇧ - ⌘ - ↓" width="100%" title="⇧ - ⌘ - ↑ 或 ⇧ - ⌘ - ↓" align="center" />

6. 选择到行首或行尾的内容

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_6.gif" alt="⇧ - ⌘ - ← 或 ⇧ - ⌘ - →" width="100%" title="⇧ - ⌘ - ← 或 ⇧ - ⌘ - →" align="center" />

7. 按字母或单词选择

- <kbd>⇧</kbd> - <kbd>←</kbd> 、 <kbd>⇧</kbd> - <kbd>→</kbd> 按字母选择   
- <kbd>⇧</kbd> - <kbd>⌥</kbd> - <kbd>←</kbd> 、 <kbd>⇧</kbd> - <kbd>⌥</kbd> - <kbd>→</kbd> 按单词选择

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_7.gif" alt="⇧ - ← 、 ⇧ - → 或 ⇧ - ⌥ - ← 、 ⇧ - ⌥ - →" width="100%" title="⇧ - ← 、 ⇧ - → 或 ⇧ - ⌥ - ← 、⇧ - ⌥ - →" align="center" />

8. 伸缩选择

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_8.gif" alt="⇧ - ⌃ - ⌘ - ← 或 ⇧ - ⌃ - ⌘ - →" width="100%" title="⇧ - ⌃ - ⌘ - ← 或 ⇧ - ⌃ - ⌘ - →" align="center" />

9. 选择匹配单词

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_9.gif" alt="⌘ - D 或 ⌘ - U" width="100%" title="⌘ - D 或 ⌘ - U" align="center" />

### 行

10. 向上或向下移动行

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_10.gif" alt="⌥ - ↑ 或 ⌥ - ↓" width="100%" title="⌥ - ↑ 或 ⌥ - ↓" align="center" />

11. 复制或删除行

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_11.gif" alt="⌥ - ⇧ - ↓ 或 ⌘ - ⇧ - K" width="100%" title="⌥ - ⇧ - ↓ 或 ⌘ - ⇧ - K" align="center" />

12. 多行合并成一行

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_12.gif" alt="⌘ - J" width="100%" title="⌘ - J" align="center" />

13. 缩进或伸缩行

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_13.gif" alt="⌘ - [ 或 ⌘ - ]" width="100%" title="⌘ - [ 或 ⌘ - ]" align="center" />

14. 在当前行之上或下插入行

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_14.gif" alt="⌘ - ↩ 或 ⌘ - ⇧ - ↩" width="100%" title="⌘ - ↩ 或 ⌘ - ⇧ - ↩" align="center" />

### 多行

15. 鼠标点击，多行编辑

按 <kbd>⌘</kbd> 选择编辑点，按 <kbd>⎋</kbd> 退出多行编辑

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_15.gif" alt="⌘" width="100%" title="⌘" align="center" />

16. 使用快捷键多行编辑

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_16.gif" alt="⌘ - ⌥ - ↓ 或 ⌘ - ⌥ - ↑" width="100%" title="⌘ - ⌥ - ↓ 或 ⌘ - ⌥ - ↑" align="center" />

17. 在所选择的行的结尾插入编辑点

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_17.gif" alt="⇧ - ⌥ - I" width="100%" title="⇧ - ⌥ - I" align="center" />

18. 选择栏位

按 <kbd>⇧</kbd> - <kbd>⌘</kbd> 再选择栏位

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_18.gif" alt="⇧ - ⌘" width="100%" title="⇧ - ⌘" align="center" />

### 高级

19. 查看类或方法的定义

- 按 <kbd>⌥</kbd> 点击，可以在新页面查看
- 按 <kbd>⇧</kbd> - <kbd>⌥</kbd> - <kbd>⌘</kbd> 点击，可以在新组查看
- 按 <kbd>⇧</kbd> - <kbd>F12</kbd> 点击，可以在当前页面查看

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_19.gif" alt="查看定义" width="100%" title="查看定义" align="center" />

20. 折叠代码

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_20.gif" alt="⌥ - ⌘ - ] 或 ⌥ - ⌘ - [" width="100%" title="⌥ - ⌘ - ] 或 ⌥ - ⌘ - [" align="center" />

21. 去掉选择行的尾部空格

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_21.gif" alt="⌘ - K 、 ⌘ - X" width="100%" title="⌘ - K 、 ⌘ - X" align="center" />

22. 定位到指定行号

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_22.gif" alt="⌃ - G" width="100%" title="⌃ - G" align="center" />

23. 在文件里查找类或方法

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_23.gif" alt="@" width="100%" title="@" align="center" />

最后，如果记不住这些快捷键，可以按 <kbd>⌘</kbd> - <kbd>K</kbd> 、 <kbd>⌘</kbd> - <kbd>S</kbd> 搜索对应快捷键绑定

<img src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code_24.gif" alt="搜索快捷键" width="100%" title="搜索快捷键" align="center" />

<img class="hidden" src="https://cdn.lishaoy.net/VSCodeCodingSkills/vs-code.jpg" alt="VS Code" width="100%" title="VS Code" align="center">