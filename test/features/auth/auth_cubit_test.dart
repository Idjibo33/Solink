import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_state.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = AuthCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test('start émet unauthenticated quand aucun utilisateur', () async {
    cubit.start();
    repository.authStateController.add(null);
    await settle();

    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.user, isNull);
  });

  test('start émet needsProfile quand la bio est vide', () async {
    cubit.start();
    repository.authStateController.add(userTest(bio: ''));
    await settle();

    expect(cubit.state.status, AuthStatus.needsProfile);
  });

  test('start émet authenticated quand le profil est complet', () async {
    cubit.start();
    repository.authStateController.add(userTest());
    await settle();

    expect(cubit.state.status, AuthStatus.authenticated);
  });

  test('signIn succès met à jour l’état authentifié', () async {
    repository.signInResult = Right(userTest());
    await cubit.signIn(email: 'test@mail.com', password: 'secret123');

    expect(repository.signInCalls, 1);
    expect(cubit.state.status, AuthStatus.authenticated);
    expect(cubit.state.isLoading, isFalse);
  });

  test('signIn invalide ne touche pas le repository', () async {
    await cubit.signIn(email: 'invalide', password: '123');

    expect(repository.signInCalls, 0);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('signIn échec expose le message', () async {
    repository.signInResult = Left<Failure, UserModel>(
      const AuthFailure('Identifiants incorrects.'),
    );
    await cubit.signIn(email: 'test@mail.com', password: 'secret123');

    expect(cubit.state.errorMessage, 'Identifiants incorrects.');
    expect(cubit.state.isLoading, isFalse);
  });

  test('signUp place l’utilisateur en onboarding', () async {
    repository.signUpResult = Right(userTest(bio: ''));
    await cubit.signUp(
      nom: 'Djibo',
      prenom: 'Ismaël',
      email: 'test@mail.com',
      password: 'secret123',
    );

    expect(repository.signUpCalls, 1);
    expect(cubit.state.status, AuthStatus.needsProfile);
  });

  test('completeProfile valide et authentifie', () async {
    cubit.start();
    repository.authStateController.add(userTest(bio: ''));
    await settle();

    await cubit.completeProfile(bio: 'Nouvelle bio');
    expect(repository.lastBio, 'Nouvelle bio');
    expect(cubit.state.status, AuthStatus.authenticated);
  });

  test('completeProfile refuse une bio vide', () async {
    cubit.start();
    repository.authStateController.add(userTest(bio: ''));
    await settle();

    await cubit.completeProfile(bio: '   ');
    expect(repository.completeProfileCalls, 0);
    expect(cubit.state.errorMessage, isNotNull);
  });

  test('signOut réinitialise la session', () async {
    cubit.start();
    repository.authStateController.add(userTest());
    await settle();

    await cubit.signOut();
    expect(repository.signOutCalls, 1);
    expect(cubit.state.status, AuthStatus.unauthenticated);
    expect(cubit.state.user, isNull);
  });
}
