import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/constants/app_constants.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/settings/domain/models/app_config.dart';
import 'package:so_link/features/settings/presentation/cubit/app_config_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAppConfigRepository repository;
  late AppConfigCubit cubit;

  setUp(() {
    repository = FakeAppConfigRepository();
    cubit = AppConfigCubit(repository);
  });

  tearDown(() => cubit.close());

  test('load expose la configuration', () async {
    repository.result = Right(
      const AppConfig(
        maintenance: true,
        updateRequired: true,
        forceUpdate: false,
        minVersion: 2,
        currentVersion: 2,
        themeIndex: 3,
      ),
    );

    await cubit.load();

    expect(cubit.state.maintenance, isTrue);
    expect(cubit.state.updateRequired, isTrue);
    expect(cubit.state.themeColor, AppConstants.seedColors[3]);
  });

  test('load échoue et retombe sur les valeurs par défaut', () async {
    repository.result = const Left<Failure, AppConfig>(
      VersionFailure('Remote Config indisponible'),
    );

    await cubit.load();

    expect(cubit.state.isLoading, isFalse);
    expect(cubit.state.maintenance, isFalse);
    expect(cubit.state.errorMessage, isNotNull);
  });
}
