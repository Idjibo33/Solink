import 'package:flutter/material.dart';

class PaddingAuthScreenColumn extends StatelessWidget {
  final double paddingHoriz;
  final Widget child;
  const PaddingAuthScreenColumn({
    super.key,
    required this.paddingHoriz,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: paddingHoriz),
      child: child,
    );
  }
}
