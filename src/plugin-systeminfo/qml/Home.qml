// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.deepin.dtk 1.0
import org.deepin.dcc 1.0

// 侧边栏首项：主页
// 设备概览（名称/系统/处理器/内存/内核）+ 系统更新入口 + 常用设置入口
DccObject {
    id: homeRoot

    // 单行“标题 : 值”卡片
    component InfoRow: DccObject {
        property string rowTitle: ""
        property string rowValue: ""
        parentName: "home"
        pageType: DccObject.Item
        backgroundType: DccObject.Normal
        page: RowLayout {
            Layout.fillWidth: true
            Label {
                Layout.leftMargin: 10
                Layout.preferredWidth: 140
                text: rowTitle
                opacity: 0.7
            }
            Label {
                Layout.fillWidth: true
                text: rowValue
                elide: Text.ElideRight
                wrapMode: Text.NoWrap
            }
        }
    }

    InfoRow {
        name: "homeDeviceName"
        weight: 10
        rowTitle: qsTr("Device name")
        rowValue: dccData.systemInfoMode().hostName
    }
    InfoRow {
        name: "homeSystem"
        weight: 20
        rowTitle: qsTr("System")
        rowValue: dccData.systemInfoMode().osName + " " + dccData.systemInfoMode().osVersion
    }
    InfoRow {
        name: "homeProcessor"
        weight: 30
        rowTitle: qsTr("Processor")
        rowValue: dccData.systemInfoMode().processor
    }
    InfoRow {
        name: "homeMemory"
        weight: 40
        rowTitle: qsTr("Memory")
        rowValue: dccData.systemInfoMode().memory
    }
    InfoRow {
        name: "homeKernel"
        weight: 50
        rowTitle: qsTr("Kernel")
        rowValue: dccData.systemInfoMode().kernel
    }

    // 系统更新：跳转到“系统更新”页
    DccObject {
        name: "homeUpdate"
        parentName: "home"
        weight: 60
        pageType: DccObject.Item
        backgroundType: DccObject.Normal
        page: RowLayout {
            Layout.fillWidth: true
            Label {
                Layout.leftMargin: 10
                Layout.fillWidth: true
                text: qsTr("Updates")
                opacity: 0.7
            }
            Button {
                text: qsTr("Check for updates")
                onClicked: DccApp.showPage("update")
            }
        }
    }

    // 常用设置入口
    DccObject {
        name: "homeShortcuts"
        parentName: "home"
        weight: 70
        pageType: DccObject.Item
        backgroundType: DccObject.Normal
        page: ColumnLayout {
            Layout.fillWidth: true
            Label {
                Layout.leftMargin: 10
                Layout.topMargin: 6
                text: qsTr("Common settings")
                opacity: 0.7
            }
            Flow {
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.bottomMargin: 10
                spacing: 8
                Button { text: qsTr("Network");        onClicked: DccApp.showPage("network") }
                Button { text: qsTr("Personalization"); onClicked: DccApp.showPage("personalization") }
                Button { text: qsTr("Display");        onClicked: DccApp.showPage("display") }
                Button { text: qsTr("Sound");          onClicked: DccApp.showPage("sound") }
                Button { text: qsTr("About This PC");  onClicked: DccApp.showPage("system/systemInfo") }
            }
        }
    }
}
