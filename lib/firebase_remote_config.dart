import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRemoteConfigService {
  FirebaseRemoteConfigService._() : remoteConfig = FirebaseRemoteConfig.instance; // MODIFIED

  static FirebaseRemoteConfigService? _instance; // NEW
  factory FirebaseRemoteConfigService() => _instance ??= FirebaseRemoteConfigService._(); // NEW

  final FirebaseRemoteConfig remoteConfig;
  String getString(String key) => remoteConfig.getString(key); // NEW
  bool getBool(String key) =>remoteConfig.getBool(key); // NEW
  int getInt(String key) =>remoteConfig.getInt(key); // NEW
  double getDouble(String key) =>remoteConfig.getDouble(key); // NEW

  Future<void> _setConfigSettings() async => remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 60),
      minimumFetchInterval: const Duration(seconds: 1),

    ));
  Future<void> _setDefaults() async => remoteConfig.setDefaults(
     {
      "base_api_url": "deafualt",
    },
  );


  Future<void> fetchAndActivate() async {
    bool updated= await remoteConfig.fetchAndActivate();
    print(remoteConfig.getAll().entries.map((e) => e.value.source.index.toString()));
    if (updated) {
      debugPrint('The config has been updated.');
    } else {
      debugPrint('The config is not updated..');
    }
    remoteConfig.getString("base_api_url");
  }

  Future<void> initialize() async {
    await remoteConfig.ensureInitialized();
    await _setConfigSettings();
    await _setDefaults();
    await fetchAndActivate();
  }
}

class FirebaseRemoteConfigKeys {
  static const String baseUrl = 'base_api_url';
}