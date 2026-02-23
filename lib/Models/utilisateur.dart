import 'package:cloud_firestore/cloud_firestore.dart';

class UtilisateurModel {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String bio;
  int nombrePosts;
  int followers;
  int followings;
  Timestamp creeLe;
  UtilisateurModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.bio,
    required this.nombrePosts,
    required this.followers,
    required this.followings,
    required this.creeLe,
  });
  factory UtilisateurModel.fromMap(Map<String, dynamic> map) {
    return UtilisateurModel(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
      bio: map['bio'],
      followers: map['followers'],
      followings: map['followings'],
      nombrePosts: map['posts'],
      creeLe: map['creeLe'],
    );
  }
}
