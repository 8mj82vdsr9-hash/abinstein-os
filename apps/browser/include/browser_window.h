#pragma once

#include <QMainWindow>
#include <QWebEngineView>
#include <QString>
#include <QList>
#include <memory>

class TabManager;
class URLBar;
class HistoryManager;
class BookmarkManager;
class DownloadManager;
class NetworkStateObserver;

/**
 * ABINSTEIN Browser Main Window
 * WPE WebKit-based mobile browser
 * NO Chromium dependency
 */
class BrowserWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit BrowserWindow(QWidget *parent = nullptr);
    ~BrowserWindow();

    // Navigation
    void navigateToUrl(const QString &url);
    void goBack();
    void goForward();
    void reload();
    void stop();

    // Tab management
    void newTab(const QString &url = "");
    void closeTab(int index);
    void switchToTab(int index);

    // History & Bookmarks
    QList<QString> getHistory();
    void addBookmark(const QString &title, const QString &url);
    QList<QPair<QString, QString>> getBookmarks();

    // Privacy
    void setPrivateBrowsingMode(bool enabled);
    bool isPrivateBrowsingMode() const;

    // Network state
    void onNetworkStateChanged(const QString &state);
    void handleNoInternetError();

protected:
    void closeEvent(QCloseEvent *event) override;
    void keyPressEvent(QKeyEvent *event) override;

private slots:
    void onUrlBarSubmit(const QString &url);
    void onTabChanged(int index);
    void onLoadFinished(bool success);
    void onLoadProgress(int progress);
    void onDownloadRequested(const QString &url, const QString &suggestedName);

private:
    void setupUI();
    void setupConnections();
    void loadSettings();
    void saveSettings();

    std::unique_ptr<TabManager> tab_manager_;
    std::unique_ptr<URLBar> url_bar_;
    std::unique_ptr<HistoryManager> history_manager_;
    std::unique_ptr<BookmarkManager> bookmark_manager_;
    std::unique_ptr<DownloadManager> download_manager_;
    std::unique_ptr<NetworkStateObserver> network_observer_;

    bool private_mode_ = false;
    int current_tab_index_ = -1;
};
