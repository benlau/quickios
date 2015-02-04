#include "testenv.h"

TestEnv::TestEnv(QObject *parent) : QObject(parent)
{
    m_waitTime = 1000;
}

TestEnv::~TestEnv()
{

}
int TestEnv::waitTime() const
{
    return m_waitTime;
}

void TestEnv::setWaitTime(int waitTime)
{
    m_waitTime = waitTime;
    emit waitTimeChanged();
}

QObject *TestEnv::findChild(QObject *parent, QString name)
{
    return parent->findChild<QObject*>(name);
}


