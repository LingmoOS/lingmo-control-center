// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 应用：默认程序等（后续补充“已安装应用”列表）
DccObject {
    name: "apps"
    parentName: "root"
    displayName: qsTr("Apps")
    description: qsTr("Default programs and installed applications")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/apps-light.svg"
    weight: 60
}
