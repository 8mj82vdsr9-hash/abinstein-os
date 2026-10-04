#pragma once

#include <QObject>
#include <QUrl>
#include <QString>

class BrowserEngine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url NOTIFY urlChanged)
    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(int loadProgress READ loadProgress NOTIFY loadProgressChanged)
    Q_PROPERTY(bool canGoBack READ canGoBack NOTIFY canGoBackChanged)
    Q_PROPERTY(bool canGoForward READ canGoForward NOTIFY canGoForwardChanged)

public:
    explicit BrowserEngine(QObject* parent = nullptr);

    QUrl url() const;
    QString title() const;
    int loadProgress() const;
    bool canGoBack() const;
    bool canGoForward() const;

public slots:
    void load(const QString& rawUrl);
    void reload();
    void stop();
    void goBack();
    void goForward();
    void openHome();
    void setUrl(const QUrl& url);
    void setTitle(const QString& title);
    void setLoadProgress(int progress);
    void setCanGoBack(bool enabled);
    void setCanGoForward(bool enabled);

signals:
    void urlChanged();
    void titleChanged();
    void loadProgressChanged();
    void canGoBackChanged();
    void canGoForwardChanged();

private:
    QUrl m_url;
    QString m_title;
    int m_loadProgress = 0;
    bool m_canGoBack = false;
    bool m_canGoForward = false;
    const QString m_homePage = QStringLiteral("https://example.com");
};
