#include "browser_window.h"

BrowserWindow::BrowserWindow(QObject* parent)
    : QObject(parent)
{
}

void BrowserWindow::show()
{
    if (m_window) {
        m_window->show();
    }
}

void BrowserWindow::hide()
{
    if (m_window) {
        m_window->hide();
    }
}

void BrowserWindow::setWindowTitle(const QString& title)
{
    if (m_window) {
        m_window->setTitle(title);
    }
}

void BrowserWindow::setGeometry(int x, int y, int width, int height)
{
    if (m_window) {
        m_window->setGeometry(x, y, width, height);
    }
}
