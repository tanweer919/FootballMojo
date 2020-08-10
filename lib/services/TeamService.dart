import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/Team.dart';
import 'HttpService.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class TeamService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<Team>> fetchTeams({@required int id}) async {
    final String season = _remoteConfig.getString(key: 'season');
    List<Team> teamList = [];
    try {
      final response =
          await dio.get('teams?league=${id}&season=$season');
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
