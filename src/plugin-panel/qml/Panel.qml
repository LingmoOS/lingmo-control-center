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
    name: "panel"
    parentName: "personalization"
    displayName: qsTr("Classic Panel")
    description: qsTr("Classic dock panel settings, plugin area management")
    icon: "dock"
    weight: 110
}
