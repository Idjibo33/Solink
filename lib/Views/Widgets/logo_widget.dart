import 'package:flutter/material.dart';
import 'package:so_link/Models/constants.dart';

class LogoWidget extends StatelessWidget {
  final double padding;
  final double size;
  const LogoWidget({super.key, required this.padding, required this.size});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.tealAccent,
      color: couleurePrincipale,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: couleureSecondaire),
        borderRadius: BorderRadiusGeometry.circular(50),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Icon(Icons.link_rounded, size: size, color: Colors.white),
      ),
    );
  }
}
