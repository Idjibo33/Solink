import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Views/Widgets/bouton_principale.dart';
import 'package:so_link/features/auth/logic/providers/auth_services_provider.dart';

class ConnexionButton extends StatelessWidget {
  final String email;
  final String pw;
  const ConnexionButton({super.key, required this.email, required this.pw});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthServicesProvider>(
      builder: (context, auth, child) => BoutonPrincipale(
        texteBouton: "Se connecter",
        action: () => auth.connecterUtilisateur(email: email, pw: pw),
        chargement: auth.chargement,
      ),
    );
  }
}
