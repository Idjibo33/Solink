import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';

class PostComposerState extends Equatable {
  const PostComposerState({
    this.isGenerating = false,
    this.isPublishing = false,
    this.generatedText,
    this.published = false,
    this.errorMessage,
  });

  final bool isGenerating;
  final bool isPublishing;
  final String? generatedText;
  final bool published;
  final String? errorMessage;

  PostComposerState copyWith({
    bool? isGenerating,
    bool? isPublishing,
    String? generatedText,
    bool? published,
    String? errorMessage,
    bool clearGeneratedText = false,
    bool clearError = false,
  }) {
    return PostComposerState(
      isGenerating: isGenerating ?? this.isGenerating,
      isPublishing: isPublishing ?? this.isPublishing,
      generatedText: clearGeneratedText
          ? null
          : generatedText ?? this.generatedText,
      published: published ?? this.published,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isGenerating,
    isPublishing,
    generatedText,
    published,
    errorMessage,
  ];
}

class PostComposerCubit extends Cubit<PostComposerState> {
  PostComposerCubit({
    required AiRepository aiRepository,
    required PostRepository postRepository,
  }) : _aiRepository = aiRepository,
       _postRepository = postRepository,
       super(const PostComposerState());

  final AiRepository _aiRepository;
  final PostRepository _postRepository;

  Future<void> generate(String prompt) async {
    if (state.isGenerating) {
      return;
    }
    emit(state.copyWith(isGenerating: true, clearError: true));
    final result = await _aiRepository.generatePost(prompt);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(isGenerating: false, errorMessage: failure.message),
      ),
      (text) => emit(
        state.copyWith(
          isGenerating: false,
          generatedText: text,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> publish({
    required UserModel author,
    required String content,
  }) async {
    if (state.isPublishing) {
      return;
    }
    if (content.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Le contenu du post est vide.'));
      return;
    }
    emit(state.copyWith(isPublishing: true, clearError: true));
    final result = await _postRepository.createPost(
      author: author,
      content: content,
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => emit(
        state.copyWith(isPublishing: false, errorMessage: failure.message),
      ),
      (_) => emit(
        state.copyWith(
          isPublishing: false,
          published: true,
          clearGeneratedText: true,
          clearError: true,
        ),
      ),
    );
  }

  void consumePublished() {
    if (state.published) {
      emit(state.copyWith(published: false));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
