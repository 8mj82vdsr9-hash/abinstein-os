#pragma once

#include <QString>
#include <QList>
#include <QStringList>
#include <QDateTime>
#include <QSize>
#include <QAbstractListModel>
#include <memory>

/**
 * Media Item - Represents a photo or video
 */
struct MediaItem {
    enum Type { Photo, Video, Unknown };

    QString file_path;
    QString file_name;
    QString mime_type;
    Type type;
    QSize dimensions;
    qint64 file_size;
    QDateTime date_taken;
    QDateTime date_modified;
    QString camera_model;
    QString location;
    double latitude;
    double longitude;
    bool is_favorite;
    bool is_hidden;
};

/**
 * ABINSTEIN Gallery Model
 * Manages media file enumeration and metadata
 * Qt Model for QML ListViews
 */
class GalleryModel : public QAbstractListModel {
    Q_OBJECT

public:
    enum MediaRoles {
        FilePathRole = Qt::UserRole + 1,
        FileNameRole,
        ThumbnailRole,
        DateTakenRole,
        FileSizeRole,
        DimensionsRole,
        TypeRole,
        IsFavoriteRole,
        CameraModelRole,
        LocationRole
    };

    GalleryModel(QObject *parent = nullptr);
    ~GalleryModel();

    // Model interface
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Gallery operations
    void scanMediaFiles(const QString &directory);
    void scanMediaFiles(const QStringList &directories);
    void refreshGallery();
    void clearGallery();

    // Filtering & sorting
    void filterByType(const QString &type); // "photo", "video", "all"
    void sortBy(const QString &sort_key); // "date", "name", "size"
    void filterByDate(const QDateTime &start, const QDateTime &end);
    void filterByLocation(const QString &location);
    void searchMedia(const QString &query);

    // Item operations
    MediaItem getMediaItem(int index) const;
    bool deleteMedia(int index);
    bool deleteMedia(const QString &file_path);
    bool moveToTrash(int index);
    bool restoreFromTrash(const QString &file_path);

    // Favorites
    void setFavorite(int index, bool favorite);
    QList<MediaItem> getFavorites() const;

    // Albums
    void createAlbum(const QString &album_name);
    void deleteAlbum(const QString &album_name);
    void addToAlbum(int media_index, const QString &album_name);
    void removeFromAlbum(int media_index, const QString &album_name);
    QStringList getAlbums() const;
    QList<MediaItem> getAlbumContents(const QString &album_name);

    // Statistics
    int getTotalMediaCount() const;
    int getPhotoCount() const;
    int getVideoCount() const;
    qint64 getTotalSize() const;
    QString getStorageInfo() const;

    // Export
    bool exportMedia(int index, const QString &export_path);
    bool exportAlbum(const QString &album_name, const QString &export_directory);

signals:
    void mediaScanned(int count);
    void scanProgress(int current, int total);
    void mediaDeleted(const QString &file_path);
    void mediaAdded(const QString &file_path);
    void albumCreated(const QString &album_name);
    void albumDeleted(const QString &album_name);

private slots:
    void onMediaFileDetected(const QString &file_path);
    void onMediaScanComplete();

private:
    void loadMediaMetadata(const QString &file_path, MediaItem &item);
    bool isMediaFile(const QString &file_path);

    class Impl;
    std::unique_ptr<Impl> impl_;
};
