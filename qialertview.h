#ifndef QIALERTVIEW_H
#define QIALERTVIEW_H

#include <QQuickItem>
#include <QMessageBox>

/// QIAlertView provides an interface to access iOS's UIAlertView

class QIAlertView : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString message READ message WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(QStringList buttons READ buttons WRITE setButtons NOTIFY buttonsChanged)
    Q_PROPERTY(int clickedButtonIndex READ clickedButtonIndex WRITE setClickedButtonIndex NOTIFY clickedButtonIndexChanged)

public:

    explicit QIAlertView(QQuickItem *parent = 0);

    virtual QString title() const;
    QString text() const;
    QString message() const;


    QStringList buttons() const;
    void setButtons(const QStringList &buttons);

    int clickedButtonIndex() const;
    void setClickedButtonIndex(int clickedButtonIndex);

public Q_SLOTS:
    virtual void setTitle(const QString &arg);
    void setMessage(const QString &arg);

    void show();

Q_SIGNALS:
    void titleChanged();
    void messageChanged();
    void buttonsChanged();

    void clicked(int buttonIndex);
    void clickedButtonIndexChanged();

private:
    Q_INVOKABLE void onReceived(QString name,QVariantMap data);
    QString m_title;
    QString m_message;

    QStringList m_buttons;
    bool m_opened;
    int m_clickedButtonIndex;
};

#endif // QIALERTVIEW_H
