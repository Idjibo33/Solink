import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback action;
  final IconData icone;
  const CustomIconButton({
    super.key,
    required this.action,
    required TextEditingController controller,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(onPressed: action, icon: Icon(icone)),
    );
  }
}
