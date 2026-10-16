// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 辅助功能（侧边栏项）
DccObject {
    name: "accessibility"
    parentName: "root"
    displayName: qsTr("Accessibility")
    description: qsTr("Vision, hearing and interaction aids")
    // 侧栏图标：DccObject 的 iconSource 只读（由 icon 派生），故写可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/accessibility-light.svg"
    weight: 110
}
