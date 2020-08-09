import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../secret.dart';

class RemoteConfigService {
  final RemoteConfig _remoteConfig;

  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }

    return _instance;
  }

  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  Future<void> initialise() async {
    try {
      activateAndFetch();
    } on FetchThrottledException catch (exception) {
      try {
        activateAndFetch();
      } catch (e) {}
    } catch (exception) {
      try {
        activateAndFetch();
      } catch (e) {}
    }
  }

  String getString({String key}) {
    return _remoteConfig.getString(key);
  }

  Future activateAndFetch() async {
    final Map<String, dynamic> defaults = {
      'season': 2019,
      'scoreApiKey': scoreApiKey,
      'newsApiKey': newsApiKey,
      'scoreUrl': scoreUrl,
      'newsUrl': newsUrl,
      'xRapidapiHost': xRapidApiHost
    };
    await _remoteConfig.setDefaults(defaults);
    await _remoteConfig.fetch(expiration: Duration(hours: 5));
    await _remoteConfig.activateFetched();
  }
}
