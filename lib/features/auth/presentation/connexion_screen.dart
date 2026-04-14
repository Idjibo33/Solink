import 'package:flutter/material.dart';
import 'package:so_link/features/auth/presentation/desktop/desktop_connexion_screen.dart';
import 'package:so_link/features/auth/presentation/mobile/mobile_connexion_screen.dart';
import 'package:so_link/features/auth/presentation/tablet/tablet_connexion_screen.dart';
import 'package:so_link/shared/responsive.dart';

class ConnexionScreen extends StatelessWidget {
  const ConnexionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileConnexionScreen(),
      tablet: TabletConnexionScreen(),
      desktop: DesktopConnexionScreen(),
    );
  }
}
