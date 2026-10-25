import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

class PostCardState extends Equatable {
  const PostCardState({
    this.isTranslating = false,
    this.isReacting = false,
    this.translation,
    this.errorMessage,
  });

  final bool isTranslating;
  final bool isReacting;
  final String? translation;
  final String? errorMessage;

  PostCardState copyWith({
    bool? isTranslating,
    bool? isReacting,
    String? translation,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PostCardState(
      isTranslating: isTranslating ?? this.isTranslating,
      isReacting: isReacting ?? this.isReacting,
      translation: translation ?? this.translation,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isTranslating,
    isReacting,
    translation,
    errorMessage,
  ];
}

class PostCardCubit extends Cubit<PostCardState> {
  PostCardCubit({
    required TranslationRepository translationRepository,
    required PostRepository postRepository,
  }) : _translationRepository = translationRepository,
       _postRepository = postRepository,
       super(const PostCardState());

  final TranslationRepository _translationRepository;
  final PostRepository _postRepository;

  Future<void> translate(String text) async {
    if (state.isTranslating || state.translation != null) {
      return;
    }
    emit(state.copyWith(isTranslating: true, clearError: true));
    final result = await _translationRepository.translate(text);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(isTranslating: false, errorMessage: failure.message),
      ),
      (translation) =>
          emit(state.copyWith(isTranslating: false, translation: translation)),
    );
  }

  Future<void> toggleLike({
    required PostModel post,
    required String userId,
  }) async {
    if (state.isReacting) {
      return;
    }
    emit(state.copyWith(isReacting: true, clearError: true));
    final result = post.isLikedBy(userId)
        ? await _postRepository.unlikePost(postId: post.id, userId: userId)
        : await _postRepository.likePost(postId: post.id, userId: userId);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(isReacting: false, errorMessage: failure.message),
      ),
      (_) => emit(state.copyWith(isReacting: false, clearError: true)),
    );
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
