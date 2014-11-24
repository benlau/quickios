#ifndef QUICKIOS_H
#define QUICKIOS_H
#include <QtPlugin>

#ifdef Q_OS_IOS
Q_IMPORT_PLUGIN(QtQuickControlsPlugin)
Q_IMPORT_PLUGIN(QtQmlModelsPlugin)
#endif

class QuickIOS
{
public:
  static void registerTypes();

};

#endif // QUICKIOS_H
