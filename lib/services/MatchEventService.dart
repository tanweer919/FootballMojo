import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/MatchEvent.dart';
import 'HttpService.dart';
class MatchEventService {
  final Dio dio = HttpService.getApiClient();

  Future<List<MatchEvent>> fetchEvents({@required int fixtureId}) async{
    List<MatchEvent> events = [];
    try {
      final response = await dio.get('https://v3.football.api-sports.io/fixtures/events?fixture=${fixtureId}');
      if(response.statusCode == 200) {
        final unparsedJson = response.data['response'].toList();
        for(int i = 0; i < unparsedJson.length; i++) {
          events.add(MatchEvent.fromJson(unparsedJson[i]));
        }
      }
      return events;
    } on DioError catch (e) {
      return null;
    }
  }
}