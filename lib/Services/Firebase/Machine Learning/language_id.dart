import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class LanguageId {
  final LanguageIdentifier _languageIdentifier = LanguageIdentifier(
    confidenceThreshold: 0.5,
  );
  //Identifier un texte
  Future<String> processText(String texte) async {
    try {
      final reponse = await _languageIdentifier.identifyLanguage(texte);

      return reponse;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
