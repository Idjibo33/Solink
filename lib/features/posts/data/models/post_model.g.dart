// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  content: json['content'] as String,
  comments: (json['comments'] as num).toInt(),
  likes: stringListFromJson(json['likes']),
  creeLe: dateTimeFromJson(json['creeLe']),
);

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'content': instance.content,
  'comments': instance.comments,
  'likes': stringListToJson(instance.likes),
  'creeLe': dateTimeToJson(instance.creeLe),
};
