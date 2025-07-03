import 'package:dio/dio.dart';
import '../models/MatchStat.dart';
import 'HttpService.dart';

class StatService {
  Future<Map<String, MatchStat>> fetchStats({required int fixtureId}) async {
    final Dio dio = await HttpService.getApiClient();
    Map<String, MatchStat> stats = {};
    try {
      final response = await dio.get('fixtures/statistics?fixture=$fixtureId');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponse = responseData['response'];
          if (apiResponse is List && apiResponse.length >= 2) {
            // Expecting two elements for home and away normally
            final dynamic homeData = apiResponse[0];
            final dynamic awayData = apiResponse[1];

            if (homeData is Map<String, dynamic> &&
                homeData.containsKey('statistics')) {
              final dynamic homeStatsData = homeData['statistics'];
              if (homeStatsData is List) {
                // Convert List to Map format that MatchStat.fromJson expects
                stats["home"] = MatchStat.fromJson({"home": homeStatsData});
              } else if (homeStatsData is Map<String, dynamic>) {
                stats["home"] = MatchStat.fromJson(homeStatsData);
              }
            }

            if (awayData is Map<String, dynamic> &&
                awayData.containsKey('statistics')) {
              final dynamic awayStatsData = awayData['statistics'];
              if (awayStatsData is List) {
                // Convert List to Map format that MatchStat.fromJson expects
                stats["away"] = MatchStat.fromJson({"home": awayStatsData});
              } else if (awayStatsData is Map<String, dynamic>) {
                stats["away"] = MatchStat.fromJson(awayStatsData);
              }
            }
          }
        }
      } else {
        print('Error fetching stats: Status code ${response.statusCode}');
        // Returns empty stats map as per original logic for non-200 or null data
      }
    } on DioException catch (e) {
      print('DioException fetching stats: $e');
      // Returns empty stats map as per original logic
    } catch (e) {
      print('Generic exception fetching stats: $e');
      // Returns empty stats map for other errors
    }
    return stats; // Always returns a (possibly empty) map
  }
}
