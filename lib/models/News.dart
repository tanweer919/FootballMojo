class News {
  final String source;
  final String? sourceLogo; // Nullable
  final String title;
  final String content;
  final String url;
  final String imageUrl; // Non-nullable due to fallback
  final DateTime publishedAt;

  News({
    required this.source,
    this.sourceLogo,
    required this.title,
    required this.content,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> parsedJson) {
    String defaultImageUrl = 'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg';

    dynamic providerList = parsedJson['provider'];
    Map<String, dynamic>? providerData;
    if (providerList is List && providerList.isNotEmpty) {
      providerData = providerList[0] as Map<String, dynamic>?;
    }

    String? sourceLogoUrl;
    if (providerData != null) {
      final imageProviderData = providerData['image'] as Map<String, dynamic>?;
      if (imageProviderData != null) {
        final thumbnailData = imageProviderData['thumbnail'] as Map<String, dynamic>?;
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
      publicationDate = DateTime.now(); // Default if datePublished is null
    }

    return News(
      source: providerData?['name'] as String? ?? 'Unknown Source',
      sourceLogo: sourceLogoUrl,
      title: parsedJson['name'] as String? ?? 'No Title',
      content: parsedJson['description'] as String? ?? 'No Content',
      url: parsedJson['url'] as String? ?? '',
      imageUrl: imageUrlFromSource ?? defaultImageUrl,
      publishedAt: publicationDate,
    );
  }
}
