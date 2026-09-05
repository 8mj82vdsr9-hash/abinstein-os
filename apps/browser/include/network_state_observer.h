#pragma once

#include <QString>
#include <QObject>
#include <memory>

/**
 * Network State Observer for Browser
 * Watches D-Bus NetworkManager for connectivity changes
 * Ensures browser knows actual network state
 */
class NetworkStateObserver : public QObject {
    Q_OBJECT

public:
    enum NetworkState {
        Unknown,
        Disabled,
        Disconnected,
        Connecting,
        ConnectedNoIP,
        ConnectedNoInternet,
        Internet
    };

    explicit NetworkStateObserver(QObject *parent = nullptr);
    ~NetworkStateObserver();

    NetworkState currentState() const;
    QString stateString() const;
    bool hasInternetConnectivity() const;

    // Connectivity check
    void checkInternetConnectivity();

signals:
    void networkStateChanged(NetworkState state);
    void internetStatusChanged(bool available);
    void dnsResolveFailed(const QString &domain);
    void serverUnreachable(const QString &url);

private slots:
    void onDBusPropertyChanged(const QString &interface, const QVariantMap &properties);
    void onConnectivityCheckComplete(bool success);

private:
    void monitorNetworkManager();
    bool resolveTestDomain();
    bool checkRouteExists();
    bool pingGateway();

    NetworkState current_state_ = Unknown;
    bool has_internet_ = false;
    
    class Impl;
    std::unique_ptr<Impl> impl_;
};
