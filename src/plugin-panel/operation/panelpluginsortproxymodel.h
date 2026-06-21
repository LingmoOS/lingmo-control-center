// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#pragma once

#include <QSortFilterProxyModel>

class PanelPluginSortProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    enum StringGroup {
        Digit = 0,
        Latin = 1,
        CJK   = 2
    };

public:
    explicit PanelPluginSortProxyModel(QObject *parent = nullptr);

    PanelPluginSortProxyModel::StringGroup classifyString(const QString &s) const;

protected:
    bool lessThan(const QModelIndex &source_left, const QModelIndex &source_right) const override;
};
