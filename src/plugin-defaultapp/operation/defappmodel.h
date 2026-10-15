// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef DEFAPPMODEL_H
#define DEFAPPMODEL_H

#include "category.h"
#include "categorymodel.h"

#include <QObject>
#include <QVariantList>

class Category;
class DefAppWorker;
class DefAppWorkerOld;

class DefAppModel : public QObject
{
    Q_OBJECT
    // 已安装应用列表（供“应用”页展示与启动）
    Q_PROPERTY(QVariantList installedApps READ installedApps NOTIFY installedAppsChanged FINAL)
public:
    explicit DefAppModel(QObject *parent = 0);
    ~DefAppModel();

    enum DefAppCategory {
        Browser = 0,
        Mail,
        Text,
        Music,
        Video,
        Picture,
        Terminal,
        Count,
    };

public Q_SLOTS:

    // 扫描 /usr/share/applications 与 ~/.local/share/applications 得到已安装应用
    QVariantList installedApps() const;
    inline CategoryModel *browser() const { return m_categoryModel[Browser]; }

    inline CategoryModel *mail() const { return m_categoryModel[Mail]; }

    inline CategoryModel *text() const { return m_categoryModel[Text]; }

    inline CategoryModel *music() const { return m_categoryModel[Music]; }

    inline CategoryModel *video() const { return m_categoryModel[Video]; }

    inline CategoryModel *picture() const { return m_categoryModel[Picture]; }

    inline CategoryModel *terminal() const { return m_categoryModel[Terminal]; }

    inline Category *getModBrowser() const { return m_categoryModel[Browser]->category(); }

    inline Category *getModMail() const { return m_categoryModel[Mail]->category(); }

    inline Category *getModText() const { return m_categoryModel[Text]->category(); }

    inline Category *getModMusic() const { return m_categoryModel[Music]->category(); }

    inline Category *getModVideo() const { return m_categoryModel[Video]->category(); }

    inline Category *getModPicture() const { return m_categoryModel[Picture]->category(); }

    inline Category *getModTerminal() const { return m_categoryModel[Terminal]->category(); }

Q_SIGNALS:
    void installedAppsChanged();

private:
    CategoryModel *m_categoryModel[Count];
    DefAppWorker *m_work;
    DefAppWorkerOld *m_oldwork;
    bool m_isOldInterface;
};
#endif // DEFAPPMODEL_H
