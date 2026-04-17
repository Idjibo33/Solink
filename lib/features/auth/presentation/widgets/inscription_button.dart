import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/naviguer_auth_gate.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/features/auth/logic/providers/auth_services_provider.dart';

class InscriptionButton extends StatelessWidget {
  final String nom;
  final String prenom;
  final String email;
  final String pw;
  const InscriptionButton({
    super.key,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.pw,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServicesProvider>(
      builder: (context, auth, child) => BoutonPrincipale(
        texteBouton: "S'inscrire",
        action: () async {
          final inscription = await auth.inscrireUtilisateur(
            nom: nom,
            prenom: prenom,
            email: email,
            pw: pw,
          );
          if (inscription) {
            if (context.mounted) naviguerAuthGate(context);
          }
        },
        chargement: auth.chargement,
      ),
    );
  }
}
