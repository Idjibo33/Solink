import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/posts/presentation/cubit/comments_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakePostRepository repository;
  late CommentsCubit cubit;

  setUp(() {
    repository = FakePostRepository();
    cubit = CommentsCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('load écoute les commentaires', () async {
    cubit.load('post-1');
    await settle();

    repository.commentsController.add([commentTest()]);
    await settle();

    expect(cubit.state.status, CommentsStatus.loaded);
    expect(cubit.state.comments, hasLength(1));
  });

  test('load expose une erreur', () async {
    cubit.load('post-1');
    await settle();

    repository.commentsController.addError(Exception('réseau'));
    await settle();

    expect(cubit.state.status, CommentsStatus.failure);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('addComment envoie le commentaire', () async {
    cubit.load('post-1');
    await settle();

    await cubit.addComment(author: userTest(), content: 'Bravo');

    expect(repository.commentCalls, 1);
    expect(repository.lastContent, 'Bravo');
    expect(cubit.state.isSending, isFalse);
  });

  test('addComment refuse un contenu vide', () async {
    cubit.load('post-1');
    await settle();

    await cubit.addComment(author: userTest(), content: '  ');

    expect(repository.commentCalls, 0);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('addComment échoue proprement', () async {
    repository.commentResult = const Left<Failure, void>(
      FirestoreFailure('Refusé'),
    );
    cubit.load('post-1');
    await settle();

    await cubit.addComment(author: userTest(), content: 'Bravo');

    expect(cubit.state.isSending, isFalse);
    expect(cubit.state.errorMessage, 'Refusé');
  });
}
