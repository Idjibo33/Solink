import 'package:flutter/foundation.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  Future<String> translate(String text) async {
    if (kIsWeb) {
      return text;
    }

    final identifier = LanguageIdentifier(confidenceThreshold: 0.5);
    String languageCode;
    try {
      languageCode = await identifier.identifyLanguage(text);
    } finally {
      identifier.close();
    }

    final TranslateLanguage sourceLanguage;
    if (languageCode == TranslateLanguage.french.bcpCode) {
      sourceLanguage = TranslateLanguage.french;
    } else if (languageCode == TranslateLanguage.english.bcpCode) {
      sourceLanguage = TranslateLanguage.english;
    } else {
      throw const FormatException(
        'Seuls le français et l\'anglais sont pris en charge.',
      );
    }

    final targetLanguage = sourceLanguage == TranslateLanguage.french
        ? TranslateLanguage.english
        : TranslateLanguage.french;

    final modelManager = OnDeviceTranslatorModelManager();
    final isDownloaded = await modelManager.isModelDownloaded(
      targetLanguage.bcpCode,
    );
    if (!isDownloaded) {
      await modelManager.downloadModel(targetLanguage.bcpCode);
    }

    final translator = OnDeviceTranslator(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
    try {
      return await translator.translateText(text);
    } finally {
      translator.close();
    }
  }
}
