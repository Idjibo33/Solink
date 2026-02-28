import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lordicon/lordicon.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = IconController.assets("assets/settings.json");
    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(padding: 12, size: 40),
            Gap(20),
            IconViewer(controller: controller, height: 150, width: 150),
            Gap(8),
            Text("Maintenance", style: enteteTexte),
            Gap(12),
            Text("On revient vite !", style: corpsTexte),
            Text("Environ 1 h de temps...", style: corpsTexte),
          ],
        ),
      ),
    );
  }
}
