import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/posts/presentation/cubit/post_composer_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAiRepository aiRepository;
  late FakePostRepository postRepository;
  late PostComposerCubit cubit;

  setUp(() {
    aiRepository = FakeAiRepository();
    postRepository = FakePostRepository();
    cubit = PostComposerCubit(
      aiRepository: aiRepository,
      postRepository: postRepository,
    );
  });

  tearDown(() async {
    await cubit.close();
    await postRepository.close();
  });

  test('generate expose le texte généré', () async {
    await cubit.generate('Un sujet');

    expect(cubit.state.isGenerating, isFalse);
    expect(cubit.state.generatedText, 'Post généré');
  });

  test('generate échoue proprement', () async {
    aiRepository.result = const Left<Failure, String>(
      AiFailure('Quota dépassé'),
    );

    await cubit.generate('Un sujet');

    expect(cubit.state.isGenerating, isFalse);
    expect(cubit.state.errorMessage, 'Quota dépassé');
  });

  test('publish crée le post et signale le succès', () async {
    await cubit.publish(author: userTest(), content: 'Mon post');

    expect(postRepository.createCalls, 1);
    expect(postRepository.lastContent, 'Mon post');
    expect(cubit.state.published, isTrue);
  });

  test('publish refuse un contenu vide', () async {
    await cubit.publish(author: userTest(), content: '   ');

    expect(postRepository.createCalls, 0);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('publish échoue proprement', () async {
    postRepository.createResult = const Left<Failure, void>(
      StorageFailure('Écriture refusée'),
    );

    await cubit.publish(author: userTest(), content: 'Mon post');

    expect(cubit.state.published, isFalse);
    expect(cubit.state.errorMessage, 'Écriture refusée');
  });

  test('consumePublished remet le drapeau à false', () async {
    await cubit.publish(author: userTest(), content: 'Mon post');
    cubit.consumePublished();

    expect(cubit.state.published, isFalse);
  });
}
