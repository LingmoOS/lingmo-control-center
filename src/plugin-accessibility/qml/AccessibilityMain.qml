// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.deepin.dtk 1.0
import org.deepin.dcc 1.0

// 辅助功能：视觉/听觉/操作辅助开关（读写 com.deepin.wrap.gnome.desktop.a11y.*）
DccObject {
    id: a11yRoot

    component A11ySwitch: DccObject {
        property string switchTitle: ""
        property string switchDescription: ""
        property string switchName: ""
        property bool switchValue: false
        property var switchSetter: null

        name: switchName
        parentName: "accessibility"
        displayName: switchTitle
        description: switchDescription
        pageType: DccObject.Editor
        backgroundType: DccObject.Normal
        page: Switch {
            checked: switchValue
            onCheckedChanged: {
                if (switchSetter && checked !== switchValue)
                    switchSetter(checked)
            }
        }
    }

    A11ySwitch {
        switchName: "a11yScreenReader"
        weight: 10
        switchTitle: qsTr("Screen reader")
        switchDescription: qsTr("Announce the interface with a speech synthesiser")
        switchValue: dccData.screenReaderEnabled
        switchSetter: function (v) { dccData.setScreenReaderEnabled(v) }
    }
    A11ySwitch {
        switchName: "a11yScreenKeyboard"
        weight: 20
        switchTitle: qsTr("On-screen keyboard")
        switchDescription: qsTr("Show a keyboard on the screen for pointer input")
        switchValue: dccData.screenKeyboardEnabled
        switchSetter: function (v) { dccData.setScreenKeyboardEnabled(v) }
    }
    A11ySwitch {
        switchName: "a11yMagnifier"
        weight: 30
        switchTitle: qsTr("Screen magnifier")
        switchDescription: qsTr("Magnify part of the screen")
        switchValue: dccData.magnifierEnabled
        switchSetter: function (v) { dccData.setMagnifierEnabled(v) }
    }
    A11ySwitch {
        switchName: "a11yStickyKeys"
        weight: 40
        switchTitle: qsTr("Sticky keys")
        switchDescription: qsTr("Press modifier keys one at a time")
        switchValue: dccData.stickyKeysEnabled
        switchSetter: function (v) { dccData.setStickyKeysEnabled(v) }
    }
    A11ySwitch {
        switchName: "a11ySlowKeys"
        weight: 50
        switchTitle: qsTr("Slow keys")
        switchDescription: qsTr("Only accept a key press held for a while")
        switchValue: dccData.slowKeysEnabled
        switchSetter: function (v) { dccData.setSlowKeysEnabled(v) }
    }
    A11ySwitch {
        switchName: "a11yBounceKeys"
        weight: 60
        switchTitle: qsTr("Bounce keys")
        switchDescription: qsTr("Ignore repeated key presses in a short time")
        switchValue: dccData.bounceKeysEnabled
        switchSetter: function (v) { dccData.setBounceKeysEnabled(v) }
    }
    A11ySwitch {
        switchName: "a11yDwellClick"
        weight: 70
        switchTitle: qsTr("Hover click")
        switchDescription: qsTr("Click by hovering the pointer over a control")
        switchValue: dccData.dwellClickEnabled
        switchSetter: function (v) { dccData.setDwellClickEnabled(v) }
    }
}
