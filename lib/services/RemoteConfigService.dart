import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../secret.dart';

class RemoteConfigService {
  final RemoteConfig _remoteConfig;

  static RemoteConfigService? _instance; // Made nullable
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      // Assuming RemoteConfig.instance is available for the version used.
      // If an older version, it might be new RemoteConfig() or similar.
      final remoteConfig = RemoteConfig.instance;
      _instance = RemoteConfigService(remoteConfig: remoteConfig);
      // Initialise is called here to ensure the instance is ready.
      // This matches the expectation from setupLocator.
      await _instance!.initialise();
    }
    return _instance!;
  }

  RemoteConfigService({required RemoteConfig remoteConfig}) // Made required
      : _remoteConfig = remoteConfig;

  Future<void> initialise() async {
    // Simplified try-catch for initialise. The primary goal is to run activateAndFetch.
    // Retrying on FetchThrottledException is a good pattern.
    try {
      await activateAndFetch();
    } on FetchThrottledException catch (e) {
      print('RemoteConfig fetch throttled, retrying: $e');
      // Consider a delay before retrying if appropriate
      await Future.delayed(Duration(seconds: 5)); // Optional delay
      try {
        await activateAndFetch();
      } catch (e_retry) {
        print('RemoteConfig retry failed: $e_retry');
      }
    } catch (exception) {
      // Catch other generic exceptions during the initial fetch/activation
      print('Error during RemoteConfig initialise: $exception');
      // Depending on policy, might attempt one more time or fail.
      // For simplicity, one retry attempt on general exception could be:
      // try { await activateAndFetch(); } catch (e_final) { print('RemoteConfig final attempt failed: $e_final'); }
    }
  }

  String getString({required String key}) { // Made key required
    return _remoteConfig.getString(key);
  }

  Future<void> activateAndFetch() async { // Return type Future<void>
    final Map<String, dynamic> defaults = {
      'season': season, // These come from secret.dart
      'scoreApiKey': scoreApiKey,
      'newsApiKey': newsApiKey, // These come from secret.dart
      'scoreUrl': scoreUrl, // These come from secret.dart
      'newsUrl': newsUrl, // These come from secret.dart
      'xRapidapiHost': xRapidApiHost // These come from secret.dart
    };
    await _remoteConfig.setDefaults(defaults);
    // Updated to use minimumFetchInterval and activate
    await _remoteConfig.fetch(minimumFetchInterval: Duration(hours: 5));
    await _remoteConfig.activate();
  }
}
