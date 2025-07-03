import '../models/Player.dart';
import 'package:dio/dio.dart';
import 'RemoteConfigService.dart';

class TopScorerService {
  final Dio dio;
  final RemoteConfigService _remoteConfig;

  TopScorerService(this.dio, this._remoteConfig);

  Future<List<Player>> fetchTopScorer({required String leagueId}) async {
    final String? season = _remoteConfig.getString(key: 'season');
    if (season == null) {
      throw Exception('Season not found in remote config');
    }

    try {
      final response = await dio.get(
        'players/topscorers',
        queryParameters: {
          'season': season,
          'league': leagueId,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch top scorers: Status code ${response.statusCode}');
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Failed to fetch top scorers: Response data is null');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception('Failed to fetch top scorers: Invalid response format');
      }

      final apiResponse = responseData['response'];
      if (apiResponse is! List) {
        throw Exception(
            'Failed to fetch top scorers: Invalid response list format');
      }

      final List<Player> topScorers = [];
      for (int i = 0; i < apiResponse.length; i++) {
        final item = apiResponse[i];
        if (item is Map<String, dynamic>) {
          try {
            final player = Player.fromJson(item, i + 1);
            topScorers.add(player);
          } catch (e) {
            print('Error parsing player data: $e');
            // Continue with next item instead of failing the entire request
            continue;
          }
        }
      }

      topScorers.sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));
      return topScorers;
    } on DioException catch (e) {
      throw Exception('Failed to fetch top scorers: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch top scorers: $e');
    }
  }
}
