import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/chat_widget.dart';
import 'package:so_link/constants.dart';

class DiscussionsScreen extends StatelessWidget {
  const DiscussionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<UtililsateurProvider>().id;
    return Scaffold(
      appBar: AppBar(title: Text("Discussions", style: enteteTexte)),
      body: Consumer<UtililsateurProvider>(
        builder: (context, value, child) => StreamBuilder(
          stream: value.readUsers(userId: userId!, context: context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Text("Aucun utilisateur trouvé", style: corpsTexte),
              );
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
