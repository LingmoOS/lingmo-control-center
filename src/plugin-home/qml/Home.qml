// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 侧边栏首项：主页
// 模块本身只承载侧栏条目，设备概览等页面内容放在 HomeMain.qml：
// 只有 <插件名>Main.qml 的上下文里才有 dccData（见 dccpluginloader.cpp 的 loadMain）。
DccObject {
    name: "home"
    parentName: "root"
    displayName: qsTr("Home")
    description: qsTr("Device overview and common settings")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/home-light.svg"
    weight: 10
}
