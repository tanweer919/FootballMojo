import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'RemoteConfigService.dart';
import 'GetItLocator.dart';
import 'dart:developer' as developer;
import 'package:path_provider/path_provider.dart';

class HttpService {
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 1);
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 30);
  static const Duration _sendTimeout = Duration(seconds: 30);
  static const Duration _cacheDuration = Duration(hours: 1);

  static Future<Dio> getApiClient() async {
    try {
      final RemoteConfigService _remoteConfigService =
          locator<RemoteConfigService>();

      final String? host = _remoteConfigService.getString(key: 'xRapidapiHost');
      final String? apiKey = _remoteConfigService.getString(key: 'scoreApiKey');
      final String? baseUrlFromConfig =
          _remoteConfigService.getString(key: 'scoreUrl');

      if (host == null) {
        throw Exception('xRapidapiHost not found in remote config');
      }
      if (apiKey == null) {
        throw Exception('scoreApiKey not found in remote config');
      }
      if (baseUrlFromConfig == null) {
        throw Exception('scoreUrl not found in remote config');
      }

      final Map<String, String> headers = {
        'x-rapidapi-host': host,
        'x-rapidapi-key': apiKey,
      };

      // Setup cache
      final cacheDir = await getTemporaryDirectory();
      final cacheStore = HiveCacheStore(
        cacheDir.path,
        hiveBoxName: 'dio_cache',
      );

      final cacheOptions = CacheOptions(
        store: cacheStore,
        policy: CachePolicy.refreshForceCache,
        hitCacheOnErrorExcept: [401, 403],
        maxStale: _cacheDuration,
        priority: CachePriority.normal,
      );

      final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

      // Setup retry
      final retryInterceptor = RetryInterceptor(
        dio: Dio(),
        logPrint: (message) => developer.log(message),
        retries: _maxRetries,
        retryDelays: List.generate(
          _maxRetries,
          (index) => _retryDelay * (index + 1),
        ),
        retryableExtraStatuses: {408, 429, 500, 502, 503, 504},
      );

      final BaseOptions options = BaseOptions(
        headers: headers,
        baseUrl: baseUrlFromConfig,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },
      );

      final dio = Dio(options)
        ..interceptors.addAll([
          cacheInterceptor,
          retryInterceptor,
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
            logPrint: (message) => developer.log(message.toString()),
          ),
        ]);

      return dio;
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing HTTP client',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final dio = await getApiClient();
      return await dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e, stackTrace) {
      developer.log(
        'Error in GET request to $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  static Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final dio = await getApiClient();
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e, stackTrace) {
      developer.log(
        'Error in POST request to $path',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
