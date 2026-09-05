#pragma once

#include <QString>
#include <QUrl>
#include <QProcess>
#include <memory>

/**
 * ABINSTEIN App Installer
 * Handles app package installation, verification, and management
 * Supports .aapk (Abinstein App Package Kit) format
 */
class AppInstaller {

public:
    enum InstallStatus {
        Idle,
        Downloading,
        Verifying,
        Installing,
        Complete,
        Failed,
        Cancelled
    };

    AppInstaller();
    ~AppInstaller();

    // Installation
    bool installApp(const QString &package_name, const QUrl &download_url);
    bool uninstallApp(const QString &package_name);
    bool updateApp(const QString &package_name, const QUrl &download_url);
    bool cancelInstallation(const QString &package_name);

    // Verification
    bool verifyPackageSignature(const QString &package_path);
    bool verifyPackageIntegrity(const QString &package_path, const QString &expected_hash);

    // Status
    InstallStatus getInstallStatus(const QString &package_name) const;
    int getInstallProgress(const QString &package_name) const;
    QString getLastError(const QString &package_name) const;

    // Rollback
    bool rollbackInstallation(const QString &package_name);
    bool rollbackUpdate(const QString &package_name);

private:
    bool extractPackage(const QString &package_path, const QString &extract_dir);
    bool installPackageFiles(const QString &package_name, const QString &extract_dir);
    bool registerApp(const QString &package_name, const QJsonObject &app_info);
    bool createSystemLinks(const QString &package_name);

    class Impl;
    std::unique_ptr<Impl> impl_;
};
