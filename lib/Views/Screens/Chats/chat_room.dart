import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Providers/Chats/chat_provider.dart';
import 'package:so_link/Providers/Utilisateur/utililsateur_provider.dart';
import 'package:so_link/Views/Widgets/chat_bubble.dart';
import 'package:so_link/Views/Widgets/custom_icon_button.dart';
import 'package:so_link/Views/Widgets/simple_text_field.dart';
import 'package:so_link/Views/Widgets/user_avatar.dart';
import 'package:so_link/constants.dart';

class ChatRoom extends StatefulWidget {
  final UtilisateurModel user;
  const ChatRoom({super.key, required this.user});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<UtililsateurProvider>().docId;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 8,
          children: [
            UserAvatar(size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.nom, style: titreTexte),
                Text(widget.user.email, style: corpsTexte),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, value, child) => StreamBuilder(
                  stream: value.readChats(
                    receiverId: widget.user.id,
                    senderId: currentUser!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasData && snapshot.data == null) {
                      return Center(child: Text("Aucun message trouvé"));
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) =>
                          ChatBubble(chat: snapshot.data![index]),
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SimpleTextField(
                    hint: "Envoyer quelque chose",
                    controller: textController,
                  ),
                ),
                Consumer<ChatProvider>(
                  builder: (context, value, child) => CustomIconButton(
                    action: () {
                      value.sendChat(
                        senderid: currentUser!,
                        content: textController.text.trim(),
                        receiverId: widget.user.id,
                      );
                      textController.clear();
                    },
                    controller: textController,
                    icone: Icons.send,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
