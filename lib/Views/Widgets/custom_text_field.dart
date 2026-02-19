import 'package:flutter/material.dart';
import 'package:so_link/constants.dart';

class CustomTextField extends StatelessWidget {
  final bool cacherContenu;
  final IconData icone;
  final String labelTexte;
  final String hintTexte;
  const CustomTextField({
    super.key,

    required this.labelTexte,
    required this.hintTexte,
    required this.icone,
    required this.cacherContenu,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelTexte, style: textfieldLabel),
          TextField(
            obscureText: cacherContenu,
            decoration: InputDecoration(
              prefixIcon: Icon(icone, color: Colors.black38),
              hintText: hintTexte,
              hintStyle: hintText,
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
