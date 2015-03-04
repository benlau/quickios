#include "qialertview.h"
#include "qisystemutils.h"
#ifndef Q_OS_IOS

#endif

QIAlertView::QIAlertView(QQuickItem *parent) :
    QQuickItem(parent)
{
    m_buttons << tr("Cancel") << tr("OK");
    m_opened = false;
    m_clickedButtonIndex = -1;
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


void QIAlertView::show()
{
    if (m_opened)
        return;

    QISystemUtils* system = QISystemUtils::instance();
#ifdef Q_OS_IOS
    QVariantMap data;
    data["title"] = m_title;
    data["message"] = m_message;
    data["buttons"] = m_buttons;

    m_opened = true;
    connect(system,SIGNAL(received(QString,QVariantMap)),
            this,SLOT(onReceived(QString,QVariantMap)));

    system->sendMessage("alertViewCreate",data);
#else

    QMessageBox dialog;

    dialog.setWindowTitle(m_title);
    dialog.setText(m_message);

    for (int i = 0 ; i < m_buttons.size() ; i++) {
        dialog.addButton(m_buttons.at(i),QMessageBox::ActionRole);
    }

    int result = dialog.exec();
    // Reserve the direction to fit iOS style
    result = m_buttons.count() - 1 - result;
    setClickedButtonIndex(result);
    emit clicked(result);
#endif
}

void QIAlertView::onReceived(QString name, QVariantMap data)
{
    if (name != "alertViewClickedButtonAtIndex"){
        return;
    }

    int buttonIndex = data["buttonIndex"].toInt();
    setClickedButtonIndex(buttonIndex);
    m_opened = false;
    QISystemUtils* system = QISystemUtils::instance();
    system->disconnect(this);
    emit clicked(buttonIndex);
}
int QIAlertView::clickedButtonIndex() const
{
    return m_clickedButtonIndex;
}

void QIAlertView::setClickedButtonIndex(int clickedButtonIndex)
{
    m_clickedButtonIndex = clickedButtonIndex;
    emit clickedButtonIndexChanged();
}


QStringList QIAlertView::buttons() const
{
    return m_buttons;
}

void QIAlertView::setButtons(const QStringList &buttons)
{
    m_buttons = buttons;
}


