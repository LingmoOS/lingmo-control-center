// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 键盘与鼠标：原来分别挂在“蓝牙和其他设备”下，现合并为侧边栏一项
DccObject {
    name: "keyboardAndMouse"
    parentName: "root"
    displayName: qsTr("Keyboard and Mouse")
    description: qsTr("Keyboard, mouse and touchpad")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/keyboardAndMouse-light.svg"
    weight: 90
}
