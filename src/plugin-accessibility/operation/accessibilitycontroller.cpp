// SPDX-FileCopyrightText: 2024 - 2027 UnionTech Software Technology Co., Ltd.
// SPDX-License-Identifier: GPL-3.0-or-later
#include "accessibilitycontroller.h"

#include "dccfactory.h"

#include <QProcess>

namespace {
constexpr auto A11yApplications = "com.deepin.wrap.gnome.desktop.a11y.applications";
constexpr auto A11yKeyboard = "com.deepin.wrap.gnome.desktop.a11y.keyboard";
constexpr auto A11yMouse = "com.deepin.wrap.gnome.desktop.a11y.mouse";
}   // namespace

AccessibilityController::AccessibilityController(QObject *parent)
    : QObject(parent)
{
}

bool AccessibilityController::readBool(const char *schema, const char *key) const
{
    QProcess process;
    process.start(QStringLiteral("gsettings"), { QStringLiteral("get"), QString::fromLatin1(schema), QString::fromLatin1(key) });
    if (!process.waitForFinished(3000))
        return false;
    const QString out = QString::fromUtf8(process.readAllStandardOutput()).trimmed();
    return out == QLatin1String("true");
}

void AccessibilityController::writeBool(const char *schema, const char *key, bool value) const
{
    QProcess::startDetached(QStringLiteral("gsettings"),
                            { QStringLiteral("set"), QString::fromLatin1(schema), QString::fromLatin1(key),
                              value ? QStringLiteral("true") : QStringLiteral("false") });
}

bool AccessibilityController::screenReaderEnabled() const { return readBool(A11yApplications, "screen-reader-enabled"); }
bool AccessibilityController::screenKeyboardEnabled() const { return readBool(A11yApplications, "screen-keyboard-enabled"); }
bool AccessibilityController::magnifierEnabled() const { return readBool(A11yApplications, "screen-magnifier-enabled"); }
bool AccessibilityController::stickyKeysEnabled() const { return readBool(A11yKeyboard, "stickykeys-enable"); }
bool AccessibilityController::slowKeysEnabled() const { return readBool(A11yKeyboard, "slowkeys-enable"); }
bool AccessibilityController::bounceKeysEnabled() const { return readBool(A11yKeyboard, "bouncekeys-enable"); }
bool AccessibilityController::dwellClickEnabled() const { return readBool(A11yMouse, "dwell-click-enabled"); }

void AccessibilityController::setScreenReaderEnabled(bool value)
{
    writeBool(A11yApplications, "screen-reader-enabled", value);
    Q_EMIT screenReaderEnabledChanged(value);
}
void AccessibilityController::setScreenKeyboardEnabled(bool value)
{
    writeBool(A11yApplications, "screen-keyboard-enabled", value);
    Q_EMIT screenKeyboardEnabledChanged(value);
}
void AccessibilityController::setMagnifierEnabled(bool value)
{
    writeBool(A11yApplications, "screen-magnifier-enabled", value);
    Q_EMIT magnifierEnabledChanged(value);
}
void AccessibilityController::setStickyKeysEnabled(bool value)
{
    writeBool(A11yKeyboard, "stickykeys-enable", value);
    Q_EMIT stickyKeysEnabledChanged(value);
}
void AccessibilityController::setSlowKeysEnabled(bool value)
{
    writeBool(A11yKeyboard, "slowkeys-enable", value);
    Q_EMIT slowKeysEnabledChanged(value);
}
void AccessibilityController::setBounceKeysEnabled(bool value)
{
    writeBool(A11yKeyboard, "bouncekeys-enable", value);
    Q_EMIT bounceKeysEnabledChanged(value);
}
void AccessibilityController::setDwellClickEnabled(bool value)
{
    writeBool(A11yMouse, "dwell-click-enabled", value);
    Q_EMIT dwellClickEnabledChanged(value);
}

DCC_FACTORY_CLASS(AccessibilityController)
