import 'package:dio/dio.dart';
import 'RemoteConfigService.dart';
import 'GetItLocator.dart';

class HttpService {
  static Dio getApiClient() {
    final RemoteConfigService _remoteConfigService =
        locator<RemoteConfigService>();

    // Retrieve values, potentially null
    final String? host = _remoteConfigService.getString(key: 'xRapidapiHost');
    final String? apiKey = _remoteConfigService.getString(key: 'scoreApiKey');
    final String? baseUrlFromConfig =
        _remoteConfigService.getString(key: 'scoreUrl');

    // Prepare headers, only adding non-null values
    final Map<String, String> headers = {};
    if (host != null) {
      headers['x-rapidapi-host'] = host;
    }
    if (apiKey != null) {
      headers['x-rapidapi-key'] = apiKey;
    }

    // Ensure baseUrl is non-null, defaulting to empty string if not found.
    // Consider throwing an error if baseUrl is critical and missing.
    final String baseUrl = baseUrlFromConfig ?? '';

    BaseOptions options =
        BaseOptions(headers: headers, baseUrl: baseUrl);
    final Dio _dio = Dio(options); // 'new' is optional in Dart
    return _dio;
  }
}