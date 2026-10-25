import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/settings/domain/models/app_config.dart';

abstract interface class AppConfigRepository {
  Future<Either<Failure, AppConfig>> load();
}
