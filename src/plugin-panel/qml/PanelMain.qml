// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
//SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.15

import org.deepin.dcc 1.0
import org.deepin.dtk 1.0 as D

DccObject {
    readonly property int modeDelegateWidth: 144
    readonly property int modeDelegateHeight: 72
    readonly property int modeDelegatePadding: 4
    readonly property int modeDelegateRadius: 9

    DccTitleObject {
        name: "classicPanelTitle"
        weight: 500
        parentName: "personalization/panel"
        displayName: qsTr("Classic Panel")
    }

    DccObject {
        name: "panelModeGroup"
        parentName: "personalization/panel"
        weight: 600
        pageType: DccObject.Item
        page: DccGroupView {}

        DccObject {
            name: "panelmode"
            parentName: "personalization/panel/panelModeGroup"
            displayName: qsTr("Mode")
            weight: 10
            pageType: DccObject.Item
            page: ColumnLayout {
                Label {
                    Layout.topMargin: 10
                    font: D.DTK.fontManager.t7
                    text: dccObj.displayName
                    Layout.leftMargin: 10
                }
                Flow {
                    id: modeLayout
                    spacing: 10
                    Layout.fillWidth: true
                    Layout.bottomMargin: 10
                    Layout.leftMargin: 10

                    ListModel {
                        id: modeData
                        ListElement { text: qsTr("Fashion Mode"); icon: "effcient_center"; value: 0 }
                        ListElement { text: qsTr("Efficient Mode"); icon: "effcient_left"; value: 1 }
                    }

                    Repeater {
                        id: modeRepeater
                        model: modeData
                        ColumnLayout {
                            D.ItemDelegate {
                                id: modeDelegate
                                Layout.preferredWidth: modeDelegateWidth
                                Layout.preferredHeight: modeDelegateHeight
                                Layout.alignment: Qt.AlignHCenter
                                Layout.margins: 0
                                checkable: false
                                backgroundVisible: false
                                focusPolicy: Qt.TabFocus
                                activeFocusOnTab: index === 0
                                padding: modeDelegatePadding

                                function activate() {
                                    dccData.panelInter.setDisplayMode(model.value)
                                }

                                background: Rectangle {
                                    radius: modeDelegateRadius
                                    color: "transparent"
                                    border.width: dccData.panelInter.DisplayMode === model.value || modeDelegate.activeFocus ? 2 : 0
                                    border.color: D.DTK.platformTheme.activeColor
                                }

                                contentItem: Control {
                                    id: iconControl

                                    contentItem: D.DciIcon {
                                        palette: D.DTK.makeIconPalette(iconControl.palette)
                                        theme: iconControl.D.ColorSelector.controlTheme
                                        sourceSize: Qt.size(iconControl.width, iconControl.height)
                                        name: model.icon
                                    }
                                }

                                onClicked: activate()
                                Keys.onSpacePressed: activate()
                                Keys.onReturnPressed: activate()

                                Keys.onLeftPressed: {
                                    if (index > 0) {
                                        modeRepeater.itemAt(index - 1).children[0].forceActiveFocus()
                                    }
                                }

                                Keys.onRightPressed: {
                                    if (index < modeRepeater.count - 1) {
                                        modeRepeater.itemAt(index + 1).children[0].forceActiveFocus()
                                    }
                                }
                            }

                            Text {
                                text: model.text
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font: D.DTK.fontManager.t9
                                color: dccData.panelInter.DisplayMode === model.value ?
                                    D.DTK.platformTheme.activeColor : this.palette.windowText
                            }
                        }
                    }
                }
            }
        }
    }

    DccObject {
        name: "panelSettingsGroup"
        parentName: "personalization/panel"
        weight: 700
        pageType: DccObject.Item
        page: DccGroupView {}

        DccObject {
            name: "panelsize"
            parentName: "personalization/panel/panelSettingsGroup"
            displayName: qsTr("Panel size")
            weight: 10
            pageType: DccObject.Editor
            page: RowLayout {
                spacing: 10
                Label {
                    Layout.alignment: Qt.AlignVCenter
                    font: D.DTK.fontManager.t7
                    text: qsTr("Small")
                }
                D.Slider {
                    Layout.alignment: Qt.AlignVCenter
                    handleType: Slider.HandleType.ArrowBottom
                    implicitHeight: 24
                    highlightedPassedGroove: true
                    stepSize: 1
                    value: dccData.panelInter.DisplayMode === 0 ? dccData.panelInter.WindowSizeFashion : dccData.panelInter.WindowSizeEfficient
                    from: 37
                    to: 100

                    onValueChanged: {
                        dccData.panelInter.resizeDock(value, true)
                    }

                    onPressedChanged: {
                        dccData.panelInter.resizeDock(value, pressed)
                    }
                }
                D.Label {
                    Layout.alignment: Qt.AlignVCenter
                    font: D.DTK.fontManager.t7
                    text: qsTr("Large")
                }
            }
        }

        DccObject {
            name: "iconSize"
            parentName: "personalization/panel/panelSettingsGroup"
            displayName: qsTr("Icon size")
            weight: 15
            pageType: DccObject.Editor
            page: RowLayout {
                spacing: 10
                Label {
                    Layout.alignment: Qt.AlignVCenter
                    font: D.DTK.fontManager.t7
                    text: qsTr("Small")
                }
                D.Slider {
                    Layout.alignment: Qt.AlignVCenter
                    handleType: Slider.HandleType.ArrowBottom
                    implicitHeight: 24
                    highlightedPassedGroove: true
                    stepSize: 1
                    value: dccData.panelInter.IconSize
                    from: 16
                    to: 48

                    onValueChanged: {
                        dccData.panelInter.setIconSize(value)
                    }
                }
                D.Label {
                    Layout.alignment: Qt.AlignVCenter
                    font: D.DTK.fontManager.t7
                    text: qsTr("Large")
                }
            }
        }

        DccObject {
            name: "lockedPanel"
            parentName: "personalization/panel/panelSettingsGroup"
            displayName: qsTr("Lock the Panel")
            weight: 20
            pageType: DccObject.Editor
            page: Switch {
                checked: dccData.panelInter.locked
                onCheckedChanged: {
                    if (dccData.panelInter.locked != checked)
                        dccData.panelInter.setLocked(checked)
                }
            }
        }

        DccObject {
            name: "positionInScreen"
            parentName: "personalization/panel/panelSettingsGroup"
            displayName: qsTr("Position on the screen")
            weight: 100
            pageType: DccObject.Editor
            page: D.ComboBox {
                flat: true
                model: [
                    { text: qsTr("Top"), value: 0 },
                    { text: qsTr("Bottom"), value: 2 },
                    { text: qsTr("Left"), value: 3 },
                    { text: qsTr("Right"), value: 1 }
                ]
                currentIndex: {
                    for (var i = 0; i < model.length; ++i) {
                        if (model[i].value === dccData.panelInter.Position)
                            return i
                    }
                    return 0
                }
                textRole: "text"
                valueRole: "value"
                onCurrentValueChanged: {
                    dccData.panelInter.setPosition(currentValue)
                }
            }
        }

        DccObject {
            name: "statusMode"
            parentName: "personalization/panel/panelSettingsGroup"
            displayName: qsTr("Status")
            weight: 200
            pageType: DccObject.Editor
            page: D.ComboBox {
                flat: true
                model: [
                    { text: qsTr("Keep shown"), value: 0 },
                    { text: qsTr("Keep hidden"), value: 1 },
                    { text: qsTr("Smart hide"), value: 2 }
                ]
                currentIndex: {
                    for (var i = 0; i < model.length; ++i) {
                        if (model[i].value === dccData.panelInter.HideMode)
                            return i
                    }
                    return 0
                }
                textRole: "text"
                valueRole: "value"
                onCurrentValueChanged: {
                    dccData.panelInter.setHideMode(currentValue)
                }
            }
        }

        DccObject {
            name: "showRecent"
            parentName: "personalization/panel/panelSettingsGroup"
            displayName: qsTr("Show recent items")
            weight: 210
            visible: dccData.panelInter.DisplayMode === 0
            pageType: DccObject.Editor
            page: Switch {
                checked: dccData.panelInter.ShowRecent
                onCheckedChanged: {
                    if (dccData.panelInter.ShowRecent !== checked)
                        dccData.panelInter.SetShowRecent(checked)
                }
            }
        }
    }

    DccObject {
        name: "panelPluginArea"
        weight: 900
        icon: "plugin"
        parentName: "personalization/panel"
        displayName: qsTr("Plugin Area")
        description: qsTr("Select which icons appear in the Classic Panel")

        PanelPluginArea {}
    }
}
