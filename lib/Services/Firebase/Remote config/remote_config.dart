import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigServices {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  Future<void> setConfigs() async {
    return await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 10),
      ),
    );
  }

  Future<void> setDefaultValues() async {
    await remoteConfig.setDefaults({
      "enMaintenance": false,
      "min_version": 2,
      "appTheme": 0,
    });
  }

  Future<void> fetchAndActivate() async {
    await remoteConfig.fetchAndActivate();
  }
}
