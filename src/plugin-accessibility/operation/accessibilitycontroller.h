// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
#ifndef ACCESSIBILITYCONTROLLER_H
#define ACCESSIBILITYCONTROLLER_H

#include <QObject>

// 辅助功能：读写 GNOME 兼容的 a11y 设置。
// 项目既有做法是调用 gsettings 命令行（见 plugin-defaultapp），这里沿用，
// 避免引入 gsettings-qt 依赖。
class AccessibilityController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool screenReaderEnabled READ screenReaderEnabled WRITE setScreenReaderEnabled NOTIFY screenReaderEnabledChanged FINAL)
    Q_PROPERTY(bool screenKeyboardEnabled READ screenKeyboardEnabled WRITE setScreenKeyboardEnabled NOTIFY screenKeyboardEnabledChanged FINAL)
    Q_PROPERTY(bool magnifierEnabled READ magnifierEnabled WRITE setMagnifierEnabled NOTIFY magnifierEnabledChanged FINAL)
    Q_PROPERTY(bool stickyKeysEnabled READ stickyKeysEnabled WRITE setStickyKeysEnabled NOTIFY stickyKeysEnabledChanged FINAL)
    Q_PROPERTY(bool slowKeysEnabled READ slowKeysEnabled WRITE setSlowKeysEnabled NOTIFY slowKeysEnabledChanged FINAL)
    Q_PROPERTY(bool bounceKeysEnabled READ bounceKeysEnabled WRITE setBounceKeysEnabled NOTIFY bounceKeysEnabledChanged FINAL)
    Q_PROPERTY(bool dwellClickEnabled READ dwellClickEnabled WRITE setDwellClickEnabled NOTIFY dwellClickEnabledChanged FINAL)

public:
    explicit AccessibilityController(QObject *parent = nullptr);

    bool screenReaderEnabled() const;
    bool screenKeyboardEnabled() const;
    bool magnifierEnabled() const;
    bool stickyKeysEnabled() const;
    bool slowKeysEnabled() const;
    bool bounceKeysEnabled() const;
    bool dwellClickEnabled() const;

public Q_SLOTS:
    void setScreenReaderEnabled(bool value);
    void setScreenKeyboardEnabled(bool value);
    void setMagnifierEnabled(bool value);
    void setStickyKeysEnabled(bool value);
    void setSlowKeysEnabled(bool value);
    void setBounceKeysEnabled(bool value);
    void setDwellClickEnabled(bool value);

Q_SIGNALS:
    void screenReaderEnabledChanged(bool value);
    void screenKeyboardEnabledChanged(bool value);
    void magnifierEnabledChanged(bool value);
    void stickyKeysEnabledChanged(bool value);
    void slowKeysEnabledChanged(bool value);
    void bounceKeysEnabledChanged(bool value);
    void dwellClickEnabledChanged(bool value);

private:
    bool readBool(const char *schema, const char *key) const;
    void writeBool(const char *schema, const char *key, bool value) const;
};

#endif // ACCESSIBILITYCONTROLLER_H
