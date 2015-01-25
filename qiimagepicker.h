#ifndef QIIMAGEPICKER_H
#define QIIMAGEPICKER_H

#include <QQuickItem>

/// QIImagePicker provides a simple interface to access camera and camera roll via the UIImagePickerController
class QIImagePicker : public QQuickItem
{
    Q_OBJECT
    Q_ENUMS(SourceType)
    Q_PROPERTY(SourceType sourceType READ sourceType WRITE setSourceType NOTIFY sourceTypeChanged)
public:
    enum SourceType {
        PhotoLibrary,
        Camera,
        SavedPhotosAlbum
    };

    QIImagePicker(QQuickItem* parent = 0);
    ~QIImagePicker();

    Q_INVOKABLE void show();

    SourceType sourceType() const;
    void setSourceType(const SourceType &sourceType);

signals:
    void sourceTypeChanged();

private:
    SourceType m_sourceType;
};

#endif // QIIMAGEPICKER_H
