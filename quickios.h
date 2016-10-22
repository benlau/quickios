#ifndef QUICKIOS_H
#define QUICKIOS_H

#include <QtPlugin>
#include <QQuickWindow>

class QuickIOS
{
public:

    /// @deprecated
    static void registerTypes();

    /// Setup the QQuickWindow instance of the application according to the environment
    /**
     *
     * @brief setupWindow
     * @param window
     */
    static void setupWindow(QQuickWindow* window);

    enum StatusBarStyle {
        StatusBarStyleDefault,
        StatusBarStyleLightContent,
        StatusBarStyleBlackTranslucent,
        StatusBarStyleBlackOpaque
    };

    static void setStatusBarStyle(StatusBarStyle style);

};

#endif // QUICKIOS_H
