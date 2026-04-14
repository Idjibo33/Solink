import 'package:flutter/material.dart';
import 'package:so_link/features/auth/presentation/desktop/desktop_inscription_screen.dart';
import 'package:so_link/features/auth/presentation/mobile/mobile_inscription_screen.dart';
import 'package:so_link/features/auth/presentation/tablet/tablet_inscription_screen.dart';
import 'package:so_link/shared/responsive.dart';

class InscriptionScreen extends StatelessWidget {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileInscriptionScreen(),
      tablet: TabletInscriptionScreen(),
      desktop: DesktopInscriptionScreen(),
    );
  }
}
