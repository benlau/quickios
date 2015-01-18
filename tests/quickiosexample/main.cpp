#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QtCore>
#include "qisystemutils.h"
#include "quickios.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Quick iOS Initialization
    engine.addImportPath("qrc:///");
    QuickIOS::registerTypes(); // It must be called before loaded any scene

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());

    /// Setup the QQuickWindow instance to fit the iOS environment
    QuickIOS::setupWindow(window);

    QuickIOS::setStatusBarStyle(QuickIOS::StatusBarStyleDefault);

    return app.exec();
}
