import 'dart:ui';

import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  const UserAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: SizedBox(),
        ),
        CircleAvatar(
          backgroundColor: Colors.teal.withValues(alpha: 0.2),
          radius: size,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.person_2_outlined, size: size),
          ),
        ),
      ],
    );
  }
}
