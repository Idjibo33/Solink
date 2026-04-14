import 'package:flutter/material.dart';
import 'package:so_link/Views/Widgets/custom_container.dart';
import 'package:so_link/Views/Widgets/logo_widget.dart';
import 'package:so_link/core/constants.dart';

class LargeScreenLogoPresentation extends StatelessWidget {
  final String description;
  const LargeScreenLogoPresentation({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "box",
      child: CustomContainer(
        child: Center(
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoWidget(padding: 25, size: 50),
              Text("soLink", style: enteteTexte, textAlign: TextAlign.center),
              Text(
                description,
                style: corpsTexte.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
