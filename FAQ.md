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












































