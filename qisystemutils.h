#ifndef QISYSTEMUTILS_H
#define QISYSTEMUTILS_H

#include <QObject>
#include <QVariantMap>

/// QISystemUtils provides an interface for Qt/QML to access the iOS system service and function call.

class QISystemUtils : public QObject {
    Q_OBJECT

public:
    static QISystemUtils* instance();

    /// Send a message to the system
    Q_INVOKABLE bool sendMessage(QString name , QVariantMap data);

    /// Register a message handler.
    /**
     * @brief registerMessageHandler
     * @param name
     * @return TRUE if it is successfully. Otherwise , it is false , it is already registered
     */
    bool registerMessageHandler(QString name,bool (*func)(QVariantMap&) );

signals:
    /// The signal is emitted when a message is received.
    void received(QString name , QVariantMap data);

private:
    explicit QISystemUtils(QObject* parent = 0);

};

#endif // QISYSTEMUTILS_H
