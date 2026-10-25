import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';

abstract interface class ChatRepository {
  Stream<List<ChatMessageModel>> watchMessages({
    required String senderId,
    required String receiverId,
  });

  Future<Either<Failure, void>> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  });
}
