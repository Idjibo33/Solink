import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';

enum ProfileStatus { initial, loading, loaded, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.posts = const [],
    this.errorMessage,
  });

  final ProfileStatus status;
  final UserModel? user;
  final List<PostModel> posts;
  final String? errorMessage;

  bool get isEmpty => status == ProfileStatus.loaded && posts.isEmpty;

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    List<PostModel>? posts,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      posts: posts ?? this.posts,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, posts, errorMessage];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required AuthRepository authRepository,
    required PostRepository postRepository,
    required String userId,
  }) : _authRepository = authRepository,
       _postRepository = postRepository,
       _userId = userId,
       super(const ProfileState());

  final AuthRepository _authRepository;
  final PostRepository _postRepository;
  final String _userId;
  StreamSubscription<UserModel>? _userSubscription;
  StreamSubscription<List<PostModel>>? _postSubscription;

  void load() {
    _userSubscription?.cancel();
    _postSubscription?.cancel();
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    _userSubscription = _authRepository
        .watchUser(_userId)
        .listen(
          (user) {
            if (isClosed) {
              return;
            }
            emit(
              state.copyWith(
                status: ProfileStatus.loaded,
                user: user,
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
                status: ProfileStatus.failure,
                errorMessage: mapFailure(error).message,
              ),
            );
          },
        );

    _postSubscription = _postRepository
        .watchUserPosts(_userId)
        .listen(
          (posts) {
            if (isClosed) {
              return;
            }
            emit(
              state.copyWith(
                status: ProfileStatus.loaded,
                posts: posts,
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
                status: ProfileStatus.failure,
                errorMessage: mapFailure(error).message,
              ),
            );
          },
        );
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    await _postSubscription?.cancel();
    return super.close();
  }
}
