import 'package:dio/dio.dart';
import '../models/Score.dart';
import 'RemoteConfigService.dart';
import 'GetItLocator.dart';
import 'HttpService.dart';

class ScoreService {
  final Dio dio;
  final RemoteConfigService _remoteConfig;

  ScoreService(this.dio, this._remoteConfig);

  Future<List<Score>> fetchScoresByLeague({required String id}) async {
    final String? season = _remoteConfig.getString(key: 'season');
    if (season == null) {
      throw Exception('Season not found in remote config');
    }

    try {
      final response = await dio.get(
        'fixtures',
        queryParameters: {
          'league': id,
          'season': season,
          'timezone': 'Asia/Kolkata',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch scores by league: Status code ${response.statusCode}');
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception(
            'Failed to fetch scores by league: Response data is null');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception(
            'Failed to fetch scores by league: Invalid response format');
      }

      final apiResponse = responseData['response'];
      if (apiResponse is! List) {
        throw Exception(
            'Failed to fetch scores by league: Invalid response list format');
      }

      final List<Score> scoresList = [];
      for (final item in apiResponse) {
        if (item is Map<String, dynamic>) {
          try {
            scoresList.add(Score.fromJson(item));
          } catch (e) {
            print('Error parsing score item: $e');
            // Continue with next item instead of failing the entire request
            continue;
          }
        }
      }

      scoresList.sort((a, b) => b.date_time.compareTo(a.date_time));
      return scoresList;
    } on DioException catch (e) {
      throw Exception('Failed to fetch scores by league: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch scores by league: $e');
    }
  }

  Future<List<Score>> fetchScoresByTeam({required String id}) async {
    final String? season = _remoteConfig.getString(key: 'season');
    if (season == null) {
      throw Exception('Season not found in remote config');
    }

    try {
      final response = await dio.get(
        'fixtures',
        queryParameters: {
          'team': id,
          'season': season,
          'timezone': 'Asia/Kolkata',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch scores by team: Status code ${response.statusCode}');
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception(
            'Failed to fetch scores by team: Response data is null');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception(
            'Failed to fetch scores by team: Invalid response format');
      }

      final apiResponse = responseData['response'];
      if (apiResponse is! List) {
        throw Exception(
            'Failed to fetch scores by team: Invalid response list format');
      }

      final List<Score> scoresList = [];
      for (final item in apiResponse) {
        if (item is Map<String, dynamic>) {
          try {
            scoresList.add(Score.fromJson(item));
          } catch (e) {
            print('Error parsing score item: $e');
            // Continue with next item instead of failing the entire request
            continue;
          }
        }
      }

      scoresList.sort((a, b) => b.date_time.compareTo(a.date_time));
      return scoresList;
    } on DioException catch (e) {
      throw Exception('Failed to fetch scores by team: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch scores by team: $e');
    }
  }
}
