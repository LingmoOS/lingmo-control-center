// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import org.deepin.dcc 1.0

// device 与 system 一样是纯分组插件：Device.qml 只提供侧栏的「蓝牙和其它设备」
// 分组项，内容由其它插件以 parentName: "device" 挂进来，没有 C++ 后端和页面。
//
// v1.1 加载流程仍会无条件去找 <Name>Main.qml（updateType() 置上 T_HasMain，
// loadMain() 执行 loadFromModule(name(), "DeviceMain")），缺了会报
//     Module "device" contains no named "DeviceMain"  -> MainObjError
// 这里补一个空的 Main，根对象没有 name，会被合并进模块对象，侧栏不会多出一行。
DccObject {
}