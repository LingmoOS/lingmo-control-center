// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
//SPDX-License-Identifier: GPL-3.0-or-later

#include "paneldbusproxy.h"

#include <QMetaObject>
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusMetaType>

const static QString DaemonDockService = "org.deepin.dde.daemon.Dock1";
const static QString DaemonDockPath = "/org/deepin/dde/daemon/Dock1";
const static QString DaemonDockInterface = "org.deepin.dde.daemon.Dock1";
const static QString DockService = "org.deepin.dde.Dock1";
const static QString DockPath = "/org/deepin/dde/Dock1";
const static QString DockInterface = "org.deepin.dde.Dock1";

const static QString PropertiesInterface = "org.freedesktop.DBus.Properties";
const static QString PropertiesChanged = "PropertiesChanged";

QDBusArgument &operator<<(QDBusArgument &arg, const PanelItemInfo &info)
{
    arg.beginStructure();
    arg << info.name << info.displayName << info.itemKey << info.settingKey << info.dcc_icon << info.visible;
    arg.endStructure();
    return arg;
}

const QDBusArgument &operator>>(const QDBusArgument &arg, PanelItemInfo &info)
{
    arg.beginStructure();
    arg >> info.name >> info.displayName >> info.itemKey >> info.settingKey >> info.dcc_icon >> info.visible;
    arg.endStructure();
    return arg;
}

static void registPanelItemType()
{
    static bool isRegister = false;
    if (isRegister)
        return;

    qRegisterMetaType<PanelItemInfo>("PanelItemInfo");
    qDBusRegisterMetaType<PanelItemInfo>();
    qRegisterMetaType<PanelItemInfos>("PanelItemInfos");
    qDBusRegisterMetaType<PanelItemInfos>();
    isRegister = true;
}

