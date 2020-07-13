import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/MatchStat.dart';
import '../secret.dart';
class StatService {
  static BaseOptions options = new BaseOptions(headers: {
    'x-rapidapi-host': 'v3.football.api-sports.io',
    'x-rapidapi-key': scoreApiKey
  });
  final dio = new Dio(options);

  Future<Map<String, MatchStat>> fetchStats({@required int fixtureId}) async{
    Map<String, MatchStat> stats = {};
    try {
      final response =
          await dio.get('https://v3.football.api-sports.io/fixtures/statistics?fixture=${fixtureId}');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response'].toList();
        stats["home"] = MatchStat.fromJson(unparsedJson[0]["statistics"]);
        stats["away"] = MatchStat.fromJson(unparsedJson[1]["statistics"]);
        return stats;
      }
    } on DioError catch (e) {
      return stats;
    }
  }
}