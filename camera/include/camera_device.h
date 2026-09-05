#pragma once

#include <QString>
#include <QSize>
#include <memory>
#include <libcamera/libcamera.h>

/**
 * ABINSTEIN Camera Device
 * Low-level camera device wrapper
 * Direct libcamera interface
 */
class CameraDevice {

public:
    CameraDevice(const std::shared_ptr<libcamera::Camera> &camera);
    ~CameraDevice();

    // Configuration
    bool configure(const QSize &resolution, int frame_rate);
    bool start();
    bool stop();

    // Capture
    bool requestCapture();
    bool waitForCapture(int timeout_ms = 5000);

    // Status
    bool isConfigured() const;
    bool isRunning() const;
    QSize getConfiguredResolution() const;
    int getConfiguredFrameRate() const;

    // Properties
    QString getModel() const;
    QString getLocation() const;
    QString getProperties() const;

    // Controls
    bool setControl(const QString &control_name, int value);
    int getControl(const QString &control_name) const;

private:
    std::shared_ptr<libcamera::Camera> camera_;
    std::unique_ptr<libcamera::CameraConfiguration> config_;

    class Impl;
    std::unique_ptr<Impl> impl_;
};
