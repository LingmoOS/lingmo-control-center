// SPDX-FileCopyrightText: 2026 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import org.deepin.dcc 1.0

DccObject {
    name: "notification"
    parentName: "root"
    displayName: qsTr("Notification")
    description: qsTr("DND mode, app notifications")
    icon: "dcc_notification"
    // 双色 SVG（Tabler, MIT）：实际变体由 delegate 按主题/选中态选择
    iconSource: "file:///usr/share/dde-control-center/icons/sidebar/notification-light.svg"
    weight: 80
}
