#include <QApplication>
#include <QtQuickTest/quicktest.h>
#include <QFileInfo>
#include <QtCore>
#include "quickios.h"

int main(int argc, char **argv)
{
    QApplication a(argc, argv);
    QuickIOS::registerTypes();

    QStringList args = a.arguments();
    QString executable = args.at(0);

    QFileInfo info(SRCDIR);
    char **s = (char**) malloc(sizeof(char*) * (10 + args.size() ) );
    int idx = 0;

    QByteArray srcdir = info.absoluteFilePath().toLocal8Bit();
    QString qrc = QString("qrc:///");

    s[idx++] = executable.toLocal8Bit().data();
    s[idx++] = strdup("-import");
    s[idx++] = srcdir.data();
    s[idx++] = strdup("-import");
    s[idx++] = qrc.toLocal8Bit().data();

    for (int i = 1 ; i < args.size();i++) {
        s[idx++] = strdup(args.at(i).toLocal8Bit().data());
    }

    s[idx++] = 0;

    return quick_test_main( idx-1,s,"Quick IOS",srcdir.data());
}
