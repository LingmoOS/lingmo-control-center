// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import org.deepin.dcc 1.0

// commonInfo 的模块对象。这个插件没有自己的侧栏入口：它的条目（Boot Menu /
// Developer Options）靠 parentName: "system" 直接挂到 system 分组下，真正的
// 内容与 dccData 调用都在 CommonInfoMain.qml 里。
//
// 但 v1.1 插件约定要求每个插件目录里必须有 <Name>.qml 作为模块对象：
// dccpluginloader.cpp 的 loadModule() 会执行
//     component.loadFromModule(name(), "CommonInfo")
// 没有这个类型时 QQmlComponent 直接进入 Error，插件在 ModuleCreate 阶段就报
//     Module "commonInfo" contains no named "CommonInfo"
// 之后整个插件（连同 commonInfo.so 的 dccData）都不再加载。
//
// 这里给一个没有 name / parentName 的空 DccObject：DccManager::addObject()
// 会把它放进 _noAdd 节点，不会出现在侧栏；它只是 CommonInfoMain.qml 的宿主，
// Main 的根对象同样没有 name，会被合并进这个模块对象。
DccObject {
}