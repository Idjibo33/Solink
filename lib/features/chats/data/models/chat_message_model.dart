import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessageModel extends Equatable {
  const ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.envoyeLe,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  final String id;
  final String senderId;
  final String content;
  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  final Timestamp envoyeLe;

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [id, senderId, content, envoyeLe];
}
