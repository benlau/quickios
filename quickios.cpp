#include <QtQml>
#include <QtGui>
#include <QVariantMap>
#include <QPointer>
#include "quickios.h"
#include "qialertview.h"
#include "qisystemdispatcher.h"
#include "qidevice.h"
#include "qiactionsheet.h"
#include "qiimagepicker.h"
#include "qiactivityindicator.h"

static QJSValue systemProvider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    QISystemDispatcher *system = QISystemDispatcher::instance();

    QJSValue value = scriptEngine->newQObject(system);
    return value;
}

static QJSValue deviceProvider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);

    QIDevice* device = QIDevice::instance();

    QScreen *src = QGuiApplication::screens().at(0); // @TODO: Dynamic update
    device->setScreenWidth(src->availableGeometry().width());
    device->setScreenHeight(src->availableGeometry().height());

    QJSValue value = scriptEngine->newQObject(device);
    return value;
}


void QuickIOS::registerTypes()
{

}

void QuickIOS::setupWindow(QQuickWindow *window)
{
#ifdef Q_OS_IOS
    QIDevice* device = QIDevice::instance();
    device->setScreenFillStatusBar(true);
    window->showFullScreen();
#else
    Q_UNUSED(window);
#endif
}

void QuickIOS::setStatusBarStyle(QuickIOS::StatusBarStyle style)
{
    QISystemDispatcher *system = QISystemDispatcher::instance();
    QVariantMap data;
    data["style"] = style;

    system->dispatch("applicationSetStatusBarStyle",data);
}

void QuickIOS::setStatusBarHidden(bool hidden, int animation)
{
    QISystemDispatcher* dispatcher = QISystemDispatcher::instance();
    QVariantMap message;
    message["hidden"] = hidden;
    message["animation"] = animation;
    dispatcher->dispatch("applicationSetStatusBarHidden", message);
}

static void registerTypes() {
    qmlRegisterSingletonType("QuickIOS", 0, 1, "SystemMessenger", systemProvider);
    qmlRegisterSingletonType("QuickIOS", 0, 1, "QIDevice", deviceProvider);

    qmlRegisterType<QIAlertView>("QuickIOS",0,1,"AlertView");
    qmlRegisterType<QIActionSheet>("QuickIOS",0,1,"ActionSheet");
    qmlRegisterType<QIImagePicker>("QuickIOS",0,1,"ImagePicker");
    qmlRegisterType<QIActivityIndicator>("QuickIOS",0,1,"ActivityIndicator");
}

Q_COREAPP_STARTUP_FUNCTION(registerTypes)
