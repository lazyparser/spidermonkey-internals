# 可能的研究点/开放项目

**CAVEAT: 以下内容可能有点过时了, 有些项目已经有人做了, 具体请去Bugzilla上看看.**

2013年8月份的时候 Mozilla 开发人员 Nicolas B. Pierron 在邮件列表中给出了几个
IonMonkey 的开放项目，有兴趣的同学可以去
[SpiderMonkey 的邮件列表](https://groups.google.com/forum/#!msg/mozilla.dev.tech.js-engine.internals/-kLUDSAxrhA/HKjvjfYLWukJ)
看看。
这里列出项目的简介：

* Clarifying our heuristics, to be able to make guesses while we are compiling
in IonMonkey, and recompile without the guarded assumptions if the bailout paths
are too costly. Our current view is mostly black & white and only one bad use
case can destroy the performances. 

* Adding resume operations, such as an instruction can be moved to a later point
in the control flow. This optimization is a blocker for any optimization which
can be done with the escape analysis.

* Adding profile guided optimization, the idea would be to profile which branches
are used and to prune branches which are unused, either while generating the
MIR Graph, or as a second optimization phase working on the graph. 

* Improving our Alias Analysis to take advantage of the type set (this might
help a lot kraken benchmarks, by factoring out array accesses).

* Improve dummy functions used for asm.js boundaries. Asm.js needs to communicate
with the DOM, and to do so it need some trampoline functions which are used as
an interface with the DOM API. Such trampolines might transform typed arrays
into strings or objects and serialize the result back into typed arrays.

2012年11月的时候, 一位巴西的大四学生给 Mozilla JS-Internals 邮件列表发了
[一封邮件](http://www.mail-archive.com/dev-tech-js-engine-internals@lists.mozilla.org/msg00120.html)，
说自己下半年就开始计算机科学的研究生学业了，希望能够在 IonMonkey 上做些研究，但是
刚接触 IonMonkey 没有什么感觉，希望能够得到一些指点。一周后 Mozilla JS Engine 的负责人
David Anderson 回复了他，指出了
[几个他们感兴趣的研究项目](http://www.mail-archive.com/dev-tech-js-engine-internals@lists.mozilla.org/msg00122.html)，
有兴趣的读者可以关注一下：

* Escape Analysis（逃逸分析）：目前还没有任何的工作，所以即使不是完整的算法实现，
能够得到一些测试数据也是很好的。逃逸分析能够帮助减少冗余的堆内存占用（当一个线程中的
堆内存对象不确定是否被其它线程引用的时候是不能轻易的删除的）。

* Better Alias Analysis（别名分析）：目前 IonMonkey 中有一个别名分析
（位于 `js/src/ion/AliasAnalysis.{h,cpp}`），但是比较的粗糙，例如在遇到类似
“v.x + v.y + v.z”这样的表达式时，现在的别名分析会将 v.x 和 v.z 都看成是 v.y 的别名。
这阻碍了后续的优化工作。

* RA Improvements（寄存器分配算法的改进）：要重写一个 RA 是非常难的，工作量也非常的大。
如果能够在现在 RA 实现的基础上做一些改进，也是很有意义的。

* Control-flow Elimination（不常用控制流消除）：目前 IonMonkey 能够消除（eliminate）
单个指令，但是无法消除 CFG 中的 Block 。如果这个功能实现了，我们（开发人员）就可以
做进一步的实验，尝试更加激进的优化，消除掉不常用的分支，或许还可以促进 RA 的效果。

目前 IonMonkey 还在开发中，支持的分析和优化还不是很多，实现上也是比较简单的实现，
应该还有不少的机会。


