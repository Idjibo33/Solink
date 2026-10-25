import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_bloc.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_event.dart';
import 'package:so_link/features/posts/presentation/bloc/feed_state.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakePostRepository repository;
  late FeedBloc bloc;

  setUp(() {
    repository = FakePostRepository();
    bloc = FeedBloc(repository);
  });

  tearDown(() async {
    await bloc.close();
    await repository.close();
  });

  test('FeedStarted charge les posts du stream', () async {
    bloc.add(const FeedStarted());
    await settle();

    repository.feedController.add([postTest()]);
    await settle();

    expect(bloc.state.status, FeedStatus.loaded);
    expect(bloc.state.posts, hasLength(1));
    expect(bloc.state.posts.first.id, 'post-1');
  });

  test('une erreur du stream passe le feed en failure', () async {
    bloc.add(const FeedStarted());
    await settle();

    repository.feedController.addError(Exception('réseau'));
    await settle();

    expect(bloc.state.status, FeedStatus.failure);
    expect(bloc.state.errorMessage, isNotNull);
  });

  test('FeedRetried réabonne le stream', () async {
    bloc.add(const FeedStarted());
    await settle();

    bloc.add(const FeedRetried());
    await settle();

    repository.feedController.add([postTest(id: 'post-2')]);
    await settle();

    expect(bloc.state.posts.single.id, 'post-2');
  });

  test('FeedErrorDismissed efface le message', () async {
    bloc.add(const FeedStarted());
    await settle();
    repository.feedController.addError(Exception('erreur'));
    await settle();

    bloc.add(const FeedErrorDismissed());
    await settle();

    expect(bloc.state.errorMessage, isNull);
  });
}
