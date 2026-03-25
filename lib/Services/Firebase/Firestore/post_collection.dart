import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Services/Firebase/Firestore/utilisateur_collection.dart';

class PostCollection {
  final firestore = FirebaseFirestore.instance;
  final String posteCollection = "posts";
  final String commentaireCollection = "comments";
  String get userCollection => UtilisateurCollection().userCollection;
  // Creer un post
  Future creerPost({required PostModel post, required String userId}) async {
    DocumentReference doc = firestore.collection(posteCollection).doc();
    // le document de l'utilisateur
    final userDoc = await firestore
        .collection(userCollection)
        .doc(userId)
        .get();
    final postData = {
      'comments': post.comments,
      'id': doc.id,
      'userId': userId,
      'userName': userDoc.data()!['prenom'], // le nom de l'utilisateur
      'content': post.content,
      'likes': post.likes,
      'creeLe': post.creeLe,
    };
    return await doc.set(postData).then((value) {
      firestore.collection(userCollection).doc(userId).update({
        'posts': FieldValue.increment(1),
      });
    });
  }

  // Lire tous les posts de l'utilisateur
  Stream<List<PostModel>>? readPosts() {
    return firestore
        .collection(posteCollection)
        .orderBy('creeLe', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            return PostModel.fromMap(e.data());
          }).toList(),
        );
  }

  // Lire les posts de l'utilisateur
  Stream<List<PostModel>>? lirePostUser({required String userId}) {
    return firestore
        .collection(posteCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('creeLe', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            return PostModel.fromMap(e.data());
          }).toList(),
        );
  }

  // Ajouter like
  Future addLike({required String docId, required String userId}) {
    return firestore.collection(posteCollection).doc(docId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  // Enlever like
  Future removeLike({required String docId, required String userId}) {
    return firestore.collection(posteCollection).doc(docId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // Ajouter commentaire au post
  Future addComment({
    required Commentaire commentaire,
    required String postId,
    required String userId,
  }) async {
    // le document de l'utilisateur
    final userDoc = await firestore
        .collection(userCollection)
        .doc(userId)
        .get();
    final comment = firestore
        .collection(posteCollection)
        .doc(postId)
        .collection(commentaireCollection)
        .doc();
    final commentdata = {
      'userName': userDoc.data()!['prenom'],
      'id': comment.id,
      'content': commentaire.content,
      'creeLe': commentaire.creeLe,
      'userId': userId,
    };
    return comment.set(commentdata).then((value) {
      firestore.collection(posteCollection).doc(postId).update({
        'comments': FieldValue.increment(1),
      });
    });
  }

  // Lire les commentaire du post
  Stream<List<Commentaire>> readPostComments(String docId) {
    return firestore
        .collection(posteCollection)
        .doc(docId)
        .collection(commentaireCollection)
        .orderBy('creeLe', descending: true)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            return Commentaire.fromMap(e.data());
          }).toList(),
        );
  }
}
