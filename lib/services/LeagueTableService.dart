import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'HttpService.dart';
import '../models/LeagueTable.dart';

class LeagueTableService {
  final Dio dio = HttpService.getApiClient();

  Future<List<LeagueTableEntry>> fetchLeagueTable({@required String id}) async{
    List<LeagueTableEntry> _leagueTableEntries = [];
    try {
      final response = await dio.get('https://v3.football.api-sports.io/standings?season=2019&league=${id}');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response']['league']['standings'][0].toList();
        for (int i = 0; i < unparsedJson.length; i++) {
          _leagueTableEntries.add(LeagueTableEntry.fromJson(unparsedJson[i]));
        }
      }
      return _leagueTableEntries;
    } on DioError catch (e) {
      return null;
    }
  }
}