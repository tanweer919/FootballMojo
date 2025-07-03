class News {
  final String source;
  final String? sourceLogo;
  final String title;
  final String content;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;

  const News({
    required this.source,
    this.sourceLogo,
    required this.title,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  News copyWith({
    String? source,
    String? sourceLogo,
    String? title,
    String? content,
    String? url,
    String? imageUrl,
    DateTime? publishedAt,
  }) {
    return News(
      source: source ?? this.source,
      sourceLogo: sourceLogo ?? this.sourceLogo,
      title: title ?? this.title,
      content: content ?? this.content,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  factory News.fromJson(Map<String, dynamic> parsedJson) {
    const String defaultImageUrl =
        'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg';

    final providerList = parsedJson['provider'];
    Map<String, dynamic>? providerData;
    if (providerList is List && providerList.isNotEmpty) {
      providerData = providerList[0] as Map<String, dynamic>?;
    }

    String? sourceLogoUrl;
    if (providerData != null) {
      final imageProviderData = providerData['image'] as Map<String, dynamic>?;
      if (imageProviderData != null) {
        final thumbnailData =
            imageProviderData['thumbnail'] as Map<String, dynamic>?;
        sourceLogoUrl = thumbnailData?['contentUrl'] as String?;
      }
    }

    String? imageUrlFromSource;
    final imageData = parsedJson['image'] as Map<String, dynamic>?;
    if (imageData != null) {
      imageUrlFromSource = imageData['contentUrl'] as String?;
    }

    DateTime publicationDate;
    final datePublishedStr = parsedJson['datePublished'] as String?;
    if (datePublishedStr != null) {
      publicationDate = DateTime.tryParse(datePublishedStr) ?? DateTime.now();
    } else {
      publicationDate = DateTime.now();
    }

    final sourceName = providerData?['name'] as String?;
    if (sourceName == null) {
      throw FormatException('Source name is required');
    }

    final title = parsedJson['name'] as String?;
    if (title == null) {
      throw FormatException('Title is required');
    }

    final content = parsedJson['description'] as String?;
    if (content == null) {
      throw FormatException('Content is required');
    }

    final url = parsedJson['url'] as String?;
    if (url == null) {
      throw FormatException('URL is required');
    }

    return News(
      source: sourceName,
      sourceLogo: sourceLogoUrl,
      title: title,
      content: content,
      url: url,
      imageUrl: imageUrlFromSource ?? defaultImageUrl,
      publishedAt: publicationDate,
    );
  }
}
