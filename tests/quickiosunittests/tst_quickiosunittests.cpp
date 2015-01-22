#include <QString>
#include <QtTest>
#include <QCoreApplication>
#include <QQmlEngine>
#include <QQmlComponent>
#include "quickios.h"

class QuickIOSUnitTests : public QObject
{
    Q_OBJECT

public:
    QuickIOSUnitTests();

private Q_SLOTS:
    void initTestCase();
    void cleanupTestCase();
    void resourceLoading();
};

QuickIOSUnitTests::QuickIOSUnitTests()
{
}

void QuickIOSUnitTests::initTestCase()
{
    QuickIOS::registerTypes();
}

void QuickIOSUnitTests::cleanupTestCase()
{
}

void QuickIOSUnitTests::resourceLoading()
{
    QQueue<QString> queue;
    queue.enqueue(":/");

    QQmlEngine engine;
    engine.addImportPath("qrc:///");

    while (queue.size()) {
        QString path = queue.dequeue();
        QDir dir(path);
        QFileInfoList infos = dir.entryInfoList(QStringList());
        for (int i = 0 ; i < infos.size();i++) {
            QFileInfo info = infos.at(i);
            if (info.fileName() == "." || info.fileName() == "..")
                continue;
            if (info.isDir()) {
                queue.enqueue(info.absoluteFilePath());
                continue;
            }
            QUrl url = info.absoluteFilePath().remove(0,1);
            url.setScheme("qrc");

            if (info.suffix() != "qml") {
                continue;
            }

            QFile file(":" + url.path());
            QVERIFY(file.open(QIODevice::ReadOnly));
            QString content = file.readAll();
            content = content.toLower();

            // Skip singleton module as it can not be loaded directly
            if (content.indexOf("pragma singleton") != -1) {
                qDebug() << QString("%1 : Skipped (singleton)").arg(url.toString());
                continue;
            }

            QQmlComponent comp(&engine);
            comp.loadUrl(url);
            if (comp.isError()) {
                qDebug() << QString("%1 : Load Failed. Reason :  %2").arg(info.absoluteFilePath()).arg(comp.errorString());
            }
            QVERIFY(!comp.isError());

            qDebug() << QString("%1 : Passed").arg(info.absoluteFilePath());
        }
    }
}

QTEST_MAIN(QuickIOSUnitTests)

#include "tst_quickiosunittests.moc"
