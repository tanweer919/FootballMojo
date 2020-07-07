import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/Score.dart';
import '../secret.dart';
class ScoreService {
  static BaseOptions options = new BaseOptions(headers: {
    'x-rapidapi-host': 'v3.football.api-sports.io',
    'x-rapidapi-key': scoreApiKey
  });
  final dio = new Dio(options);
  Future<List<Score>> fetchScoresByLeague({@required String id}) async {
    List<Score> scoresList = [];
    try {
      final response =
      await dio.get('https://v3.football.api-sports.io/fixtures?league=${id}&season=2019&timezone=Asia/Kolkata');
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
    List<Score> scoresList = [];
    try {
      final response =
      await dio.get('https://v3.football.api-sports.io/fixtures?team=${id}&season=2019&timezone=Asia/Kolkata');
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
