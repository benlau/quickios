#include "qisystemutils.h"
#include "qiactivityindicator.h"

QIActivityIndicator::QIActivityIndicator(QQuickItem* parent) : QQuickItem(parent)
{
    m_isAnimating = false;
}

QIActivityIndicator::~QIActivityIndicator()
{

}

void QIActivityIndicator::startAnimation()
{
    if (m_isAnimating)
        return;

    QISystemUtils::instance()->sendMessage("activityIndicatorStartAnimation",QVariantMap());
    setIsAnimating(true);
}

void QIActivityIndicator::stopAnimation()
{
    if (!m_isAnimating)
        return;

    QISystemUtils::instance()->sendMessage("activityIndicatorStopAnimation",QVariantMap());
    setIsAnimating(false);
}

bool QIActivityIndicator::isAnimating() const
{
    return m_isAnimating;
}

void QIActivityIndicator::setIsAnimating(bool isAnimating)
{
    m_isAnimating = isAnimating;
    emit isAnimatingChanged();
}


