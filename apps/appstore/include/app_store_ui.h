#pragma once

#include <QMainWindow>
#include <QString>
#include <QList>
#include <memory>
#include <QJsonObject>

class AppCatalog;
class AppInstaller;
class AppManager;
class DownloadManager;
class RatingSystem;
class UpdateChecker;

/**
 * ABINSTEIN App Store UI
 * Independent app distribution system
 * Similar to Google Play Store but not tied to Google services
 */
class AppStoreUI : public QMainWindow {
    Q_OBJECT

public:
    explicit AppStoreUI(QWidget *parent = nullptr);
    ~AppStoreUI();

    // Browse & Search
    void searchApps(const QString &query);
    void browseCategory(const QString &category);
    void showFeaturedApps();
    void showPopularApps();
    void showUpdates();

    // App Details
    void viewAppDetails(const QString &package_name);
    void viewAppReviews(const QString &package_name);
    void viewAppScreenshots(const QString &package_name);

    // Installation & Management
    void installApp(const QString &package_name);
    void uninstallApp(const QString &package_name);
    void updateApp(const QString &package_name);
    void openApp(const QString &package_name);

    // My Apps
    QList<QJsonObject> getInstalledApps();
    QList<QJsonObject> getPendingUpdates();
    QList<QJsonObject> getDownloadHistory();

    // Account & Settings
    void login();
    void logout();
    void openSettings();
    void viewAccountInfo();

    // Ratings & Reviews
    void rateApp(const QString &package_name, int rating, const QString &review);
    void reportApp(const QString &package_name, const QString &reason);

protected:
    void closeEvent(QCloseEvent *event) override;

private slots:
    void onAppInstallProgress(const QString &package, int progress);
    void onAppInstallComplete(const QString &package, bool success);
    void onAppInstallError(const QString &package, const QString &error);
    void onUpdateAvailable(const QString &package, const QString &version);
    void onDownloadStarted(const QString &url, const QString &filename);
    void onDownloadProgress(int bytes_downloaded, int total_bytes);
    void onNetworkError(const QString &error);

private:
    void setupUI();
    void setupConnections();
    void loadAppCatalog();
    void verifyAppSignatures();
    void checkForUpdates();

    std::unique_ptr<AppCatalog> app_catalog_;
    std::unique_ptr<AppInstaller> app_installer_;
    std::unique_ptr<AppManager> app_manager_;
    std::unique_ptr<DownloadManager> download_manager_;
    std::unique_ptr<RatingSystem> rating_system_;
    std::unique_ptr<UpdateChecker> update_checker_;

    QString current_user_id_;
    bool is_logged_in_ = false;
};
