import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:so_link/core/utils/date_serialization.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel extends Equatable {
  const CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.creeLe,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  final String id;
  final String userId;
  final String userName;
  final String content;
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime creeLe;

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  @override
  List<Object?> get props => [id, userId, userName, content, creeLe];
}
