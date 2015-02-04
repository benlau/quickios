#include <QApplication>
#include <QtQuickTest/quicktest.h>
#include <QFileInfo>
#include <QtCore>
#include <QtQml>
#include <QtGui>
#include <QVariantMap>
#include <execinfo.h>
#include <signal.h>
#include <unistd.h>
#include "quickios.h"
#include "testenv.h"

int waitTime = 1000;

void handleBacktrace(int sig) {
  void *array[100];
  size_t size;

  // get void*'s for all entries on the stack
  size = backtrace(array, 100);

  // print out all the frames to stderr
  fprintf(stderr, "Error: signal %d:\n", sig);
  backtrace_symbols_fd(array, size, STDERR_FILENO);
  exit(1);
}


static QObject* envProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
//  QJSValue value = scriptEngine->newObject();
//  value.setProperty("waitTime", waitTime);
    TestEnv* object = new TestEnv();
    object->setWaitTime(waitTime);
    return object;
}

int main(int argc, char **argv)
{
    signal(SIGSEGV, handleBacktrace);

    QApplication a(argc, argv);
    QuickIOS::registerTypes();
    qmlRegisterSingletonType<TestEnv>("QuickIOS", 0, 1, "TestEnv", envProvider);

    QEventLoop loop;
    QTimer timer;
    QObject::connect(&timer,SIGNAL(timeout()),
                     &loop,SLOT(quit()));
    timer.setInterval(500);
    timer.start();
    loop.exec();

    QStringList args = a.arguments();
    QString executable = args.at(0);

    QFileInfo info(SRCDIR);
    char **s = (char**) malloc(sizeof(char*) * (20 + args.size() ) );
    int idx = 0;

    QByteArray srcdir = info.absoluteFilePath().toLocal8Bit();
    QString qrc = QString("qrc:///");

    s[idx++] = strdup(executable.toLocal8Bit().data());
    s[idx++] = strdup("-import");
    s[idx++] = srcdir.data();
    s[idx++] = strdup("-import");
    s[idx++] = strdup(qrc.toLocal8Bit().data());

    if (args.size() > 1)
        waitTime = 60000; // The wait time should be longer if user asked to run specific test case

    for (int i = 1 ; i < args.size();i++) {
        QString arg = args.at(i);
        qDebug() << arg;
        s[idx++] = strdup(arg.toLocal8Bit().data());
    }

    s[idx++] = 0;

    return quick_test_main( idx-1,s,"Quick IOS",srcdir.data());
}
