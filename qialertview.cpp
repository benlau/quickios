#include "qialertview.h"
#include "qisystemutils.h"

QIAlertView::QIAlertView(QQuickItem *parent) :
    QQuickItem(parent)
{
    m_buttons << tr("Cancel") << tr("OK");
    m_opened = false;
}

QString QIAlertView::title() const {
    return m_title;
}


QString QIAlertView::message() const
{
    return m_message;
}

void QIAlertView::setTitle(const QString &arg)
{
    m_title = arg;
    emit titleChanged();
}


void QIAlertView::setMessage(const QString &arg)
{
    m_message = arg;
    emit messageChanged();
}


void QIAlertView::open()
{
    if (m_opened)
        return;

    QISystemUtils* system = QISystemUtils::instance();

    QVariantMap data;
    data["title"] = m_title;
    data["message"] = m_message;
    data["buttons"] = m_buttons;

    m_opened = true;
    connect(system,SIGNAL(received(QString,QVariantMap)),
            this,SLOT(onReceived(QString,QVariantMap)));

    system->sendMessage("alertViewCreate",data);
}

void QIAlertView::onReceived(QString name, QVariantMap data)
{
    if (name != "alertViewDismissWithButtonIndex"){
        return;
    }

    int buttonIndex = data["buttonIndex"].toInt();
    m_opened = false;
    QISystemUtils* system = QISystemUtils::instance();
    system->disconnect(this);
    emit clicked(buttonIndex);
}

QStringList QIAlertView::buttons() const
{
    return m_buttons;
}

void QIAlertView::setButtons(const QStringList &buttons)
{
    m_buttons = buttons;
}


