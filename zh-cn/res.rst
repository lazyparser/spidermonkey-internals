学习资源
========

幻灯片(Slides or PPT)
---------------------

**A new GVN for IonMonkey**

`在线PPT <http://sunfishcode.github.io/NewGVN/#/>`__
`PPT源代码 <https://github.com/sunfishcode/sunfishcode.github.io/tree/master/NewGVN>`__
`演讲视频 <https://air.mozilla.org/a-new-gvn-for-ionmonkey/>`__ by
@sunfish

介绍了目前 IonMonkey 中的 GVN (Global Value Numbering) 的实现.

**IonMonkey: Yet Another JavaScript Just-In-Time Compiler?**

`下载地址1 <https://github.com/evilpie/ionmonkey-fosdem2013>`__,
`下载地址2 <https://github.com/nbp/ionmonkey-fosdem2013>`__

@evilpies (Tom Schuster) 和 @nbp (Nicolas B. Pierron) 在 FOSDEM 2013
上的演讲. 下载下来ZIP包之后解压缩,
用浏览器打开\ ``presentation.html``\ 就可以看了.

**Javascript Optimizations** MozCamp Europe in 2012

    Javascript Optimization talk presented at the MozCamp Europe in
    2012. Present bad / good practice to avoid / adopt when developping
    Web Applications, especially for mobile.

可以从作者 @nbp
的github上\ `下载 <https://github.com/nbp/mozcamp-eu-2012-js-optim>`__,
虽然时间有点久, 但是里面说大部分结论都还成立.

**Recover Instructions**

`下载地址 <https://nbp.github.io/slides/RInstruction>`__

by @nbp again.

TODO: 没看懂.

**Dynamic Taint Analysis**

`下载地址 <https://nbp.github.io/slides/TaintAnalysis>`__

by @nbp again.
`涉及Jalangi框架的部分可以看这里 <https://github.com/Berkeley-Correctness-Group/Jalangi-Berkeley>`__.
上半年正好关注过这个团队 :-)

TODO: 没看懂.

污点分析记得在 JSTOOLS’12 上也有人报告过类似的动态分析工具,
当时啥都不懂, 没记住多少. 现在忘记了具体工作细节了.

**JavaScript Updates** B2G Week Oslo 2013

    JS presentation for the B2G Work Week

`下载地址 <https://github.com/nbp/oslo-2013>`__

By Kannan Vijayan [:djvj], Nicolas B. Pierron [:nbp]

工作总结性质, 没有多少技术细节.

**Vyacheslav Egorov: V8 Inside Out**

`幻灯片 <http://s3.mrale.ph/webrebels2012.pdf>`__
`演讲视频 <http://vimeo.com/43334972>`__
`本地缓存 <res/V8-Inside-Out-Vyacheslav-Egorov-mraleph-webrebels2012.pdf>`__

虽然是V8的资料, 但是里面提到的 Inlining Caching 和 Hidden Classes 技术
SpiderMonkey 中也有用到.

**The Future of JavaScript: EcmaScript 6 and even more**

`内容简介 <https://archive.fosdem.org/2015/schedule/event/the_future_of_javascript/>`__
`视频下载 <http://video.fosdem.org/2015/devroom-mozilla/the_future_of_javascript__CAM_ONLY.mp4>`__

Hannes Verschore (@h4writer) 和 Benjamin Bouvier (@bbouvier) 的报告.
视频只拍摄到了人, 没有拍到PPT, 感觉稍微有点鸡肋.

技术文章(Articles or Essays)
----------------------------

Hannes Verschore (@h4writer) 是 SpiderMonkey 的核心开发人员, 他写的
SpiderMonkey 2014 年度总结系列, 个人觉得非常的完善,
强烈有一些编译基础的人阅读. 即使之前没有接触过 SpiderMonkey,
也可以读一读, 有一个直观的脉络性的感受.

`Year in review: Spidermonkey in 2014 part
1 <http://h4writer.com/?p=14>`__

`Year in review: Spidermonkey in 2014 part
2 <http://h4writer.com/?p=40>`__

`Year in review: Spidermonkey in 2014 part
3 <http://h4writer.com/?p=46>`__

`Vyacheslav Egorov: Explaining JavaScript VMs in JavaScript - Inline
Caches <http://mrale.ph/blog/2012/06/03/explaining-js-vms-in-js-inline-caches.html>`__

研究论文(Papers)
----------------

`Ryan Pearl 和 Michael Sullivan 关于 Range Analysis 在 IonMonkey
中的实现. <http://www.endofunctor.org/~cmplrz/paper.pdf>`__

编译器相关的技术博客(Blogs)
---------------------------

`Vyacheslav Egorov 的博客 <http://mrale.ph/>`__

Vyacheslav Egorov 是 Google 的 V8/Dart 开发人员. 比较活跃,
写了不少很好的V8原理的文章.
