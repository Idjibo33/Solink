import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:so_link/core/constants/app_constants.dart';
import 'package:so_link/features/settings/domain/models/app_config.dart';

class RemoteConfigService {
  RemoteConfigService(this._remoteConfig);

  final FirebaseRemoteConfig _remoteConfig;

  String get versionConfigUrl => _remoteConfig.getString('version_config_url');

  Future<AppConfig> load() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(minutes: 10),
        ),
      );
      await _remoteConfig.setDefaults({
        'enMaintenance': false,
        'min_version': AppConstants.currentVersion,
        'appTheme': 0,
        'version_config_url': '',
      });
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Les valeurs par défaut restent disponibles hors ligne.
    }

    return AppConfig(
      maintenance: _remoteConfig.getBool('enMaintenance'),
      updateRequired: false,
      forceUpdate: false,
      minVersion: _remoteConfig.getInt('min_version'),
      currentVersion: AppConstants.currentVersion,
      themeIndex: _remoteConfig.getInt('appTheme'),
    );
  }
}
