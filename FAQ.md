# FAQ

说明: 常见的问题回答, 以及一些暂时不知道如何归类的知识点(文章)都放在这里.

## 代码中的 JS_ALWAYS_INLINE 是什么意思?
在SpiderMonkey的代码库中经常可以看到一个函数名前面定义了一个宏 `JS_ALWAYS_INLINE`，这个宏定义在 `js/src/jstypes.h` 中：

```c
#define JS_ALWAYS_INLINE MOZ_ALWAYS_INLINE
```

而 `MOZ_ALWAYS_INLINE` 定义在 `mfbt/Attributes.h` 中：

```c
/*
 * MOZ_ALWAYS_INLINE is a macro which expands to tell the compiler that the
 * method decorated with it must be inlined, even if the compiler thinks
 * otherwise.  This is only a (much) stronger version of the MOZ_INLINE hint:
 * compilers are not guaranteed to respect it (although they're much more likely
 * to do so).
 */
#if defined(DEBUG)
#  define MOZ_ALWAYS_INLINE     MOZ_INLINE
#elif defined(_MSC_VER)
#  define MOZ_ALWAYS_INLINE     __forceinline
#elif defined(__GNUC__)
#  define MOZ_ALWAYS_INLINE     __attribute__((always_inline)) MOZ_INLINE
#else
#  define MOZ_ALWAYS_INLINE     MOZ_INLINE
#endif
```

而这里的 `MOZ_INLINE` 也定义在 `mfbt/Attributes.h` 中：

```c
/*
 * MOZ_INLINE is a macro which expands to tell the compiler that the method
 * decorated with it should be inlined.  This macro is usable from C and C++
 * code, even though C89 does not support the |inline| keyword.  The compiler
 * may ignore this directive if it chooses.
 */
#if defined(__cplusplus)
#  define MOZ_INLINE            inline
#elif defined(_MSC_VER)
#  define MOZ_INLINE            __inline
#elif defined(__GNUC__)
#  define MOZ_INLINE            __inline__
#else
#  define MOZ_INLINE            inline
#endif
```

这个定义文件放在mfbt目录下，这个目录的全称是“Mozilla Framework Based on Templates (MFBT)”，作用在\[1\]中有解释：

    The Mozilla Framework Based on Templates (“mfbt”) is the central repository
    for macros, functions, and data structures used throughout Mozilla code, 
    including in the JavaScript engine.

\[1\]: https://developer.mozilla.org/en-US/docs/Mozilla/MFBT

## SpiderMonkey 是如何确定版本号的?

编译好的 SpiderMonkey JSShell 是有一个版本号的. 通过运行 `js --version` 可以看到
(是Mozilla的版本, 不是`1.7+`,`1.8`这样的JS_VERSION). 例如我的构建版本输出的是
`44.0a1`. 这个版本上是Mozilla仓库统一的版本号. 这个信息并不保存在 SpiderMonkey
源代码目录中, 而是保存于 Mozilla-Central(or gecko-dev) 仓库的 `config/milestone.txt`
目录下:
```bash
$ cd mozilla-central/
$ cat config/milestone.txt
# Holds the current milestone.
# Should be in the format of
#
#    x.x.x
#    x.x.x.x
#    x.x.x+
#
# Referenced by milestone.py.
# Hopefully I'll be able to automate replacement of *all*
# hardcoded milestones in the tree from these two files.
#--------------------------------------------------------
44.0a1
```
之后, 在 SpiderMonkey 的 `configure` 脚本中, `configure` 脚本调用
`$srcdir/python/mozbuild/mozbuild/milestone.py` 读取 `milestone.txt`
并返回版本(子)字符串. 在脚本配置过程中使用到了 `MOZILLA_VERSION`、`MOZILLA_UAVERSION`、
`MOZILLA_SYMBOLVERSION` 三种版本形式:
```bash
MOZILLA_VERSION=`$PYTHON $srcdir/python/mozbuild/mozbuild/milestone.py --topsrcdir $srcdir`
MOZILLA_UAVERSION=`$PYTHON $srcdir/python/mozbuild/mozbuild/milestone.py --topsrcdir $srcdir --uaversion`
MOZILLA_SYMBOLVERSION=`$PYTHON $srcdir/python/mozbuild/mozbuild/milestone.py --topsrcdir $srcdir --symbolversion`
```
其中 `MOZILLA_VERSION` 又进一步的被分成 `MOZJS_MAJOR_VERSION`、`MOZJS_MINOR_VERSION`、
`MOZJS_PATCH_VERSION`、`IS_ALPHA` 四个变量:
```bash
MOZJS_MAJOR_VERSION=`echo $MOZILLA_VERSION | sed "s|\(^[0-9]*\)\.[0-9]*.*|\1|"`
MOZJS_MINOR_VERSION=`echo $MOZILLA_VERSION | sed "s|^[0-9]*\.\([0-9]*\).*|\1|"`
MOZJS_PATCH_VERSION=`echo $MOZILLA_VERSION | sed "s|^[0-9]*\.[0-9]*[^0-9]*||"`
IS_ALPHA=`echo $MOZILLA_VERSION | grep '[ab]'`
```
在本例中分别对应 `44`, `0`, `1`, `a`.

