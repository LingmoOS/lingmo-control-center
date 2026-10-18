// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import org.deepin.dcc 1.0

// system 是纯分组插件：System.qml 只提供侧栏的「系统」分组项，分组内容
// （关于本机、启动菜单、开发者选项……）都由其它插件以 parentName: "system"
// 挂进来，自己既没有 C++ 后端也没有页面。
//
// 但 v1.1 加载流程仍然会无条件去找 <Name>Main.qml：
// dccpluginloader.cpp 的 updateType() 在 qmldir 存在时同时置上
// T_HasModule | T_HasMain，loadMain() 随后 loadFromModule(name(), "SystemMain")。
// 没有这个类型就会报
//     Module "system" contains no named "SystemMain"  -> MainObjError
// 所以分组插件也补一个空的 Main。根对象没有 name，addMainObject() 会把它当成
// 「与 <Name>.qml 同一项」合并进模块对象，不会在侧栏多出一行。
DccObject {
}