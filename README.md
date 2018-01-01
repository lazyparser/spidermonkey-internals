# SpiderMonkey Internals

The internals of SpiderMonkey and IonMonkey.

这本书记录了我在 SpiderMonkey 学习过程中的一些零散的经验.
内容是我工作需要调研到哪里就记录到哪里, 并不是按照教学顺序撰写的.
如果你也正在学习 SpiderMonkey 的代码, 欢迎 `Pull Request`!

## 如何将本书编译成PDF版本
本文使用的是github风格的`markdown`格式, 以方便在github上直接查看. 你也可以将本项目编译成PDF格式,
以方便离线时阅读. 我使用`pandoc`来生成PDF. 以下是我使用的命令 (环境: Ubuntu 14.04 LTS):

    pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

或者直接在项目的根目录下`make`即可, 会在项目目录下生成一个`book.pdf`的文件, 包含了除本`README.md`之外的md文件.

## 开源许可证
本项目使用CC-BY-NC-SA协议。
本项目中缓存的第三方的PPT及文档, 使用他们自己的开源协议.
如果协议之间存在不相容的情况, 请给我提交ISSUE, 我从这个项目中移除.
