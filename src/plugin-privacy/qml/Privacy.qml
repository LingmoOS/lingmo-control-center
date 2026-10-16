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
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/privacy-light.svg"
    weight: 120
    visible: true
}
