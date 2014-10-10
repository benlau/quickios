#include <QtQml>
#include <QtGui>
#include <QVariantMap>
#include "quickios.h"

static QJSValue aProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
  QScreen *src = QGuiApplication::screens().at(0);

  QJSValue value = scriptEngine->newObject();
  value.setProperty("screenWidth", src->availableGeometry().width());
  value.setProperty("screenHeight", src->availableGeometry().height());

  return value;
}

void QuickIOS::registerTypes()
{
  qmlRegisterSingletonType("QuickIOS", 0, 1, "A", aProvider);
}
