#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include <QPointer>
#include <QtCore>
#include <QImage>
#include "qisystemutils.h"
#include "qiviewdelegate.h"

static bool isPad() {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

static QImage cloneAsQImage(UIImage* image) {
    QImage::Format format = QImage::Format_RGB32;

    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;

    int orientation = [image imageOrientation];
    int degree = 0;

    switch (orientation) {
    case UIImageOrientationLeft:
        degree = -90;
        break;
    case UIImageOrientationDown: // Down
        degree = 180;
        break;
    case UIImageOrientationRight:
        degree = 90;
        break;
    }

    if (degree == 90 || degree == -90)  {
        CGFloat tmp = width;
        width = height;
        height = tmp;
    }

    QSize size(width,height);

    QImage result = QImage(size,format);

    CGContextRef contextRef = CGBitmapContextCreate(result.bits(),                 // Pointer to  data
                                                   width,                       // Width of bitmap
                                                   height,                       // Height of bitmap
                                                   8,                          // Bits per component
                                                   result.bytesPerLine(),              // Bytes per row
                                                   colorSpace,                 // Colorspace
                                                   kCGImageAlphaNoneSkipFirst |
                                                   kCGBitmapByteOrder32Little); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), image.CGImage);
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
    return app.keyWindow.rootViewController;
}

static bool alertViewCreate(QVariantMap& data) {
    Q_UNUSED(data);

    QISystemUtils* m_instance = QISystemUtils::instance();
    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->alertViewClickedButtonAtIndex = ^(int buttonIndex) {
        QString name = "alertViewClickedButtonAtIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QISystemUtils* m_instance = QISystemUtils::instance();
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
    QISystemUtils* m_instance = QISystemUtils::instance();

    delegate->actionSheetClickedButtonAtIndex = ^(int buttonIndex) {
        QString name = "actionSheetClickedButtonAtIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QISystemUtils* m_instance = QISystemUtils::instance();
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
    QRect rect = data["rect"].value<QRect>();

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

    if (isPad()) {
        qDebug() << "showFromRect";
        [actionSheet showFromRect:CGRectMake(rect.x(),rect.y(),rect.width(),rect.height())
                inView:[rootViewController() view] animated:YES];

    } else {
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
    [actionSheet release];

    return true;
}

static UIImagePickerController* imagePickerController = 0;
static UIActivityIndicatorView* imagePickerControllerActivityIndicator = 0;

static bool imagePickerControllerPresent(QVariantMap& data) {

    UIApplication* app = [UIApplication sharedApplication];
    QISystemUtils* m_instance = QISystemUtils::instance();

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
        Q_UNUSED(picker);

        QString name = "imagePickerControllerDisFinishPickingMetaWithInfo";
        QVariantMap data;

        data["mediaType"] = QString::fromNSString(info[UIImagePickerControllerMediaType]);
        data["mediaUrl"] = fromNSUrl(info[UIImagePickerControllerMediaURL]);
        data["referenceUrl"] = fromNSUrl(info[UIImagePickerControllerReferenceURL]);

//        NSDictionary *metaInfo = info[UIImagePickerControllerMediaMetadata];

//        qDebug() << QString::fromNSString([metaInfo description]);
//        if (metaInfo) {
//            orientation = [metaInfo[@"Orientation"] integerValue];
//        }

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

        QISystemUtils* m_instance = QISystemUtils::instance();

        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));

    };

    delegate->imagePickerControllerDidCancel = ^(UIImagePickerController *picker) {
        Q_UNUSED(picker);

        QString name = "imagePickerControllerDidCancel";
        QVariantMap data;
        QISystemUtils* m_instance = QISystemUtils::instance();
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));
    };

    picker.delegate = delegate;

    imagePickerControllerActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    imagePickerControllerActivityIndicator.center = picker.view.center;
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
    return true;
}

static UIActivityIndicatorView* activityIndicator = 0;

static bool activityIndicatorStartAniamtion(QVariantMap& data) {
    Q_UNUSED(data);
    if (!activityIndicator) {
        int style = data["style"].toInt();

        UIViewController* rootView = rootViewController();

        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle) style];
        activityIndicator.center = rootView.view.center;
        activityIndicator.hidesWhenStopped = YES;

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

class QISystemUtilsRegisterHelper {
public:
    QISystemUtilsRegisterHelper() {
        QISystemUtils* m_instance = QISystemUtils::instance();

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

};

static QISystemUtilsRegisterHelper registerHelper;
