#pragma once

#include <QString>
#include <QImage>
#include <QObject>
#include <memory>

/**
 * ABINSTEIN Image Editor
 * Basic image editing capabilities
 */
class ImageEditor : public QObject {
    Q_OBJECT

public:
    explicit ImageEditor(QObject *parent = nullptr);
    ~ImageEditor();

    // File operations
    bool loadImage(const QString &file_path);
    bool saveImage(const QString &output_path);
    bool saveImageAs(const QString &output_path, const QString &format);
    void discardChanges();

    // Basic edits
    bool rotate(int degrees); // 90, 180, 270, -90, -180, -270
    bool flip(bool horizontal); // true = horizontal flip, false = vertical flip
    bool crop(int x, int y, int width, int height);
    bool resize(int width, int height);
    bool scale(double scale_factor); // 0.1 to 10.0

    // Color adjustments
    bool adjustBrightness(int value); // -100 to +100
    bool adjustContrast(int value); // -100 to +100
    bool adjustSaturation(int value); // -100 to +100
    bool adjustHue(int value); // -180 to +180
    bool adjustExposure(int value); // -100 to +100
    bool adjustShadows(int value); // -100 to +100
    bool adjustHighlights(int value); // -100 to +100

    // Filters
    bool applyGrayScale();
    bool applySepia();
    bool applySharpen(int strength); // 1-10
    bool applyBlur(int radius); // 1-50
    bool applyVignette(int strength); // 0-100
    bool applyBlackAndWhite();
    bool applyInvert();

    // Auto enhancements
    bool autoEnhance();
    bool autoWhiteBalance();
    bool autoExposure();
    bool reduceNoise();

    // Undo/Redo
    bool undo();
    bool redo();
    void clearHistory();
    bool hasUndoStack() const;
    bool hasRedoStack() const;

    // Status
    bool hasChanges() const;
    QImage getCurrentImage() const;
    QString getImageInfo() const;
    QString getLastError() const;

signals:
    void imageChanged(const QImage &image);
    void imageLoaded(const QString &file_path);
    void imageSaved(const QString &file_path);
    void editApplied(const QString &edit_name);
    void errorOccurred(const QString &error);

private:
    class Impl;
    std::unique_ptr<Impl> impl_;
};
