import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';
import 'test_app.dart';

void defineAuthFlowScenarios() {
  const loginScreen = ValueKey('login_screen');
  const loginEmailField = ValueKey('login_email_field');
  const loginPasswordField = ValueKey('login_password_field');
  const loginSubmitButton = ValueKey('login_submit_button');
  const loginRegisterButton = ValueKey('login_register_button');
  const registerScreen = ValueKey('register_screen');
  const registerNomField = ValueKey('register_nom_field');
  const registerPrenomField = ValueKey('register_prenom_field');
  const registerEmailField = ValueKey('register_email_field');
  const registerPasswordField = ValueKey('register_password_field');
  const registerSubmitButton = ValueKey('register_submit_button');
  const onboardingScreen = ValueKey('onboarding_screen');
  const onboardingBioField = ValueKey('onboarding_bio_field');
  const onboardingSubmitButton = ValueKey('onboarding_submit_button');
  const feedScreen = ValueKey('feed_screen');

  late FakeAuthRepository authRepository;
  late FakePostRepository postRepository;
  late IntegrationTestApp app;

  setUp(() {
    authRepository = FakeAuthRepository();
    postRepository = FakePostRepository();
    app = IntegrationTestApp(
      authRepository: authRepository,
      postRepository: postRepository,
    );
  });

  tearDown(() async {
    await authRepository.close();
    await postRepository.close();
  });

  Future<void> pumpUntil(WidgetTester tester, Finder finder) async {
    for (var attempt = 0; attempt < 30; attempt++) {
      if (finder.evaluate().isNotEmpty) {
        return;
      }
      await tester.pump(const Duration(milliseconds: 50));
    }
    fail('Widget introuvable : $finder');
  }

  Future<void> startApp(WidgetTester tester) async {
    await tester.pumpWidget(app);
    authRepository.authStateController.add(null);
    await pumpUntil(tester, find.byKey(loginScreen));
  }

  Future<void> hideKeyboard(WidgetTester tester) async {
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('affiche la connexion au démarrage', (tester) async {
    await startApp(tester);

    expect(find.byKey(loginScreen), findsOneWidget);
    expect(find.text('Bienvenue sur SoLink'), findsOneWidget);
    expect(find.byKey(loginEmailField), findsOneWidget);
    expect(find.byKey(loginPasswordField), findsOneWidget);
    expect(find.byKey(loginSubmitButton), findsOneWidget);
    expect(find.byKey(loginRegisterButton), findsOneWidget);
  });

  testWidgets('affiche les erreurs de validation du formulaire', (
    tester,
  ) async {
    await startApp(tester);

    await tester.tap(find.byKey(loginSubmitButton));
    await tester.pump();

    expect(find.text("L'e-mail est obligatoire."), findsOneWidget);
    expect(find.text('Le mot de passe est obligatoire.'), findsOneWidget);
    expect(authRepository.signInCalls, 0);

    await tester.enterText(find.byKey(loginEmailField), 'pas-un-email');
    await tester.enterText(find.byKey(loginPasswordField), '123');
    await tester.tap(find.byKey(loginSubmitButton));
    await tester.pump();

    expect(find.text('Adresse e-mail invalide.'), findsOneWidget);
    expect(
      find.text('Le mot de passe doit contenir au moins 6 caractères.'),
      findsOneWidget,
    );
    expect(authRepository.signInCalls, 0);
  });

  testWidgets('navigue de la connexion vers l’inscription', (tester) async {
    await startApp(tester);

    await tester.tap(find.byKey(loginRegisterButton));
    await pumpUntil(tester, find.byKey(registerScreen));

    expect(find.text('Créer un compte'), findsOneWidget);
    expect(find.byKey(registerNomField), findsOneWidget);
    expect(find.byKey(registerPrenomField), findsOneWidget);
    expect(find.byKey(registerEmailField), findsOneWidget);
    expect(find.byKey(registerPasswordField), findsOneWidget);
    expect(find.byKey(registerSubmitButton), findsOneWidget);
  });

  testWidgets('inscription, onboarding puis arrivée sur le feed', (
    tester,
  ) async {
    await startApp(tester);

    await tester.tap(find.byKey(loginRegisterButton));
    await pumpUntil(tester, find.byKey(registerScreen));

    await tester.enterText(find.byKey(registerNomField), 'Djibo');
    await tester.enterText(find.byKey(registerPrenomField), 'Ismaël');
    await tester.enterText(
      find.byKey(registerEmailField),
      'ismael@example.com',
    );
    await tester.enterText(find.byKey(registerPasswordField), 'secret123');
    await hideKeyboard(tester);
    await tester.ensureVisible(find.byKey(registerSubmitButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(registerSubmitButton));
    await pumpUntil(tester, find.byKey(onboardingScreen));

    expect(find.text('Parlez-nous de vous'), findsOneWidget);
    expect(authRepository.signUpCalls, 1);

    await tester.enterText(
      find.byKey(onboardingBioField),
      'Développeur Flutter',
    );
    await hideKeyboard(tester);
    await tester.ensureVisible(find.byKey(onboardingSubmitButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(onboardingSubmitButton));
    await pumpUntil(tester, find.byKey(feedScreen));

    expect(authRepository.completeProfileCalls, 1);
    expect(authRepository.lastBio, 'Développeur Flutter');

    await tester.pump();
    postRepository.feedController.add(const []);
    await tester.pump();
    await tester.pump();

    expect(find.text('Aucun post pour le moment.'), findsOneWidget);
  });

  testWidgets('connexion réussie puis arrivée sur le feed', (tester) async {
    await startApp(tester);

    await tester.enterText(find.byKey(loginEmailField), 'ismael@example.com');
    await tester.enterText(find.byKey(loginPasswordField), 'secret123');
    await tester.tap(find.byKey(loginSubmitButton));
    await pumpUntil(tester, find.byKey(feedScreen));

    expect(authRepository.signInCalls, 1);

    await tester.pump();
    postRepository.feedController.add(const []);
    await tester.pump();
    await tester.pump();

    expect(find.text('Aucun post pour le moment.'), findsOneWidget);
  });
}
