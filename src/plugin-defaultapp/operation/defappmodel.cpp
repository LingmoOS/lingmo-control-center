// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#include "defappmodel.h"
#include <QVariantList>
#include <QVariantMap>
#include <QTextStream>
#include <QFile>
#include <QDir>

#include "QtQml/qqml.h"
#include "categorymodel.h"
#include "dccfactory.h"
#include "defappworker.h"
#include "defappworkerold.h"
#include "mimedbusproxyold.h"

DefAppModel::DefAppModel(QObject *parent)
    : QObject(parent)
{
    qmlRegisterType<CategoryModel>("org.deepin.dcc.defApp", 1, 0, "CategoryModel");
    for (int i = 0; i < Count; i++) {
        m_categoryModel[i] = new CategoryModel(new Category(this));
    }
    if (MimeDBusProxyOld::isRegisted()) {
        m_oldwork = new DefAppWorkerOld(this, this);
        m_isOldInterface = true;
        for (int i = 0; i < Count; i++) {
            m_categoryModel[i] = new CategoryModel(new Category(this));
            connect(m_categoryModel[i], &CategoryModel::requestCreateFile, m_oldwork, &DefAppWorkerOld::onCreateFile);
            connect(m_categoryModel[i], &CategoryModel::requestDelUserApp, m_oldwork, &DefAppWorkerOld::onDelUserApp);
            connect(m_categoryModel[i], &CategoryModel::requestSetDefaultApp, m_oldwork, &DefAppWorkerOld::onSetDefaultApp);
        }
        m_oldwork->active();
        m_oldwork->onGetListApps();
    } else {
        m_work = new DefAppWorker(this, this);
        for (int i = 0; i < Count; i++) {
            m_categoryModel[i] = new CategoryModel(new Category(this));
            connect(m_categoryModel[i], &CategoryModel::requestCreateFile, m_work, &DefAppWorker::onCreateFile);
            connect(m_categoryModel[i], &CategoryModel::requestDelUserApp, m_work, &DefAppWorker::onDelUserApp);
            connect(m_categoryModel[i], &CategoryModel::requestSetDefaultApp, m_work, &DefAppWorker::onSetDefaultApp);
        }
        m_work->active();
        m_work->onGetListApps();
    }
}

DefAppModel::~DefAppModel()
{
    for (int i = 0; i < Count; i++) {
        m_categoryModel[i]->deleteLater();
    }
}

DCC_FACTORY_CLASS(DefAppModel)

#include "defappmodel.moc"

// 扫描系统与用户目录下的 .desktop，返回 {name, icon, file} 列表
QVariantList DefAppModel::installedApps() const
{
    QVariantList list;
    const QStringList dirs{ QStringLiteral("/usr/share/applications"),
                            QDir::homePath() + QStringLiteral("/.local/share/applications") };
    for (const QString &dirPath : dirs) {
        QDir dir(dirPath);
        const QStringList files = dir.entryList({ QStringLiteral("*.desktop") }, QDir::Files, QDir::Name);
        for (const QString &fileName : files) {
            QFile file(dir.filePath(fileName));
            if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
                continue;
            QString name, icon, exec;
            bool skip = false, inEntry = false;
            QTextStream in(&file);
            while (!in.atEnd()) {
                const QString line = in.readLine().trimmed();
                if (line.startsWith(QLatin1Char('['))) {
                    inEntry = (line == QLatin1String("[Desktop Entry]"));
                    continue;
                }
                if (!inEntry)
                    continue;
                if (line.startsWith(QLatin1String("Name=")) && name.isEmpty())
                    name = line.mid(5);
                else if (line.startsWith(QLatin1String("Icon=")))
                    icon = line.mid(5);
                else if (line.startsWith(QLatin1String("Exec=")))
                    exec = line.mid(5);
                else if (line == QLatin1String("NoDisplay=true") || line == QLatin1String("Hidden=true"))
                    skip = true;
            }
            file.close();
            if (skip || name.isEmpty() || exec.isEmpty())
                continue;
            QVariantMap item;
            item.insert(QStringLiteral("name"), name);
            item.insert(QStringLiteral("icon"), icon);
            item.insert(QStringLiteral("file"), dir.filePath(fileName));
            list.append(item);
        }
    }
    return list;
}

