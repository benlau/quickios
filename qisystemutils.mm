#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include "qisystemutils.h"
#include "qiviewdelegate.h"

typedef bool (*handler)(QVariantMap data);
static QMap<QString,handler> handlers;
static QPointer<QISystemUtils> m_instance;

static QImage cloneAsQImage(UIImage* image) {
    QImage::Format format = QImage::Format_RGB32;

    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    QSize size(cols,rows);

    QImage result = QImage(size,format);


    CGContextRef contextRef = CGBitmapContextCreate(result.bits(),                 // Pointer to  data
                                                   cols,                       // Width of bitmap
                                                   rows,                       // Height of bitmap
                                                   8,                          // Bits per component
                                                   result.bytesPerLine(),              // Bytes per row
                                                   colorSpace,                 // Colorspace
                                                   kCGImageAlphaNoneSkipFirst |
                                                   kCGBitmapByteOrder32Little); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return result;
}

static QString fromNSUrl(NSURL* url) {
    QString result = QString::fromNSString([url absoluteString]);

    return result;
}

static UIViewController* rootViewController() {
    UIApplication* app = [UIApplication sharedApplication];

    if (app.windows.count <= 0)
        return 0;

    UIWindow* rootWindow = app.windows[0];
    UIViewController* rootViewController = rootWindow.rootViewController;
    return rootViewController;
}

static bool alertViewCreate(QVariantMap data) {
    Q_UNUSED(data);

    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->alertViewClickedButtonAtIndex = ^(int buttonIndex) {
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

    delegate->actionSheetClickedButtonAtIndex = ^(int buttonIndex) {
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

static UIImagePickerController* imagePickerController = 0;
static UIActivityIndicatorView* imagePickerControllerActivityIndicator = 0;

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
    imagePickerController = picker;
    picker.sourceType = (UIImagePickerControllerSourceType) sourceType;

    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->imagePickerControllerDidFinishPickingMediaWithInfo = ^(UIImagePickerController *picker,
                                                                     NSDictionary* info) {
//        [picker dismissViewControllerAnimated:YES completion:NULL];

        QString name = "imagePickerControllerDisFinishPickingMetaWithInfo";
        QVariantMap data;

        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        if (!chosenImage) {
            chosenImage = info[UIImagePickerControllerOriginalImage];
        }

        if (!chosenImage) {
            qWarning() << "Image Picker: Failed to take image";
            name = "imagePickerControllerDidCancel";
        } else {
            QImage chosenQImage = cloneAsQImage(chosenImage);
            data["image"] = QVariant::fromValue<QImage>(chosenQImage);
        }

        data["mediaType"] = QString::fromNSString(info[UIImagePickerControllerMediaType]);
        data["mediaUrl"] = fromNSUrl(info[UIImagePickerControllerMediaURL]);
        data["referenceUrl"] = fromNSUrl(info[UIImagePickerControllerReferenceURL]);

        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));

    };

    delegate->imagePickerControllerDidCancel = ^(UIImagePickerController *picker) {
        QString name = "imagePickerControllerDidCancel";
        QVariantMap data;
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));
    };

    picker.delegate = delegate;

    imagePickerControllerActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    imagePickerControllerActivityIndicator.center = picker.view.center;
    imagePickerControllerActivityIndicator.hidesWhenStopped;
    [picker.view addSubview:imagePickerControllerActivityIndicator];

    [rootViewController presentViewController:picker animated:YES completion:NULL];

    return true;
}

bool imagePickerControllerDismiss(QVariantMap data) {
    Q_UNUSED(data);
    if (!imagePickerController)
        return false;

    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    [imagePickerController release];

    [imagePickerControllerActivityIndicator release];

    imagePickerController = 0;
    imagePickerControllerActivityIndicator = 0;
    return true;
}

bool imagePickerControllerSetIndicator(QVariantMap data) {
    if (!imagePickerControllerActivityIndicator)
        return false;

    bool active = data["active"].toBool();

    if (active) {
        [imagePickerControllerActivityIndicator startAnimation];
    } else {
        [imagePickerControllerActivityIndicator stopAnimation];
    }

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

static UIActivityIndicatorView* activityIndicator = 0;

static bool activityIndicatorStartAniamtion(QVariantMap data) {
    Q_UNUSED(data);
    if (!activityIndicator) {
        UIViewController* rootView = rootViewController();

        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = rootView.view.center;
        activityIndicator.hidesWhenStopped = YES;

        qDebug() << rootView.view.tintColor;
        [rootView.view addSubview:activityIndicator];
    }

    [activityIndicator startAnimating];
    return true;
}

static bool activityIndicatorStopAnimation(QVariantMap data) {
    Q_UNUSED(data);

    if (!activityIndicator) {
        return false;
    }

    [activityIndicator stopAnimating];
    [activityIndicator release];
    activityIndicator = 0;
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
        handlers["imagePickerControllerDismiss"] = imagePickerControllerDismiss;
        handlers["imagePickerControllerSetIndicator"] = imagePickerControllerSetIndicator;

        handlers["activityIndicatorStartAnimation"] = activityIndicatorStartAniamtion;
        handlers["activityIndicatorStopAnimation"] = activityIndicatorStopAnimation;
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
