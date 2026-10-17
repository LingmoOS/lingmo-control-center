// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef HOMEINTERACTION_H
#define HOMEINTERACTION_H

#include <QObject>
#include <QString>

// 主页设备概览的数据源：5 项只读设备信息。
// 数据在构造时一次性读取本地文件（/etc 与 /proc），读不到时为空串，
// 由 HomeMain.qml 统一显示占位符。
class HomeInteraction : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString deviceName READ deviceName CONSTANT FINAL)
    Q_PROPERTY(QString osName READ osName CONSTANT FINAL)
    Q_PROPERTY(QString cpuModel READ cpuModel CONSTANT FINAL)
    Q_PROPERTY(QString memTotal READ memTotal CONSTANT FINAL)
    Q_PROPERTY(QString kernelVersion READ kernelVersion CONSTANT FINAL)

public:
    explicit HomeInteraction(QObject *parent = nullptr);

    QString deviceName() const;
    QString osName() const;
    QString cpuModel() const;
    QString memTotal() const;
    QString kernelVersion() const;

private:
    QString m_deviceName;
    QString m_osName;
    QString m_cpuModel;
    QString m_memTotal;
    QString m_kernelVersion;
};

#endif   // HOMEINTERACTION_H
