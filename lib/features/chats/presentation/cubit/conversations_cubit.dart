import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';

enum ConversationsStatus { initial, loading, loaded, failure }

class ConversationsState extends Equatable {
  const ConversationsState({
    this.status = ConversationsStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  final ConversationsStatus status;
  final List<UserModel> users;
  final String? errorMessage;

  bool get isEmpty => status == ConversationsStatus.loaded && users.isEmpty;

  ConversationsState copyWith({
    ConversationsStatus? status,
    List<UserModel>? users,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ConversationsState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage];
}

class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit({
    required AuthRepository repository,
    required String currentUserId,
  }) : _repository = repository,
       _currentUserId = currentUserId,
       super(const ConversationsState());

  final AuthRepository _repository;
  final String _currentUserId;
  StreamSubscription<List<UserModel>>? _subscription;

  void load() {
    _subscription?.cancel();
    emit(state.copyWith(status: ConversationsStatus.loading, clearError: true));
    _subscription = _repository
        .watchOtherUsers(_currentUserId)
        .listen(
          (users) {
            if (isClosed) {
              return;
            }
            emit(
              state.copyWith(
                status: ConversationsStatus.loaded,
                users: users,
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
                status: ConversationsStatus.failure,
                errorMessage: mapFailure(error).message,
              ),
            );
          },
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
