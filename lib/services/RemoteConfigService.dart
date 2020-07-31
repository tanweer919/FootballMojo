import 'package:firebase_remote_config/firebase_remote_config.dart';

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

  Future<void> initialise() async{
    final Map<String, dynamic> defaults = {
      'season': 2019,
      'scoreApiKey': "",
      'newsApiKey': "",
      'scoreUrl': "",
      'newsUrl': "",
      'xRapidapiHost': ""
    };
    await _remoteConfig.setDefaults(defaults);
    await _remoteConfig.fetch(expiration: Duration(hours: 1));
    await _remoteConfig.activateFetched();
  }

  String getString({String key}){
    return _remoteConfig.getString(key);
  }
}