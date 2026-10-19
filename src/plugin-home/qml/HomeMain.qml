// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
import QtQuick 2.15
import org.deepin.dcc 1.0

// 主页模块的 Main 对象。
//
// 这里不再摆一串 DccObject.Item 卡片，而是把整个页面挂在 page 上：
// 插件的 Main 对象没有 name 时，加载器会把它的 page 转交给模块对象
// （dccpluginloader.cpp:413-419），于是侧栏点「主页」时 SecondPage 直接渲染
// 这一页；只有当 activeObject.page 为空时框架才会塞一个 DccRightView
// （SecondPage.qml:335-346）。同一套做法在 lingmo-update-ui 的
// dcc-update-plugin/qml/Update.qml:28 里也是这么用的。
//
// 设备信息仍来自 operation/homeinteraction（只读 5 项），接口没动；
// 后端没加载时 dccData 不存在，这里退回空串，页面统一显示「—」。
DccObject {
    id: homeMain

    readonly property var deviceInfo: (typeof dccData === "undefined" || dccData === null) ? null : dccData

    page: HomeView {
        deviceName: homeMain.deviceInfo ? homeMain.deviceInfo.deviceName : ""
        osName: homeMain.deviceInfo ? homeMain.deviceInfo.osName : ""
        cpuModel: homeMain.deviceInfo ? homeMain.deviceInfo.cpuModel : ""
        memTotal: homeMain.deviceInfo ? homeMain.deviceInfo.memTotal : ""
        kernelVersion: homeMain.deviceInfo ? homeMain.deviceInfo.kernelVersion : ""
    }
}
