import 'package:dio/dio.dart';
import '../models/MatchEvent.dart';
import 'HttpService.dart';
class MatchEventService {

  Future<List<MatchEvent>?> fetchEvents(
      {required int fixtureId}) async { // Return type is now nullable
  final Dio dio = await HttpService.getApiClient();
    List<MatchEvent> events = [];
    try {
      final response = await dio.get('fixtures/events?fixture=$fixtureId');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final dynamic apiResponse = responseData['response'];
          if (apiResponse is List) {
            for (var item in apiResponse) {
              if (item is Map<String, dynamic>) {
                // Assuming MatchEvent.fromJson handles its input safely
                events.add(MatchEvent.fromJson(item));
              }
            }
          }
        }
      } else {
        // Non-200 status or null data
        print('Error fetching match events: Status code ${response.statusCode}');
        return null;
      }
      return events;
    } on DioException catch (e) { // Added catch (e)
      print('DioException fetching match events: $e');
      return null;
    } catch (e) { // Generic catch for other errors like parsing
      print('Generic exception fetching match events: $e');
      return null;
    }
  }
}