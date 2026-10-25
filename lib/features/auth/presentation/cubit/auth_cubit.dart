import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/core/utils/validators.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;
  StreamSubscription<UserModel?>? _subscription;

  void start() {
    _subscription?.cancel();
    _subscription = _repository.authStateChanges().listen(
      (user) {
        if (user == null) {
          _emit(
            state.copyWith(
              status: AuthStatus.unauthenticated,
              isLoading: false,
              clearUser: true,
              clearError: true,
            ),
          );
          return;
        }
        _emit(
          state.copyWith(
            status: user.hasCompletedProfile
                ? AuthStatus.authenticated
                : AuthStatus.needsProfile,
            user: user,
            isLoading: false,
            clearError: true,
          ),
        );
      },
      onError: (Object error) {
        _emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
            clearUser: true,
            errorMessage: mapFailure(error).message,
          ),
        );
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    if (!Validators.isValidEmail(email)) {
      _emit(state.copyWith(errorMessage: 'Adresse e-mail invalide.'));
      return;
    }
    if (!Validators.isValidPassword(password)) {
      _emit(
        state.copyWith(
          errorMessage: 'Le mot de passe doit contenir au moins 6 caractères.',
        ),
      );
      return;
    }

    _emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.signIn(email: email, password: password);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => _emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (user) => _emit(
        state.copyWith(
          isLoading: false,
          user: user,
          status: user.hasCompletedProfile
              ? AuthStatus.authenticated
              : AuthStatus.needsProfile,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> signUp({
    required String nom,
    required String prenom,
    required String email,
    required String password,
  }) async {
    if (nom.trim().isEmpty || prenom.trim().isEmpty) {
      _emit(state.copyWith(errorMessage: 'Nom et prénom sont obligatoires.'));
      return;
    }
    if (!Validators.isValidEmail(email)) {
      _emit(state.copyWith(errorMessage: 'Adresse e-mail invalide.'));
      return;
    }
    if (!Validators.isValidPassword(password)) {
      _emit(
        state.copyWith(
          errorMessage: 'Le mot de passe doit contenir au moins 6 caractères.',
        ),
      );
      return;
    }

    _emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.signUp(
      nom: nom,
      prenom: prenom,
      email: email,
      password: password,
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => _emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (user) => _emit(
        state.copyWith(
          isLoading: false,
          user: user,
          status: AuthStatus.needsProfile,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> completeProfile({required String bio}) async {
    final user = state.user;
    if (user == null) {
      _emit(state.copyWith(errorMessage: 'Utilisateur non connecté.'));
      return;
    }
    if (bio.trim().isEmpty) {
      _emit(state.copyWith(errorMessage: 'Ajoutez une bio pour continuer.'));
      return;
    }

    _emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.completeProfile(userId: user.id, bio: bio);
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => _emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (updatedUser) => _emit(
        state.copyWith(
          isLoading: false,
          user: updatedUser,
          status: AuthStatus.authenticated,
          clearError: true,
        ),
      ),
    );
  }

  Future<void> signOut() async {
    _emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.signOut();
    if (isClosed) {
      return;
    }
    result.fold(
      (failure) => _emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (_) => _emit(const AuthState(status: AuthStatus.unauthenticated)),
    );
  }

  void clearError() {
    _emit(state.copyWith(clearError: true));
  }

  void _emit(AuthState newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
