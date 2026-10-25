import 'package:equatable/equatable.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

enum AuthStatus { unknown, unauthenticated, needsProfile, authenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, isLoading, errorMessage];
}
