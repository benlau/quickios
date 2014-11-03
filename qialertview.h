#ifndef QIALERTVIEW_H
#define QIALERTVIEW_H

#include <QQuickItem>
#include <QMessageBox>

/// UIAlertView provides an interface to access iOS's UIAlertView

class QIAlertView : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(QStringList buttons READ buttons WRITE setButtons NOTIFY buttonsChanged)

public:

    explicit QIAlertView(QQuickItem *parent = 0);

    virtual QString title() const;
    QString text() const;
    QString message() const;


    QStringList buttons() const;
    void setButtons(const QStringList &buttons);

public Q_SLOTS:
    virtual void setTitle(const QString &arg);
    void setMessage(const QString &arg);

    void open();

Q_SIGNALS:
    void titleChanged();
    void messageChanged();
    void buttonsChanged();

    void clicked(int buttonIndex);

private:
    Q_INVOKABLE void onReceived(QString name,QVariantMap data);
    QString m_title;
    QString m_message;

    QStringList m_buttons;
    bool m_opened;
};

#endif // QIALERTVIEW_H
