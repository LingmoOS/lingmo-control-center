// SPDX-FileCopyrightText: 2026 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include "operation/dockdbusproxy.h"
#include "operation/dockpluginsortproxymodel.h"
#include <qtypes.h>

#include <QDBusInterface>

namespace Dtk {
namespace Core {
class DConfig;
}
}

class DccDockExport : public QObject
{
    Q_OBJECT
    Q_PROPERTY(DockDBusProxy *dockInter MEMBER m_dockDbusProxy CONSTANT)
    Q_PROPERTY(DockPluginSortProxyModel *pluginModel MEMBER m_sortProxyModel CONSTANT)
    Q_PROPERTY(int displayMode READ displayMode NOTIFY displayModeChanged)
    Q_PROPERTY(int monitorCount READ monitorCount NOTIFY monitorCountChanged)
    Q_PROPERTY(bool combineApp READ combineApp WRITE setCombineApp NOTIFY combineAppChanged)
    Q_PROPERTY(int layoutMode READ layoutMode WRITE setLayoutMode NOTIFY layoutModeChanged)

public:
    explicit DccDockExport(QObject *parent = nullptr);
    ~DccDockExport() override;

    int displayMode() const;
    int monitorCount() const;
    bool combineApp() const;
    int layoutMode() const;

private:
    void initData();
    void initDisplayModeConnection();

public Q_SLOTS:
    void loadPluginData();
    void setCombineApp(bool value);
    void setLayoutMode(int mode);

Q_SIGNALS:
    void displayModeChanged();
    void monitorCountChanged();
    void combineAppChanged(bool combineApp);
    void layoutModeChanged(int mode);

private:
    DockDBusProxy *m_dockDbusProxy;
    DockPluginModel *m_pluginModel;
    DockPluginSortProxyModel *m_sortProxyModel;
    Dtk::Core::DConfig *m_dconfig;
    Dtk::Core::DConfig *m_layoutDconfig;
    QDBusInterface *m_displayInter;
    int m_displayMode;
    int m_monitorCount;
    bool m_combineApp;
    int m_layoutMode;
    
private Q_SLOTS:
    void onDisplayModeChanged(uint mode);
    void onPropertiesChanged(const QString &interfaceName, const QMap<QString, QVariant> &changedProperties, const QStringList &invalidatedProperties);
};
