import 'package:flutter/material.dart';

class TextfieldModel {
  int? lines;
  IconData? icone;
  String labelTexte;
  String hintTexte;
  TextEditingController texteController;
  TextfieldModel({
    this.lines,
    this.icone,
    required this.hintTexte,
    required this.labelTexte,
    required this.texteController,
  });
}
