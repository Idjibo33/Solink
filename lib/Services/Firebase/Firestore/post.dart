import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/Models/commentaire.dart';
import 'package:so_link/Models/post.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/creation_utilisateur.dart';
import 'package:so_link/Services/Firebase/Firestore/firestore.dart';

class Post {
  final firestore = FirestoreService().firestoreService;
  final String posteCollection = "posts";
  final String commentaireCollection = "comment";
  String get userId => AuthService().currentUser!.uid;
  String get userCollection => CreationUtilisateur().userCollection;
  // Creer un post
  Future creerPost({required PostModel post}) async {
    try {
      DocumentReference doc = firestore.collection(posteCollection).doc();
      final postData = {
        'id': doc.id,
        'userId': userId,
        'content': post.content,
        'likes': post.likes,
        'creeLe': post.creeLe,
      };
      return await doc.set(postData).then((value) {
        firestore.collection(userCollection).doc(userId).update({
          'posts': FieldValue.increment(1),
        });
      });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Lire tous les posts de l'utilisateur
  Stream<List<PostModel>>? readPosts() {
    try {
      return firestore
          .collection(posteCollection)
          .orderBy('creeLe', descending: true)
          .snapshots()
          .map(
            (event) => event.docs.map((e) {
              return PostModel.fromMap(e.data());
            }).toList(),
          );
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Lire les posts de l'utilisateur
  Stream<List<PostModel>>? lirePostUser() {
    try {
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
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Ajouter like
  Future addLike(String docId) {
    try {
      return firestore.collection(posteCollection).doc(docId).update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Enlever like
  Future removeLike(String docId) {
    try {
      return firestore.collection(posteCollection).doc(docId).update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Ajouter commentaire au post
  Future addComment(Commentaire commentaire, String postId) {
    try {
      final comment = firestore
          .collection(posteCollection)
          .doc(postId)
          .collection(commentaireCollection)
          .doc();
      final commentdata = {
        'id': comment.id,
        'content': commentaire.content,
        'creeLe': commentaire.creeLe,
        'userId': userId,
      };
      return comment.set(commentdata);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Lire les commentaire du post
  Stream<List<Commentaire>>? readPostComments(String docId) {
    try {
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
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
