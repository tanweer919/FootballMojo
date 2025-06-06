import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'HttpService.dart';
import '../models/LeagueTable.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class LeagueTableService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<LeagueTableEntry>?> fetchLeagueTable(
      {required String id}) async {
    final String? season = _remoteConfig.getString(key: 'season');
    if (season == null) {
      // Or handle with a default season, or log an error.
      // Depending on requirements, throwing might be too aggressive.
      // For now, returning null as the method is nullable.
      print("Error: Season not found in remote config for LeagueTableService.");
      return null;
    }

    List<LeagueTableEntry> _leagueTableEntries = [];
    try {
      final response = await dio.get('standings?season=$season&league=$id');

      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponseList = responseData['response'];
          if (apiResponseList is List && apiResponseList.isNotEmpty) {
            final dynamic firstResponse = apiResponseList[0];
            if (firstResponse is Map<String, dynamic>) {
              final dynamic leagueData = firstResponse['league'];
              if (leagueData is Map<String, dynamic>) {
                final dynamic standingsList = leagueData['standings'];
                // Expecting standingsList to be a List containing the actual table list
                if (standingsList is List && standingsList.isNotEmpty) {
                   // The actual league table seems to be the first element of standingsList
                  final dynamic leagueTableList = standingsList[0];
                  if (leagueTableList is List) {
                    for (var item in leagueTableList) {
                      if (item is Map<String, dynamic>) {
                        // Assuming LeagueTableEntry.fromJson handles potential nulls internally
                        // or expects a perfectly formed Map.
                        _leagueTableEntries.add(LeagueTableEntry.fromJson(item));
                      }
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        // Non-200 status code or null data
        print('Error fetching league table: Status code ${response.statusCode}');
        return null;
      }

      _leagueTableEntries.sort((a, b) {
        // Add null checks if position can be null
        return (a.position ?? 0).compareTo(b.position ?? 0);
      });
      return _leagueTableEntries;
    } on DioException catch (e) {
      // Handle Dio specific errors, e.g., network issues
      print('DioException fetching league table: $e');
      return null;
    } catch (e) {
      // Handle other potential errors (e.g., parsing errors not caught above)
      print('Generic exception fetching league table: $e');
      return null;
    }
  }
}