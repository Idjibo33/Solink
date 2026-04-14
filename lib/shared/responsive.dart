import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = constraints.maxWidth;
        switch (screen) {
          case (< 600):
            {
              return mobile;
            }
          case (>= 600 && < 1024):
            {
              return tablet;
            }
          case (>= 1024):
            {
              return desktop;
            }

          default:
            {
              return mobile;
            }
        }
      },
    );
  }
}
