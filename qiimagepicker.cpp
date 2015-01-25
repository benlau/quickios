#include "qisystemutils.h"
#include "qiimagepicker.h"

QIImagePicker::QIImagePicker(QQuickItem *parent) : QQuickItem(parent)
{
    m_sourceType = PhotoLibrary;
}

QIImagePicker::~QIImagePicker()
{

}

void QIImagePicker::show()
{
    QISystemUtils* system = QISystemUtils::instance();

    QVariantMap data;
    data["sourceType"] = m_sourceType;

    system->sendMessage("imagePickerControllerPresent",data);
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