PanelDBusProxy::PanelDBusProxy(QObject *parent)
    : QObject(parent)
    , m_daemonDockInter(new QDBusInterface(DaemonDockService, DaemonDockPath, DaemonDockInterface, QDBusConnection::sessionBus(), this))
    , m_dockInter(new QDBusInterface(DockService, DockPath, DockInterface, QDBusConnection::sessionBus(), this))
{
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "DisplayModeChanged", this, SIGNAL(DisplayModeChanged(int)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "PositionChanged", this, SIGNAL(PositionChanged(int)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "HideModeChanged", this, SIGNAL(HideModeChanged(int)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "WindowSizeEfficientChanged", this, SIGNAL(WindowSizeEfficientChanged(uint)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "WindowSizeFashionChanged", this, SIGNAL(WindowSizeFashionChanged(uint)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "showRecentChanged", this, SIGNAL(showRecentChanged(bool)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "LockedChanged", this, SIGNAL(LockedChanged(bool)));
    QDBusConnection::sessionBus().connect(DaemonDockService, DaemonDockPath, DaemonDockInterface, "IconSizeChanged", this, SIGNAL(IconSizeChanged(uint)));

    QDBusConnection::sessionBus().connect(DockService, DockPath, DockInterface, "showInPrimaryChanged", this, SIGNAL(ShowInPrimaryChanged(bool)));
    QDBusConnection::sessionBus().connect(DockService, DockPath, DockInterface, "pluginVisibleChanged", this, SIGNAL(pluginVisibleChanged(const QString &, bool)));
    QDBusConnection::sessionBus().connect(DockService, DockPath, DockInterface, "pluginsChanged", this, SIGNAL(pluginsChanged()));

    registPanelItemType();
}

int PanelDBusProxy::displayMode()
{
    return qvariant_cast<int>(m_daemonDockInter->property("DisplayMode"));
}

void PanelDBusProxy::setDisplayMode(int mode)
{
    m_daemonDockInter->setProperty("DisplayMode", QVariant::fromValue(mode));
}

int PanelDBusProxy::position()
{
    return qvariant_cast<int>(m_daemonDockInter->property("Position"));
}

void PanelDBusProxy::setPosition(int value)
{
    m_daemonDockInter->setProperty("Position", QVariant::fromValue(value));
}

int PanelDBusProxy::hideMode()
{
    return qvariant_cast<int>(m_daemonDockInter->property("HideMode"));
}

void PanelDBusProxy::setHideMode(int value)
{
    m_daemonDockInter->setProperty("HideMode", QVariant::fromValue(value));
}

uint PanelDBusProxy::windowSizeEfficient()
{
    return qvariant_cast<uint>(m_daemonDockInter->property("WindowSizeEfficient"));
}

void PanelDBusProxy::setWindowSizeEfficient(uint value)
{
    m_daemonDockInter->setProperty("WindowSizeEfficient", QVariant::fromValue(value));
}

uint PanelDBusProxy::windowSizeFashion()
{
    return qvariant_cast<uint>(m_daemonDockInter->property("WindowSizeFashion"));
}

void PanelDBusProxy::setWindowSizeFashion(uint value)
{
    m_daemonDockInter->setProperty("WindowSizeFashion", QVariant::fromValue(value));
}

bool PanelDBusProxy::showInPrimary()
{
    return qvariant_cast<bool>(m_dockInter->property("showInPrimary"));
}

void PanelDBusProxy::setShowInPrimary(bool value)
{
    m_dockInter->setProperty("showInPrimary", QVariant::fromValue(value));
}

bool PanelDBusProxy::locked()
{
    return qvariant_cast<bool>(m_daemonDockInter->property("Locked"));
}

void PanelDBusProxy::setLocked(bool value)
{
    m_daemonDockInter->setProperty("Locked", QVariant::fromValue(value));
}

bool PanelDBusProxy::showRecent()
{
    return qvariant_cast<bool>(m_daemonDockInter->property("ShowRecent"));
}

uint PanelDBusProxy::iconSize()
{
    return qvariant_cast<uint>(m_daemonDockInter->property("IconSize"));
}

void PanelDBusProxy::setIconSize(uint value)
{
    m_daemonDockInter->setProperty("IconSize", QVariant::fromValue(value));
}

void PanelDBusProxy::resizeDock(int offset, bool dragging)
{
    m_dockInter->call(QDBus::CallMode::Block, QStringLiteral("resizeDock"), QVariant::fromValue(offset), QVariant::fromValue(dragging));
}

QDBusPendingReply<QStringList> PanelDBusProxy::GetLoadedPlugins()
{
    QDBusPendingReply<QStringList> reply = m_dockInter->asyncCall(QStringLiteral("GetLoadedPlugins"));
    reply.waitForFinished();
    return reply;
}

QDBusPendingReply<QString> PanelDBusProxy::getPluginKey(const QString &pluginName)
{
    QList<QVariant> argumentList;
    argumentList << QVariant::fromValue(pluginName);
    return m_dockInter->asyncCallWithArgumentList(QStringLiteral("getPluginKey"), argumentList);
}

QDBusPendingReply<bool> PanelDBusProxy::getPluginVisible(const QString &pluginName)
{
    QList<QVariant> argumentList;
    argumentList << QVariant::fromValue(pluginName);
    return m_dockInter->asyncCallWithArgumentList(QStringLiteral("getPluginVisible"), argumentList);
}

QDBusPendingReply<> PanelDBusProxy::setPluginVisible(const QString &pluginName, bool visible)
{
    QList<QVariant> argumentList;
    argumentList << QVariant::fromValue(pluginName) << QVariant::fromValue(visible);
    return m_dockInter->asyncCallWithArgumentList(QStringLiteral("setPluginVisible"), argumentList);
}

QDBusPendingReply<> PanelDBusProxy::SetShowRecent(bool visible)
{
    QList<QVariant> argumentList;
    argumentList << QVariant::fromValue(visible);
    return m_daemonDockInter->asyncCallWithArgumentList(QStringLiteral("SetShowRecent"), argumentList);
}

QDBusPendingReply<PanelItemInfos> PanelDBusProxy::plugins()
{
    QDBusPendingReply<PanelItemInfos> reply = m_dockInter->asyncCall(QStringLiteral("plugins"));
    reply.waitForFinished();
    return reply;
}

QDBusPendingReply<> PanelDBusProxy::setItemOnDock(const QString settingKey, const QString &itemKey, bool visible)
{
    QList<QVariant> argumentList;
    argumentList << settingKey << itemKey << QVariant::fromValue(visible);
    return m_dockInter->asyncCallWithArgumentList("setItemOnDock", argumentList);
}
