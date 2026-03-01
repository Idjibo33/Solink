import 'package:firebase_ai/firebase_ai.dart';

class AiServices {
  final FirebaseAI _aiServices = FirebaseAI.googleAI();
  Future<String?> generatePost(String description) async {
    try {
      final model = _aiServices.generativeModel(
        model: "gemini-3-flash-preview",
      );
      final prompt = [
        Content.text(
          "Agis comme un gestionnaire de communauté. "
          "À partir de la description suivante, rédige UN SEUL post pour un réseau social. "
          "Ne donne pas d'options, ne fais pas de commentaires avant ou après. "
          "Inclus des emojis et 3 hashtags pertinents à la fin. "
          "Voici le sujet : $description",
        ),
      ];
      final reponse = await model.generateContent(prompt);
      return reponse.text;
    } on FirebaseAIException catch (e) {
      throw Exception(e);
    }
  }
}
