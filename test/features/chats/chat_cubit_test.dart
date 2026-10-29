import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/chats/presentation/cubit/chat_cubit.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeChatRepository chatRepository;
  late FakeAuthRepository authRepository;
  late ChatCubit cubit;

  setUp(() {
    chatRepository = FakeChatRepository();
    authRepository = FakeAuthRepository();
    cubit = ChatCubit(
      chatRepository: chatRepository,
      authRepository: authRepository,
    );
  });

  tearDown(() async {
    await cubit.close();
    await chatRepository.close();
    await authRepository.close();
  });

  test('open charge le destinataire et les messages', () async {
    await cubit.open(
      currentUser: userTest(),
      receiverId: 'user-2',
      initialReceiver: userTest(id: 'user-2'),
    );
    await settle();

    chatRepository.messagesController.add([messageTest()]);
    await settle();

    expect(cubit.state.status, ChatStatus.loaded);
    expect(cubit.state.receiver?.id, 'user-2');
    expect(cubit.state.messages, hasLength(1));
  });

  test('open récupère le destinataire sans extra', () async {
    authRepository.getUserResult = Right(userTest(id: 'user-2'));

    await cubit.open(currentUser: userTest(), receiverId: 'user-2');
    await settle();

    expect(cubit.state.receiver?.id, 'user-2');
  });

  test('send envoie un message', () async {
    await cubit.open(
      currentUser: userTest(),
      receiverId: 'user-2',
      initialReceiver: userTest(id: 'user-2'),
    );
    await settle();

    await cubit.send(currentUser: userTest(), content: 'Bonjour');

    expect(chatRepository.sendCalls, 1);
    expect(chatRepository.lastContent, 'Bonjour');
    expect(cubit.state.isSending, isFalse);
  });

  test('send refuse un message vide', () async {
    await cubit.open(
      currentUser: userTest(),
      receiverId: 'user-2',
      initialReceiver: userTest(id: 'user-2'),
    );
    await settle();

    await cubit.send(currentUser: userTest(), content: '  ');

    expect(chatRepository.sendCalls, 0);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('send échoue proprement', () async {
    chatRepository.sendResult = const Left<Failure, void>(
      StorageFailure('Envoi refusé'),
    );
    await cubit.open(
      currentUser: userTest(),
      receiverId: 'user-2',
      initialReceiver: userTest(id: 'user-2'),
    );
    await settle();

    await cubit.send(currentUser: userTest(), content: 'Bonjour');

    expect(cubit.state.isSending, isFalse);
    expect(cubit.state.errorMessage, 'Envoi refusé');
  });
}
