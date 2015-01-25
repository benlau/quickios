#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include "qisystemutils.h"
#include "qiviewdelegate.h"

typedef bool (*handler)(QVariantMap data);
static QMap<QString,handler> handlers;
static QPointer<QISystemUtils> m_instance;

static bool alertViewCreate(QVariantMap data) {
    Q_UNUSED(data);

    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->alertViewClickedButtonAtIndex = ^(NSInteger buttonIndex) {
        QString name = "alertViewClickedButtonAtIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));
    };

    NSString* title = data["title"].toString().toNSString();
    NSString* message = data["message"].toString().toNSString();
    QStringList buttons = data["buttons"].toStringList();

    UIAlertView *alert = [UIAlertView alloc ] ;
    [alert initWithTitle:title
        message:message
        delegate:delegate
        cancelButtonTitle:nil
        otherButtonTitles:nil
        ];

    for (int i = 0 ; i < buttons.size();i++) {
        NSString *btn = buttons.at(i).toNSString();
        [alert addButtonWithTitle:btn];
    }

    [alert show];
    [alert release];

    return true;
}

static bool actionSheetCreate(QVariantMap data) {
    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->actionSheetClickedButtonAtIndex = ^(NSInteger buttonIndex) {
        QString name = "actionSheetClickedButtonAtIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));

    };

    NSString* title = data["title"].toString().toNSString();
    NSString* cancelButtonTitle = data["cancelButtonTitle"].toString().toNSString();
    QStringList buttons = data["otherButtonTitles"].toStringList();

    UIActionSheet* actionSheet = [UIActionSheet alloc];


    [actionSheet initWithTitle:title
        delegate:delegate
        cancelButtonTitle: nil
        destructiveButtonTitle:nil
        otherButtonTitles:nil];

    for (int i = 0 ; i < buttons.size();i++) {
        NSString *btn = buttons.at(i).toNSString();
        [actionSheet addButtonWithTitle:btn];
    }

    // Reference: http://stackoverflow.com/questions/1602214/use-nsarray-to-specify-otherbuttontitles

    [actionSheet addButtonWithTitle:cancelButtonTitle];

    actionSheet.cancelButtonIndex = buttons.size();

    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    [actionSheet release];

    return true;
}

static bool imagePickerControllerPresent(QVariantMap data) {

    UIApplication* app = [UIApplication sharedApplication];

    if (app.windows.count <= 0)
        return false;

    UIWindow* rootWindow = app.windows[0];
    UIViewController* rootViewController = rootWindow.rootViewController;

    int sourceType = data["sourceType"].toInt();

    if (![UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceType) sourceType]) {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                          message:@"The operation is not supported in this device"
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil];
        [myAlertView show];
        [myAlertView release];
        return false;
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = (UIImagePickerControllerSourceType) sourceType;

    [rootViewController presentViewController:picker animated:YES completion:NULL];

    return true;
}

static bool applicationSetStatusBarStyle(QVariantMap data) {
    qDebug() << data;
    if (!data.contains("style")) {
        qWarning() << "applicationSetStatusBarStyle: Missing argument";
        return false;
    }

    int style = data["style"].toInt();
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyle) style];
    return true;
}

QISystemUtils *QISystemUtils::instance()
{
    if (!m_instance) {
        QCoreApplication* app = QCoreApplication::instance();
        m_instance = new QISystemUtils(app);

        handlers["alertViewCreate"]  = alertViewCreate;
        handlers["applicationSetStatusBarStyle"]  = applicationSetStatusBarStyle;
        handlers["actionSheetCreate"]  = actionSheetCreate;
        handlers["imagePickerControllerPresent"] = imagePickerControllerPresent;

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
