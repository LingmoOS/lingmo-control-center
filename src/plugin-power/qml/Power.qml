// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import org.deepin.dcc 1.0

DccObject {
    id: power
    name: "power"
    parentName: "root"
    displayName: qsTr("Power Management")
    description: qsTr("Power saving settings, screen and suspend")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/power-light.svg"
    weight: 130

    visible: true
    DccDBusInterface {
        property var onBattery
        service: "org.deepin.dde.Power1"
        path: "/org/deepin/dde/Power1"
        inter: "org.deepin.dde.Power1"
        connection: DccDBusInterface.SessionBus
        onOnBatteryChanged: power.visible = true
    }
}
