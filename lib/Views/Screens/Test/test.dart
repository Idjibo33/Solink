import 'package:flutter/material.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_translation.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: "Bonjour");
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: controller),
            FilledButton(
              onPressed: () {
                LanguageTranslation().translateFrToEn(controller.text);
              },
              child: Text("test"),
            ),
          ],
        ),
      ),
    );
  }
}
