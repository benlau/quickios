#include <QtQml>
#include <QtGui>
#include <QVariantMap>
#include "quickios.h"
#include "qialertview.h"
#include "qisystemutils.h"

static QJSValue aProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
  Q_UNUSED(engine);

  QScreen *src = QGuiApplication::screens().at(0);

  QJSValue value = scriptEngine->newObject();
  value.setProperty("screenWidth", src->availableGeometry().width());
  value.setProperty("screenHeight", src->availableGeometry().height());

  return value;
}

static QJSValue systemProvider(QQmlEngine* engine , QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    QISystemUtils *system = QISystemUtils::instance();

    QJSValue value = scriptEngine->newQObject(system);
    return value;
}

void QuickIOS::registerTypes()
{
  qmlRegisterSingletonType("QuickIOS", 0, 1, "System", systemProvider);
  qmlRegisterType<QIAlertView>("QuickIOS",0,1,"IAlertView");
}