`configure` 获取到相关的信息之后, 将其写入到 `js-config.h` 以及 `js-confdefs.h`
两个文件中, 使得 JSShell 能够获得版本信息. 同时, `configure` 也将该信息写入
`Makefile` 文件, 用于在 `make source-package` 命令式, 将版本号正确的传递给
`make-source-package.sh` 脚本.
`make-source-package.sh` 脚本可以简单的理解为一个打包脚本, 将 SpiderMonkey 在
mozilla-central 仓库中所有依赖的文件都抽取出来, 用于单独发布.

## 如何打包 SpiderMonkey 代码, 从 Mozilla 仓库中抽取出来.

SpiderMonkey 提供了一个脚本`make-source-package.sh`来打包 SpiderMonkey 代码.
在`configure`生成的`js/src/Makefile`中, 包含了打包脚本的使用方法.
```makefile
source-package:
        SRCDIR=$(srcdir) \
        DIST=$(DIST) \
        MAKE=$(MAKE) \
        MKDIR=$(MKDIR) \
        TAR=$(TAR) \
        MOZJS_MAJOR_VERSION=$(MOZJS_MAJOR_VERSION) \
        MOZJS_MINOR_VERSION=$(MOZJS_MINOR_VERSION) \
        MOZJS_PATCH_VERSION=$(MOZJS_PATCH_VERSION) \
        MOZJS_ALPHA=$(MOZJS_ALPHA) \
        $(srcdir)/make-source-package.sh
```
如果是在Debian/Ubuntu或Fedora这样的Linux系统下, 可以直接替换成以下命令生成:
```
cd $srcdir && \
SRCDIR=$PWD \
DIST=$YOUR_DIST_DIR_OUTSIDE_SRCDIR \
MAKE=make \
MKDIR=mkdir \
TAR=tar \
MOZJS_MAJOR_VERSION=44 \
MOZJS_MINOR_VERSION=0 \
MOZJS_PATCH_VERSION=1 \
MOZJS_ALPHA=a \
./make-source-package.sh
```
对于`make source-package`而言, 生成的代码包会放置于`./dist`目录下.
注意目前`make-source-package.sh`并不能忽略掉`js/src`中的`_DBG.OBJ`和`_OPT.OBJ`
这样的临时文件夹. 所以在打包的时候需要检查相关的目录中没有中间文件或临时文件.


## 如何在大陆(墙内)构建 Firefox for Android

大陆由于墙的缘故, 不仅Google的服务没有正确的部署, 所有依赖于Google的服务都会出现问题.
Firefox for Android (以下称 Fennec) 需要使用 Android SDK 和 NDK 进行构建, 因此也就
遇到了同样的问题, 导致了 Mozilla 仓库中的 mach bootstrap 命令无法正确执行.

