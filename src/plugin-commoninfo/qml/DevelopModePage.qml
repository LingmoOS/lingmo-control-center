// SPDX-FileCopyrightText: 2024 - 2026 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
// import org.deepin.dtk 1.0 as D
import QtQuick 2.15
import QtQuick.Controls 2.15
import org.deepin.dtk 1.0 as D

import org.deepin.dcc 1.0
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt.labs.platform 1.1
import org.deepin.dtk.style 1.0 as DS

DccObject {
    DccObject {
        name: "developTitle"
        parentName: "developerMode"
        displayName: qsTr("Root Access")
        weight: 10
        visible: !dccData.mode().isCommunitySystem()
        pageType: DccObject.Item
        page: Label {
            leftPadding: 15
            bottomPadding: -2
            text: dccObj.displayName
            font.pixelSize: D.DTK.fontManager.t5.pixelSize
            font.weight: 500
            color: D.DTK.themeType === D.ApplicationHelper.LightType ?
                    Qt.rgba(0, 0, 0, 1) : Qt.rgba(1, 1, 1, 1)
        }
    }

    DccObject {
        name: "developDebugTitle"
        parentName: "developerMode"
        displayName: qsTr("Development and debugging options")
        weight: 20
        pageType: DccObject.Item
        page: Label {
            topPadding: 5
            leftPadding: 15
            bottomPadding: -2
            text: dccObj.displayName
            font.pixelSize: D.DTK.fontManager.t5.pixelSize
            font.weight: 500
            color: D.DTK.themeType === D.ApplicationHelper.LightType ?
                    Qt.rgba(0, 0, 0, 1) : Qt.rgba(1, 1, 1, 1)
        }
    }

    DccObject {
        name: "developDebugGrp"
        parentName: "developerMode"
        weight: 60
        pageType: DccObject.Item

        page: DccGroupView {

            Layout.topMargin: 0
        }

        DccObject {
            name: "developDebug"
            parentName: "developDebugGrp"
            displayName: qsTr("System logging level")
            description: qsTr("Changing the options results in more detailed logging that may degrade system performance and/or take up more storage space.")
            weight: 10
            backgroundType: DccObject.Normal
            pageType: DccObject.Editor
            page:  Row{
                ComboBox {
                    id: debugLogCombo
                    model: [ qsTr("Off"), qsTr("Debug") ]
                    flat: true
                    font: D.DTK.fontManager.t8
                    currentIndex: dccData.mode().debugLogCurrentIndex
                    onCurrentIndexChanged: {
                        console.log("Selected index:", currentIndex)
                        if (currentIndex !== dccData.mode().debugLogCurrentIndex) {
                            dccData.work().setLogDebug(currentIndex)
                        }
                    }
                }
            }
        }

        DccObject {
            name: "developDebugTips"
            parentName: "developDebugGrp"
            weight: 20
            pageType: DccObject.Item
            page: Label {
                leftPadding: 15
                bottomPadding: 5
                topPadding: 5
                rightPadding: 10
                text: qsTr("Changing the option may take up to a minute to process, after receiving a successful setting prompt, please reboot the device to take effect.")
                font: D.DTK.fontManager.t10
                opacity: 0.5
                wrapMode: Text.WordWrap
            }
        }


    }

    DccObject {
        name: "developReadOnlyProtection"
        parentName: "developerMode"
        displayName: qsTr("Solid System Read-Only Protection")
        weight: 70
        visible: dccData.work().showReadOnlyProtection()
        canSearch: visible
        backgroundType: DccObject.Normal
        pageType: DccObject.Item
        page: RowLayout {
            Layout.topMargin: 5
            ColumnLayout {
                spacing: 2
                Layout.leftMargin: 15
                Layout.topMargin: 5
                Layout.bottomMargin: 5
                Label {
                    text: dccObj.displayName
                    font: D.DTK.fontManager.t6
                }

                Label {
                    horizontalAlignment: Text.AlignLeft
                    wrapMode: Text.WordWrap
                    text: dccData.mode().readOnlyProtectionEnabled
                            ? qsTr("Disabling protection unlocks system directories，This action carries a high risk of system damage.")
                            : qsTr("Enable protection to lock system directories and ensure optimal stability.")
                    font: D.DTK.fontManager.t10
                    opacity: 0.5

                    Layout.fillWidth: true
                }
            }

            Switch {
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 10
                implicitWidth: 50
                checked: dccData.mode().readOnlyProtectionEnabled
                onClicked: {
                    console.log("Read-Only Protection switched to:", checked, "current state:", dccData.mode().readOnlyProtectionEnabled)

                    dccData.work().setReadOnlyProtectionEnabled(checked)
                }
            }
        }
    }
}
