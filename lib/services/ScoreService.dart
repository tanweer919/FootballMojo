import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/Score.dart';
import 'RemoteConfigService.dart';
import 'GetItLocator.dart';
import 'HttpService.dart';
class ScoreService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<Score>?> fetchScoresByLeague(
      {required String id}) async { // Return type is now nullable
    // Assuming _remoteConfig.getString returns a non-empty string for 'season'
    // or API handles empty season. Key 'season' is required by getString.
    final String season = _remoteConfig.getString(key: 'season');
    List<Score> scoresList = [];
    try {
      final response = await dio
          .get('fixtures?league=$id&season=$season&timezone=Asia/Kolkata');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponse = responseData['response'];
          if (apiResponse is List) {
            for (var item in apiResponse) {
              if (item is Map<String, dynamic>) {
                scoresList.add(Score.fromJson(item));
              }
            }
          }
        }
      } else {
        print(
            'Error fetching scores by league: Status code ${response.statusCode}');
        return null;
      }
      scoresList.sort((a, b) {
        // Assuming Score.date_time is non-null or Score.fromJson handles default/null for comparison
        return b.date_time.compareTo(a.date_time);
      });
      return scoresList;
    } on DioException catch (e) {
      print('DioException fetching scores by league: $e');
      return null;
    } catch (e) {
      print('Generic exception fetching scores by league: $e');
      return null;
    }
  }

  Future<List<Score>?> fetchScoresByTeam(
      {required String id}) async { // Return type is now nullable
    final String season = _remoteConfig.getString(key: 'season');
    List<Score> scoresList = [];
    try {
      final response = await dio
          .get('fixtures?team=$id&season=$season&timezone=Asia/Kolkata');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponse = responseData['response'];
          if (apiResponse is List) {
            for (var item in apiResponse) {
              if (item is Map<String, dynamic>) {
                scoresList.add(Score.fromJson(item));
              }
            }
          }
        }
      } else {
        print(
            'Error fetching scores by team: Status code ${response.statusCode}');
        return null;
      }
      scoresList.sort((a, b) {
        return b.date_time.compareTo(a.date_time);
      });
      return scoresList;
    } on DioException catch (e) {
      print('DioException fetching scores by team: $e');
      return null;
    }
  }
}
