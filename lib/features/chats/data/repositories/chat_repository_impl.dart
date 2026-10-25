import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';
import 'package:so_link/features/chats/data/services/chat_service.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._service);

  final ChatService _service;

  @override
  Stream<List<ChatMessageModel>> watchMessages({
    required String senderId,
    required String receiverId,
  }) {
    return _service.watchMessages(senderId: senderId, receiverId: receiverId);
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return const Left(ValidationFailure('Le message est vide.'));
    }
    try {
      await _service.sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        content: content,
      );
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }
}
