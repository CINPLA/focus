#ifndef PONG_H
#define PONG_H

#include <QtCore/QObject>

class Pong: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString response READ response WRITE setResponse NOTIFY responseChanged)
    QString m_response;

public:
    Pong();
    QString response() const;

public slots:
    Q_SCRIPTABLE QString ping(const QString &message);
    void setResponse(QString arg);

signals:
    void pinged(QString message);
    void responseChanged(QString arg);
};

#endif
