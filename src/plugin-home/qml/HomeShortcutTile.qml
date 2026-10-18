// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.deepin.dtk 1.0 as D
import org.deepin.dcc 1.0

// 主页「常用设置」里的一个快捷入口：图标 + 名称，点击跳转到对应模块。
// 卡片背景沿用 HomePage.qml 的写法（DccItemBackground + ClickStyle）。
D.ItemDelegate {
    id: shortcutTile

    property string tileIcon: ""
    property string tileText: ""
    property string targetPage: ""

    // DccItemBackground 会读取 control.corners 画圆角与底部阴影
    readonly property int corners: D.RoundRectangle.TopLeftCorner | D.RoundRectangle.TopRightCorner
                                  | D.RoundRectangle.BottomLeftCorner | D.RoundRectangle.BottomRightCorner

    implicitHeight: 88
    padding: 0
    hoverEnabled: true
    activeFocusOnTab: false
    font: D.DTK.fontManager.t6

    background: DccItemBackground {
        backgroundType: DccObject.ClickStyle
        separatorVisible: false
    }

    contentItem: ColumnLayout {
        spacing: 8

        D.DciIcon {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 12
            name: shortcutTile.tileIcon
            sourceSize: Qt.size(28, 28)
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: 6
            Layout.rightMargin: 6
            Layout.bottomMargin: 12
            horizontalAlignment: Text.AlignHCenter
            font: D.DTK.fontManager.t6
            text: shortcutTile.tileText
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }

    onClicked: DccApp.showPage(shortcutTile.targetPage)
}