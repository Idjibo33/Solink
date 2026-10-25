import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_event.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._repository) : super(const FeedState()) {
    on<FeedStarted>(_onStarted);
    on<FeedRetried>(_onRetried);
    on<FeedPostsUpdated>(_onPostsUpdated);
    on<FeedFailed>(_onFailed);
    on<FeedErrorDismissed>(_onErrorDismissed);
  }

  final PostRepository _repository;
  StreamSubscription<List<PostModel>>? _subscription;

  Future<void> _onStarted(FeedStarted event, Emitter<FeedState> emit) async {
    await _subscribe(emit);
  }

  Future<void> _onRetried(FeedRetried event, Emitter<FeedState> emit) async {
    await _subscribe(emit);
  }

  Future<void> _subscribe(Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading, clearError: true));
    await _subscription?.cancel();
    _subscription = _repository.watchFeed().listen(
      (posts) {
        if (!isClosed) {
          add(FeedPostsUpdated(posts));
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          add(FeedFailed(mapFailure(error).message));
        }
      },
    );
  }

  void _onPostsUpdated(FeedPostsUpdated event, Emitter<FeedState> emit) {
    emit(
      state.copyWith(
        status: FeedStatus.loaded,
        posts: event.posts,
        clearError: true,
      ),
    );
  }

  void _onFailed(FeedFailed event, Emitter<FeedState> emit) {
    emit(
      state.copyWith(status: FeedStatus.failure, errorMessage: event.message),
    );
  }

  void _onErrorDismissed(FeedErrorDismissed event, Emitter<FeedState> emit) {
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
