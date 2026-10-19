import 'package:flutter/material.dart';
import 'package:so_link/Models/constants.dart';

class UserAvatar extends StatelessWidget {
  final String username;
  final double size;
  const UserAvatar({super.key, required this.size, required this.username});

  String get initiale {
    final trimmed = username.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return String.fromCharCode(trimmed.runes.first);
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      radius: size,
      child: Padding(
        padding: EdgeInsets.all(size / 4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(initiale, style: titreTexte),
        ),
      ),
    );
  }
}
