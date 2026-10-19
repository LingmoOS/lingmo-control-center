// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.deepin.dtk 1.0 as D
import org.deepin.dcc 1.0

// 主页「常用设置」里的一个快捷入口：图标 + 名称，点击跳到对应模块。
// 背景沿用 HomePage.qml / DccMenuItem 的写法（DccItemBackground），图标与文字给
// 显式尺寸，不依赖隐式高度。
D.ItemDelegate {
    id: tile

    property string tileIcon: ""
    property string tileText: ""
    property string targetPage: ""

    // DTK 的 ItemDelegate 默认 checkable: true，选中后 palette.windowText 会变成
    // 高亮文字色（浅色），卡片底色没变时文字就"看不见"了，这里必须关掉。
    checkable: false
    autoExclusive: false

    implicitHeight: 58
    padding: 0
    hoverEnabled: true
    activeFocusOnTab: false
    font: D.DTK.fontManager.t7

    // DccItemBackground 会读取 control.corners 画圆角（D.ItemDelegate 自带该属性）
    corners: D.RoundRectangle.TopLeftCorner | D.RoundRectangle.TopRightCorner
             | D.RoundRectangle.BottomLeftCorner | D.RoundRectangle.BottomRightCorner

    background: DccItemBackground {
        backgroundType: DccObject.Hover | DccObject.Clickable
        separatorVisible: false
    }

    contentItem: RowLayout {
        spacing: 8

        D.DciIcon {
            Layout.leftMargin: 10
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            name: tile.tileIcon
            sourceSize: Qt.size(24, 24)
        }

        Label {
            Layout.fillWidth: true
            Layout.rightMargin: 8
            text: tile.tileText
            color: palette.windowText
            font: D.DTK.fontManager.t7
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }

    onClicked: {
        if (tile.targetPage.length > 0)
            DccApp.showPage(tile.targetPage)
    }
}
