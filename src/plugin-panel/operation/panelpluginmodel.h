// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include <QAbstractItemModel>
#include <QHash>
#include <QList>

struct PanelItemInfo
{
    QString name;
    QString displayName;
    QString itemKey;
    QString settingKey;
    QString dcc_icon;
    bool visible;
};

typedef QList<PanelItemInfo> PanelItemInfos;

class PanelPluginModel : public QAbstractItemModel
{
    Q_OBJECT
    enum PanelPluginTypeRole {
        PluginNameRole = Qt::UserRole + 1,
        PlugindisplayNameRole,
        PluginItemKeyRole,
        PluginSettingKeyRole,
        PluginIconKeyRole,
        PluginVisibleRole
    };

public:
    explicit PanelPluginModel(QObject *parent = nullptr);
    QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &child) const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    void setPluginVisible(const QString &pluginName, bool visible);
    void resetData(const PanelItemInfos &pluginInfos);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    PanelItemInfos m_panelItemInfos;
};
