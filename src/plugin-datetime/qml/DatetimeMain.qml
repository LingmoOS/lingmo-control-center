// SPDX-FileCopyrightText: 2026 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import org.deepin.dcc 1.0

DccObject {
    // 侧边栏入口：「时间与语言」
    TimeAndLanguage {}

    // 「时间与语言」下的「时间和日期」子节点
    Datetime {}

    // 「时间和日期」页面内容（其子 DccObject 挂在 "datetime" 下）
    TimeAndDate {}

    // 「时间与语言」下的「语言和格式」子节点（需要 LangSelector1 服务可用才显示）
    DccObject {
        id: langAndFormat
        name: "langAndFormat"
        parentName: "timeAndLanguage"
        displayName: qsTr("Language and region")
        description: qsTr("System language, regional formats")
        icon: "dcc_lang_format"
        weight: 20
        visible: false
        DccDBusInterface {
            property var locales
            service: "org.deepin.dde.LangSelector1"
            path: "/org/deepin/dde/LangSelector1"
            inter: "org.deepin.dde.LangSelector1"
            connection: DccDBusInterface.SessionBus
            onLocalesChanged: langAndFormat.visible = true
        }
        LangAndFormat {}
    }
}
