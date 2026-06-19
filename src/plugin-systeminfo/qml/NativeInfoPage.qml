// SPDX-FileCopyrightText: 2024 - 2026 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import org.deepin.dtk 1.0
import org.deepin.dcc 1.0
import org.deepin.dtk.style 1.0 as DS

DccObject {
    id: root11

    // ========== Logo 区域：圆角卡片 + 阴影效果 ==========
    DccObject {
        name: "systemDetailLogo"
        weight: 10
        parentName: "systemInfo"
        pageType: DccObject.Item
        backgroundType: DccObject.Normal
        visible: dccData.systemInfoMode().showDetail
        page: ColumnLayout {
            spacing: 16

            // 卡片容器
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
                Layout.preferredWidth: Math.min(parent.width * 0.7, 280)
                Layout.preferredHeight: logoColumn.implicitHeight + 48
                radius: 16
                color: "transparent"

                // 渐变背景
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.95) }
                    GradientStop { position: 1.0; color: Qt.rgba(0.95, 0.96, 0.98, 0.9) }
                }

                // 边框
                border.color: Qt.rgba(0, 0, 0, 0.08)
                border.width: 1

                ColumnLayout {
                    id: logoColumn
                    anchors.centerIn: parent
                    spacing: 12

                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: Math.min(120, parent.width * 0.5)
                        Layout.preferredHeight: implicitHeight
                        sourceSize.width: 120
                        fillMode: Image.PreserveAspectFit
                        source: "file://" + dccData.systemInfoMode().logoPath
                    }

                    // 系统名称标题
                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 22
                        font.bold: true
                        color: palette.text
                        text: dccData.systemInfoMode().productName
                    }

                    // 版本号标签
                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        font.pixelSize: 13
                        color: palette.midlight
                        text: dccData.systemInfoMode().versionNumber
                    }

                    // 版权信息
                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 8
                        font.pixelSize: 11
                        color: palette.mid
                        wrapMode: Text.Wrap
                        Layout.preferredWidth: parent ? parent.width - 40 : implicitWidth
                        text: dccData.systemInfoMode().systemCopyright
                    }
                }
            }
        }
    }

    // ========== 授权状态区域 ==========
    DccObject {
        name: "authorizationSection"
        weight: 20
        parentName: "systemInfo"
        pageType: DccObject.Item
        backgroundType: DccObject.Normal
        visible: dccData.systemInfoMode().showDetail && dccData.systemInfoMode().showAuthorization()
        page: RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 16
            Layout.bottomMargin: 8
            spacing: 12

            // 状态图标
            Label {
                font.pixelSize: 18
                text: dccData.systemInfoMode().licenseStatus === 1 ? "\u2713" : "\u26A0"
                color: dccData.systemInfoMode().licenseStatusColor
            }

            // 状态文字
            Label {
                id: licenseLabel
                font.pixelSize: 14
                color: dccData.systemInfoMode().licenseStatusColor
                text: dccData.systemInfoMode().licenseStatusText
            }

            // 操作按钮
            Button {
                id: licenseActionBtn
                text: dccData.systemInfoMode().licenseActionText
                ColorSelector.family: Palette.CommonColor
                implicitHeight: 32
                implicitWidth: licenseActionBtnMetrics.width + 24
                flat: false
                visible: dccData.systemInfoMode().showDetail && dccData.systemInfoMode().licenseActionText !== ""
                onClicked: {
                    dccData.systemInfoWork().showActivatorDialog()
                }
                ToolTip.visible: licenseActionBtn.hovered && licenseActionBtnMetrics.width > licenseActionBtn.availableWidth
                ToolTip.text: licenseActionBtn.text
                ToolTip.delay: 500
                TextMetrics {
                    id: licenseActionBtnMetrics
                    font: licenseActionBtn.font
                    text: licenseActionBtn.text
                }
            }
        }
    }

    // ========== 系统信息组：带图标的信息项 ==========
    DccObject {
        name: "nativeInfoGrp"
        parentName: "systemInfo"
        weight: 40
        pageType: DccObject.Item
        page: ColumnLayout {
            spacing: 2

            DccGroupView {
            }

            // 计算机名称（可编辑）
            DccObject {
                name: "productName"
                weight: 10
                parentName: "nativeInfoGrp"
                displayName: qsTr("Computer name") + ":"
                icon: "computer"
                backgroundType: DccObject.Normal
                visible: dccData.systemInfoMode().showDetail
                pageType: DccObject.Editor
                page: RowLayout {
                    spacing: 8

                    Label {
                        id: hostNameLabel
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        Layout.fillWidth: true
                        elide: Text.ElideMiddle
                        text: dccData.systemInfoMode().hostName
                        ToolTip {
                            text: hostNameLabel.text
                            delay: 500
                            visible: hostNameArea.containsMouse
                        }
                        MouseArea {
                            id: hostNameArea
                            anchors.fill: parent
                            hoverEnabled: true
                        }
                    }

                    ActionButton {
                        id: editBtn
                        icon.name: "edit"
                        icon.width: 16
                        icon.height: 16
                        implicitWidth: 30
                        implicitHeight: 30
                        flat: !hovered
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        palette.windowText: ColorSelector.textColor
                        background: Rectangle {
                            property Palette pressedColor: Palette {
                                normal: Qt.rgba(0, 0, 0, 0.2)
                                normalDark: Qt.rgba(0, 0, 0, 0.15)
                            }
                            property Palette hoveredColor: Palette {
                                normal: Qt.rgba(0, 0, 0, 0.1)
                                normalDark: Qt.rgba(1, 1, 1, 0.1)
                            }
                            radius: DS.Style.control.radius
                            color: parent.pressed ? ColorSelector.pressedColor : (parent.hovered ? ColorSelector.hoveredColor : "transparent")
                            border {
                                color: parent.palette.highlight
                                width: parent.visualFocus ? DS.Style.control.focusBorderWidth : 0
                            }
                        }
                        onClicked: {
                            editBtn.visible = false
                            hostNameLabel.visible = false
                            hostNameEdit.visible = true
                            hostNameEdit.text = dccData.systemInfoMode().hostName
                            hostNameEdit.selectAll()
                            hostNameEdit.forceActiveFocus()
                        }
                    }

                    LineEdit {
                        id: hostNameEdit
                        horizontalAlignment: TextInput.AlignLeft
                        text: dccData.systemInfoMode().hostName
                        visible: false
                        showAlert: false
                        alertDuration: 3000
                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.RightButton
                            onClicked: function(mouse) { mouse.accepted = true }
                        }
                        onVisibleChanged: { if (!visible && showAlert) showAlert = false }
                        Connections {
                            target: DccApp
                            function onActiveObjectChanged(object) {
                                if (hostNameEdit.showAlert) hostNameEdit.showAlert = false
                            }
                        }
                        onTextChanged: {
                            if (showAlert) showAlert = false
                            if (text.length > 63) {
                                var cursorPos = cursorPosition
                                text = text.slice(0, 63)
                                cursorPosition = Math.min(cursorPos, text.length)
                                showAlert = true
                                alertText = qsTr("1~63 characters please")
                                dccData.systemInfoWork().playSystemSound(14)
                                return
                            }
                            if (!/^[A-Za-z0-9-]{0,63}$/.test(text)) {
                                var cursorPos = cursorPosition
                                var filteredText = text.replace(/[^A-Za-z0-9-]/g, "")
                                filteredText = filteredText.slice(0, 63)
                                if (filteredText !== text) {
                                    text = filteredText
                                    cursorPosition = Math.min(cursorPos, text.length)
                                    dccData.systemInfoWork().playSystemSound(14)
                                }
                            }
                        }
                        onEditingFinished: {
                            editBtn.forceActiveFocus()
                            if (hostNameEdit.text.length === 0) {
                                editBtn.visible = true
                                hostNameLabel.visible = true
                                hostNameEdit.visible = false
                                hostNameEdit.showAlert = false
                                return
                            }
                            if ((hostNameEdit.text.indexOf('-') === 0 || hostNameEdit.text.lastIndexOf('-') === hostNameEdit.text.length - 1) && hostNameEdit.text.length <= 63) {
                                hostNameEdit.showAlert = true
                                hostNameEdit.alertText = qsTr("It cannot start or end with dashes")
                                dccData.systemInfoWork().playSystemSound(14)
                                return
                            }
                            editBtn.visible = true
                            hostNameLabel.visible = true
                            hostNameEdit.visible = false
                            hostNameEdit.showAlert = false
                            dccData.systemInfoWork().onSetHostname(hostNameEdit.text)
                        }
                        Keys.onPressed: function(event) {
                            if (event.key === Qt.Key_Return) {
                                hostNameEdit.forceActiveFocus(false);
                            } else if ((event.modifiers & Qt.ControlModifier) &&
                                       (event.key === Qt.Key_C || event.key === Qt.Key_V || event.key === Qt.Key_X)) {
                                event.accepted = true
                            }
                        }
                    }
                }
            }

            // 操作系统名称
            DccObject {
                name: "hostName"
                weight: 20
                parentName: "nativeInfoGrp"
                displayName: qsTr("OS Name") + ":"
                icon: "os_name"
                backgroundType: DccObject.Normal
                pageType: DccObject.Editor
                page: Label {
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: dccData.systemInfoMode().productName
                }
            }

            // 版本号
            DccObject {
                name: "version"
                weight: 30
                parentName: "nativeInfoGrp"
                displayName: qsTr("Version") + ":"
                icon: "version"
                pageType: DccObject.Editor
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().versionNumber
                }
            }

            // 构建版本
            DccObject {
                name: "buildVersion"
                weight: 40
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Build Version") + ":"
                icon: "build"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().buildVersion
                }
            }

            // Debian 版本
            DccObject {
                name: "debianVersion"
                weight: 50
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Debian Version") + ":"
                icon: "debian"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().debianVersion
                }
            }

            // 构建日期
            DccObject {
                name: "buildDate"
                weight: 60
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Build Date") + ":"
                icon: "calendar"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().buildDate
                }
            }

            // 系统类型
            DccObject {
                name: "type"
                weight: 70
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Type") + ":"
                icon: "cpu"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().type + qsTr("bit")
                }
            }

            // 安装时间
            DccObject {
                name: "systemInstallationTime"
                weight: 80
                visible: dccData.systemInfoMode().showAuthorization()
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("System installation time") + ":"
                icon: "time"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().systemInstallationDate
                }
            }

            // 内核版本
            DccObject {
                name: "kernel"
                weight: 90
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Kernel") + ":"
                icon: "kernel"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().kernel
                }
            }

            // 图形平台
            DccObject {
                name: "graphicsPlatform"
                weight: 100
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                visible: dccData.systemInfoMode().showGraphicsPlatform()
                displayName: qsTr("Graphics Platform") + ":"
                icon: "graphics"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().graphicsPlatform
                }
            }

            // 处理器
            DccObject {
                id: processorObj
                name: "processor"
                weight: 110
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Processor") + ":"
                icon: "processor"
                page: Label {
                    id: processorLabel
                    horizontalAlignment: Text.AlignRight
                    wrapMode: Text.Wrap
                    width: processorObj.parentItem
                        ? Math.max(0, processorObj.parentItem.width - displayNameMetrics.width - processorObj.parentItem.leftPadding - 30)
                        : implicitWidth
                    TextMetrics {
                        id: displayNameMetrics
                        text: processorObj.displayName
                        font: processorLabel.font
                    }
                    text: dccData.systemInfoMode().processor
                }
            }

            // 内存
            DccObject {
                name: "memory"
                weight: 120
                parentName: "nativeInfoGrp"
                pageType: DccObject.Editor
                displayName: qsTr("Memory") + ":"
                icon: "memory"
                page: Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().memory
                }
            }
        }
    }
}
