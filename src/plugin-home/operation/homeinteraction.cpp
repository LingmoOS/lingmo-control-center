// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
#include "homeinteraction.h"

#include "dccfactory.h"

#include <QFile>
#include <QHash>
#include <QStringList>
#include <QSysInfo>
#include <QTextStream>

namespace {

const QString HostNameFile = QStringLiteral("/etc/hostname");
const QString OsReleaseFile = QStringLiteral("/etc/os-release");
const QString CpuInfoFile = QStringLiteral("/proc/cpuinfo");
const QString MemInfoFile = QStringLiteral("/proc/meminfo");
const QString KernelReleaseFile = QStringLiteral("/proc/sys/kernel/osrelease");

QStringList readFileLines(const QString &path)
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return {};

    QStringList lines;
    QTextStream stream(&file);
    while (!stream.atEnd())
        lines.append(stream.readLine());
    file.close();
    return lines;
}

// 去掉 /etc/os-release 里值的成对引号
QString unquoted(const QString &value)
{
    const QString text = value.trimmed();
    if (text.length() >= 2) {
        const QChar quote = text.front();
        if ((quote == QLatin1Char('"') || quote == QLatin1Char('\'')) && text.back() == quote)
            return text.mid(1, text.length() - 2);
    }
    return text;
}

QHash<QString, QString> readOsRelease()
{
    QHash<QString, QString> values;
    const QStringList lines = readFileLines(OsReleaseFile);
    for (const QString &line : lines) {
        if (line.trimmed().startsWith(QLatin1Char('#')))
            continue;
        const int index = line.indexOf(QLatin1Char('='));
        if (index <= 0)
            continue;
        values.insert(line.left(index).trimmed(), unquoted(line.mid(index + 1)));
    }
    return values;
}

// 设备名称：优先静态主机名 /etc/hostname，取不到时退回运行时主机名
QString readDeviceName()
{
    const QString staticHostName = readFileLines(HostNameFile).value(0).trimmed();
    if (!staticHostName.isEmpty())
        return staticHostName;
    return QSysInfo::machineHostName().trimmed();
}

// 系统：/etc/os-release 的 PRETTY_NAME，缺失时用 NAME + VERSION_ID 拼接
QString readOsName()
{
    const QHash<QString, QString> osRelease = readOsRelease();
    const QString prettyName = osRelease.value(QStringLiteral("PRETTY_NAME"));
    if (!prettyName.isEmpty())
        return prettyName;

    QStringList parts;
    const QString name = osRelease.value(QStringLiteral("NAME"));
    if (!name.isEmpty())
        parts.append(name);
    const QString versionId = osRelease.value(QStringLiteral("VERSION_ID"));
    if (!versionId.isEmpty())
        parts.append(versionId);
    return parts.join(QLatin1Char(' '));
}

// 处理器：/proc/cpuinfo 的型号名，x86 上是 model name，ARM 上可能是 Hardware 等
QString readCpuModel()
{
    const QStringList keys = { QStringLiteral("model name"), QStringLiteral("Hardware"),
                               QStringLiteral("Processor"), QStringLiteral("cpu model") };
    const QStringList lines = readFileLines(CpuInfoFile);
    for (const QString &key : keys) {
        for (const QString &line : lines) {
            const int index = line.indexOf(QLatin1Char(':'));
            if (index <= 0)
                continue;
            if (line.left(index).trimmed().compare(key, Qt::CaseInsensitive) != 0)
                continue;
            const QString value = line.mid(index + 1).trimmed();
            if (!value.isEmpty())
                return value;
        }
    }
    return {};
}

// 内存：/proc/meminfo 的 MemTotal（单位 kB）换算成 GB，保留 1 位小数
QString readMemTotal()
{
    const QStringList lines = readFileLines(MemInfoFile);
    for (const QString &line : lines) {
        if (!line.startsWith(QStringLiteral("MemTotal:")))
            continue;

        const QStringList fields = line.mid(9).trimmed().split(QLatin1Char(' '), Qt::SkipEmptyParts);
        bool ok = false;
        const double kiloBytes = fields.value(0).toDouble(&ok);
        if (!ok || kiloBytes <= 0)
            return {};
        return QStringLiteral("%1 GB").arg(QString::number(kiloBytes / 1024.0 / 1024.0, 'f', 1));
    }
    return {};
}

// 内核：/proc/sys/kernel/osrelease，取不到时退回 Qt 的版本接口
QString readKernelVersion()
{
    const QString release = readFileLines(KernelReleaseFile).value(0).trimmed();
    if (!release.isEmpty())
        return release;
    return QSysInfo::kernelVersion().trimmed();
}

}   // namespace

HomeInteraction::HomeInteraction(QObject *parent)
    : QObject(parent)
    , m_deviceName(readDeviceName())
    , m_osName(readOsName())
    , m_cpuModel(readCpuModel())
    , m_memTotal(readMemTotal())
    , m_kernelVersion(readKernelVersion())
{
}

QString HomeInteraction::deviceName() const
{
    return m_deviceName;
}

QString HomeInteraction::osName() const
{
    return m_osName;
}

QString HomeInteraction::cpuModel() const
{
    return m_cpuModel;
}

QString HomeInteraction::memTotal() const
{
    return m_memTotal;
}

QString HomeInteraction::kernelVersion() const
{
    return m_kernelVersion;
}

DCC_FACTORY_CLASS(HomeInteraction)

#include "homeinteraction.moc"
