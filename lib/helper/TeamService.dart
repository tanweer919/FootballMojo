import 'package:dio/dio.dart';
import '../models/Team.dart';
import '../secret.dart';
class TeamService {
  int id;
  TeamService({this.id});
  static BaseOptions options = new BaseOptions(headers: {
    'x-rapidapi-host': 'v3.football.api-sports.io',
    'x-rapidapi-key': scoreApiKey
  });
  final dio = new Dio(options);
  Future<List<Team>> fetchTeams() async {
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
