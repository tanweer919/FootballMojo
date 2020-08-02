import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'CustomRouter.dart';
import 'GetItLocator.dart';
import 'LocalStorage.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final RouterService _routerService = locator<RouterService>();
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _routerService.navigationKey.currentState
            .pushReplacementNamed('/score');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _routerService.navigationKey.currentState
            .pushReplacementNamed('/score');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _routerService.navigationKey.currentState
            .pushReplacementNamed('/score');
      },
    );
  }

  Future subscribeToTopic({String topic}) async {
    await _fcm.subscribeToTopic(topic);
    final String lastTopic = await LocalStorage.getString('lastTopic');
    if (lastTopic != null) {
      await _fcm.unsubscribeFromTopic(lastTopic);
    }
    await LocalStorage.setString('lastTopic', topic);
  }

  Future unsubscribeFromTopic({String topic}) async {
    await _fcm.unsubscribeFromTopic(topic);
  }

  Future<String> getToken() async {
    final String token = await _fcm.getToken();
    return token;
  }
}
