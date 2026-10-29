import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/posts/domain/repositories/post_store.dart';

class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._store);

  final PostStore _store;

  @override
  Stream<List<PostModel>> watchFeed() => _store.watchFeed();

  @override
  Stream<List<PostModel>> watchUserPosts(String userId) =>
      _store.watchUserPosts(userId);

  @override
  Stream<List<CommentModel>> watchComments(String postId) =>
      _store.watchComments(postId);

  @override
  Future<Either<Failure, void>> createPost({
    required UserModel author,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      return const Left(ValidationFailure('Le contenu du post est vide.'));
    }
    try {
      await _store.createPost(author: author, content: content);
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
      await _store.addComment(
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
      await _store.likePost(postId: postId, userId: userId);
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
      await _store.unlikePost(postId: postId, userId: userId);
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }
}
