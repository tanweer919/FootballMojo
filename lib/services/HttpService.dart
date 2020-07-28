import 'package:dio/dio.dart';
import 'RemoteConfigService.dart';
import 'GetItLocator.dart';

class HttpService {
  static Dio getApiClient() {
    final RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
    BaseOptions options = new BaseOptions(headers: {
      'x-rapidapi-host': 'v3.football.api-sports.io',
      'x-rapidapi-key': _remoteConfigService.getString(key: 'scoreApiKey')
    }, baseUrl: 'https://v3.football.api-sports.io/');
    final _dio = new Dio(options);
    return _dio;
  }
}