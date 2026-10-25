import 'package:equatable/equatable.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

final class FeedStarted extends FeedEvent {
  const FeedStarted();
}

final class FeedRetried extends FeedEvent {
  const FeedRetried();
}

final class FeedErrorDismissed extends FeedEvent {
  const FeedErrorDismissed();
}

final class FeedPostsUpdated extends FeedEvent {
  const FeedPostsUpdated(this.posts);

  final List<PostModel> posts;

  @override
  List<Object?> get props => [posts];
}

final class FeedFailed extends FeedEvent {
  const FeedFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
