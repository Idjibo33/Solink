import 'package:flutter/material.dart';
import 'package:so_link/Services/Firebase/Remote%20config/remote_config.dart';

class RemoteConfigProvider extends ChangeNotifier {
  final RemoteConfigServices _remoteConfigServices = RemoteConfigServices();
  Future<void> init() async {
    try {
      await _remoteConfigServices.setConfigs();
      await _remoteConfigServices.setDefaultValues();
      await _remoteConfigServices.fetchAndActivate();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> getConfigBool() async {
    return _remoteConfigServices.remoteConfig.getBool("test");
  }
}
