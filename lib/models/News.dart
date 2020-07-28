class News {
  String source;
//  String sourceLogo;
  String title;
  String content;
  String url;
  String imageUrl;
  DateTime publishedAt;
  News({this.source, this.title, this.content, this.url, this.imageUrl, this.publishedAt});
  News.fromJson(Map<String, dynamic> parsedJson)
    : source = parsedJson['provider'][0]['name'],
//      sourceLogo = parsedJson['provider'][0]['image']['thumbnail']['contentUrl'],
      title = parsedJson['name'],
      content = parsedJson['description'],
      url = parsedJson['url'],
      imageUrl = parsedJson['image'] != null ? parsedJson['image']['thumbnail']['contentUrl'] : 'https://www.lissah.com/lissahadmin/uploads/news/default.png',
      publishedAt = DateTime.parse(parsedJson['datePublished']);
}