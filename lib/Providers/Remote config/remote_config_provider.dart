import 'package:flutter/material.dart';
import 'package:so_link/Providers/Version/version_provider.dart';
import 'package:so_link/Services/Firebase/Remote%20config/remote_config.dart';

class RemoteConfigProvider extends ChangeNotifier {
  final RemoteConfigServices _remoteConfigServices = RemoteConfigServices();
  final VersionProvider _versionProvider = VersionProvider();
  VersionProvider get versionProvider => _versionProvider;
  Future<void> init() async {
    try {
      await _remoteConfigServices.setConfigs();
      await _remoteConfigServices.setDefaultValues();
      await _remoteConfigServices.fetchAndActivate();
    } catch (e) {
      throw Exception(e);
    }
  }

  bool getMaintenanceConfig() {
    return _remoteConfigServices.remoteConfig.getBool("enMaintenance");
  }

  bool requireUpdate() {
    final currentVersion = _versionProvider.currentVersion;
    final minVersion = _remoteConfigServices.remoteConfig.getInt("min_version");
    if (minVersion > currentVersion) {
      return true;
    }
    return false;
  }
}
