// SPDX-FileCopyrightText: 2024 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later

import org.deepin.dcc 1.0

DccObject {
    name: "accounts"
    parentName: "root"
    displayName: qsTr("Accounts")
    description: qsTr("Account manager")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/accounts-light.svg"
    weight: 70
}

