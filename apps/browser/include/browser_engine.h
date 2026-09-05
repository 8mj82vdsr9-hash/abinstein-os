#pragma once

#include <QString>
#include <QUrl>
#include <memory>

/**
 * ABINSTEIN Browser Engine
 * WPE WebKit Integration
 * Pure Linux WebKit, NO Chromium
 */
class BrowserEngine {

public:
    BrowserEngine();
    ~BrowserEngine();

    // Initialize WPE WebKit
    bool initialize();

    // Navigation
    void loadUrl(const QUrl &url);
    void goBack();
    void goForward();
    void reload();
    void stop();

    // Content
    QString getTitle() const;
    QString getUrl() const;
    double getLoadProgress() const;
    bool isLoading() const;

    // JavaScript execution
    void executeScript(const QString &script);

    // SSL/TLS
    bool verifyCertificate();

    // Cache management
    void clearCache();
    void clearCookies();

private:
    class Impl;
    std::unique_ptr<Impl> impl_;
};
