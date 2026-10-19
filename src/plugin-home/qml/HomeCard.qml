// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.deepin.dtk 1.0 as D
import org.deepin.dcc 1.0

// 主页里的一张卡片：圆角底 + 可选小标题 + 内容。
// 卡片高度只由自己内部的 ColumnLayout 决定（implicitHeight），不依赖外层 Loader
// 传下来的隐式高度；需要固定高度的场合（信息条、更新入口）直接给 height。
Rectangle {
    id: card

    property string title: ""
    property int padding: 14
    property int contentSpacing: 10

    // 内容直接写进这里（卡片内的 ColumnLayout）
    default property alias content: column.data

    // 卡片底色：浅色主题白色，深色主题 5% 白，与 DccItemBackground 的 Normal 一致
    property D.Palette cardColor: D.Palette {
        normal: Qt.rgba(1, 1, 1, 1)
        normalDark: Qt.rgba(1, 1, 1, 0.05)
    }

    color: card.D.ColorSelector.cardColor
    radius: 8
    implicitHeight: column.implicitHeight + card.padding * 2

    ColumnLayout {
        id: column
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            leftMargin: card.padding
            rightMargin: card.padding
            topMargin: card.padding
        }
        spacing: card.contentSpacing

        Label {
            Layout.fillWidth: true
            visible: card.title.length > 0
            text: card.title
            color: palette.windowText
            opacity: 0.6
            font: D.DTK.fontManager.t7
            elide: Text.ElideRight
        }
    }
}
