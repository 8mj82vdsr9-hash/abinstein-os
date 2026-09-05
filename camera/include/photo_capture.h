#pragma once

#include <QString>
#include <QImage>
#include <memory>

/**
 * ABINSTEIN Photo Capture
 * Handles still photo capture from camera
 */
class PhotoCapture {

public:
    enum Quality {
        Low,      // 60% JPEG quality
        Medium,   // 80% JPEG quality
        High,     // 95% JPEG quality (default)
        Maximum   // 100% JPEG quality (lossless)
    };

    enum Format {
        JPEG,
        PNG,
        RAW,
        WebP
    };

    PhotoCapture();
    ~PhotoCapture();

    // Capture
    bool capturePhoto(const QString &output_path, Format format = JPEG, Quality quality = High);
    bool cancelCapture();

    // Burst mode
    bool startBurstCapture(int photo_count, const QString &output_dir, Format format = JPEG);
    bool stopBurstCapture();
    int getBurstProgress() const; // 0-100%

    // HDR capture
    bool captureHDR(const QString &output_path);

    // RAW capture
    bool captureRAW(const QString &output_path);

    // Auto-enhance
    bool enableAutoEnhance(bool enabled);
    bool enableNightMode(bool enabled);
    bool enableBeautyMode(bool enabled);

    // Status
    bool isCaptureReady() const;
    bool isCapturing() const;
    QString getLastError() const;

private:
    class Impl;
    std::unique_ptr<Impl> impl_;
};
