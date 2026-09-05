#pragma once

#include <QString>
#include <QByteArray>
#include <memory>

/**
 * Signature Verifier for App Store
 * Verifies that apps are signed with valid certificates
 * Prevents installation of tampered or malicious apps
 */
class SignatureVerifier {

public:
    enum VerificationResult {
        Valid,
        InvalidSignature,
        UntrustedCertificate,
        ExpiredCertificate,
        NotSigned,
        UnknownError
    };

    SignatureVerifier();
    ~SignatureVerifier();

    // Initialize with trusted certificate store
    bool initialize(const QString &cert_store_path);

    // Verify package signature
    VerificationResult verifyPackage(const QString &package_path);
    
    // Get certificate info
    QString getSignerInfo(const QString &package_path);
    QString getCertificateSubject(const QString &package_path);
    QString getCertificateIssuer(const QString &package_path);
    bool isCertificateTrusted(const QString &package_path);

    // Add trusted certificate
    bool addTrustedCertificate(const QString &cert_path);
    bool revokeTrustedCertificate(const QString &cert_fingerprint);

private:
    bool validateCertificateChain(const QString &package_path);
    bool checkCertificateExpiration(const QString &cert_path);
    QString calculateCertificateFingerprint(const QString &cert_path);

    class Impl;
    std::unique_ptr<Impl> impl_;
};
