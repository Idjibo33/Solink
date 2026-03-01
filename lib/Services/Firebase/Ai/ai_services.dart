import 'package:firebase_ai/firebase_ai.dart';

class AiServices {
  final FirebaseAI _aiServices = FirebaseAI.googleAI();
  Future<String> generatePost(String description) async {
    final model = _aiServices.generativeModel(model: "gemini-3-flash-preview");
    final prompt = [Content.text(description)];
    final reponse = await model.generateContent(prompt);
    return reponse.toString();
  }
}
