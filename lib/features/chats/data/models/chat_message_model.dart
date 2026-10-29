import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:so_link/core/utils/date_serialization.dart';

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
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime envoyeLe;

  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);

  @override
  List<Object?> get props => [id, senderId, content, envoyeLe];
}
