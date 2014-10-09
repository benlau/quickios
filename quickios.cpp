#include <QtQml>
#include <QVariantMap>
#include "quickios.h"

static QJSValue aProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{

}

void QuickIOS::registerTypes()
{
  qmlRegisterSingletonType("QuickIOS", 0, 1, "A", aProvider);
}
