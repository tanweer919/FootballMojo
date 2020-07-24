import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/Team.dart';
import 'HttpService.dart';
class TeamService {
  final Dio dio = HttpService.getApiClient();
  Future<List<Team>> fetchTeams({@required int id}) async {
    List<Team> teamList = [];
    try {
      final response =
          await dio.get('https://v3.football.api-sports.io/teams?league=${id}&season=2019');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response'].toList();
        for (int i = 0; i < unparsedJson.length; i++) {
          teamList.add(Team.fromJson(unparsedJson[i]['team']));
        }
      }
      return teamList;
    } on DioError catch (e) {
      return null;
    }
  }
}
