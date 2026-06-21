// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
//SPDX-License-Identifier: GPL-3.0-or-later

#include "panelpluginmodel.h"

PanelPluginModel::PanelPluginModel(QObject *parent)
    : QAbstractItemModel(parent)
{
}

QModelIndex PanelPluginModel::index(int row, int column, const QModelIndex &parent) const
{
    if (row < 0 || row >= rowCount() || parent.isValid() || column != 0)
        return QModelIndex();

    return createIndex(row, 0);
}

QModelIndex PanelPluginModel::parent(const QModelIndex &child) const
{
    Q_UNUSED(child)
    return QModelIndex();
}

int PanelPluginModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_panelItemInfos.size();
}

int PanelPluginModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 1;
}

QVariant PanelPluginModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    if (row < 0 || row >= m_panelItemInfos.size()) {
        return {};
    }

    switch (role) {
    case Qt::DisplayRole:
        return m_panelItemInfos[row].displayName;
    case PluginNameRole:
        return m_panelItemInfos[row].name;
    case PlugindisplayNameRole:
        return m_panelItemInfos[row].displayName;
    case PluginItemKeyRole:
        return m_panelItemInfos[row].itemKey;
    case PluginSettingKeyRole:
        return m_panelItemInfos[row].settingKey;
    case PluginIconKeyRole:
        return m_panelItemInfos[row].dcc_icon;
    case PluginVisibleRole:
        return m_panelItemInfos[row].visible;
    }
    return {};
}

QHash<int, QByteArray> PanelPluginModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractItemModel::roleNames();
    roles[PluginNameRole] = "name";
    roles[PlugindisplayNameRole] = "displayName";
    roles[PluginItemKeyRole] = "key";
    roles[PluginSettingKeyRole] = "settingKey";
    roles[PluginIconKeyRole] = "icon";
    roles[PluginVisibleRole] = "visible";
    return roles;
}

void PanelPluginModel::setPluginVisible(const QString &pluginName, bool visible)
{
    for (int i = 0; i < m_panelItemInfos.size(); ++i) {
        if (pluginName == m_panelItemInfos[i].itemKey) {
            m_panelItemInfos[i].visible = visible;
            emit dataChanged(index(i, 0), index(i, 0));
            return;
        }
    }
}

void PanelPluginModel::resetData(const PanelItemInfos &pluginInfos)
{
    beginResetModel();
    m_panelItemInfos = pluginInfos;
    endResetModel();
}
