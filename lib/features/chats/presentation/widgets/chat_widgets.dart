import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/utils/date_formatter.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      leading: UserAvatar(username: user.displayName, size: 22),
      title: Text(
        user.displayName,
        style: AppTextStyles.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        user.bio.isEmpty ? 'Aucune bio' : user.bio,
        style: AppTextStyles.caption,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/chats/${user.id}', extra: user),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message, required this.isMine});

  final ChatMessageModel message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? primary : Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMine ? 18 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              message.content,
              style: AppTextStyles.body.copyWith(
                color: isMine ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              formatTimestamp(message.envoyeLe),
              style: AppTextStyles.caption.copyWith(
                color: isMine ? Colors.white70 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
