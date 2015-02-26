#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QtCore/QCoreApplication>
#include <QtCore/QTimer>
#include <QtDBus/QtDBus>
#include <stdio.h>
#include <stdlib.h>

#include "pong.h"
#define SERVICE_NAME            "org.example.QtDBus.PingExample"

int main(int argc, char *argv[])
{
    qmlRegisterType<Pong>("Pong", 1, 0, "Pong");

    QGuiApplication app(argc, argv);

    QFontDatabase::addApplicationFont(":/fonts/SourceSansPro-Regular.ttf");
    app.setFont(QFont("Source Sans Pro"));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:///qml/main.qml")));


    return app.exec();
}
