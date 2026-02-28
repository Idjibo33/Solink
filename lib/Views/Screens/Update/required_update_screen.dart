import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Providers/Version/version_provider.dart';
import 'package:so_link/Services/Firebase/Remote%20config/remote_config.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';

class RequiredUpdateScreen extends StatelessWidget {
  const RequiredUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final minVersion = RemoteConfigServices().remoteConfig.getString(
      "min_version",
    );
    final currentVersionProvider = context.watch<VersionProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LogoWidget(padding: 12, size: 50),
              Gap(20),
              Icon(Icons.update, size: 80, color: Colors.orange),
              Gap(12),
              Text(
                "Télécharger la version $minVersion de votre application pour continuer à l'utiliser",
                style: enteteTexte,
                textAlign: TextAlign.center,
              ),
              Gap(8),
              Text(
                "Actuellement vous avez la version ${currentVersionProvider.currentVersion} qui n'est plus supporté ",
                style: corpsTexte,
                textAlign: TextAlign.center,
              ),
              Gap(12),
              FilledButton(
                onPressed: () {
                  currentVersionProvider.changerVersion(int.parse(minVersion));
                },
                child: Text("Mettre à jour"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
