import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

abstract interface class PostRepository {
  Stream<List<PostModel>> watchFeed();

  Stream<List<PostModel>> watchUserPosts(String userId);

  Stream<List<CommentModel>> watchComments(String postId);

  Future<Either<Failure, void>> createPost({
    required UserModel author,
    required String content,
  });

  Future<Either<Failure, void>> addComment({
    required String postId,
    required UserModel author,
    required String content,
  });

  Future<Either<Failure, void>> likePost({
    required String postId,
    required String userId,
  });

  Future<Either<Failure, void>> unlikePost({
    required String postId,
    required String userId,
  });
}
