import 'package:flutter/material.dart';
import 'package:so_link/core/constants.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback action;
  final IconData icone;
  const CustomIconButton({
    super.key,
    required this.action,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        onPressed: action,
        icon: Icon(icone),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(couleureSecondaire),
        ),
      ),
    );
  }
}
