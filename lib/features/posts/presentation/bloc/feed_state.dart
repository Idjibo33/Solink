import 'package:equatable/equatable.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

enum FeedStatus { initial, loading, loaded, failure }

class FeedState extends Equatable {
  const FeedState({
    this.status = FeedStatus.initial,
    this.posts = const [],
    this.errorMessage,
  });

  final FeedStatus status;
  final List<PostModel> posts;
  final String? errorMessage;

  bool get isEmpty => status == FeedStatus.loaded && posts.isEmpty;

  FeedState copyWith({
    FeedStatus? status,
    List<PostModel>? posts,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FeedState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}
