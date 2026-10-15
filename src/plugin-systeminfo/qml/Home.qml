// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 侧边栏首项：主页（设备概览）。当前复用“关于本机”的概览页，
// 后续再改成卡片式布局（设备/存储/更新状态 + 常用入口）。
DccObject {
    name: "home"
    parentName: "root"
    displayName: qsTr("Home")
    description: qsTr("Device overview and common settings")
    icon: "commoninfo"
    weight: 10

    NativeInfoPage {}
}
