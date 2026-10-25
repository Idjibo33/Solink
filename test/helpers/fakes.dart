import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';
import 'package:so_link/features/chats/domain/repositories/chat_repository.dart';
import 'package:so_link/features/posts/data/models/comment_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';
import 'package:so_link/features/posts/domain/repositories/post_repository.dart';
import 'package:so_link/features/settings/domain/models/app_config.dart';
import 'package:so_link/features/settings/domain/repositories/app_config_repository.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

UserModel userTest({
  String id = 'user-1',
  String nom = 'Djibo',
  String prenom = 'Ismaël',
  String bio = 'Développeur Flutter',
  int posts = 0,
}) {
  return UserModel(
    id: id,
    nom: nom,
    prenom: prenom,
    bio: bio,
    posts: posts,
    followers: 0,
    followings: 0,
    creeLe: Timestamp.fromMillisecondsSinceEpoch(0),
  );
}

PostModel postTest({
  String id = 'post-1',
  String userId = 'user-1',
  String userName = 'Ismaël Djibo',
  String content = 'Contenu de test',
  List<String> likes = const [],
  int comments = 0,
}) {
  return PostModel(
    id: id,
    userId: userId,
    userName: userName,
    content: content,
    likes: likes,
    comments: comments,
    creeLe: Timestamp.fromMillisecondsSinceEpoch(0),
  );
}

CommentModel commentTest({
  String id = 'comment-1',
  String content = 'Commentaire de test',
}) {
  return CommentModel(
    id: id,
    userId: 'user-1',
    userName: 'Ismaël Djibo',
    content: content,
    creeLe: Timestamp.fromMillisecondsSinceEpoch(0),
  );
}

ChatMessageModel messageTest({
  String id = 'message-1',
  String senderId = 'user-1',
  String content = 'Message de test',
}) {
  return ChatMessageModel(
    id: id,
    senderId: senderId,
    content: content,
    envoyeLe: Timestamp.fromMillisecondsSinceEpoch(0),
  );
}

Future<void> settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

class FakeAuthRepository implements AuthRepository {
  final authStateController = StreamController<UserModel?>.broadcast();
  final otherUsersController = StreamController<List<UserModel>>.broadcast();

  UserModel user = userTest();
  Either<Failure, UserModel>? signInResult;
  Either<Failure, UserModel>? signUpResult;
  Either<Failure, UserModel>? completeProfileResult;
  Either<Failure, void>? signOutResult;
  Either<Failure, UserModel>? getUserResult;

  int signInCalls = 0;
  int signUpCalls = 0;
  int completeProfileCalls = 0;
  int signOutCalls = 0;
  String? lastBio;

  @override
  Stream<UserModel?> authStateChanges() => authStateController.stream;

  @override
  Stream<UserModel> watchUser(String userId) => Stream.value(user);

  @override
  Stream<List<UserModel>> watchOtherUsers(String currentUserId) =>
      otherUsersController.stream;

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    return signInResult ?? Right(user);
  }

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String nom,
    required String prenom,
    required String email,
    required String password,
  }) async {
    signUpCalls++;
    return signUpResult ?? Right(user.copyWith(bio: ''));
  }

  @override
  Future<Either<Failure, UserModel>> completeProfile({
    required String userId,
    required String bio,
  }) async {
    completeProfileCalls++;
    lastBio = bio;
    return completeProfileResult ?? Right(user.copyWith(bio: bio));
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    signOutCalls++;
    return signOutResult ?? const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, UserModel>> getUser(String userId) async {
    return getUserResult ?? Right(user);
  }

  Future<void> close() async {
    await authStateController.close();
    await otherUsersController.close();
  }
}

class FakePostRepository implements PostRepository {
  final feedController = StreamController<List<PostModel>>.broadcast();
  final userPostsController = StreamController<List<PostModel>>.broadcast();
  final commentsController = StreamController<List<CommentModel>>.broadcast();

  Either<Failure, void>? createResult;
  Either<Failure, void>? commentResult;
  Either<Failure, void>? likeResult;
  Either<Failure, void>? unlikeResult;

  int createCalls = 0;
  int commentCalls = 0;
  int likeCalls = 0;
  int unlikeCalls = 0;
  String? lastContent;

  @override
  Stream<List<PostModel>> watchFeed() => feedController.stream;

  @override
  Stream<List<PostModel>> watchUserPosts(String userId) =>
      userPostsController.stream;

  @override
  Stream<List<CommentModel>> watchComments(String postId) =>
      commentsController.stream;

  @override
  Future<Either<Failure, void>> createPost({
    required UserModel author,
    required String content,
  }) async {
    createCalls++;
    lastContent = content;
    return createResult ?? const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> addComment({
    required String postId,
    required UserModel author,
    required String content,
  }) async {
    commentCalls++;
    lastContent = content;
    return commentResult ?? const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> likePost({
    required String postId,
    required String userId,
  }) async {
    likeCalls++;
    return likeResult ?? const Right<Failure, void>(null);
  }

  @override
  Future<Either<Failure, void>> unlikePost({
    required String postId,
    required String userId,
  }) async {
    unlikeCalls++;
    return unlikeResult ?? const Right<Failure, void>(null);
  }

  Future<void> close() async {
    await feedController.close();
    await userPostsController.close();
    await commentsController.close();
  }
}

class FakeChatRepository implements ChatRepository {
  final messagesController =
      StreamController<List<ChatMessageModel>>.broadcast();

  Either<Failure, void>? sendResult;
  int sendCalls = 0;
  String? lastContent;

  @override
  Stream<List<ChatMessageModel>> watchMessages({
    required String senderId,
    required String receiverId,
  }) => messagesController.stream;

  @override
  Future<Either<Failure, void>> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    sendCalls++;
    lastContent = content;
    return sendResult ?? const Right<Failure, void>(null);
  }

  Future<void> close() => messagesController.close();
}

class FakeAiRepository implements AiRepository {
  Either<Failure, String>? result;

  @override
  Future<Either<Failure, String>> generatePost(String prompt) async {
    return result ?? const Right<Failure, String>('Post généré');
  }
}

class FakeTranslationRepository implements TranslationRepository {
  Either<Failure, String>? result;

  @override
  Future<Either<Failure, String>> translate(String text) async {
    return result ?? Right<Failure, String>('Traduction de $text');
  }
}

class FakeAppConfigRepository implements AppConfigRepository {
  Either<Failure, AppConfig>? result;

  @override
  Future<Either<Failure, AppConfig>> load() async {
    return result ?? Right(AppConfig.defaults().copyWith(themeIndex: 2));
  }
}
