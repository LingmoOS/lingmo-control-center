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
    icon: "device_keyboard"
    // 双色 SVG（Tabler, MIT）：实际变体由 delegate 按主题/选中态选择
    iconSource: "file:///usr/share/dde-control-center/icons/sidebar/keyboardAndMouse-light.svg"
    weight: 90
}
