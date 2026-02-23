import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/firestore.dart';

class CreationUtilisateur {
  final firestoreService = FirestoreService().firestoreService;
  final String userCollection = "users";
  String? get docId => AuthService().currentUser?.uid;

  // Creer docuement user
  Future creerDocUser({required UtilisateurModel utilisateur}) {
    final userData = {
      'id': utilisateur.id,
      'nom': utilisateur.nom,
      'prenom': utilisateur.prenom,
      'email': utilisateur.email,
      'bio': "",
      'posts': 0,
      'followers': 0,
      'followings': 0,
      'creeLe': utilisateur.creeLe,
    };
    try {
      return firestoreService
          .collection(userCollection)
          .doc(utilisateur.id)
          .set(userData);
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  Future ajouterBio({required String bio}) {
    try {
      return firestoreService.collection(userCollection).doc(docId).update({
        'bio': bio,
      });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  // Lire les utilisateurs
  Stream<List<UtilisateurModel>>? users() {
    try {
      return firestoreService
          .collection(userCollection)
          .where('id', isNotEqualTo: docId)
          .snapshots()
          .map(
            (event) => event.docs.map((e) {
              return UtilisateurModel.fromMap(e.data());
            }).toList(),
          );
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }

  //Lire document utilisateur
  Stream<UtilisateurModel> lireDocUser(String id) {
    try {
      return firestoreService
          .collection(userCollection)
          .doc(id)
          .snapshots()
          .map((snapshot) {
            return UtilisateurModel.fromMap(snapshot.data()!);
          });
    } on FirebaseException catch (e) {
      throw Exception(e);
    }
  }
}
