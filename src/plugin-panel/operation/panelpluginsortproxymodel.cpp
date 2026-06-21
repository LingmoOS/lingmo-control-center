// SPDX-FileCopyrightText: 2026 Lingmo OS Team.
//
// SPDX-License-Identifier: GPL-3.0-or-later

#include "panelpluginsortproxymodel.h"

#include <QCollator>
#include <QLocale>

PanelPluginSortProxyModel::PanelPluginSortProxyModel(QObject *parent)
    : QSortFilterProxyModel(parent)
{
    setDynamicSortFilter(true);
    setSortRole(Qt::DisplayRole);
    sort(0, Qt::AscendingOrder);
}

PanelPluginSortProxyModel::StringGroup PanelPluginSortProxyModel::classifyString(const QString &s) const
{
    for (QChar c : s) {
        if (c.isSpace())
            continue;

        if (c.isDigit())
            return StringGroup::Digit;

        ushort u = c.unicode();
        if ((u >= 'A' && u <= 'Z') || (u >= 'a' && u <= 'z'))
            return StringGroup::Latin;

        return StringGroup::CJK;
    }
    return StringGroup::CJK;
}

bool PanelPluginSortProxyModel::lessThan(const QModelIndex &leftIndex, const QModelIndex &rightIndex) const
{
    const QString left = sourceModel()->data(leftIndex, Qt::DisplayRole).toString();
    const QString right = sourceModel()->data(rightIndex, Qt::DisplayRole).toString();

    const StringGroup leftGroup  = classifyString(left);
    const StringGroup rightGroup = classifyString(right);

    if (leftGroup != rightGroup)
        return static_cast<int>(leftGroup) < static_cast<int>(rightGroup);

    if (leftGroup == StringGroup::Digit) {
        QCollator digitCollator(QLocale::c());
        digitCollator.setNumericMode(true);
        digitCollator.setCaseSensitivity(Qt::CaseInsensitive);
        return digitCollator.compare(left, right) < 0;
    }

    if (leftGroup == StringGroup::Latin) {
        return QString::compare(left, right, Qt::CaseInsensitive) < 0;
    }

    QCollator zhCollator(QLocale(QLocale::Chinese, QLocale::China));
    zhCollator.setNumericMode(true);
    zhCollator.setCaseSensitivity(Qt::CaseInsensitive);

    return zhCollator.compare(left, right) < 0;
}
