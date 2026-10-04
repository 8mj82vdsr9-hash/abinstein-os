#include "browser_engine.h"

#include <QUrl>
#include <QRegularExpression>

BrowserEngine::BrowserEngine(QObject* parent)
    : QObject(parent)
{
    m_url = QUrl(m_homePage);
}

QUrl BrowserEngine::url() const
{
    return m_url;
}

QString BrowserEngine::title() const
{
    return m_title;
}

int BrowserEngine::loadProgress() const
{
    return m_loadProgress;
}

bool BrowserEngine::canGoBack() const
{
    return m_canGoBack;
}

bool BrowserEngine::canGoForward() const
{
    return m_canGoForward;
}

void BrowserEngine::load(const QString& rawUrl)
{
    QString value = rawUrl.trimmed();
    if (value.isEmpty()) {
        value = m_homePage;
    }

    if (!value.contains(QRegularExpression(QStringLiteral("^[a-zA-Z]+://")))) {
        value.prepend(QStringLiteral("https://"));
    }

    setUrl(QUrl(value));
}

void BrowserEngine::reload()
{
    if (m_url.isValid()) {
        setUrl(m_url);
    }
}

void BrowserEngine::stop()
{
    m_loadProgress = 100;
    emit loadProgressChanged();
}

void BrowserEngine::goBack()
{
    if (m_canGoBack) {
        setUrl(m_url); // placeholder for a real history stack in a fuller implementation
    }
}

void BrowserEngine::goForward()
{
    if (m_canGoForward) {
        setUrl(m_url);
    }
}

void BrowserEngine::openHome()
{
    setUrl(QUrl(m_homePage));
}

void BrowserEngine::setUrl(const QUrl& url)
{
    if (m_url == url) {
        return;
    }

    m_url = url;
    emit urlChanged();
}

void BrowserEngine::setTitle(const QString& title)
{
    if (m_title == title) {
        return;
    }

    m_title = title;
    emit titleChanged();
}

void BrowserEngine::setLoadProgress(int progress)
{
    if (m_loadProgress == progress) {
        return;
    }

    m_loadProgress = progress;
    emit loadProgressChanged();
}

void BrowserEngine::setCanGoBack(bool enabled)
{
    if (m_canGoBack == enabled) {
        return;
    }

    m_canGoBack = enabled;
    emit canGoBackChanged();
}

void BrowserEngine::setCanGoForward(bool enabled)
{
    if (m_canGoForward == enabled) {
        return;
    }

    m_canGoForward = enabled;
    emit canGoForwardChanged();
}
