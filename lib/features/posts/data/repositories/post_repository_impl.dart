import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/data/services/post_service.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._service);

  final PostService _service;

  @override
  Stream<List<PostModel>> watchFeed() => _service.watchFeed();

  @override
  Stream<List<PostModel>> watchUserPosts(String userId) =>
      _service.watchUserPosts(userId);

  @override
  Stream<List<CommentModel>> watchComments(String postId) =>
      _service.watchComments(postId);

  @override
  Future<Either<Failure, void>> createPost({
    required UserModel author,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return const Left(ValidationFailure('Le contenu du post est vide.'));
    }
    try {
      await _service.createPost(author: author, content: content);
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> addComment({
    required String postId,
    required UserModel author,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return const Left(ValidationFailure('Le commentaire est vide.'));
    }
    try {
      await _service.addComment(
        postId: postId,
        author: author,
        content: content,
      );
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _service.likePost(postId: postId, userId: userId);
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> unlikePost({
    required String postId,
    required String userId,
  }) async {
    try {
      await _service.unlikePost(postId: postId, userId: userId);
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }
}
