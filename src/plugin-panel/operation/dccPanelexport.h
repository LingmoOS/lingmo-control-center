// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include "operation/paneldbusproxy.h"
#include "operation/panelpluginsortproxymodel.h"
#include <qtypes.h>

#include <QDBusInterface>

namespace Dtk {
namespace Core {
class DConfig;
}
}

class DccPanelExport : public QObject
{
    Q_OBJECT
    Q_PROPERTY(PanelDBusProxy *panelInter MEMBER m_panelDbusProxy CONSTANT)
    Q_PROPERTY(PanelPluginSortProxyModel *pluginModel MEMBER m_sortProxyModel CONSTANT)
    Q_PROPERTY(int displayMode READ displayMode NOTIFY displayModeChanged)
    Q_PROPERTY(int monitorCount READ monitorCount NOTIFY monitorCountChanged)

public:
    explicit DccPanelExport(QObject *parent = nullptr);
    ~DccPanelExport() override;

    int displayMode() const;
    int monitorCount() const;

private:
    void initData();
    void initDisplayModeConnection();

public Q_SLOTS:
    void loadPluginData();

Q_SIGNALS:
    void displayModeChanged();
    void monitorCountChanged();

private:
    PanelDBusProxy *m_panelDbusProxy;
    PanelPluginModel *m_pluginModel;
    PanelPluginSortProxyModel *m_sortProxyModel;
    Dtk::Core::DConfig *m_dconfig;
    QDBusInterface *m_displayInter;
    int m_displayMode;
    int m_monitorCount;

private Q_SLOTS:
    void onDisplayModeChanged(uint mode);
    void onPropertiesChanged(const QString &interfaceName, const QMap<QString, QVariant> &changedProperties, const QStringList &invalidatedProperties);
};
