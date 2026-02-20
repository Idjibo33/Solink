import 'package:cloud_firestore/cloud_firestore.dart';

class UtilisateurModel {
  String id;
  String nom;
  String prenom;
  String email;
  Timestamp creeLe;
  UtilisateurModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.creeLe,
  });
  factory UtilisateurModel.fromMap(Map<String, dynamic> map) {
    return UtilisateurModel(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
      creeLe: map['creeLe'],
    );
  }
}
