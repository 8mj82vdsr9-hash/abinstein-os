#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

#include "browser_engine.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("ABINSTEIN Browser");
    app.setOrganizationName("ABINSTEIN");

    QQmlApplicationEngine engine;
    BrowserEngine browserEngine;
    engine.rootContext()->setContextProperty(QStringLiteral("browser"), &browserEngine);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    engine.load(url);

    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
