#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include "qisystemutils.h"

typedef bool (*handler)(QVariantMap data);
static QMap<QString,handler> handlers;

static bool createAlertView(QVariantMap data) {
    Q_UNUSED(data);

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; // white text
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault]; // default black text

    UIAlertView *alert = [UIAlertView alloc ] ;
    [alert initWithTitle:@"OK Dailog"
        message:@"This is OK dialog"
        delegate:nil
        cancelButtonTitle:@"Ok"
        otherButtonTitles:nil
        ];
    [alert show];

    return true;
}

QISystemUtils *QISystemUtils::instance()
{
    static QISystemUtils * m_instance = 0;
    if (!m_instance) {
        QCoreApplication* app = QCoreApplication::instance();
        m_instance = new QISystemUtils(app);

        handlers["createAlertView"]  = createAlertView;

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
