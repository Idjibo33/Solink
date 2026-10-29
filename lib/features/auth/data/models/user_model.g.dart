// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  nom: json['nom'] as String,
  prenom: json['prenom'] as String,
  bio: json['bio'] as String,
  posts: (json['posts'] as num).toInt(),
  followers: (json['followers'] as num).toInt(),
  followings: (json['followings'] as num).toInt(),
  creeLe: dateTimeFromJson(json['creeLe']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'nom': instance.nom,
  'prenom': instance.prenom,
  'bio': instance.bio,
  'posts': instance.posts,
  'followers': instance.followers,
  'followings': instance.followings,
  'creeLe': dateTimeToJson(instance.creeLe),
};
