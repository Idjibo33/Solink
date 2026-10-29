import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';
import 'package:so_link/features/chats/domain/repositories/chat_store.dart';

/// Adaptateur Firestore du stockage des conversations.
class FirestoreChatStore implements ChatStore {  FirestoreChatStore(this._firestore);

  final FirebaseFirestore _firestore;

  static const String chatRoomsCollection = 'chatrooms';
  static const String messagesCollection = 'messages';

  @override
  String roomId({required String senderId, required String receiverId}) {
    final ids = [senderId, receiverId]..sort();
    return ids.join('_');
  }

  @override
  Stream<List<ChatMessageModel>> watchMessages({
    required String senderId,
    required String receiverId,
  }) {
    final roomId = this.roomId(senderId: senderId, receiverId: receiverId);
    return _firestore
        .collection(chatRoomsCollection)
        .doc(roomId)
        .collection(messagesCollection)
        .orderBy('envoyeLe', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatMessageModel.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                  'envoyeLe': _toDate(doc.data()['envoyeLe']),
                }),
              )
              .toList(growable: false),
        );
  }

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    final roomId = this.roomId(senderId: senderId, receiverId: receiverId);
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

  DateTime _toDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return DateTime.now();
  }
}
