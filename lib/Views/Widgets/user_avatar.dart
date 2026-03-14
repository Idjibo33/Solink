import 'package:flutter/material.dart';
import 'package:so_link/Models/constants.dart';

class UserAvatar extends StatelessWidget {
  final String username;
  final double size;
  const UserAvatar({super.key, required this.size, required this.username});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CircleAvatar(
        backgroundColor: Colors.teal.withValues(alpha: 0.2),
        radius: size,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(username[0], style: titreTexte),
        ),
      ),
    );
  }
}
