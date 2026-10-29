import 'package:so_link/features/chats/data/models/chat_message_model.dart';

/// Port de stockage des conversations.
///
/// Chaque backend fournit une implementation de ce contrat.
abstract interface class ChatStore {
  Stream<List<ChatMessageModel>> watchMessages({
    required String senderId,
    required String receiverId,
  });

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  });

  /// Identifiant canonique d'une conversation, independant du backend.
  String roomId({required String senderId, required String receiverId});
}
