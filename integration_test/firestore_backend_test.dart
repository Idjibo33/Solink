import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:so_link/core/di/emulator_recaptcha.dart';
import 'package:so_link/core/di/firebase_bootstrap.dart';
import 'package:so_link/features/auth/data/firestore/firestore_user_store.dart';
import 'package:so_link/features/auth/data/gateways/firebase_auth_gateway.dart';
import 'package:so_link/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:so_link/features/posts/data/firestore/firestore_post_store.dart';

/// Test d'integration contre l'emulateur Firebase local.
///
/// Verifie que la chaine complete fonctionne apres la refactorisation :
/// SDK Firebase -> adaptateur (`data/firestore`) -> repository (`data/`).
///
/// Necessite l'emulateur demarre :
///   cd tool && npm run emulators
///
/// Les variables d'environnement `FIREBASE_EMULATOR_HOST` et
/// `FIRESTORE_EMULATOR_HOST` pointent vers l'emulateur ; elles sont definies
/// automatiquement par `flutter test integration_test` via le fichier de
/// configuration Firebase CLI, ou manuellement pour un runner local.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Sur Android, le SDK redirige `127.0.0.1` vers `10.0.2.2`, alias de
  // l'hote uniquement disponible depuis un emulateur AVD. Sur un appareil
  // physique, il faut indiquer l'IP de la machine hote :
  //   flutter test integration_test/firestore_backend_test.dart \
  //     -d <device> --dart-define=EMULATOR_HOST=192.168.1.10
  const emulatorHost = String.fromEnvironment(
    'EMULATOR_HOST',
    defaultValue: '127.0.0.1',
  );

  late FirebaseFirestore firestore;

  setUpAll(() async {
    await initializeFirebaseApp(
      options: const FirebaseOptions(
        apiKey: 'fake-api-key',
        appId: '1:000000000000:android:0000000000000000',
        messagingSenderId: '000000000000',
        projectId: 'demo-solink',
      ),
    );

    firestore = FirebaseFirestore.instance;
    firestore.useFirestoreEmulator(emulatorHost, 8080);
    FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);

    // L'emulateur n'exige aucune preuve reCAPTCHA ; sans ce verificateur le
    // SDK Android tente de joindre le service Google et echoue.
    RecaptchaVerifierFactoryPlatform.instance =
        EmulatorRecaptchaVerifierFactory();
  });

  testWidgets('connexion puis lecture du profil et du feed', (tester) async {
    final email = 'integration-${DateTime.now().millisecondsSinceEpoch}@solink.test';

    // 1. Inscription via l'adaptateur d'authentification.
    final gateway = FirebaseAuthGateway(FirebaseAuth.instance);
    final authUser = await gateway.signUp(email: email, password: 'secret123');

    expect(authUser.uid, isNotEmpty);
    expect(authUser.email, email);

    // 2. Creation du profil via l'adaptateur de stockage.
    final userStore = FirestoreUserStore(firestore);
    await userStore.createUserProfile(
      id: authUser.uid,
      nom: 'Djibo',
      prenom: 'Ismael',
      email: email,
    );

    // 3. Lecture du profil : la bio est vide, le statut est « needsProfile ».
    final repository = AuthRepositoryImpl(
      authGateway: gateway,
      userStore: userStore,
    );

    final user = await repository.getUser(authUser.uid);
    expect(user.isRight(), isTrue);
    user.fold(
      (failure) => fail('Lecture du profil impossible : $failure'),
      (profile) {
        expect(profile.id, authUser.uid);
        expect(profile.nom, 'Djibo');
        expect(profile.prenom, 'Ismael');
        expect(profile.bio, isEmpty);
        expect(profile.hasCompletedProfile, isFalse);
      },
    );

    // 4. Mise a jour de la bio seule (update partiel).
    await userStore.updateBio(
      userId: authUser.uid,
      bio: 'Developpeur Flutter',
    );

    final updated = await repository.getUser(authUser.uid);
    updated.fold(
      (failure) => fail('Relecture du profil impossible : $failure'),
      (profile) {
        expect(profile.bio, 'Developpeur Flutter');
        expect(profile.hasCompletedProfile, isTrue);
      },
    );

    final author = await userStore.getUser(authUser.uid);
    expect(author, isNotNull);

    // 5. Ecriture et relecture d'un post via l'adaptateur de stockage.
    final postStore = FirestorePostStore(firestore);
    await postStore.createPost(
      author: author!,
      content: 'Post de test d integration',
    );

    final feed = await postStore.watchFeed().first;
    expect(feed, isNotEmpty);
    expect(feed.first.content, 'Post de test d integration');
    expect(feed.first.creeLe, isA<DateTime>());

    // 6. Nettoyage.
    // Les regles interdisent la suppression de `users` et la suppression d'un
    // post modifie le compteur du profil. L'emulateur est jetable : on laisse
    // les traces, ce qui evite de dependre de droits administrateur.
  });
}
