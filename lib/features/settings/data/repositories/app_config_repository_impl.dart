import 'package:check_app_version/check_app_version.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/settings/data/services/remote_config_service.dart';
import 'package:so_link/features/settings/domain/models/app_config.dart';
import 'package:so_link/features/settings/domain/repositories/app_config_repository.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  AppConfigRepositoryImpl(this._remoteConfigService);

  final RemoteConfigService _remoteConfigService;

  @override
  Future<Either<Failure, AppConfig>> load() async {
    try {
      final config = await _remoteConfigService.load();
      var updateRequired = config.minVersion > config.currentVersion;
      var forceUpdate = updateRequired;
      String? latestVersion = config.minVersion.toString();

      final versionUrl = _remoteConfigService.versionConfigUrl.trim();
      if (versionUrl.isNotEmpty) {
        try {
          final decision = await CheckAppVersion.get(
            versionUrl,
            policy: const UpdatePolicy(forceRefresh: true),
          );
          updateRequired = decision.shouldUpdate;
          forceUpdate = decision.isForceUpdate;
          if (decision.requiredMinVersion.isNotEmpty) {
            latestVersion = decision.requiredMinVersion;
          } else if (decision.latestVersion != null) {
            latestVersion = decision.latestVersion;
          }
        } catch (_) {
          // Le contrôle distant reste facultatif : le fallback Remote Config
          // conserve le comportement historique.
        }
      }

      return Right(
        config.copyWith(
          updateRequired: updateRequired,
          forceUpdate: forceUpdate,
          latestVersion: latestVersion,
        ),
      );
    } catch (error) {
      return Left(mapFailure(error));
    }
  }
}
