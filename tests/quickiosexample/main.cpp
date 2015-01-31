
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtCore>
#include "qisystemutils.h"
#include "quickios.h"

#ifndef Q_OS_IOS
#include <QApplication>
#endif

int main(int argc, char *argv[])
{
#ifdef Q_OS_IOS
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc,argv);
#endif

    QQmlApplicationEngine engine;

    // Quick iOS Initialization
    engine.addImportPath("qrc:///");
    QuickIOS::registerTypes(); // It must be called before loaded any scene

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());

    /// Setup the QQuickWindow instance to fit the iOS environment
    QuickIOS::setupWindow(window);

    QuickIOS::setStatusBarStyle(QuickIOS::StatusBarStyleDefault);

    QISystemUtils::instance()->sendMessage("activityIndicatorStart",QVariantMap());

    return app.exec();
}
