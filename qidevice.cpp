#include "qidevice.h"

QIDevice::QIDevice(QObject* parent) : QObject(parent)
{
    m_screenFillStatusBar = false;
    m_screenWidth = -1;
    m_screenHeight = -1;
}

QIDevice::~QIDevice()
{

}

bool QIDevice::screenFillStatusBar() const
{
    return m_screenFillStatusBar;
}

void QIDevice::setScreenFillStatusBar(bool screenFillStatusBar)
{
    m_screenFillStatusBar = screenFillStatusBar;
    emit screenFillStatusBarChanged();
}

int QIDevice::screenWidth() const
{
    return m_screenWidth;
}

void QIDevice::setScreenWidth(int screenWidth)
{
    m_screenWidth = screenWidth;
    emit screenHeightChanged();
}

int QIDevice::screenHeight() const
{
    return m_screenHeight;
}

void QIDevice::setScreenHeight(int screenHeight)
{
    m_screenHeight = screenHeight;
    emit screenHeightChanged();
}




