import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'HttpService.dart';
import '../models/LeagueTable.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class LeagueTableService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<LeagueTableEntry>> fetchLeagueTable({@required String id}) async{
    final String season = _remoteConfig.getString(key: 'season');
    List<LeagueTableEntry> _leagueTableEntries = [];
    try {
      final response = await dio.get('standings?season=$season&league=${id}');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response'][0]['league']['standings'][0].toList();
        for (int i = 0; i < unparsedJson.length; i++) {
          _leagueTableEntries.add(LeagueTableEntry.fromJson(unparsedJson[i]));
        }
      }
      _leagueTableEntries.sort((a,b) {
        return a.position.compareTo(b.position);
      });
      return _leagueTableEntries;
    } on DioError catch (e) {
      return null;
    }
  }
}