#include <QtQml>
#include <QtGui>
#include <QVariantMap>
#include <QPointer>
#include "quickios.h"
#include "qialertview.h"
#include "qisystemutils.h"
#include "qidevice.h"
#include "qiactionsheet.h"
#include "qiimagepicker.h"
#include "qiactivityindicator.h"

static QPointer<QIDevice> deviceInstance;

static QJSValue systemProvider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    QISystemUtils *system = QISystemUtils::instance();

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
  qmlRegisterSingletonType("QuickIOS", 0, 1, "QISystem", systemProvider);
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
#endif
}

void QuickIOS::setStatusBarStyle(QuickIOS::StatusBarStyle style)
{
    QISystemUtils *system = QISystemUtils::instance();
    QVariantMap data;
    data["style"] = style;

    system->sendMessage("applicationSetStatusBarStyle",data);
}
