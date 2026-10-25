import 'package:firebase_ai/firebase_ai.dart';

class AiService {
  AiService(this._ai);

  final FirebaseAI _ai;

  Future<String> generatePost(String description) async {
    final model = _ai.generativeModel(model: 'gemini-2.5-flash');
    final response = await model.generateContent([
      Content.text(
        'Agis comme un gestionnaire de communauté. '
        'À partir de la description suivante, rédige UN SEUL post pour un '
        'réseau social. Ne donne pas d\'options, ne fais pas de commentaires '
        'avant ou après. Inclus des emojis et 3 hashtags pertinents à la fin. '
        'Voici le sujet : $description',
      ),
    ]);
    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw StateError("L'IA n'a renvoyé aucun texte.");
    }
    return text.trim();
  }
}
