class News {
  String source;
  String title;
  String content;
  String url;
  String imageUrl;
  String publishedAt;
  News({this.source, this.title, this.content, this.url, this.imageUrl, this.publishedAt});
  News.fromJson(Map<String, dynamic> parsedJson)
    : source = parsedJson['source']['name'],
      title = parsedJson['title'],
      content = parsedJson['content'],
      url = parsedJson['url'],
      imageUrl = parsedJson['urlToImage'],
      publishedAt = parsedJson['publishedAt'];
}