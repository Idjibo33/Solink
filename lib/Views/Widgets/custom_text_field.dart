import 'package:flutter/material.dart';
import 'package:so_link/constants.dart';

class CustomTextField extends StatelessWidget {
  final IconData icone;
  final String labelTexte;
  final String hintTexte;
  const CustomTextField({
    super.key,
    required this.hintTexte,
    required this.labelTexte,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelTexte, style: textfieldLabel),
          TextField(
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
