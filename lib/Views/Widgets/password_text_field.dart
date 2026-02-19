import 'package:flutter/material.dart';
import 'package:so_link/constants.dart';

class PasswordTextField extends StatefulWidget {
  final IconData icone;
  final String labelTexte;
  final String hintTexte;
  const PasswordTextField({
    super.key,

    required this.labelTexte,
    required this.hintTexte,
    required this.icone,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool cacherPw = true;
  void changerVisibilitePw() {
    setState(() {
      cacherPw = !cacherPw;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelTexte, style: textfieldLabel),
          TextField(
            obscureText: cacherPw,
            decoration: InputDecoration(
              prefixIcon: Icon(widget.icone, color: Colors.black38),
              suffixIcon: IconButton(
                onPressed: () => changerVisibilitePw(),
                icon: Icon(cacherPw ? Icons.visibility : Icons.visibility_off),
              ),
              hintText: widget.hintTexte,
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
