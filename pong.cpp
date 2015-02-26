#include <stdio.h>
#include <stdlib.h>

#include <QtCore/QCoreApplication>
#include <QtCore/QTimer>
#include <QtDBus/QtDBus>

#include "pong.h"

Pong::Pong()
{
    if (!QDBusConnection::sessionBus().isConnected()) {
        fprintf(stderr, "Cannot connect to the D-Bus session bus.\n"
                "To start it, run:\n"
                "\teval `dbus-launch --auto-syntax`\n");
    }

    if (!QDBusConnection::sessionBus().registerService("org.cinpla.focus")) {
        fprintf(stderr, "%s\n",
                qPrintable(QDBusConnection::sessionBus().lastError().message()));
    }

    QDBusConnection::sessionBus().registerObject("/", this, QDBusConnection::ExportAllSlots);
}

QString Pong::response() const
{
    return m_response;
}

QString Pong::ping(const QString &message)
{
    emit pinged(message);
    return response();
}

void Pong::setResponse(QString arg)
{
    if (m_response == arg)
        return;

    m_response = arg;
    emit responseChanged(arg);
}
