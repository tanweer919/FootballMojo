import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/Score.dart';
import 'RemoteConfigService.dart';
import 'GetItLocator.dart';
import 'HttpService.dart';
class ScoreService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<Score>> fetchScoresByLeague({@required String id}) async {
    final String season = _remoteConfig.getString(key: 'season');
    List<Score> scoresList = [];
    try {
      final response =
      await dio.get('fixtures?league=${id}&season=$season&timezone=Asia/Kolkata');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response'].toList();
        for (int i = 0; i < unparsedJson.length; i++) {
          scoresList.add(Score.fromJson(unparsedJson[i]));
        }
      }
      scoresList.sort((a,b) {
        return b.date_time.compareTo(a.date_time);
      });
      return scoresList;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<List<Score>> fetchScoresByTeam({@required String id}) async {
    final String season = _remoteConfig.getString(key: 'season');
    List<Score> scoresList = [];
    try {
      final response =
      await dio.get('fixtures?team=${id}&season=$season&timezone=Asia/Kolkata');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response'].toList();
        for (int i = 0; i < unparsedJson.length; i++) {
          scoresList.add(Score.fromJson(unparsedJson[i]));
        }
      }
      scoresList.sort((a,b) {
        return b.date_time.compareTo(a.date_time);
      });
      return scoresList;
    } on DioError catch (e) {
      return null;
    }
  }
}
