// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.deepin.dtk 1.0
import org.deepin.dcc 1.0

// 应用 -> 已安装应用：列出本机应用并可搜索、启动
// 数据来自 DefAppModel::installedApps()（扫描 /usr/share/applications 与 ~/.local/share/applications）
DccObject {
    name: "installedApps"
    parentName: "apps"
    displayName: qsTr("Installed applications")
    description: qsTr("Browse and launch installed applications")
    icon: "default_program"
    weight: 20
    pageType: DccObject.Item
    backgroundType: DccObject.Normal

    page: ColumnLayout {
        id: appsPage
        Layout.fillWidth: true
        property var allApps: dccData.installedApps

        TextField {
            id: appSearch
            Layout.fillWidth: true
            Layout.margins: 10
            placeholderText: qsTr("Search applications")
        }

        ListView {
            id: appList
            Layout.fillWidth: true
            Layout.preferredHeight: 420
            clip: true
            model: {
                var kw = appSearch.text.toLowerCase()
                if (!kw)
                    return appsPage.allApps
                return appsPage.allApps.filter(function (a) {
                    return a.name.toLowerCase().indexOf(kw) >= 0
                })
            }
            delegate: ItemDelegate {
                width: ListView.view.width
                text: modelData.name
                icon.name: modelData.icon ? modelData.icon : ""
                onClicked: dccData.launchApp(modelData.file)
            }
            ScrollBar.vertical: ScrollBar {}
        }

        Label {
            Layout.margins: 10
            visible: appList.count === 0
            text: qsTr("No applications found")
            opacity: 0.7
        }
    }
}
