import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';

enum CommentsStatus { initial, loading, loaded, failure }

class CommentsState extends Equatable {
  const CommentsState({
    this.status = CommentsStatus.initial,
    this.comments = const [],
    this.postId,
    this.isSending = false,
    this.errorMessage,
  });

  final CommentsStatus status;
  final List<CommentModel> comments;
  final String? postId;
  final bool isSending;
  final String? errorMessage;

  bool get isEmpty => status == CommentsStatus.loaded && comments.isEmpty;

  CommentsState copyWith({
    CommentsStatus? status,
    List<CommentModel>? comments,
    String? postId,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      postId: postId ?? this.postId,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    comments,
    postId,
    isSending,
    errorMessage,
  ];
}

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit(this._repository) : super(const CommentsState());

  final PostRepository _repository;
  StreamSubscription<List<CommentModel>>? _subscription;

  void load(String postId) {
    _subscription?.cancel();
    emit(
      state.copyWith(
        status: CommentsStatus.loading,
        postId: postId,
        clearError: true,
      ),
    );
    _subscription = _repository
        .watchComments(postId)
        .listen(
          (comments) {
            if (isClosed) {
              return;
            }
            emit(
              state.copyWith(
                status: CommentsStatus.loaded,
                comments: comments,
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
                status: CommentsStatus.failure,
                errorMessage: mapFailure(error).message,
              ),
            );
          },
        );
  }

  Future<void> addComment({
    required UserModel author,
    required String content,
  }) async {
    final postId = state.postId;
    if (postId == null || state.isSending) {
      return;
    }
    if (content.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Le commentaire est vide.'));
      return;
    }
    emit(state.copyWith(isSending: true, clearError: true));
    final result = await _repository.addComment(
      postId: postId,
      author: author,
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
