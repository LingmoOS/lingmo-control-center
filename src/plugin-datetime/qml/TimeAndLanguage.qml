// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 时间和语言：原“时间和日期”“语言和格式”合并为侧边栏一项
DccObject {
    name: "timeAndLanguage"
    parentName: "root"
    displayName: qsTr("Time and Language")
    description: qsTr("Date, time, language and formats")
    // DccObject 的 iconSource 是只读（由 icon 派生），这里必须用可写的 icon
    icon: "file:///usr/share/dde-control-center/icons/sidebar/timeAndLanguage-light.svg"
    weight: 100
}
