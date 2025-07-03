import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'HttpService.dart';
import '../models/LeagueTable.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class LeagueTableService {
  final Dio dio;
  final RemoteConfigService _remoteConfig;

  LeagueTableService(this.dio, this._remoteConfig);

  Future<List<LeagueTableEntry>> fetchLeagueTable({required String id}) async {
    final String? season = _remoteConfig.getString(key: 'season');
    if (season == null) {
      throw Exception('Season not found in remote config');
    }

    try {
      final response = await dio.get(
        'standings',
        queryParameters: {
          'season': season,
          'league': id,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to fetch league table: Status code ${response.statusCode}');
      }

      final responseData = response.data;
      if (responseData == null) {
        throw Exception('Failed to fetch league table: Response data is null');
      }

      if (responseData is! Map<String, dynamic>) {
        throw Exception(
            'Failed to fetch league table: Invalid response format');
      }

      final apiResponseList = responseData['response'];
      if (apiResponseList is! List || apiResponseList.isEmpty) {
        throw Exception(
            'Failed to fetch league table: Invalid response list format');
      }

      final firstResponse = apiResponseList[0];
      if (firstResponse is! Map<String, dynamic>) {
        throw Exception(
            'Failed to fetch league table: Invalid first response format');
      }

      final leagueData = firstResponse['league'];
      if (leagueData is! Map<String, dynamic>) {
        throw Exception(
            'Failed to fetch league table: Invalid league data format');
      }

      final standingsList = leagueData['standings'];
      if (standingsList is! List || standingsList.isEmpty) {
        throw Exception(
            'Failed to fetch league table: Invalid standings list format');
      }

      final leagueTableList = standingsList[0];
      if (leagueTableList is! List) {
        throw Exception(
            'Failed to fetch league table: Invalid league table list format');
      }

      final List<LeagueTableEntry> leagueTableEntries = [];
      for (final item in leagueTableList) {
        if (item is Map<String, dynamic>) {
          try {
            leagueTableEntries.add(LeagueTableEntry.fromJson(item));
          } catch (e) {
            print('Error parsing league table entry: $e');
            // Continue with next item instead of failing the entire request
            continue;
          }
        }
      }

      leagueTableEntries.sort((a, b) => a.position.compareTo(b.position));
      return leagueTableEntries;
    } on DioException catch (e) {
      throw Exception('Failed to fetch league table: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch league table: $e');
    }
  }
}
