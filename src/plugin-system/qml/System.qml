// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.0
import QtQuick.Controls 2.0

import org.deepin.dtk 1.0 as D

import org.deepin.dcc 1.0

DccObject {
    id: root
    name: "system"
    parentName: "root"
    displayName: qsTr("System")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/system-light.svg"
    weight: 20

    DccTitleObject {
        name: "common"
        parentName: "system"
        displayName: qsTr("Common settings")
        weight: 5
        onParentItemChanged: {
            if (parentItem) {
                parentItem.topPadding = 10
            }
        }
    }
}
