import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

void main() {
  // Les modeles stockent des dates UTC : la serialisation est stable quel que
  // soit le fuseau horaire de l'appareil.
  final timestamp = DateTime.fromMillisecondsSinceEpoch(1700000000000, isUtc: true);

  test('UserModel fait un aller-retour JSON', () {
    final model = UserModel(
      id: 'user-1',
      nom: 'Djibo',
      prenom: 'Ismaël',
      bio: 'Flutter',
      posts: 2,
      followers: 3,
      followings: 4,
      creeLe: timestamp,
    );

    final json = model.toJson();
    final decoded = UserModel.fromJson(json);

    expect(decoded, model);
    expect(decoded.displayName, 'Ismaël Djibo');
    expect(decoded.hasCompletedProfile, isTrue);
  });

  test('PostModel normalise les likes', () {
    final model = PostModel.fromJson({
      'id': 'post-1',
      'userId': 'user-1',
      'userName': 'Ismaël Djibo',
      'content': 'Bonjour',
      'comments': 2,
      'likes': ['user-1', 'user-2'],
      'creeLe': timestamp,
    });

    expect(model.likes, ['user-1', 'user-2']);
    expect(model.isLikedBy('user-1'), isTrue);
    expect(PostModel.fromJson(model.toJson()), model);
  });

  test('CommentModel et ChatMessageModel font un aller-retour', () {
    final comment = CommentModel(
      id: 'comment-1',
      userId: 'user-1',
      userName: 'Ismaël',
      content: 'Bravo',
      creeLe: timestamp,
    );
    final message = ChatMessageModel(
      id: 'message-1',
      senderId: 'user-1',
      content: 'Salut',
      envoyeLe: timestamp,
    );

    expect(CommentModel.fromJson(comment.toJson()), comment);
    expect(ChatMessageModel.fromJson(message.toJson()), message);
  });
}
