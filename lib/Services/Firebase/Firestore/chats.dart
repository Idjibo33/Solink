import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/Models/chat.dart';
import 'package:so_link/Services/Firebase/Firestore/firestore.dart';

class Chats {
  final firestore = FirestoreService().firestoreService;
  final chatRoomCollection = "chatrooms";
  final messageCollection = "messages";

  //Creer un id pour le chat room
  String idChatRoom({required String receiverId, required String senderId}) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String id = ids.join("_");
    return id;
  }

  //envoi message
  Future sendChat({
    required String content,
    required String receiverId,
    required String senderId,
  }) async {
    // Batch
    WriteBatch batch = firestore.batch();

    // l'id de du chat room
    final chatRoomId = idChatRoom(receiverId: receiverId, senderId: senderId);

    // La donnée du chat room
    final chatRoomData = {
      'members': [senderId, receiverId],
      'envoyeLe': FieldValue.serverTimestamp(),
    };

    //la ref du chatRoom
    final chatRoom = firestore.collection(chatRoomCollection).doc(chatRoomId);

    // la ref du message
    final chatRef = chatRoom.collection(messageCollection).doc();

    // La donnée du message
    final chatData = {
      'senderId': senderId,
      'content': content,
      'envoyeLe': FieldValue.serverTimestamp(),
    };

    batch.set(chatRoom, chatRoomData, SetOptions(merge: true));
    batch.set(chatRef, chatData);
    batch.commit();
  }

  //Recevoir message
  Stream<List<Chat>>? getChats({
    required String receiverId,
    required String senderId,
  }) {
    String chatRoomId = idChatRoom(receiverId: receiverId, senderId: senderId);
    try {
      return firestore
          .collection(chatRoomCollection)
          .doc(chatRoomId)
          .collection(messageCollection)
          .snapshots()
          .map(
            (event) => event.docs.map((e) {
              return Chat.fromMap(e.data());
            }).toList(),
          );
    } catch (e) {
      throw Exception(e);
    }
  }
}
