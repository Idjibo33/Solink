import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lordicon/lordicon.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/settings/presentation/cubit/app_config_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppConfigCubit, AppConfigState>(
        builder: (context, state) {
          if (state.errorMessage != null) {
            return AppErrorState(
              message: state.errorMessage!,
              onRetry: () => context.read<AppConfigCubit>().load(),
            );
          }
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                const AppLogo(padding: 16, size: 40),
                Text('SoLink', style: AppTextStyles.heading),
                const AppLoading(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IconController.assets('assets/settings.json');
    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(padding: 12, size: 36),
              const Gap(20),
              IconViewer(controller: controller, height: 140, width: 140),
              const Gap(8),
              Text('Maintenance', style: AppTextStyles.heading),
              const Gap(12),
              Text(
                'On revient très vite !',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              SecondaryButton(
                label: 'Réessayer',
                onPressed: () => context.read<AppConfigCubit>().load(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RequiredUpdateScreen extends StatelessWidget {
  const RequiredUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AppConfigCubit, AppConfigState>(
        builder: (context, state) {
          final config = state.config;
          final minVersion =
              config?.latestVersion ?? '${config?.minVersion ?? 2}';
          final currentVersion = config?.currentVersion ?? 2;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(padding: 12, size: 36),
                  const Gap(20),
                  Icon(
                    Icons.system_update,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const Gap(12),
                  Text(
                    'Téléchargez la version $minVersion de SoLink pour continuer.',
                    style: AppTextStyles.heading,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Votre version actuelle ($currentVersion) n’est plus prise en charge.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  const Gap(20),
                  PrimaryButton(
                    label: 'Vérifier à nouveau',
                    isLoading: state.isLoading,
                    onPressed: () => context.read<AppConfigCubit>().load(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
