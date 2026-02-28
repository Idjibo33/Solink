import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigServices {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  Future<void> setConfigs() async {
    try {
      return await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 10),
        ),
      );
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> setDefaultValues() async {
    try {
      await remoteConfig.setDefaults({
        "enMaintenance": false,
        "min_version": 2,
      });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchAndActivate() async {
    try {
      await remoteConfig.fetchAndActivate();
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
