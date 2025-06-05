import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'CustomRouter.dart';
import 'GetItLocator.dart';
import 'LocalStorage.dart';

class FirebaseMessagingService {
  // Assuming _fcm = FirebaseMessaging() is for an older library version.
  // For modern versions, it would be FirebaseMessaging.instance.
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final RouterService _routerService = locator<RouterService>();

  Future<void> initialise() async {
    if (Platform.isIOS) {
      // Ensure IosNotificationSettings is correctly instantiated if needed.
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        final dynamic data = message['data'];
        if (data is Map && data.containsKey('route')) {
          final route = data['route'];
          if (route is String) {
            _routerService.navigationKey.currentState?.pushReplacementNamed(route);
          }
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        final dynamic data = message['data'];
        if (data is Map && data.containsKey('route')) {
          final route = data['route'];
          if (route is String) {
            _routerService.navigationKey.currentState?.pushReplacementNamed(route);
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {
        final dynamic data = message['data'];
        if (data is Map && data.containsKey('route')) {
          final route = data['route'];
          if (route is String) {
            _routerService.navigationKey.currentState?.pushNamed(route);
          }
        }
      },
    );
  }

  Future<void> subscribeToTopic({required String topic}) async {
    await _fcm.subscribeToTopic(topic);
    final String? lastTopic = await LocalStorage.getString('lastTopic');
    if (lastTopic != null) {
      await _fcm.unsubscribeFromTopic(lastTopic);
    }
    await LocalStorage.setString('lastTopic', topic);
  }

  Future<void> unsubscribeFromTopic({required String topic}) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  Future<String?> getToken() async {
    // getToken from older firebase_messaging might return null or String.
    // Explicitly making it Future<String?> is safer.
    final String? token = await _fcm.getToken();
    return token;
  }
}
