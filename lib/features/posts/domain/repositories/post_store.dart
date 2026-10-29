import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

/// Port de stockage des posts et commentaires.
///
/// Chaque backend fournit une implementation de ce contrat. Les types
/// exposes sont neutres : aucune reference a un SDK de base de donnees.
abstract interface class PostStore {
  Stream<List<PostModel>> watchFeed();

  Stream<List<PostModel>> watchUserPosts(String userId);

  Stream<List<CommentModel>> watchComments(String postId);

  Future<void> createPost({
    required UserModel author,
    required String content,
  });

  Future<void> addComment({
    required String postId,
    required UserModel author,
    required String content,
  });

  Future<void> likePost({required String postId, required String userId});

  Future<void> unlikePost({required String postId, required String userId});
}
