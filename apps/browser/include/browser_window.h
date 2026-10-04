#pragma once

#include <QObject>
#include <QQuickWindow>

class BrowserWindow : public QObject
{
    Q_OBJECT

public:
    explicit BrowserWindow(QObject* parent = nullptr);

public slots:
    void show();
    void hide();
    void setWindowTitle(const QString& title);
    void setGeometry(int x, int y, int width, int height);

private:
    QQuickWindow* m_window = nullptr;
};
