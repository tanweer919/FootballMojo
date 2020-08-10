import '../models/Player.dart';
import 'HttpService.dart';
import 'package:dio/dio.dart';
import 'GetItLocator.dart';
import 'RemoteConfigService.dart';

class TopScorerService {
  final Dio dio = HttpService.getApiClient();
  final RemoteConfigService _remoteConfig = locator<RemoteConfigService>();

  Future<List<Player>> fetchTopScorer({String leagueId}) async {
    final String season = _remoteConfig.getString(key: 'season');
    List<Player> topScorers = [];
    try {
      final response = await dio.get(
          'players/topscorers?season=$season&league=$leagueId');
      if (response.statusCode == 200) {
        final unparsedJson = response.data['response'].toList();
        for (int i = 0; i < unparsedJson.length; i++) {
          Player player = Player.fromJson(unparsedJson[i]);
          player.rank = i + 1;
          topScorers.add(player);
        }
      }
      topScorers.sort((a, b) {
        return a.rank.compareTo(b.rank);
      });
      return topScorers;
    } on DioError catch (e) {
      return null;
    }
  }
}
