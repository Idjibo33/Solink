import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/Models/utilisateur.dart';

class UtilisateurCollection {
  final firestoreService = FirebaseFirestore.instance;
  final String userCollection = "users";

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

    return firestoreService
        .collection(userCollection)
        .doc(utilisateur.id)
        .set(userData);
  }

  Future ajouterBio({required String bio, required String userId}) {
    return firestoreService.collection(userCollection).doc(userId).update({
      'bio': bio,
    });
  }

  // Lire les utilisateurs
  Stream<List<UtilisateurModel>> users(String userId) {
    return firestoreService
        .collection(userCollection)
        .where('id', isNotEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map((e) {
            return UtilisateurModel.fromMap(e.data());
          }).toList(),
        );
  }

  //Lire document utilisateur
  Stream<UtilisateurModel> lireDocUser(String id) {
    return firestoreService.collection(userCollection).doc(id).snapshots().map((
      snapshot,
    ) {
      return UtilisateurModel.fromMap(snapshot.data()!);
    });
  }
}
