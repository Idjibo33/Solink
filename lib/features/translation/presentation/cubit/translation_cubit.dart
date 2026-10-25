import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

class TranslationState extends Equatable {
  const TranslationState({
    this.isLoading = false,
    this.translation,
    this.errorMessage,
  });

  final bool isLoading;
  final String? translation;
  final String? errorMessage;

  TranslationState copyWith({
    bool? isLoading,
    String? translation,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TranslationState(
      isLoading: isLoading ?? this.isLoading,
      translation: translation ?? this.translation,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, translation, errorMessage];
}

class TranslationCubit extends Cubit<TranslationState> {
  TranslationCubit(this._repository) : super(const TranslationState());

  final TranslationRepository _repository;

  Future<void> translate(String text) async {
    if (state.translation != null || state.isLoading) {
      return;
    }
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.translate(text);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (translation) =>
          emit(state.copyWith(isLoading: false, translation: translation)),
    );
  }
}
