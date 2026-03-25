import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class LanguageTranslation {
  Future<String> translateFrToEn(String texte) async {
    final TranslateLanguage sourceLanguage = TranslateLanguage.french;
    final TranslateLanguage targetLanguage = TranslateLanguage.english;

    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
    final String reponse = await onDeviceTranslator.translateText(texte);
    onDeviceTranslator.close;
    return reponse;
  }

  Future<String> translateEnToFr(String texte) async {
    final TranslateLanguage sourceLanguage = TranslateLanguage.english;
    final TranslateLanguage targetLanguage = TranslateLanguage.french;

    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
    final String reponse = await onDeviceTranslator.translateText(texte);
    onDeviceTranslator.close;
    return reponse;
  }
}
