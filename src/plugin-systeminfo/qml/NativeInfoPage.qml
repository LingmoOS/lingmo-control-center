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

    DccObject {
        name: "systemLogo"
        weight: 20
        parentName: "systemInfo"
        pageType: DccObject.Item
        backgroundType: DccObject.Normal
        visible: dccData.systemInfoMode().showDetail
        page: ColumnLayout{

            Image {
                Layout.topMargin: 25
                Layout.alignment: Qt.AlignHCenter
                sourceSize.width: 310
                source: "file://" + dccData.systemInfoMode().logoPath
            }

            RowLayout{
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 5
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: qsTr("Powered by ")
                }
                Image {
                    source: "file:///usr/share/pixmaps/debian-logo.png"
                    sourceSize.width: 16
                }
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: qsTr("Debian %1").arg(dccData.systemInfoMode().debianVersion)
                }
            }
            // Label {
            //     Layout.alignment: Qt.AlignHCenter
            //     text: dccData.systemInfoMode().systemCopyright
            //     Layout.bottomMargin: 25
            //     horizontalAlignment: Text.AlignHCenter
            //     wrapMode: Text.Wrap
            //     Layout.preferredWidth: parent ? parent.width : implicitWidth
            // }
        }
    }


    // DccObject {
    //     name: "authorizationSection"
    //     weight: 20
    //     parentName: "systemInfo"
    //     pageType: DccObject.Item
    //     backgroundType: DccObject.Normal
    //     // visible: dccData.systemInfoMode().showDetail && dccData.systemInfoMode().showAuthorization()
    //     page: RowLayout {
    //         Layout.alignment: Qt.AlignHCenter
    //         Layout.topMargin: 16
    //         Layout.bottomMargin: 8
    //         spacing: 12

    //         // 状态图标
    //         Label {
    //             font.pixelSize: 18
    //             text: dccData.systemInfoMode().licenseStatus === 1 ? "\u2713" : "\u26A0"
    //             color: dccData.systemInfoMode().licenseStatusColor
    //         }

    //         // 状态文字
    //         Label {
    //             id: licenseLabel
    //             font.pixelSize: 14
    //             color: dccData.systemInfoMode().licenseStatusColor
    //             text: dccData.systemInfoMode().licenseStatusText
    //         }

    //         // 操作按钮
    //         Button {
    //             id: licenseActionBtn
    //             text: dccData.systemInfoMode().licenseActionText
    //             ColorSelector.family: Palette.CommonColor
    //             implicitHeight: 32
    //             implicitWidth: licenseActionBtnMetrics.width + 24
    //             flat: false
    //             visible: dccData.systemInfoMode().showDetail && dccData.systemInfoMode().licenseActionText !== ""
    //             onClicked: {
    //                 dccData.systemInfoWork().showActivatorDialog()
    //             }
    //             ToolTip.visible: licenseActionBtn.hovered && licenseActionBtnMetrics.width > licenseActionBtn.availableWidth
    //             ToolTip.text: licenseActionBtn.text
    //             ToolTip.delay: 500
    //             TextMetrics {
    //                 id: licenseActionBtnMetrics
    //                 font: licenseActionBtn.font
    //                 text: licenseActionBtn.text
    //             }
    //         }
    //     }
    // }

    DccObject {
        name: "nativeInfoGrp"
        parentName: "systemInfo"
        weight: 20
        pageType: DccObject.Item
        page: ColumnLayout {
            DccGroupView {
            }
        }
        DccObject {
            name: "hostName"
            weight: 10
            parentName: "nativeInfoGrp"
            displayName: qsTr("Computer name") + ":"
            backgroundType: DccObject.Normal
            visible: dccData.systemInfoMode().showDetail
            pageType: DccObject.Editor
            page: RowLayout {
                Label {
                    id: hostNameLabel
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
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
                    icon.name: "dcc_systemInfo_edit"
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
                        onClicked: function(mouse) {
                            mouse.accepted = true
                        }
                    }
                    
                    onVisibleChanged: {
                        if (!visible && showAlert) {
                            showAlert = false
                        }
                    }

                    Connections {
                        target: DccApp
                        function onActiveObjectChanged(object) {
                            if (hostNameEdit.showAlert) {
                                hostNameEdit.showAlert = false
                            }
                        }
                    }

                    onTextChanged: {
                        if (showAlert)
                            showAlert = false
                            
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
                        }
                        else if ((event.modifiers & Qt.ControlModifier) && 
                                (event.key === Qt.Key_C || event.key === Qt.Key_V || event.key === Qt.Key_X)) {
                            event.accepted = true
                        }
                    }
                }
            }
        }
    }

    DccObject {
        name: "systemInfoDetail"
        weight: 30
        pageType: DccObject.Item
        page: 
            DccGroupView {
            }
        
        DccObject {
            name: "productName"
            weight: 20
            parentName: "nativeInfoGrp"
            displayName: qsTr("OS Name")
            backgroundType: DccObject.Normal
            pageType: DccObject.Editor
            page: Label {
                Layout.alignment: Qt.AlignRight | Qt.AlignTop
                text: dccData.systemInfoMode().productName
            }
            // page: Image {
            //     sourceSize.height: 16
            //     source: "file://" + dccData.systemInfoMode().logoPath
            // }
        }
        DccObject {
            name: "versionNumber"
            weight: 30
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Version")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().versionNumber
            }
        }
        DccObject {
            name: "buildVersion"
            weight: 40
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Build Version")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().buildVersion
            }
        }
        DccObject {
            name: "debianVersion"
            weight: 50
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Debian Version")
            page: RowLayout{
                Image {
                    source: "file:///usr/share/pixmaps/debian-logo.png"
                    sourceSize.width: 16
                }
                Label {
                    horizontalAlignment: Text.AlignLeft
                    text: dccData.systemInfoMode().debianVersion
                }
            }
        }
        // DccObject {
        //     name: "edition"
        //     weight: 40
        //     parentName: "nativeInfoGrp"
        //     pageType: DccObject.Editor
        //     displayName: qsTr("Edition") + ":"
        //     page: Label {
        //         horizontalAlignment: Text.AlignLeft
        //         text: dccData.systemInfoMode().version
        //     }
        // }

        DccObject {
            name: "buildDate"
            weight: 60
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Build Date")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().buildDate
            }
        }

        DccObject {
            name: "type"
            weight: 70
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Type")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().type + qsTr("bit")
            }
        }

        // DccObject {
        //     name: "authorization"
        //     weight: 60
        //     parentName: "nativeInfoGrp"
        //     pageType: DccObject.Editor
        //     displayName: qsTr("Authorization") + ":"
        //     visible: dccData.systemInfoMode().showAuthorization()
        //     page: RowLayout {
        //         spacing: 8
        //         Label {
        //             id: jihuo
        //             color: dccData.systemInfoMode().licenseStatusColor
        //             horizontalAlignment: Text.AlignLeft
        //             text: dccData.systemInfoMode().licenseStatusText
        //         }

        //         Button {
        //             id: licenseActionBtn
        //             text: dccData.systemInfoMode().licenseActionText
        //             ColorSelector.family: Palette.CommonColor
        //             implicitHeight: 30
        //             implicitWidth: licenseActionBtnMetrics.width + 2 * (DS.Style.button.hPadding + DS.Style.control.borderWidth)
        //             flat: false
        //             visible: dccData.systemInfoMode().showDetail
        //             onClicked: {
        //                 dccData.systemInfoWork().showActivatorDialog()
        //             }
        //             ToolTip.visible: licenseActionBtn.hovered && licenseActionBtnMetrics.width > licenseActionBtn.availableWidth
        //             ToolTip.text: licenseActionBtn.text
        //             ToolTip.delay: 500
        //             TextMetrics {
        //                 id: licenseActionBtnMetrics
        //                 font: licenseActionBtn.font
        //                 text: licenseActionBtn.text
        //             }
        //         }
        //     }
        // }

        DccObject {
            name: "systemInstallationTime"
            weight: 80
            visible: dccData.systemInfoMode().showAuthorization()
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("System installation time")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().systemInstallationDate
            }
        }

        DccObject {
            name: "kernel"
            weight: 90
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Kernel")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().kernel
            }
        }
    }

    DccObject {
        name: "systemHardwareGrp"
        weight: 60
        parentName: "systemInfo"
        pageType: DccObject.Item
        page: ColumnLayout {
            DccGroupView {
            }
        }
        DccObject {
            name: "graphicsPlatform"
            weight: 100
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            visible: dccData.systemInfoMode().showGraphicsPlatform()
            displayName: qsTr("Graphics Platform")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().graphicsPlatform
            }
        }

        DccObject {
            id: processorObj
            name: "processor"
            weight: 110
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Processor")

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

        DccObject {
            name: "memory"
            weight: 120
            parentName: "nativeInfoGrp"
            pageType: DccObject.Editor
            displayName: qsTr("Memory")
            page: Label {
                horizontalAlignment: Text.AlignLeft
                text: dccData.systemInfoMode().memory
            }
        }
    }

    // DccObject {
    //     name: "detailBtn"
    //     weight: 60
    //     parentName: "systemInfo"
    //     pageType: DccObject.Item
    //     visible: !dccData.systemInfoMode().showDetail
    //     page: RowLayout {

    //         Button {
    //             Layout.topMargin: 10
    //             implicitWidth: 250
    //             implicitHeight: 30
    //             Layout.alignment: Qt.AlignHCenter
    //             text: "显示详细信息"
    //             font: DTK.fontManager.t6
    //             opacity: 0.7
    //             onClicked: {
    //                 dccData.systemInfoWork().showDetail()
    //             }
    //         }
    //     }
    // }
}