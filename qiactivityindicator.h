#ifndef QIACTIVITYINDICATOR_H
#define QIACTIVITYINDICATOR_H

#include <QObject>
#include <QQuickItem>

class QIActivityIndicator : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(bool isAnimating READ isAnimating WRITE setIsAnimating NOTIFY isAnimatingChanged)
public:
    QIActivityIndicator(QQuickItem* parent = 0);
    ~QIActivityIndicator();

    Q_INVOKABLE void startAnimation();

    Q_INVOKABLE void stopAnimation();

    bool isAnimating() const;
    void setIsAnimating(bool isAnimating);

signals:
    void isAnimatingChanged();

private:
    bool m_isAnimating;

};

#endif // ACTIVITYINDICATOR_H
