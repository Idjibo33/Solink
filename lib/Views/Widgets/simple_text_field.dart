import 'package:flutter/material.dart';
import 'package:so_link/Models/constants.dart';

class SimpleTextField extends StatelessWidget {
  final String _hint;
  final TextEditingController _controller;
  const SimpleTextField({
    super.key,
    required String hint,
    required TextEditingController controller,
  }) : _hint = hint,
       _controller = controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      minLines: 1,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: _hint,
        hintStyle: hintTextStyle,
        filled: true,
        fillColor: couleureSecondaire,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
