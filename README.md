# SpiderMonkey Internals
The internals of SpiderMonkey and IonMonkey.

这本书记录了我在 SpiderMonkey 学习过程中的一些零散的经验.
内容是我工作需要调研到哪里就记录到哪里, 并不是按照教学顺序撰写的.
如果你也正在学习 SpiderMonkey 的代码, 欢迎 Pull Request!

## 如何将本书编译成PDF版本

    pandoc README.md -o README.pdf --latex-engine=xelatex -V mainfont="WenQuanYi Micro Hei"

或者直接在项目的根目录下 make 即可.

