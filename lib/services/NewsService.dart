import 'package:dio/dio.dart';
import '../models/News.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class NewsService {
  final RemoteConfigService _remoteConfigService;

  NewsService(this._remoteConfigService);

  Future<List<News>> fetchNews(String query) async {
    final String? newsApiKey =
        _remoteConfigService.getString(key: 'newsApiKey');
    if (newsApiKey == null) {
      throw Exception('News API Key not found in remote config');
    }

    final String? newsUrl = _remoteConfigService.getString(key: 'newsUrl');
    if (newsUrl == null) {
      throw Exception('News URL not found in remote config');
    }

    final options =
        BaseOptions(headers: {'Ocp-Apim-Subscription-Key': newsApiKey});
    final dio = Dio(options);

    try {
      final response = await dio.get(
        newsUrl,
        queryParameters: {
          'q': query,
          'mkt': 'en-IN',
          'originalImg': 'true',
          'count': '100',
          'freshness': 'week',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch news: Status code ${response.statusCode}');
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Failed to fetch news: Response data is null');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Failed to fetch news: Invalid response format');
      }

      final valueList = responseData['value'];
      if (valueList is! List) {
        throw Exception('Failed to fetch news: Invalid value list format');
      }

      final List<News> newsList = [];
      for (final item in valueList) {
        if (item is Map<String, dynamic>) {
          try {
            newsList.add(News.fromJson(item));
          } catch (e) {
            print('Error parsing news item: $e');
            // Continue with next item instead of failing the entire request
            continue;
          }
        }
      }

      return newsList;
    } on DioException catch (e) {
      throw Exception('Failed to fetch news: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}
