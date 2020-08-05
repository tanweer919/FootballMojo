class News {
  String source;
  String sourceLogo;
  String title;
  String content;
  String url;
  String imageUrl;
  DateTime publishedAt;
  News(
      {this.source,
      this.sourceLogo,
      this.title,
      this.content,
      this.url,
      this.imageUrl,
      this.publishedAt});
  News.fromJson(Map<String, dynamic> parsedJson)
      : source = parsedJson['provider'][0]['name'],
        sourceLogo = parsedJson['provider'][0]['image'] != null
            ? parsedJson['provider'][0]['image']['thumbnail']['contentUrl']
            : null,
        title = parsedJson['name'],
        content = parsedJson['description'],
        url = parsedJson['url'],
        imageUrl = parsedJson['image'] != null
            ? parsedJson['image']['contentUrl']
            : 'https://res.cloudinary.com/doy9hqxr1/image/upload/q_70/v1596572656/Football-Class-Cover-Page_sjrsaq.jpg',
        publishedAt = DateTime.parse(parsedJson['datePublished']);
}