一种方式是不使用 mach bootstrap 命令初始化的 toolchain, 利用你之前手工下载的 Android
SDK/NDK 进行构建. 方法是配置 mozilla 仓库根目录下的 mozconfig 参数, 指定好路径.

另一种方式是死磕, 在 mach bootstrap 过程中加入一点手工的方法来绕过. 以下是方法:

首先你需要 google hosts 能够下载基本的SDK等; 具体可以自行上 github 上找找;
* 运行 mach bootstrap, 在尝试 refresh android repository addons list-2.xml 或者
类似的文件的时候会显示读取失败.
* 手工的切换到 $HOME/.mozbuild 中的目录. 找到 Android 工具并运行, 一般是
`$HOME/.mozbuild/android-sdk-linux/tools/android`
这时就看到了熟悉的 Android SDK 管理页面. 在配置中取消 HTTPS, 强制使用 HTTP.
安装所有需要的 SDK/NDK/Tools.
* 回到 mozilla-central 目录下运行 mach build.
* 这个时候可能会遇到说找不到正确的 SDK 和 NDK 路径, 这是因为 bootstrap 没有正确
执行结束导致的. 解决方法是修改 mozconfig 配置文件中`--with-android-sdk`和
`--with-android-ndk`选项, 指向具体的位置.
* 之后就可以执行 mach build & mach package 正确的编译出 apk 了.

PS: 当然还有一种最为高大上的方式就是VPN了, 然而下载量很大的说...如果你壕的话可以尝试.

## SpiderMonkey中的一堆的“-inl.h”头文件是什么?

