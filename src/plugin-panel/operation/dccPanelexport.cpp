// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "dccfactory.h"
#include "operation/panelpluginmodel.h"
#include "operation/panelpluginsortproxymodel.h"
#include <qtypes.h>

#include "dccPanelexport.h"

#include <QFile>
#include <QIcon>
#include <QDir>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusObjectPath>
#include <QDebug>
#include <QDBusArgument>
#include <QDBusMetaType>

#include <DConfig>
#include <DIconTheme>
#include <DWindowManagerHelper>

#define CUSTOM_MODE 0
#define MERGE_MODE 1
#define EXTEND_MODE 2
#define SINGLE_MODE 3

constexpr auto PLUGIN_ICON_DIR = "/usr/share/dde-dock/icons/dcc-setting";
constexpr auto PLUGIN_ICON_PREFIX = "dcc-";
constexpr auto PLUGIN_ICON_DEFAULT = "dcc_dock_plug_in";

static const QMap<QString, QString> pluginIconMap = {
    {"AiAssistant",    "dcc_dock_assistant"}
    , {"show-desktop",   "dcc_dock_desktop"}
    , {"onboard",        "dcc_dock_keyboard"}
    , {"notifications",  "dcc_dock_notify"}
    , {"shutdown",       "dcc_dock_power"}
    , {"multitasking",   "dcc_dock_task"}
    , {"datetime",       "dcc_dock_time"}
    , {"system-monitor", "dcc_dock_systemmonitor"}
    , {"grand-search",   "dcc_dock_grandsearch"}
    , {"trash",          "dcc_dock_trash"}
    , {"shot-start-plugin",  "dcc_dock_shot_start_plugin"}
};

DGUI_USE_NAMESPACE;

static QString getPluginIcon(const PanelItemInfo &info)
{
    QString iconName = info.dcc_icon;

    if (iconName.isEmpty()) {
        iconName = pluginIconMap.value(info.name, PLUGIN_ICON_DEFAULT);
    }

    DGuiApplicationHelper::ColorType themeType = DGuiApplicationHelper::instance()->themeType();
    const auto iconTheme = DGuiApplicationHelper::instance()->applicationIconTheme();
    if (!iconTheme->iconFilePath(iconName).isEmpty()) {
        return iconName;
    }

    QString dirName = (themeType == DGuiApplicationHelper::DarkType) ? "dark" : "light";
    QDir dir(QString("%1/%2").arg(PLUGIN_ICON_DIR, dirName));
    if (dir.exists(iconName + ".svg")) {
        return dir.absoluteFilePath(iconName + ".svg");
    }

    iconName = PLUGIN_ICON_DEFAULT;
    if (!iconTheme->iconFilePath(iconName).isEmpty()) {
        return iconName;
    }

    dir = QDir(QString("%1/%2").arg(PLUGIN_ICON_DIR, dirName));
    if (dir.exists(iconName + ".svg")) {
        return dir.absoluteFilePath(iconName + ".svg");
    }

    return iconName;
}

static QString getDccIcon(const PanelItemInfo &info)
{
    QString iconName = info.dcc_icon;

    if (iconName.isEmpty()) {
        iconName = pluginIconMap.value(info.name, PLUGIN_ICON_DEFAULT);
    }

    return iconName;
}

DccPanelExport::DccPanelExport(QObject *parent)
    : QObject(parent)
    , m_panelDbusProxy(new PanelDBusProxy(this))
    , m_pluginModel(new PanelPluginModel(this))
    , m_sortProxyModel(new PanelPluginSortProxyModel(this))
    , m_dconfig(Dtk::Core::DConfig::create("org.deepin.dde.control-center", "org.deepin.dde.control.center.plugin.panel"))
    , m_displayInter(new QDBusInterface("org.deepin.dde.Display1", "/org/deepin/dde/Display1", "org.deepin.dde.Display1", QDBusConnection::sessionBus(), this))
    , m_displayMode(0)
    , m_monitorCount(0)
{
    m_sortProxyModel->setSourceModel(m_pluginModel);
    initData();
    initDisplayModeConnection();
}

