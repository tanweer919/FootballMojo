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
        for (int i = unparsedJson.length - 1; i >= 0 ; i--) {
          scoresList.add(Score.fromJson(unparsedJson[i]));
        }
      }
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
        for (int i = unparsedJson.length - 1; i >= 0 ; i--) {
          scoresList.add(Score.fromJson(unparsedJson[i]));
        }
      }
      return scoresList;
    } on DioError catch (e) {
      return null;
    }
  }
}
