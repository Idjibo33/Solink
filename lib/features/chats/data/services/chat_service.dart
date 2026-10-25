import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';

class ChatService {
  ChatService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String chatRoomsCollection = 'chatrooms';
  static const String messagesCollection = 'messages';

  String chatRoomId({required String senderId, required String receiverId}) {
    final ids = [senderId, receiverId]..sort();
    return ids.join('_');
  }

  Stream<List<ChatMessageModel>> watchMessages({
    required String senderId,
    required String receiverId,
  }) {
    final roomId = chatRoomId(senderId: senderId, receiverId: receiverId);
    return _firestore
        .collection(chatRoomsCollection)
        .doc(roomId)
        .collection(messagesCollection)
        .orderBy('envoyeLe', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ChatMessageModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(growable: false),
        );
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final roomId = chatRoomId(senderId: senderId, receiverId: receiverId);
    final roomRef = _firestore.collection(chatRoomsCollection).doc(roomId);
    final messageRef = roomRef.collection(messagesCollection).doc();

    final batch = _firestore.batch();
    batch.set(roomRef, {
      'members': [senderId, receiverId],
      'lastMessage': content.trim(),
      'envoyeLe': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    batch.set(messageRef, {
      'senderId': senderId,
      'content': content.trim(),
      'envoyeLe': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }
}
