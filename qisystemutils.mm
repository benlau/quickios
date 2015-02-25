#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include "qisystemutils.h"
#include "qiviewdelegate.h"

typedef bool (*handler)(QVariantMap& data);
static QMap<QString,handler> handlers;
static QPointer<QISystemUtils> m_instance;

/// Convert the value of "EXIF orientation" to the degree of rotation
static int exifOrientationToDegree(int orientation) {
    int value = 0;

    switch (orientation) {
    case 8:
        value = -90;
        break;
    case 3:
        value = 180;
        break;
    case 6:
        value = 90;
        break;
    }

    return value;
}

static QImage cloneAsQImage(UIImage* image,int degree) {
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

    if (degree != 0) {
        QTransform myTransform;
        myTransform.rotate(degree);
        result = result.transformed(myTransform,Qt::SmoothTransformation);
    }

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

    UIWindow* rootWindow = app.keyWindow;
    UIViewController* rootViewController = rootWindow.rootViewController;
    return rootViewController;
}

static bool alertViewCreate(QVariantMap& data) {
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

static bool actionSheetCreate(QVariantMap& data) {
    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->actionSheetClickedButtonAtIndex = ^(int buttonIndex) {
        QString name = "actionSheetClickedButtonAtIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));

    };

    NSString* title = nil;
    QString qTitle = data["title"].toString();
    if (!qTitle.isEmpty()) {
        title = qTitle.toNSString();
    }

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

static bool imagePickerControllerPresent(QVariantMap& data) {

    UIApplication* app = [UIApplication sharedApplication];

    if (app.windows.count <= 0)
        return false;

    UIWindow* rootWindow = app.windows[0];
    UIViewController* rootViewController = rootWindow.rootViewController;

    int sourceType = data["sourceType"].toInt();
    bool animated = data["animated"].toBool();

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

        int degree = 0;
        QString name = "imagePickerControllerDisFinishPickingMetaWithInfo";
        QVariantMap data;

        data["mediaType"] = QString::fromNSString(info[UIImagePickerControllerMediaType]);
        data["mediaUrl"] = fromNSUrl(info[UIImagePickerControllerMediaURL]);
        data["referenceUrl"] = fromNSUrl(info[UIImagePickerControllerReferenceURL]);

        NSDictionary *metaInfo = info[UIImagePickerControllerMediaMetadata];

//        qDebug() << QString::fromNSString([metaInfo description]);
        if (metaInfo) {
            int orientation = [metaInfo[@"Orientation"] integerValue];
            degree = exifOrientationToDegree(orientation);
        }

        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        if (!chosenImage) {
            chosenImage = info[UIImagePickerControllerOriginalImage];
        }

        if (!chosenImage) {
            qWarning() << "Image Picker: Failed to take image";
            name = "imagePickerControllerDidCancel";
        } else {
            QImage chosenQImage = cloneAsQImage(chosenImage,degree);
            data["image"] = QVariant::fromValue<QImage>(chosenQImage);
        }


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

    [rootViewController presentViewController:picker animated:animated completion:NULL];

    return true;
}

bool imagePickerControllerDismiss(QVariantMap& data) {
    Q_UNUSED(data);
    if (!imagePickerController)
        return false;

    bool animated = data["animated"].toBool();

    [imagePickerController dismissViewControllerAnimated:animated completion:NULL];
    [imagePickerController release];

    [imagePickerControllerActivityIndicator release];

    imagePickerController = 0;
    imagePickerControllerActivityIndicator = 0;
    return true;
}

bool imagePickerControllerSetIndicator(QVariantMap& data) {
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


static bool applicationSetStatusBarStyle(QVariantMap& data) {
    if (!data.contains("style")) {
        qWarning() << "applicationSetStatusBarStyle: Missing argument";
        return false;
    }

    int style = data["style"].toInt();
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyle) style];
    return true;
}

static bool applicationSetStatusBarHidden(QVariantMap& data) {
    bool hidden = data["hidden"].toBool();
    int animation = data["animation"].toInt();

    [[UIApplication sharedApplication] setStatusBarHidden:(bool) hidden withAnimation:(UIStatusBarAnimation) animation];
}

static UIActivityIndicatorView* activityIndicator = 0;

static bool activityIndicatorStartAniamtion(QVariantMap& data) {
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

static bool activityIndicatorStopAnimation(QVariantMap& data) {
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

        m_instance->registerMessageHandler("alertViewCreate",alertViewCreate);
        m_instance->registerMessageHandler("applicationSetStatusBarStyle",applicationSetStatusBarStyle);
        m_instance->registerMessageHandler("applicationSetStatusBarHidden",applicationSetStatusBarHidden);

        m_instance->registerMessageHandler("actionSheetCreate",actionSheetCreate);
        m_instance->registerMessageHandler("imagePickerControllerPresent",imagePickerControllerPresent);
        m_instance->registerMessageHandler("imagePickerControllerDismiss",imagePickerControllerDismiss);
        m_instance->registerMessageHandler("imagePickerControllerSetIndicator",imagePickerControllerSetIndicator);

        m_instance->registerMessageHandler("activityIndicatorStartAnimation",activityIndicatorStartAniamtion);
        m_instance->registerMessageHandler("activityIndicatorStopAnimation",activityIndicatorStopAnimation);
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
}
