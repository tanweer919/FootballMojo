import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'CustomRouter.dart';
import 'GetItLocator.dart';
import 'LocalStorage.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final RouterService _routerService = locator<RouterService>();

  Future<void> initialise() async {
    if (Platform.isIOS) {
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data;
      if (data.containsKey('route')) {
        final route = data['route'];
        if (route is String) {
          _routerService.navigationKey.currentState
              ?.pushReplacementNamed(route);
        }
      }
    });

    // Handle messages when app is in background and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final data = message.data;
      if (data.containsKey('route')) {
        final route = data['route'];
        if (route is String) {
          _routerService.navigationKey.currentState?.pushNamed(route);
        }
      }
    });

    // Handle messages when app is terminated and user taps notification
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final data = initialMessage.data;
      if (data.containsKey('route')) {
        final route = data['route'];
        if (route is String) {
          _routerService.navigationKey.currentState
              ?.pushReplacementNamed(route);
        }
      }
    }
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
    return await _fcm.getToken();
  }
}
