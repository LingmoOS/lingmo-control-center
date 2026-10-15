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
    icon: "commoninfo"
    // 双色 SVG（Tabler, MIT）：实际变体由 delegate 按主题/选中态选择
    iconSource: "file:///usr/share/dde-control-center/icons/sidebar/system-light.svg"
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
