#ifndef PONG_H
#define PONG_H

#include <QtCore/QObject>

class Pong: public QObject
{
    Q_OBJECT
public:
    Pong();
public slots:
    Q_SCRIPTABLE QString ping(const QString &arg);
signals:
    void pinged();
};

#endif
