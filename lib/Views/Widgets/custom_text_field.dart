import 'package:flutter/material.dart';
import 'package:so_link/Models/textfield.dart';
import 'package:so_link/Models/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextfieldModel values;
  const CustomTextField({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(values.labelTexte, style: textfieldLabel),
          TextField(
            controller: values.texteController,
            minLines: values.lines,
            maxLines: values.lines,
            decoration: InputDecoration(
              prefixIcon: Icon(values.icone, color: Colors.black38),
              hintText: values.hintTexte,
              hintStyle: hintTextStyle,
              filled: true,
              fillColor: couleureSecondaire,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
