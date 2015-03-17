#include <QCoreApplication>
#include <QPointer>
#include <QtCore>
#include "qisystemutils.h"

typedef bool (*handler)(QVariantMap& data);
static QMap<QString,handler> handlers;
static QPointer<QISystemUtils> m_instance;

QISystemUtils *QISystemUtils::instance()
{
    if (!m_instance) {
        QCoreApplication* app = QCoreApplication::instance();
        m_instance = new QISystemUtils(app);
    }
    return m_instance;
}

QISystemUtils::QISystemUtils(QObject *parent) : QObject(parent) {
}

bool QISystemUtils::sendMessage(QString name , QVariantMap data) {
    if (!handlers.contains(name))
        return false;
    return handlers[name](data);
}

bool QISystemUtils::registerMessageHandler(QString name, bool (*func)(QVariantMap&))
{
    if (handlers.contains(name)) {
        qWarning() << QString("%s is already registered").arg(name);
        return false;
    }

    handlers[name] = func;
    return true;
}
