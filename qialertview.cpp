#include "qialertview.h"
#include "qisystemmessenger.h"
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

    QISystemMessenger* system = QISystemMessenger::instance();
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

    QMessageBox* dialog = new QMessageBox();

    dialog->setWindowTitle(m_title);
    dialog->setText(m_message);

    for (int i = 0 ; i < m_buttons.size() ; i++) {
        dialog->addButton(m_buttons.at(i),QMessageBox::ActionRole);
    }

    connect(dialog,SIGNAL(finished(int)),
            this,SLOT(onFinished(int)));

    connect(dialog,SIGNAL(finished(int)),
            dialog,SLOT(close()));

    connect(dialog,SIGNAL(finished(int)),
            dialog,SLOT(deleteLater()));

    dialog->show();

#endif
}

void QIAlertView::onReceived(QString name, QVariantMap data)
{
    if (name != "alertViewClickedButtonAtIndex"){
        return;
    }

    QISystemMessenger* system = QISystemMessenger::instance();
    system->disconnect(this);

    int buttonIndex = data["buttonIndex"].toInt();
    onFinished(buttonIndex);
}

void QIAlertView::onFinished(int index)
{
    m_opened = false;
    setClickedButtonIndex(index);
    emit clicked(index);
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


