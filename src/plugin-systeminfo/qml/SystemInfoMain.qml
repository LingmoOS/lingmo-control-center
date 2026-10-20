// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import org.deepin.dtk 1.0 as D
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
        // 图标名必须与 qrc 里实际存在的资源对应：本仓库只有 dcc_nav_systeminfo_*，
        // 原先的 "about" 在图标集里不存在，会让该行在侧栏渲染为空白。
        icon: "systeminfo"
        weight: 1010
        NativeInfoPage {}
    }
    DccObject {
        name: "userLicense"
        parentName: "system"
        displayName: qsTr("End User License Agreement")
        description: qsTr("View the end  user license agreement")
        icon: "user_license_agreement"
        visible: true
        weight: 1020
        UserLicensePage{}
    }
    DccObject {
        name: "privacyPolicy"
        parentName: "system"
        displayName: qsTr("Privacy Policy")
        description: qsTr("View information about privacy policy")
        icon: "privacy_policy"
        weight: 1030
        PrivacyPolicyPage{}
    }
    DccObject {
        name: "userExperienceProgram"
        parentName: "system"
        displayName: qsTr("User Experience Program")
        description: qsTr("Join the user experience program to help improve the product")
        icon: "user_experience_plan"
        weight: 1040
        // 防御式：dccData 或 systemInfoMode 不可用时不能让整份文件加载失败，
          // 否则本页所有条目（含关于本机）会一起消失。
          visible: (typeof dccData !== "undefined" && dccData && dccData.systemInfoMode)
                   ? dccData.systemInfoMode().showUserExperienceProgram() : false
        UserExperienceProgramPage{}
    }
    // “隐私和安全性”里放的是设置项：用户体验改善计划（诊断与反馈）
    DccObject {
        name: "ueProgramSwitch"
        parentName: "privacy"
        displayName: qsTr("User Experience Program")
        description: qsTr("Send anonymous usage statistics to help improve the system")
        icon: "user_experience_plan"
        weight: 10
        pageType: DccObject.Editor
        page: D.Switch {
            checked: (typeof dccData !== "undefined" && dccData && dccData.systemInfoMode)
                     ? dccData.systemInfoMode().joinUeProgram : false
            onCheckedChanged: {
                if (checked !== dccData.systemInfoMode().joinUeProgram)
                    dccData.systemInfoWork().setUeProgram(checked)
            }
        }
    }
}
