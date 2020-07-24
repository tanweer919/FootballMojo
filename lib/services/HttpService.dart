import 'package:dio/dio.dart';
import '../secret.dart';

class HttpService {
  static Dio getApiClient() {
    BaseOptions options = new BaseOptions(headers: {
      'x-rapidapi-host': 'v3.football.api-sports.io',
      'x-rapidapi-key': scoreApiKey
    });
    final _dio = new Dio(options);
    return _dio;
  }
}