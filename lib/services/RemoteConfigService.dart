import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:developer' as developer;

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;
  static RemoteConfigService? _instance;
  bool _isInitialized = false;

  // Default values for remote config
  static const String season = '2023-2024';
  static const String scoreApiKey = '';
  static const String newsApiKey = '';
  static const String scoreUrl = 'https://api-football-v1.p.rapidapi.com/v3';
  static const String newsUrl = 'https://newsapi.org/v2';
  static const String xRapidApiHost = 'api-football-v1.p.rapidapi.com';

  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      try {
        final remoteConfig = FirebaseRemoteConfig.instance;
        _instance = RemoteConfigService(remoteConfig: remoteConfig);
        await _instance!.initialise();
      } catch (e, stackTrace) {
        developer.log(
          'Error creating RemoteConfigService instance',
          error: e,
          stackTrace: stackTrace,
        );
        rethrow;
      }
    }
    return _instance!;
  }

  RemoteConfigService({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  Future<void> initialise() async {
    if (_isInitialized) {
      developer.log('RemoteConfigService already initialized');
      return;
    }

    try {
      developer.log('Initializing RemoteConfigService');
      await activateAndFetch();
      _isInitialized = true;
      developer.log('RemoteConfigService initialized successfully');
    } catch (e, stackTrace) {
      developer.log(
        'Error during RemoteConfig initialization',
        error: e,
        stackTrace: stackTrace,
      );
      try {
        developer.log('Retrying RemoteConfig initialization');
        await activateAndFetch();
        _isInitialized = true;
        developer.log('RemoteConfigService initialized successfully on retry');
      } catch (e_final, stackTrace_final) {
        developer.log(
          'RemoteConfig final initialization attempt failed',
          error: e_final,
          stackTrace: stackTrace_final,
        );
        // Don't throw here, just log the error and continue with defaults
      }
    }
  }

  String? getString({required String key}) {
    if (!_isInitialized) {
      developer.log(
          'RemoteConfigService not initialized when getting string for key: $key');
      return null;
    }

    try {
      final value = _remoteConfig.getString(key);
      if (value.isEmpty) {
        developer.log('Empty string returned from RemoteConfig for key: $key');
        return null;
      }
      return value;
    } catch (e, stackTrace) {
      developer.log(
        'Error getting string from RemoteConfig for key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<void> activateAndFetch() async {
    final Map<String, dynamic> defaults = {
      'season': season,
      'scoreApiKey': scoreApiKey,
      'newsApiKey': newsApiKey,
      'scoreUrl': scoreUrl,
      'newsUrl': newsUrl,
      'xRapidapiHost': xRapidApiHost,
    };

    try {
      developer.log('Setting RemoteConfig defaults');
      await _remoteConfig.setDefaults(defaults);

      developer.log('Fetching and activating RemoteConfig');
      final activated = await _remoteConfig.fetchAndActivate();
      if (!activated) {
        developer.log('RemoteConfig fetch and activate returned false');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error during RemoteConfig activateAndFetch',
        error: e,
        stackTrace: stackTrace,
      );
      // Don't throw here, just log the error and continue with defaults
    }
  }

  void dispose() {
    _isInitialized = false;
    _instance = null;
  }
}
