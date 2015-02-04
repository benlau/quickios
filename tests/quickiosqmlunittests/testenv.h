#ifndef TESTENV_H
#define TESTENV_H

#include <QObject>

/// Provides helper functions and data for test suite

class TestEnv : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int waitTime READ waitTime WRITE setWaitTime NOTIFY waitTimeChanged)
public:
    explicit TestEnv(QObject *parent = 0);
    ~TestEnv();

    int waitTime() const;
    void setWaitTime(int waitTime);

    Q_INVOKABLE QObject* findChild(QObject* parent,QString name);

signals:
    void waitTimeChanged();

private:
    int m_waitTime;

};

#endif // TESTENV_H
