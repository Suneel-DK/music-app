class Song {
  final String id;
  final String name;
  final String url;
  final List<ImageQuality> images;
  final List<DownloadUrl> downloadUrls;
  final String language;
  final bool hasLyrics;
  bool isDownloaded;

  Song({
    required this.id,
    required this.name,
    required this.url,
    required this.images,
    required this.downloadUrls,
    required this.language,
    required this.hasLyrics,
    this.isDownloaded = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      images: (json['image'] as List? ?? [])
          .map((img) => ImageQuality.fromJson(img))
          .toList(),
      downloadUrls: (json['downloadUrl'] as List? ?? [])
          .map((url) => DownloadUrl.fromJson(url))
          .toList(),
      language: json['language'] ?? '',
      hasLyrics: json['hasLyrics'] ?? false,
    );
  }
}

class ImageQuality {
  final String quality;
  final String url;

  ImageQuality({required this.quality, required this.url});

  factory ImageQuality.fromJson(Map<String, dynamic> json) {
    return ImageQuality(
      quality: json['quality'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class DownloadUrl {
  final String quality;
  final String url;

  DownloadUrl({required this.quality, required this.url});

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      quality: json['quality'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