DccPanelExport::~DccPanelExport()
{
}

int DccPanelExport::displayMode() const
{
    return m_displayMode;
}

int DccPanelExport::monitorCount() const
{
    return m_monitorCount;
}

void DccPanelExport::initData()
{
    if (m_displayInter && m_displayInter->isValid()) {
        QDBusPendingReply<uint> modeReply = m_displayInter->call("GetBuiltinMode");
        modeReply.waitForFinished();
        if (!modeReply.isError()) {
            m_displayMode = static_cast<int>(modeReply.value());
        }

        QDBusPendingReply<QList<QDBusObjectPath>> monitors = m_displayInter->call("ListMonitors");
        monitors.waitForFinished();
        if (!monitors.isError()) {
            m_monitorCount = monitors.value().size();
        }
    }

    if (m_displayInter && m_displayInter->isValid()) {
        QDBusConnection::sessionBus().connect("org.deepin.dde.Display1",
                                               "/org/deepin/dde/Display1",
                                               "org.freedesktop.DBus.Properties",
                                               "PropertiesChanged",
                                               this, SLOT(onPropertiesChanged(QString, QMap<QString, QVariant>, QStringList)));
    }
}

void DccPanelExport::initDisplayModeConnection()
{
    connect(DWindowManagerHelper::instance(), &DWindowManagerHelper::hasCompositeChanged, this, [this] {
        if (m_displayInter && m_displayInter->isValid()) {
            QDBusPendingReply<uint> modeReply = m_displayInter->call("GetBuiltinMode");
            modeReply.waitForFinished();
            if (!modeReply.isError()) {
                int newMode = static_cast<int>(modeReply.value());
                if (m_displayMode != newMode) {
                    m_displayMode = newMode;
                    emit displayModeChanged();
                }
            }
        }
    });
}

void DccPanelExport::loadPluginData()
{
    QDBusPendingReply<PanelItemInfos> reply = m_panelDbusProxy->plugins();
    reply.waitForFinished();

    if (reply.isError()) {
        qWarning() << "Failed to get panel plugins:" << reply.error().message();
        return;
    }

    PanelItemInfos pluginInfos = reply.value();
    for (auto &info : pluginInfos) {
        info.dcc_icon = getDccIcon(info);
    }

    m_pluginModel->resetData(pluginInfos);
}

void DccPanelExport::onDisplayModeChanged(uint mode)
{
    Q_UNUSED(mode);
    if (m_displayInter && m_displayInter->isValid()) {
        QDBusPendingReply<uint> modeReply = m_displayInter->call("GetBuiltinMode");
        modeReply.waitForFinished();
        if (!modeReply.isError()) {
            m_displayMode = static_cast<int>(modeReply.value());
            emit displayModeChanged();
        }
    }
}

void DccPanelExport::onPropertiesChanged(const QString &interfaceName, const QMap<QString, QVariant> &changedProperties, const QStringList &invalidatedProperties)
{
    Q_UNUSED(interfaceName);
    Q_UNUSED(changedProperties);
    Q_UNUSED(invalidatedProperties);

    if (m_displayInter && m_displayInter->isValid()) {
        QDBusPendingReply<uint> modeReply = m_displayInter->call("GetBuiltinMode");
        modeReply.waitForFinished();
        if (!modeReply.isError()) {
            m_displayMode = static_cast<int>(modeReply.value());
            emit displayModeChanged();
        }

        QDBusPendingReply<QList<QDBusObjectPath>> monitors = m_displayInter->call("ListMonitors");
        monitors.waitForFinished();
        if (!monitors.isError()) {
            int newCount = monitors.value().size();
            if (m_monitorCount != newCount) {
                m_monitorCount = newCount;
                emit monitorCountChanged();
            }
        }
    }
}

DCC_FACTORY_CLASS(DccPanelExport)
#include "dccPanelexport.moc"
