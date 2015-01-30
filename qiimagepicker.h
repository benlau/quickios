#ifndef QIIMAGEPICKER_H
#define QIIMAGEPICKER_H

#include <QQuickItem>
#include <QImage>

/// QIImagePicker provides a simple interface to access camera and camera roll via the UIImagePickerController
class QIImagePicker : public QQuickItem
{
    Q_OBJECT
    Q_ENUMS(SourceType)
    Q_ENUMS(Status)
    Q_PROPERTY(SourceType sourceType READ sourceType WRITE setSourceType NOTIFY sourceTypeChanged)
    Q_PROPERTY(QImage image READ image WRITE setImage NOTIFY imageChanged)
    Q_PROPERTY(Status status READ status WRITE setStatus NOTIFY statusChanged)

public:
    enum SourceType {
        PhotoLibrary,
        Camera,
        SavedPhotosAlbum
    };

    enum Status {
        Null, // Nothing loaded
        Running, // The view controller is running
        Ready, // The image is ready
        Saving // The image is saving
    };

    QIImagePicker(QQuickItem* parent = 0);
    ~QIImagePicker();

    Q_INVOKABLE void show();

    Q_INVOKABLE void save(QString fileName);

    /// Save the stored image to tmp file.
    Q_INVOKABLE void saveAsTemp();

    Q_INVOKABLE void clear();

    SourceType sourceType() const;
    void setSourceType(const SourceType &sourceType);

    QImage image() const;
    void setImage(const QImage &image);

    Status status() const;
    void setStatus(const Status &status);

signals:
    void sourceTypeChanged();
    void imageChanged();
    void statusChanged();

    void ready();
    void saved(QString fileName);

private:
    Q_INVOKABLE void endSave(QString fileName);

    SourceType m_sourceType;
    QImage m_image;
    Status m_status;
};

#endif // QIIMAGEPICKER_H
