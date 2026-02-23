import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/chat_widget.dart';
import 'package:so_link/constants.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discussions", style: enteteTexte)),
      body: Consumer<UtililsateurProvider>(
        builder: (context, value, child) => StreamBuilder(
          stream: value.users,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.data == null) {
              return Center(child: Text("Aucun utilisateur trouvé"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  ChatWidget(user: snapshot.data![index]),
            );
          },
        ),
      ),
    );
  }
}
