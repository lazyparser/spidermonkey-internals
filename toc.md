# 目录

## 简介

不动手, 纯背景知识介绍. 包括四大(浏览器背后的)JS引擎的发展过程(目前就了解SpiderMonkey,
V8等引擎的发展过程欢迎[提交PR](https://github.com/lazyparser/spidermonkey-internals/pulls).

### JavaScript

介绍JavaScript的历史, 现状(ES5), 及未来ES6, ES7的发展.

### SpiderMonkey 历史

介绍SpiderMonkey的发展过程. 主要介绍几个JIT的演变(就关注过这个).

### Firefox 架构及内存组织

介绍 SpiderMonkey 在 Firefox 中的位置, 与其它模块之间的交互关系. 以及 Firefox
基于 Zone/Compartment 的内存管理机制.

### SpiderMonkey 的架构

介绍 SpiderMonkey 的内部组成, 在概念上的模块划分.

## 上手实践

从零开始, 编译和构建自己的 SpiderMonkey 引擎, 并学会如何做(简单的)性能测评.

### 下载和编译 SpiderMonkey

如何在 Ubuntu 上下载和构建 SpiderMonkey 的 JSShell.

### 执行 SpiderMonkey 回归测试

Mozilla 提供了完善的测试集. 以后你可能会自己动手修改代码, 提交patch. 在提交之前,
通过测试集是必要条件之一.

### 运行 Benchmarks

运行各个测试集的结果, 从此不再被忽悠.

### 常见的编译构建配置

探索和发现各种好用的开发调试功能.

## 调试及性能数据收集

### 调试配置

### SPS Profiler

### IonSpew

### TraceLogger

### InferSpew

### Code Coverage

## 深入源代码

### 前端

### 解释器

### Baseline JIT

### IonMonkey JIT

### OdinMonkey(AsmJS) JIT

### 如何提交Patch, 贡献代码

### 进一步的学习资源
