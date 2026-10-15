// SPDX-FileCopyrightText: 2025 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import org.deepin.dcc 1.0
import org.deepin.dtk 1.0 as D

DccObject {
    name: "privacy"
    parentName: "root"
    displayName: qsTr("Privacy and Security")
    description: qsTr("Camera, folder permissions")
    icon: "privacy"
    // 双色 SVG（Tabler, MIT）：实际变体由 delegate 按主题/选中态选择
    iconSource: "file:///usr/share/dde-control-center/icons/sidebar/privacy-light.svg"
    weight: 120
    visible: true
}
