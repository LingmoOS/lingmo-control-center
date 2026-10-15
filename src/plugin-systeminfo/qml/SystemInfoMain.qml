// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
// import org.deepin.dtk 1.0 as D
import QtQuick 2.15
import QtQuick.Controls 2.0

import org.deepin.dcc 1.0
import QtQuick.Layouts 1.15

DccObject {
    DccObject {
        name: "systemInfo"
        parentName: "system"
        displayName: qsTr("About This PC")
        description: qsTr("System version, device information")
        icon: "about"
        weight: 1010
        NativeInfoPage {}
    }
    DccObject {
        name: "userLicense"
        parentName: "privacy"
        displayName: qsTr("End User License Agreement")
        description: qsTr("View the end  user license agreement")
        icon: "user_license_agreement"
        visible: true
        weight: 40
        UserLicensePage{}
    }
    DccObject {
        name: "privacyPolicy"
        parentName: "privacy"
        displayName: qsTr("Privacy Policy")
        description: qsTr("View information about privacy policy")
        icon: "privacy_policy"
        weight: 50
        PrivacyPolicyPage{}
    }
    DccObject {
        name: "userExperienceProgram"
        parentName: "privacy"
        displayName: qsTr("User Experience Program")
        description: qsTr("Join the user experience program to help improve the product")
        icon: "user_experience_plan"
        weight: 60
        visible: dccData.systemInfoMode().showUserExperienceProgram()
        UserExperienceProgramPage{}
    }
}
