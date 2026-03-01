import 'package:flutter/material.dart';
import 'package:so_link/Models/constants.dart';
import 'package:so_link/Views/Widgets/loading_widget.dart';

class AiGeneratingButton extends StatelessWidget {
  final VoidCallback action;
  final bool chargement;
  const AiGeneratingButton({
    super.key,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: chargement ? null : action,
        icon: chargement ? LoadingWidget() : Icon(Icons.electric_bolt_sharp),
        label: chargement
            ? Text("En train de générer le poste ...", style: corpsTexte)
            : Text("Générer post"),
      ),
    );
  }
}
