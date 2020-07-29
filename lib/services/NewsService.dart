import 'package:dio/dio.dart';
import '../models/News.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class NewsService {
  Future<List<News>> fetchNews(String query) async {
    final RemoteConfigService _remoteConfigService =
        locator<RemoteConfigService>();
    BaseOptions options = BaseOptions(headers: {
      'Ocp-Apim-Subscription-Key':
          _remoteConfigService.getString(key: 'newsApiKey')
    });
    final dio = new Dio(options);
    List<News> newsList = [];
    try {
      final response = await dio.get(
          _remoteConfigService.getString(key: 'newsUrl'),
          queryParameters: {
            'q': query,
            'originalImg': 'true',
            'count': '100',
            'freshness': 'week',
            'sortBy': 'date'
          });
      if (response.statusCode == 200) {
        final unparsedNews = response.data['value'].toList();
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
