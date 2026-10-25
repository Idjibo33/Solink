import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.bio,
    required this.posts,
    required this.followers,
    required this.followings,
    required this.creeLe,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  final String id;
  final String nom;
  final String prenom;
  final String bio;
  final int posts;
  final int followers;
  final int followings;
  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp creeLe;

  String get displayName {
    final values = [prenom, nom].where((value) => value.trim().isNotEmpty);
    return values.isEmpty ? 'Utilisateur' : values.join(' ');
  }

  bool get hasCompletedProfile => bio.trim().isNotEmpty;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? bio,
    int? posts,
    int? followers,
    int? followings,
    Timestamp? creeLe,
  }) {
    return UserModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      bio: bio ?? this.bio,
      posts: posts ?? this.posts,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      creeLe: creeLe ?? this.creeLe,
    );
  }

  @override
  List<Object?> get props => [
    id,
    nom,
    prenom,
    bio,
    posts,
    followers,
    followings,
    creeLe,
  ];
}

Timestamp timestampFromJson(Object? value) {
  if (value is Timestamp) {
    return value;
  }
  if (value is DateTime) {
    return Timestamp.fromDate(value);
  }
  if (value is int) {
    return Timestamp.fromMillisecondsSinceEpoch(value);
  }
  if (value is String) {
    return Timestamp.fromDate(DateTime.parse(value));
  }
  return Timestamp.now();
}

Object timestampToJson(Timestamp value) => value;
