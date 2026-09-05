#pragma once

#include <QString>
#include <QList>
#include <QSize>
#include <memory>
#include <libcamera/libcamera.h>

/**
 * ABINSTEIN Camera Manager
 * Hardware-agnostic camera management using libcamera
 * Supports both virtual cameras (QEMU) and real hardware (Galaxy A20e)
 */
class CameraManager {

public:
    enum CameraPosition {
        Front,
        Back,
        External
    };

    enum CameraCapability {
        PhotoCapture,
        VideoRecording,
        AutoFocus,
        DigitalZoom,
        OpticalZoom,
        FlashControl,
        TorchMode,
        FaceDetection,
        HDR,
        Panorama
    };

    CameraManager();
    ~CameraManager();

    // Camera enumeration
    bool initialize();
    QList<QString> getAvailableCameras();
    QString getCameraName(const QString &camera_id);
    CameraPosition getCameraPosition(const QString &camera_id);

    // Camera selection
    bool selectCamera(const QString &camera_id);
    QString getSelectedCamera() const;

    // Properties
    QList<CameraCapability> getCapabilities(const QString &camera_id);
    bool hasCapability(const QString &camera_id, CameraCapability cap);
    QList<QSize> getSupportedResolutions();
    QList<int> getSupportedFrameRates();

    // Video modes
    bool startPreview();
    bool stopPreview();
    bool capturePhoto(const QString &output_path);
    bool startVideoRecording(const QString &output_path);
    bool stopVideoRecording();
    bool pauseVideoRecording();
    bool resumeVideoRecording();

    // Settings
    bool setResolution(const QSize &resolution);
    bool setFrameRate(int fps);
    bool setExposure(double ev);
    bool setWhiteBalance(const QString &mode); // auto, daylight, cloudy, tungsten, fluorescent
    bool setFocus(const QString &mode); // auto, manual, continuous
    bool setFlash(const QString &mode); // off, on, auto, red-eye
    bool setZoom(double zoom_factor);
    bool setRotation(int degrees); // 0, 90, 180, 270

    // Status
    bool isPreviewActive() const;
    bool isRecording() const;
    QString getLastError() const;

    // Statistics
    int getCameraCount() const;
    QString getCameraInfo(const QString &camera_id);

private:
    bool enumerateCameras();
    bool loadCameraConfigurations();

    class Impl;
    std::unique_ptr<Impl> impl_;
};
