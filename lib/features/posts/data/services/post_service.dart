import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

class PostService {
  PostService(this._firestore);

  final FirebaseFirestore _firestore;

  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String usersCollection = 'users';

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(postsCollection);

  Stream<List<PostModel>> watchFeed() {
    return _posts
        .orderBy('creeLe', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  Stream<List<PostModel>> watchUserPosts(String userId) {
    return _posts
        .where('userId', isEqualTo: userId)
        .orderBy('creeLe', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }

  Stream<List<CommentModel>> watchComments(String postId) {
    return _posts
        .doc(postId)
        .collection(commentsCollection)
        .orderBy('creeLe', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CommentModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(growable: false),
        );
  }

  Future<void> createPost({
    required UserModel author,
    required String content,
  }) async {
    final postRef = _posts.doc();
    final batch = _firestore.batch();
    batch.set(postRef, {
      'id': postRef.id,
      'userId': author.id,
      'userName': author.displayName,
      'content': content.trim(),
      'comments': 0,
      'likes': <String>[],
      'creeLe': FieldValue.serverTimestamp(),
    });
    batch.update(_firestore.collection(usersCollection).doc(author.id), {
      'posts': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> addComment({
    required String postId,
    required UserModel author,
    required String content,
  }) async {
    final commentRef = _posts.doc(postId).collection(commentsCollection).doc();
    final batch = _firestore.batch();
    batch.set(commentRef, {
      'id': commentRef.id,
      'userId': author.id,
      'userName': author.displayName,
      'content': content.trim(),
      'creeLe': FieldValue.serverTimestamp(),
    });
    batch.update(_posts.doc(postId), {'comments': FieldValue.increment(1)});
    await batch.commit();
  }

  Future<void> likePost({required String postId, required String userId}) {
    return _posts.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikePost({required String postId, required String userId}) {
    return _posts.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }
}
