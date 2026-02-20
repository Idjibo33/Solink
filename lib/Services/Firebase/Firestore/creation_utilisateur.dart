import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:so_link/Models/utilisateur.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/firestore.dart';

class CreationUtilisateur {
  final firestoreService = FirestoreService().firestoreService;
  final String userCollection = "users";
  // Creer docuement user
  Future creerDocUser({required UtilisateurModel utilisateur}) {
    final userData = {
      'id': utilisateur.id,
      'nom': utilisateur.nom,
      'prenom': utilisateur.prenom,
      'email': utilisateur.email,
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
}
