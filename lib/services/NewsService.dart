import 'package:dio/dio.dart';
import '../models/News.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class NewsService {
  Future<List<News>?> fetchNews(String query) async { // Return type is now nullable
    final RemoteConfigService _remoteConfigService =
        locator<RemoteConfigService>();

    final String? newsApiKey =
        _remoteConfigService.getString(key: 'newsApiKey');
    final String? newsUrl = _remoteConfigService.getString(key: 'newsUrl');

    if (newsApiKey == null) {
      print("Error: News API Key not found in remote config.");
      return null; // Or throw Exception("News API Key not found");
    }
    if (newsUrl == null) {
      print("Error: News URL not found in remote config.");
      return null; // Or throw Exception("News URL not found");
    }

    BaseOptions options =
        BaseOptions(headers: {'Ocp-Apim-Subscription-Key': newsApiKey});
    final Dio dio = Dio(options); // 'new' is optional
    List<News> newsList = [];
    try {
      final response = await dio.get(newsUrl, queryParameters: {
        'q': query,
        'mkt': 'en-IN',
        'originalImg': 'true',
        'count': '100',
        'freshness': 'week'
      });
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic valueList = responseData['value'];
          if (valueList is List) {
            for (var item in valueList) {
              if (item is Map<String, dynamic>) {
                // Assuming News.fromJson handles its input safely
                newsList.add(News.fromJson(item));
              }
            }
          }
        }
      } else {
        print('Error fetching news: Status code ${response.statusCode}');
        return null;
      }
      return newsList;
    } on DioException catch (e) { // Added catch (e)
      print('DioException fetching news: $e');
      return null;
    } catch (e) { // Generic catch
      print('Generic exception fetching news: $e');
      return null;
    }
  }
}
