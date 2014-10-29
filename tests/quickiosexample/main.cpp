#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "quickios.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Quick iOS Initialization
    engine.addImportPath("qrc:///");
    QuickIOS::registerTypes(); // It must be called before loaded any scene
    // End of Quick iOS Initialization

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
