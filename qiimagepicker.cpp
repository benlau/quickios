#include <QStandardPaths>
#include <QFileDialog>
#include <QTemporaryFile>
#include <QUrl>
#include <QRunnable>
#include <QPointer>
#include <QThreadPool>
#include <QImageWriter>
#include "qisystemutils.h"
#include "qiimagepicker.h"

class QIImagePickerSaver : public QRunnable {
public:
    QPointer<QIImagePicker> owner;
    QImage image;
    QString fileName;

    void run() {
        if (fileName.isNull()) { // Save as temp
            QTemporaryFile tmp;
            QStringList paths = QStandardPaths::standardLocations(QStandardPaths::TempLocation);
            QString tmpPath = paths.at(0);

            tmp.setFileTemplate(tmpPath + "/XXXXXX.jpg");
            tmp.open();
            fileName = tmp.fileName();
            tmp.close();
        }

        image.save(fileName);
        QImageWriter writer;
        writer.setFileName(fileName);
        if (!writer.write(image)) {
            qWarning() << QString("Failed to save %1 : %2").arg(fileName).arg(writer.errorString());
        }

        if (!owner.isNull()) {
            QMetaObject::invokeMethod(owner.data(),"endSave",Qt::QueuedConnection,
                                      Q_ARG(QString,fileName));
        }
    }
};

QIImagePicker::QIImagePicker(QQuickItem *parent) : QQuickItem(parent)
{
    m_sourceType = PhotoLibrary;
    m_status = Null;
}

QIImagePicker::~QIImagePicker()
{

}

void QIImagePicker::show()
{
    if (m_status == Running || m_status == Saving) {
        return;
    }

#ifdef Q_OS_IOS
    setStatus(Running);

    QISystemUtils* system = QISystemUtils::instance();

    QVariantMap data;
    data["sourceType"] = m_sourceType;

    connect(system,SIGNAL(received(QString,QVariantMap)),
            this,SLOT(onReceived(QString,QVariantMap)));

    system->sendMessage("imagePickerControllerPresent",data);

#else
    setStatus(Running);
    QStringList paths = QStandardPaths::standardLocations(QStandardPaths::DownloadLocation);

    QString file = QFileDialog::getOpenFileName (0,
                                                 tr("Import Image"),
                                                 paths.at(0),
                                                 "Images (*.png *.xpm *.jpg)");

    if (file.isNull()) {
        setStatus(Null);
    } else {
        QImage image;
        if (!image.load(file)) {
            setStatus(Null);
        } else {
            setImage(image);
            setStatus(Ready);
            emit ready();
        }
    }
#endif
}

void QIImagePicker::close()
{
    QISystemUtils* system = QISystemUtils::instance();

    system->sendMessage("imagePickerControllerDismiss",QVariantMap());
}

void QIImagePicker::save(QString fileName)
{
    QIImagePickerSaver* saver = new QIImagePickerSaver();
    saver->setAutoDelete(true);
    saver->owner = this;
    saver->fileName = fileName;
    saver->image = m_image;

    QThreadPool::globalInstance()->start(saver);
}

void QIImagePicker::saveAsTemp()
{
    save(QString());
}

void QIImagePicker::clear()
{
    setImage(QImage());
    setStatus(Null);
}

QIImagePicker::SourceType QIImagePicker::sourceType() const
{
    return m_sourceType;
}

void QIImagePicker::setSourceType(const SourceType &sourceType)
{
    m_sourceType = sourceType;
    emit sourceTypeChanged();
}

QImage QIImagePicker::image() const
{
    return m_image;
}

void QIImagePicker::setImage(const QImage &image)
{
    m_image = image;
}

QIImagePicker::Status QIImagePicker::status() const
{
    return m_status;
}

void QIImagePicker::setStatus(const Status &status)
{
    if (m_status == status)
        return;
    m_status = status;
    emit statusChanged();
}

void QIImagePicker::onReceived(QString name, QVariantMap data)
{
    QISystemUtils* system = QISystemUtils::instance();

    if (name == "imagePickerControllerDidCancel") {
        setStatus(Null);
        system->disconnect(this);
        close();
    }

    if (name != "imagePickerControllerDisFinishPickingMetaWithInfo")
        return;

    system->disconnect(this);
    QImage image = data["image"].value<QImage>();

    setImage(image);
    setStatus(Ready);
    emit ready();
}

void QIImagePicker::endSave(QString fileName)
{
    QUrl url = QUrl::fromLocalFile(fileName);

    emit saved(url.toString());

    if (m_image.isNull()) {
        setStatus(Null);
    } else {
        setStatus(Ready);
    }
}




