#include <QtQml>
#include <QtGui>
#include <QVariantMap>
#include <QPointer>
#include "quickios.h"
#include "qialertview.h"
#include "qisystemmessenger.h"
#include "qidevice.h"
#include "qiactionsheet.h"
#include "qiimagepicker.h"
#include "qiactivityindicator.h"

static QPointer<QIDevice> deviceInstance;

static QJSValue systemProvider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    QISystemMessenger *system = QISystemMessenger::instance();

    QJSValue value = scriptEngine->newQObject(system);
    return value;
}

static QJSValue deviceProvider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);

    if (deviceInstance.isNull()) {
        deviceInstance = new QIDevice();
    }

    QScreen *src = QGuiApplication::screens().at(0); // @TODO: Dynamic update
    deviceInstance->setScreenWidth(src->availableGeometry().width());
    deviceInstance->setScreenHeight(src->availableGeometry().height());

    QJSValue value = scriptEngine->newQObject(deviceInstance.data());
    return value;
}


void QuickIOS::registerTypes()
{
  qmlRegisterSingletonType("QuickIOS", 0, 1, "SystemMessenger", systemProvider);
  qmlRegisterSingletonType("QuickIOS", 0, 1, "QIDevice", deviceProvider);

  qmlRegisterType<QIAlertView>("QuickIOS",0,1,"AlertView");
  qmlRegisterType<QIActionSheet>("QuickIOS",0,1,"ActionSheet");
  qmlRegisterType<QIImagePicker>("QuickIOS",0,1,"ImagePicker");
  qmlRegisterType<QIActivityIndicator>("QuickIOS",0,1,"ActivityIndicator");

}

void QuickIOS::setupWindow(QQuickWindow *window)
{
#ifdef Q_OS_IOS
    if (!deviceInstance.isNull()) {
        deviceInstance->setScreenFillStatusBar(true);
    }

    window->showFullScreen();
#else
    Q_UNUSED(window);
#endif
}

void QuickIOS::setStatusBarStyle(QuickIOS::StatusBarStyle style)
{
    QISystemMessenger *system = QISystemMessenger::instance();
    QVariantMap data;
    data["style"] = style;

    system->sendMessage("applicationSetStatusBarStyle",data);
}
