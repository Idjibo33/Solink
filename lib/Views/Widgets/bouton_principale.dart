import 'package:flutter/material.dart';

class BoutonPrincipale extends StatelessWidget {
  final String texteBouton;
  final VoidCallback action;
  final bool chargement;
  const BoutonPrincipale({
    super.key,
    required this.texteBouton,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: chargement ? null : action,
        child: chargement
            ? CircularProgressIndicator.adaptive()
            : Text(texteBouton),
      ),
    );
  }
}
