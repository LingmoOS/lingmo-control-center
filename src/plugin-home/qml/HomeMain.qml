// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.deepin.dtk 1.0 as D
import org.deepin.dcc 1.0

// 主页内容（卡片式）：
//   概览卡 —— 设备名 + 系统版本
//   规格卡 —— 处理器 / 内存 / 内核
//   更新卡 —— 打开「系统更新」模块
//   快捷卡 —— 常用设置入口，点击跳转到对应模块
//
// 设备信息由插件后端（operation/homeinteraction）注入为 dccData；后端没加载时
// dccData 为 undefined，deviceInfo 随之为 null，各值回退显示占位符。
//
// 卡片沿用仓库既有写法：pageType: DccObject.Item + backgroundType: DccObject.Normal
// 单行成卡，分组用 DccGroupView（子项各自 DccObject.Normal），小标题用 DccTitleObject。
DccObject {
    id: homeMain

    readonly property var deviceInfo: typeof dccData === "undefined" ? null : dccData

    // 取设备信息里的一个字段，缺失时统一显示占位符
    function infoValue(value) {
        return value && value.length > 0 ? value : "—"
    }

    // ------------------------------------------------------------------
    // 顶部概览卡：设备名做醒目大字，系统版本做副标题
    // ------------------------------------------------------------------
    DccObject {
        name: "homeOverview"
        parentName: "home"
        weight: 10
        pageType: DccObject.Item
        backgroundType: DccObject.Normal

        property string deviceName: homeMain.infoValue(homeMain.deviceInfo ? homeMain.deviceInfo.deviceName : "")
        property string osName: homeMain.infoValue(homeMain.deviceInfo ? homeMain.deviceInfo.osName : "")

        page: ColumnLayout {
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: 18
                spacing: 18

                D.DciIcon {
                    Layout.alignment: Qt.AlignVCenter
                    name: "dcc_nav_systeminfo"
                    sourceSize: Qt.size(48, 48)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t3
                        text: deviceName
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t8
                        opacity: 0.6
                        text: osName
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------------
    // 规格卡：处理器 / 内存 / 内核
    // ------------------------------------------------------------------
    DccTitleObject {
        name: "homeSpecsTitle"
        parentName: "home"
        displayName: qsTr("Specifications")
        weight: 20
    }

    DccObject {
        name: "homeSpecs"
        parentName: "home"
        weight: 30
        pageType: DccObject.Item
        page: DccGroupView {}

        // 规格行：图标 + 标题 + 值（值用次要色）
        DccObject {
            name: "homeProcessor"
            parentName: "home/homeSpecs"
            weight: 10
            pageType: DccObject.Item
            backgroundType: DccObject.Normal

            property string specIcon: "cpu"
            property string specTitle: qsTr("Processor")
            property string specValue: homeMain.infoValue(homeMain.deviceInfo ? homeMain.deviceInfo.cpuModel : "")

            page: RowLayout {
                spacing: 14

                D.DciIcon {
                    Layout.leftMargin: 14
                    Layout.alignment: Qt.AlignVCenter
                    name: specIcon
                    sourceSize: Qt.size(24, 24)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.rightMargin: 14
                    Layout.topMargin: 12
                    Layout.bottomMargin: 12
                    spacing: 3

                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t6
                        text: specTitle
                        elide: Text.ElideRight
                    }
                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t8
                        opacity: 0.6
                        text: specValue
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }
            }
        }

        DccObject {
            name: "homeMemory"
            parentName: "home/homeSpecs"
            weight: 20
            pageType: DccObject.Item
            backgroundType: DccObject.Normal

            property string specIcon: "dialog-memory"
            property string specTitle: qsTr("Memory")
            property string specValue: homeMain.infoValue(homeMain.deviceInfo ? homeMain.deviceInfo.memTotal : "")

            page: RowLayout {
                spacing: 14

                D.DciIcon {
                    Layout.leftMargin: 14
                    Layout.alignment: Qt.AlignVCenter
                    name: specIcon
                    sourceSize: Qt.size(24, 24)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.rightMargin: 14
                    Layout.topMargin: 12
                    Layout.bottomMargin: 12
                    spacing: 3

                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t6
                        text: specTitle
                        elide: Text.ElideRight
                    }
                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t8
                        opacity: 0.6
                        text: specValue
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }
            }
        }

        DccObject {
            name: "homeKernel"
            parentName: "home/homeSpecs"
            weight: 30
            pageType: DccObject.Item
            backgroundType: DccObject.Normal

            property string specIcon: "system"
            property string specTitle: qsTr("Kernel")
            property string specValue: homeMain.infoValue(homeMain.deviceInfo ? homeMain.deviceInfo.kernelVersion : "")

            page: RowLayout {
                spacing: 14

                D.DciIcon {
                    Layout.leftMargin: 14
                    Layout.alignment: Qt.AlignVCenter
                    name: specIcon
                    sourceSize: Qt.size(24, 24)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.rightMargin: 14
                    Layout.topMargin: 12
                    Layout.bottomMargin: 12
                    spacing: 3

                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t6
                        text: specTitle
                        elide: Text.ElideRight
                    }
                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t8
                        opacity: 0.6
                        text: specValue
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }
            }
        }
    }

    // ------------------------------------------------------------------
    // 系统更新卡：一条入口，点击打开「系统更新」模块。
    // 卡片背景由内部的 ItemDelegate 提供（DccItemBackground + ClickStyle），
    // 与 HomePage.qml 里模块卡片的写法一致。
    // ------------------------------------------------------------------
    DccObject {
        name: "homeUpdate"
        parentName: "home"
        weight: 40
        pageType: DccObject.Item

        page: D.ItemDelegate {
            readonly property int corners: D.RoundRectangle.TopLeftCorner | D.RoundRectangle.TopRightCorner
                                          | D.RoundRectangle.BottomLeftCorner | D.RoundRectangle.BottomRightCorner

            implicitHeight: 66
            padding: 0
            hoverEnabled: true
            activeFocusOnTab: false

            background: DccItemBackground {
                backgroundType: DccObject.ClickStyle
                separatorVisible: false
            }

            contentItem: RowLayout {
                spacing: 14

                D.DciIcon {
                    Layout.leftMargin: 14
                    Layout.alignment: Qt.AlignVCenter
                    name: "dcc_nav_update"
                    sourceSize: Qt.size(28, 28)
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 3

                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t6
                        text: qsTr("System update")
                        elide: Text.ElideRight
                    }
                    Label {
                        Layout.fillWidth: true
                        font: D.DTK.fontManager.t8
                        opacity: 0.5
                        text: qsTr("Check for and install system updates")
                        elide: Text.ElideRight
                    }
                }

                D.DciIcon {
                    Layout.rightMargin: 14
                    Layout.alignment: Qt.AlignVCenter
                    name: "arrow_ordinary_right"
                    sourceSize: Qt.size(16, 16)
                }
            }

            onClicked: DccApp.showPage("update")
        }
    }

    // ------------------------------------------------------------------
    // 常用设置卡：6 个快捷入口，点击跳转到对应模块
    // ------------------------------------------------------------------
    DccTitleObject {
        name: "homeShortcutsTitle"
        parentName: "home"
        displayName: qsTr("Common settings")
        weight: 50
    }

    DccObject {
        name: "homeShortcuts"
        parentName: "home"
        weight: 60
        pageType: DccObject.Item
        backgroundType: DccObject.Normal

        page: ColumnLayout {
            GridLayout {
                Layout.fillWidth: true
                Layout.margins: 12
                columns: 3
                rowSpacing: 4
                columnSpacing: 4

                HomeShortcutTile {
                    Layout.fillWidth: true
                    tileIcon: "dcc_nav_personalization"
                    tileText: qsTr("Personalization")
                    targetPage: "personalization"
                }
                HomeShortcutTile {
                    Layout.fillWidth: true
                    tileIcon: "display"
                    tileText: qsTr("Display")
                    targetPage: "display"
                }
                HomeShortcutTile {
                    Layout.fillWidth: true
                    tileIcon: "network"
                    tileText: qsTr("Network")
                    targetPage: "network"
                }
                HomeShortcutTile {
                    Layout.fillWidth: true
                    tileIcon: "dcc_nav_power"
                    tileText: qsTr("Power")
                    targetPage: "power"
                }
                HomeShortcutTile {
                    Layout.fillWidth: true
                    tileIcon: "dcc_nav_sound"
                    tileText: qsTr("Sound")
                    targetPage: "sound"
                }
                HomeShortcutTile {
                    Layout.fillWidth: true
                    tileIcon: "dcc_nav_datetime"
                    tileText: qsTr("Date and time")
                    targetPage: "timeAndLanguage"
                }
            }
        }
    }
}