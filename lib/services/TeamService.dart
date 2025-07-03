import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/Team.dart';
import 'HttpService.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class TeamService {
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<Team>?> fetchTeams({required int id}) async { // Return type is now nullable
    final Dio dio = await HttpService.getApiClient();
    final String? season = _remoteConfig.getString(key: 'season');
    if (season == null) {
      throw Exception('Season not found in remote config');
    }
    List<Team> teamList = [];
    try {
      final response = await dio.get('teams?league=$id&season=$season');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponse = responseData['response'];
          if (apiResponse is List) {
            for (var itemData in apiResponse) {
              if (itemData is Map<String, dynamic>) {
                final dynamic teamData = itemData['team'];
                if (teamData is Map<String, dynamic>) {
                  // Assuming Team.fromJson handles its input safely
                  teamList.add(Team.fromJson(teamData));
                }
              }
            }
          }
        }
      } else {
        print('Error fetching teams: Status code ${response.statusCode}');
        return null;
      }
      return teamList;
    } on DioException catch (e) {
      print('DioException fetching teams: $e');
      return null;
    } catch (e) {
      print('Generic exception fetching teams: $e');
      return null;
    }
  }
}
