import 'package:dio/dio.dart';
import '../models/News.dart';
import '../secret.dart';
class NewsService {
  final dio = new Dio();
  Future<List<News>> fetchNews(String query) async {
    List<News> newsList = [];
    try {
      final response = await dio.get('https://newsapi.org/v2/everything',
          queryParameters: {
            'language': 'en',
            'q': query,
            'apiKey': newsApiKey
          });
      if (response.statusCode == 200) {
        final unparsedNews = response.data['articles'].toList();
        for (int i = 0; i < unparsedNews.length; i++) {
          newsList.add(News.fromJson(unparsedNews[i]));
        }
        return newsList;
      }
    } on DioError catch (e) {
      return null;
    }
  }
}
