// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.deepin.dtk 1.0 as D
import org.deepin.dcc 1.0

// 主页页面本体：
//   顶部  设备信息条（头像 + 设备名 + 系统版本 + 右侧状态）
//   左列  常用设置快捷入口、设备规格
//   右列  系统更新、项目主页（GitHub）、关于本机
//
// 为什么整页自己排：Dcc 里 Item 类型的行，高度只有 DccItem.implicitHeight
// （contentItem 是 DccLoader）这一个来源，卡片自己决定不了可用高度，内容比它高
// 就会被下一张卡的底盖住。本页作为模块根对象的 page 使用，由 SecondPage 里的
// StackView 拉满右侧视图（SecondPage.qml:335-346 只在 activeObject.page 为空时
// 才塞 DccRightView），所以宽高是确定的，滚动由本页 contentHeight 负责。
//
// 数据由 HomeMain.qml 传入；空串表示后端没取到，统一显示「—」。
Flickable {
    id: view

    property string deviceName: ""
    property string osName: ""
    property string cpuModel: ""
    property string memTotal: ""
    property string kernelVersion: ""

    readonly property string projectUrl: "https://github.com/LingmoOS/lingmo-control-center"
    readonly property int pageMargin: 22
    // 内容太窄时退回单列，避免两栏被压成一条
    readonly property bool twoColumns: body.width >= 430

    function value(text) {
        return text && text.length > 0 ? text : "—"
    }

    clip: true
    contentWidth: width
    contentHeight: body.y + body.implicitHeight + view.pageMargin
    boundsBehavior: Flickable.StopAtBounds
    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    ColumnLayout {
        id: body
        x: view.pageMargin
        y: view.pageMargin
        width: Math.max(0, view.width - view.pageMargin * 2)
        spacing: 18

        // ------------------------------------------------------------------
        // 顶部：设备信息条
        // ------------------------------------------------------------------
        HomeCard {
            Layout.fillWidth: true
            padding: 16
            contentSpacing: 0

            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                // 头像：后端没有账号接口，用内置的账号图标兜底
                Rectangle {
                    id: avatar
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: 46
                    implicitHeight: 46
                    radius: width / 2

                    property D.Palette avatarColor: D.Palette {
                        normal: Qt.rgba(0, 0, 0, 0.06)
                        normalDark: Qt.rgba(1, 1, 1, 0.10)
                    }
                    color: avatar.D.ColorSelector.avatarColor

                    D.DciIcon {
                        anchors.centerIn: parent
                        width: 26
                        height: 26
                        name: "dcc_nav_accounts"
                        sourceSize: Qt.size(26, 26)
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Label {
                        Layout.fillWidth: true
                        text: view.value(view.deviceName)
                        color: palette.windowText
                        font: D.DTK.fontManager.t3
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                    Label {
                        Layout.fillWidth: true
                        text: view.value(view.osName)
                        color: palette.windowText
                        opacity: 0.65
                        font: D.DTK.fontManager.t7
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Kernel %1").arg(view.value(view.kernelVersion))
                        color: palette.windowText
                        opacity: 0.5
                        font: D.DTK.fontManager.t9
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }

                // 右侧状态：内存、处理器
                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.maximumWidth: 150
                    spacing: 2

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Memory")
                        color: palette.windowText
                        opacity: 0.5
                        font: D.DTK.fontManager.t9
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        Layout.fillWidth: true
                        text: view.value(view.memTotal)
                        color: palette.windowText
                        font: D.DTK.fontManager.t7
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }

                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.maximumWidth: 170
                    spacing: 2

                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Processor")
                        color: palette.windowText
                        opacity: 0.5
                        font: D.DTK.fontManager.t9
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        Layout.fillWidth: true
                        text: view.value(view.cpuModel)
                        color: palette.windowText
                        font: D.DTK.fontManager.t7
                        horizontalAlignment: Text.AlignRight
                        elide: Text.ElideRight
                        wrapMode: Text.NoWrap
                    }
                }
            }
        }

        // ------------------------------------------------------------------
        // 两栏
        // ------------------------------------------------------------------
        GridLayout {
            Layout.fillWidth: true
            columns: view.twoColumns ? 2 : 1
            columnSpacing: 16
            rowSpacing: 18

            // ------------------------- 左列 -------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 8

                Label {
                    Layout.fillWidth: true
                    text: qsTr("Common settings")
                    color: palette.windowText
                    opacity: 0.6
                    font: D.DTK.fontManager.t7
                    elide: Text.ElideRight
                }

                HomeCard {
                    Layout.fillWidth: true
                    padding: 8
                    contentSpacing: 4

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
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
                            tileIcon: "dcc_nav_power"
                            tileText: qsTr("Power Management")
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
                            tileText: qsTr("Time and Language")
                            targetPage: "timeAndLanguage"
                        }
                        HomeShortcutTile {
                            Layout.fillWidth: true
                            tileIcon: "dcc_nav_notification"
                            tileText: qsTr("Notification")
                            targetPage: "notification"
                        }
                        HomeShortcutTile {
                            Layout.fillWidth: true
                            tileIcon: "dcc_nav_mouse"
                            tileText: qsTr("Keyboard and Mouse")
                            targetPage: "keyboardAndMouse"
                        }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: 6
                    text: qsTr("Specifications")
                    color: palette.windowText
                    opacity: 0.6
                    font: D.DTK.fontManager.t7
                    elide: Text.ElideRight
                }

                HomeCard {
                    Layout.fillWidth: true
                    padding: 14
                    contentSpacing: 12

                    Repeater {
                        model: [
                            { "title": qsTr("Processor"), "value": view.value(view.cpuModel) },
                            { "title": qsTr("Memory"), "value": view.value(view.memTotal) },
                            { "title": qsTr("Kernel"), "value": view.value(view.kernelVersion) }
                        ]

                        delegate: ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Label {
                                Layout.fillWidth: true
                                text: modelData.title
                                color: palette.windowText
                                opacity: 0.5
                                font: D.DTK.fontManager.t9
                                elide: Text.ElideRight
                            }
                            Label {
                                Layout.fillWidth: true
                                text: modelData.value
                                color: palette.windowText
                                font: D.DTK.fontManager.t7
                                elide: Text.ElideRight
                                wrapMode: Text.NoWrap
                            }
                        }
                    }
                }
            }

            // ------------------------- 右列 -------------------------
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 8

                Label {
                    Layout.fillWidth: true
                    text: qsTr("System")
                    color: palette.windowText
                    opacity: 0.6
                    font: D.DTK.fontManager.t7
                    elide: Text.ElideRight
                }

                // 系统更新：lingmo-update-ui 提供的 update 模块
                HomeCard {
                    Layout.fillWidth: true
                    padding: 6
                    contentSpacing: 0

                    D.ItemDelegate {
                        id: updateRow
                        Layout.fillWidth: true
                        implicitHeight: 56
                        padding: 0
                        checkable: false
                        autoExclusive: false
                        hoverEnabled: true
                        activeFocusOnTab: false

                        corners: D.RoundRectangle.TopLeftCorner | D.RoundRectangle.TopRightCorner
                                 | D.RoundRectangle.BottomLeftCorner | D.RoundRectangle.BottomRightCorner

                        background: DccItemBackground {
                            backgroundType: DccObject.Hover | DccObject.Clickable
                            separatorVisible: false
                        }

                        contentItem: RowLayout {
                            spacing: 10

                            D.DciIcon {
                                Layout.leftMargin: 8
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                name: "dcc_nav_update"
                                sourceSize: Qt.size(24, 24)
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                Label {
                                    Layout.fillWidth: true
                                    text: qsTr("System update")
                                    color: palette.windowText
                                    font: D.DTK.fontManager.t6
                                    elide: Text.ElideRight
                                }
                                Label {
                                    Layout.fillWidth: true
                                    text: qsTr("Check for and install updates")
                                    color: palette.windowText
                                    opacity: 0.5
                                    font: D.DTK.fontManager.t9
                                    elide: Text.ElideRight
                                }
                            }

                            D.DciIcon {
                                Layout.rightMargin: 8
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                name: "arrow_ordinary_right"
                                sourceSize: Qt.size(14, 14)
                            }
                        }

                        onClicked: DccApp.showPage("update")
                    }
                }

                // 关于本机
                HomeCard {
                    Layout.fillWidth: true
                    padding: 6
                    contentSpacing: 0

                    D.ItemDelegate {
                        id: aboutRow
                        Layout.fillWidth: true
                        implicitHeight: 56
                        padding: 0
                        checkable: false
                        autoExclusive: false
                        hoverEnabled: true
                        activeFocusOnTab: false

                        corners: D.RoundRectangle.TopLeftCorner | D.RoundRectangle.TopRightCorner
                                 | D.RoundRectangle.BottomLeftCorner | D.RoundRectangle.BottomRightCorner

                        background: DccItemBackground {
                            backgroundType: DccObject.Hover | DccObject.Clickable
                            separatorVisible: false
                        }

                        contentItem: RowLayout {
                            spacing: 10

                            D.DciIcon {
                                Layout.leftMargin: 8
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 24
                                Layout.preferredHeight: 24
                                name: "dcc_nav_systeminfo"
                                sourceSize: Qt.size(24, 24)
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                Label {
                                    Layout.fillWidth: true
                                    text: qsTr("About This PC")
                                    color: palette.windowText
                                    font: D.DTK.fontManager.t6
                                    elide: Text.ElideRight
                                }
                                Label {
                                    Layout.fillWidth: true
                                    text: qsTr("Device name, system version and hardware")
                                    color: palette.windowText
                                    opacity: 0.5
                                    font: D.DTK.fontManager.t9
                                    elide: Text.ElideRight
                                }
                            }

                            D.DciIcon {
                                Layout.rightMargin: 8
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: 14
                                Layout.preferredHeight: 14
                                name: "arrow_ordinary_right"
                                sourceSize: Qt.size(14, 14)
                            }
                        }

                        onClicked: DccApp.showPage("systemInfo")
                    }
                }

                // 项目主页：暗色卡片 + 生成的背景图，点击用默认浏览器打开
                Rectangle {
                    id: projectCard
                    Layout.fillWidth: true
                    implicitHeight: 158
                    radius: 8
                    color: "#0d1117"
                    clip: true

                    // 背景图自己带圆角（见 generate-github-card.py 的 mask），用 Stretch
                    // 正好铺满卡片，圆角与卡片边缘对得上，不用 ItemViewport 之类的裁剪
                    Image {
                        anchors.fill: parent
                        source: "qrc:/home/images/home-github.png"
                        fillMode: Image.Stretch
                        asynchronous: false
                    }

                    // 底部压暗，保证文字在任何背景上都能看清
                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        height: parent.height * 0.72
                        gradient: Gradient {
                            GradientStop {
                                position: 0.0
                                color: Qt.rgba(0, 0, 0, 0)
                            }
                            GradientStop {
                                position: 1.0
                                color: Qt.rgba(0, 0, 0, 0.6)
                            }
                        }
                    }

                    Label {
                        anchors {
                            top: parent.top
                            right: parent.right
                            topMargin: 12
                            rightMargin: 14
                        }
                        text: "GitHub"
                        color: Qt.rgba(1, 1, 1, 0.9)
                        font: D.DTK.fontManager.t8
                    }

                    ColumnLayout {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                            leftMargin: 14
                            rightMargin: 14
                            bottomMargin: 12
                        }
                        spacing: 2

                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Lingmo Control Center")
                            color: "#ffffff"
                            font: D.DTK.fontManager.t6
                            elide: Text.ElideRight
                        }
                        Label {
                            Layout.fillWidth: true
                            text: qsTr("Source code and discussions on GitHub")
                            color: Qt.rgba(1, 1, 1, 0.65)
                            font: D.DTK.fontManager.t9
                            elide: Text.ElideRight
                        }
                    }

                    // hover 时整卡轻微提亮，放在 MouseArea 下面，不挡事件
                    Rectangle {
                        anchors.fill: parent
                        radius: projectCard.radius
                        color: "#ffffff"
                        opacity: projectArea.containsMouse ? 0.06 : 0

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 120
                            }
                        }
                    }

                    MouseArea {
                        id: projectArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(view.projectUrl)
                    }
                }
            }
        }
    }
}