如果你看过 SpiderMonkey 的代码目录，你就发现经常会有名为“`ABC-inl.h`的文件与头文件
`ABC.h`成对出现。这是 SpiderMonkey 内部组织的一个风格（不知道算不算规范），其目的是
为了改善和提高系统内部的模块性。感兴趣的同学可以看看这个
[Mozilla 维基页面](https://wiki.mozilla.org/JS_engine_modularization)
或者这个
[Bugzilla 链接](https://bugzilla.mozilla.org/show_bug.cgi?id=653057)。

## ubi::Node 是什么, 做什么用的?
这个可以参考 [Bug 960786 - SpiderMonkey should provide an introspection API for memory heap analysis (ubi::Node)](https://bugzilla.mozilla.org/show_bug.cgi?id=960786).
代码可以看[这次提交](https://hg.mozilla.org/mozilla-central/rev/3d405f960e94).

简单的说, 是用来方便调试工具的. 为了能够统一的呈现SpiderMonkey的内存结构.
由于内存结构非常的复杂, 包含了很多不同类型的对象结构, 所以 Jim Blandy
就将这个功能单独抽出变成了一个接口. 这里, `ubi::Node` 是 `ubiquitous node` 的意思:

	To decouple these problems, SpiderMonkey should define a type,
	which I'll call ubi::Node (for "ubiquitous node") that represents
	a reference to any type of node in the heap graph: strings, JSObjects,
	Shapes, BaseShapes, and so on; but also to non-SpiderMonkey types
	like XPCOM objects, nsINodes, and so on.

感兴趣可以看看 Bug 960786 的Reivew过程, big patch. 评论也蛮有意思, 同事关系挺好 ;-)

## 如何在Linux上用MSVC2013编译Firefox for Windows

这是一个很纠结的决定。Mozilla 开发者 Ehsan Akhgari 分享了自己的方法,
有兴趣的可以去看 [他的博客](http://ehsanakhgari.org/blog/2015-01-23/running-microsoft-visual-c-2013-under-wine-on-linux)
以及 [github gist](https://github.com/ehsan/msvc2013onwine)。

嗯，自然是基于 Wine。

## 如何使用 Eclipse CDT 查看 SpiderMonkey 的源代码

是的, 这是可以的. 不过由于SpiderMonkey的代码结构的复杂性, 使用了大量的宏定义和构建时环境变量生成,
给Eclipse/CDT带来了一些麻烦, 这些麻烦目前CDT还没有修复, 如果你愿意提交patch到Eclipse社区,
请让我知道, 好尽快用上你的patch :-)

首先, 按照[mozilla的wiki上的教程](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Setting_up_CDT_to_work_on_SpiderMonkey)配置好. 这可能需要个十几分钟到半个小时的时间, 具体要看你的机器性能.

然后, 在项目的属性页面中(选中项目, `Alt+Enter`), 在Build属性中, 添加一些路径.
比如 `mfbt` 对应的路径 Eclipse 目前还找不到, 需要到对应的OBJ目录下的`dist/include/mozilla`
下去寻找.
其它找不到的内容, 可以参照`mfbt`的方法, 一个一个的添加进去即可.


## JS 和 js 的 namespace 有差异?

Mozilla SpiderMonkey 中有两个不同的 namespace: JS 和 js。JS 名字空间用来存放公开的函数和类型名称。类似 JSXXX、jsXXX、JS_XXX 的函数和类型名都应该放在这个名字空间中；js 名字空间用来保存私有的函数和对象。

SpiderMonkey的这两个名字空间用大小写进行区分，带来的最大的不方便，就是用搜索引擎搜索的时候无法找到相关的说明。以前想找这两个名字空间的区别，搜索了半天都找不到相关的网页。

具体可以参考[这里](https://wiki.mozilla.org/JavaScript:SpiderMonkey:C%2B%2B_Coding_Style)


## IonMonkey 是什么时候并入 Firefox 的?

是2012年9月份进入主分支的, 当时的 Firefox 版本号是 18. 当时的模块负责人 David Anderson 写了[一篇博客](https://blog.mozilla.org/javascript/2012/09/12/ionmonkey-in-firefox-18/)介绍了IonMonkey的基本情况. 如果想看中文版, 可以看[编译路漫漫的翻译版](http://hellocompiler.com/archives/322)

## Baseline Compiler 是什么时候并入 SpiderMonkey 的?

是2013年4月份进入主分支的, 跟IonMonkey共享了很多的模块. 在Mozilla博客上可以找到[介绍Baseline实现的博客](http://blog.mozilla.org/javascript/2013/04/05/the-baseline-compiler-has-landed/). 如果想看中文版, 可以去看[编译路漫漫的翻译版](http://hellocompiler.com/archives/580).

## TraceMonkey 是什么时候从 SpiderMonkey 中移除的

2008年左右加入到Firefox/SpiderMonkey中的Trace-based JIT引擎TraceMonkey，2011年10月份的时候被默认禁用（bug 697666），11月份的时候已经被David Anderson从Mozilla-Central中移除了（bug 698201）。感情深入阅读可以去参考[编译路漫漫的相关博客](http://hellocompiler.com/archives/407).

## 如何得到SpiderMonkey引擎的字节码（bytecode）

最简单的方法是用[SpiderMonkey](https://wiki.mozilla.org/JavaScript:New_to_SpiderMonkey)自带的[jsshell](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Introduction_to_the_JavaScript_shell)工具。使用debug模式编译之后，通过“-D”参数就可以获得JavaScript脚本对应的bytecode了。示例（假设你编译的目录是build-debug）：

```
cd mozilla-central/js/src
./build-debug/js -D tests/js1_8_5/shell.js
```

得到的结果如下：

>	— SCRIPT tests/js1_8_5/shell.js:1 —
>	00000: 10 getgname “version”
>	{“interp”: 1}
>	00005: 10 typeof
>	{“interp”: 1}
>	00006: 10 string “undefined”
>	{“interp”: 1}
>	00011: 10 ne
>	{“interp”: 1}
>	00012: 10 ifeq 32 (+20)
>	{}
>	00017: 12 callgname “version”
>	{“interp”: 1}
>	00022: 12 undefined
>	{“interp”: 1}
>	00023: 12 notearg
>	{“interp”: 1}
>	00024: 12 uint16 185
>	{“interp”: 1}
>	00027: 12 notearg
>	{“interp”: 1}
>	00028: 12 call 1
>	{“interp”: 1}
>	00031: 12 pop
>	{“interp”: 1}
>	00032: 12 stop
>	{“interp”: 1}
>	— END SCRIPT tests/js1_8_5/shell.js:1 —

注意只有debug模式才会输出，release/optimize模式的jsshell会忽略该选项。

可以通过Mozilla的wiki学习如何[下载](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Getting_SpiderMonkey_source_code)和[编译](https://developer.mozilla.org/en-US/docs/SpiderMonkey/Build_Documentation)源代码。

## SpiderMonkey 代码注释中的常见缩写有哪些

N.B.: nota bene，注意; 不是牛B :)

NYI: Not Yet Implemented，尚未实现；

i.e.: id est，就是；

e.g.: exempli gratia，例如；

XXX: 代码需要改进；(这个往往搜索引擎搜不到 >_<)

FIXME: 代码需要改进，可能存在bug，需要修复；

TODO: 有功能待添加。


## SpiderMonkey (Firefox) 是如何管理内存的?

这个比较复杂. 在不考虑 e10s 的情况下, Firefox 浏览器内部的内存管理是基于”Compartment”的.

提出这个概念的背景, 是 Firefox 既是一个单进程多线程的架构, 又支持多 Tab 页面浏览.
这就导致了不同的网页的内容出现在同一个虚拟地址空间中. Firefox 3.5 之前的内存组织方式
是一视同仁的散布在堆中. 这样如果 Firefox 有内存方面的漏洞, 导致恶意页面可以访问到
敏感页面(例如银行支付页面)的内存信息, 就悲剧了. 性能上使得页面浏览的时候无法利用
缓存访问的局部性, Cache Miss 高一点点对于软件的速度影响是很可观的(1).

于是 Mozilla 把单个进程的堆, 以网页为单位分成了子堆, 在浏览器的内部实现了一套隔离和
通信机制. 你可以认为 Mozilla 把操作系统对于进程所做的工作, 在线程的层次上做了一层实现.
具体的实现原理和示意图可以参考
[Andreas Gal 的博客](http://andreasgal.com/2010/10/13/compartments/),
[MDN的介绍](https://developer.mozilla.org/en-US/docs/SpiderMonkey/SpiderMonkey_compartments),
或者直接看[论文《Compartmental memory management in a modern web browser》](http://ssllab.org/~nsf/files/memory_management.pdf).

## SpiderMonkey 内部如何表示字符串

简单说使用的 String Atom 技巧. 在SpiderMonkey的代码中经常能够看到 JSAtom
这一个数据结构。它并不是定义在 js/src/jsatom.h 中，而是在js/src/vm/String.h中。
SpiderMonkey为了能够快速的实现字符串的复制、比较操作，使用了一系列的C++对象。具体实现在
[String.h的注释](https://dxr.mozilla.org/mozilla-central/source/js/src/vm/String.h#44)
中有描述.

PS: [Mozilla DXR](https://dxr.mozilla.org/) 是一个比较不错的在线代码阅读网站,
虽然可能偶尔有 bug, 日常使用的搜索的功能使用起来还不错.

## 使用GDB调试 SpiderMonkey 有没有什么工具或者技巧?

这个我也还在摸索中. 首先
[Hacking Tips](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Hacking_Tips)
里面提供了不少的 hacking 技巧. 需要多练习几次才能熟练(那个时候你就是debug高手了哦:P);
其次可以使用"pretty-printer"来美化JIT中的输出, 使用方法和介绍可以看
[JS邮件列表贴出来的介绍](https://lists.mozilla.org/pipermail/dev-tech-js-engine-internals/2012-December/000880.html);
最后, [HelloGCC](http://hellogcc.org) 组织发起的 [《100个GDB小技巧》](https://github.com/hellogcc/100-gdb-tips)
也值得尝试一下(利益相关: 作者是HelloGCC组织者之一 :P).




















