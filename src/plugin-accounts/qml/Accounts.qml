// SPDX-FileCopyrightText: 2024 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later

import org.deepin.dcc 1.0

DccObject {
    name: "accounts"
    parentName: "root"
    displayName: qsTr("Accounts")
    description: qsTr("Account manager")
    icon: "accounts"
    // 双色 SVG（Tabler, MIT）：实际变体由 delegate 按主题/选中态选择
    iconSource: "file:///usr/share/dde-control-center/icons/sidebar/accounts-light.svg"
    weight: 70
}

