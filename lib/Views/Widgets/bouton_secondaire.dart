import 'package:flutter/material.dart';

class BoutonSecondaire extends StatelessWidget {
  final String boutonTexte;
  final VoidCallback action;
  const BoutonSecondaire({
    super.key,
    required this.boutonTexte,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: action, child: Text("Test")),
      ),
    );
  }
}
