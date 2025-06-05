import '../models/Player.dart';
import 'HttpService.dart';
import 'package:dio/dio.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class TopScorerService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<Player>?> fetchTopScorer(
      {required String leagueId}) async { // Made leagueId required, return type nullable
    final String season = _remoteConfig.getString(key: 'season');
    List<Player> topScorers = [];
    try {
      final response =
          await dio.get('players/topscorers?season=$season&league=$leagueId');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponse = responseData['response'];
          if (apiResponse is List) {
            for (int i = 0; i < apiResponse.length; i++) {
              var item = apiResponse[i];
              if (item is Map<String, dynamic>) {
                // Assuming Player.fromJson handles its input safely
                Player player = Player.fromJson(item);
                // Ensure Player model has a nullable rank or handles this assignment safely
                player.rank = i + 1;
                topScorers.add(player);
              }
            }
          }
        }
      } else {
        print('Error fetching top scorers: Status code ${response.statusCode}');
        return null;
      }
      topScorers.sort((a, b) {
        // Assuming rank is non-null after assignment or Player model handles null for compareTo
        return (a.rank ?? 0).compareTo(b.rank ?? 0);
      });
      return topScorers;
    } on DioException catch (e) {
      print('DioException fetching top scorers: $e');
      return null;
    } catch (e) {
      print('Generic exception fetching top scorers: $e');
      return null;
    }
  }
}
