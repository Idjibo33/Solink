import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

/// Verificateur reCAPTCHA factice.
///
/// L'emulateur Firebase Auth n'exige aucune preuve anti-robot. Or le SDK
/// Android tente de joindre le service reCAPTCHA de Google avant chaque
/// connexion, ce qui echoue en environnement de developpement et bloque la
/// connexion avant meme que la requete n'atteigne l'emulateur.
///
/// Ce verificateur renvoie un jeton vide : l'emulateur l'accepte, et aucune
/// requete reseau supplementaire n'est effectuee.
///
/// Il ne doit etre installe que lorsque `USE_FIREBASE_EMULATORS` est actif.
class EmulatorRecaptchaVerifierFactory extends RecaptchaVerifierFactoryPlatform {
  @override
  RecaptchaVerifierFactoryPlatform delegateFor({
    required FirebaseAuthPlatform auth,
    String? container,
    RecaptchaVerifierSize size = RecaptchaVerifierSize.normal,
    RecaptchaVerifierTheme theme = RecaptchaVerifierTheme.light,
    RecaptchaVerifierOnSuccess? onSuccess,
    RecaptchaVerifierOnError? onError,
    RecaptchaVerifierOnExpired? onExpired,
  }) {
    return this;
  }

  @override
  String get type => 'recaptcha';

  @override
  Future<int> render() async => 0;

  @override
  Future<String> verify() async => '';

  @override
  void clear() {}
}
