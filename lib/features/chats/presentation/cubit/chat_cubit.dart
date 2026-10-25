import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';

enum ChatStatus { initial, loading, loaded, failure }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.receiver,
    this.isSending = false,
    this.errorMessage,
  });

  final ChatStatus status;
  final List<ChatMessageModel> messages;
  final UserModel? receiver;
  final bool isSending;
  final String? errorMessage;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessageModel>? messages,
    UserModel? receiver,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      receiver: receiver ?? this.receiver,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    receiver,
    isSending,
    errorMessage,
  ];
}

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required ChatRepository chatRepository,
    required AuthRepository authRepository,
  }) : _chatRepository = chatRepository,
       _authRepository = authRepository,
       super(const ChatState());

  final ChatRepository _chatRepository;
  final AuthRepository _authRepository;
  StreamSubscription<List<ChatMessageModel>>? _subscription;

  Future<void> open({
    required UserModel currentUser,
    required String receiverId,
    UserModel? initialReceiver,
  }) async {
    emit(state.copyWith(status: ChatStatus.loading, clearError: true));

    var receiver = initialReceiver;
    if (receiver == null) {
      final result = await _authRepository.getUser(receiverId);
      if (isClosed) {
        return;
      }
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: ChatStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (user) => receiver = user,
      );
    }
    if (isClosed || receiver == null) {
      return;
    }

    _subscription?.cancel();
    emit(state.copyWith(receiver: receiver));
    _subscription = _chatRepository
        .watchMessages(senderId: currentUser.id, receiverId: receiverId)
        .listen(
          (messages) {
            if (isClosed) {
              return;
            }
            emit(
              state.copyWith(
                status: ChatStatus.loaded,
                messages: messages,
                clearError: true,
              ),
            );
          },
          onError: (Object error) {
            if (isClosed) {
              return;
            }
            emit(
              state.copyWith(
                status: ChatStatus.failure,
                errorMessage: mapFailure(error).message,
              ),
            );
          },
        );
  }

  Future<void> send({
    required UserModel currentUser,
    required String content,
  }) async {
    final receiver = state.receiver;
    if (receiver == null || state.isSending) {
      return;
    }
    if (content.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Le message est vide.'));
      return;
    }
    emit(state.copyWith(isSending: true, clearError: true));
    final result = await _chatRepository.sendMessage(
      senderId: currentUser.id,
      receiverId: receiver.id,
      content: content,
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) =>
          emit(state.copyWith(isSending: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSending: false, clearError: true)),
    );
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
