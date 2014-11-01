#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include "qisystemutils.h"
#include "qiviewdelegate.h"

typedef bool (*handler)(QVariantMap data);
static QMap<QString,handler> handlers;
static QISystemUtils * m_instance = 0;

static bool createAlertView(QVariantMap data) {
    Q_UNUSED(data);

    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->alertViewDismissWithButtonIndex = ^(NSInteger buttonIndex) {
        QString name = "alertViewDismissWithButtonIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));
    };

    UIAlertView *alert = [UIAlertView alloc ] ;
    [alert initWithTitle:@"OK Dailog"
        message:@"This is OK dialog"
        delegate:delegate
        cancelButtonTitle:@"Ok"
        otherButtonTitles:nil
        ];
    [alert show];

    return true;
}

QISystemUtils *QISystemUtils::instance()
{
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
