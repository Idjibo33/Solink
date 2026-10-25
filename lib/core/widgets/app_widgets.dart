import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:so_link/core/theme/app_theme.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? const AppLoading(size: 18) : Text(label),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(onPressed: onPressed, child: Text(label)),
    );
  }
}

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: const SizedBox.expand(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withValues(alpha: 0.8),
            ),
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.padding = 12, this.size = 32});

  final double padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.tealAccent,
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Icon(Icons.link_rounded, size: size, color: Colors.white),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon,
    this.lines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? icon;
  final int lines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(label, style: AppTextStyles.title.copyWith(fontSize: 14)),
        TextFormField(
          controller: controller,
          minLines: lines,
          maxLines: lines,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: icon == null ? null : Icon(icon, color: Colors.black38),
            suffixIcon: suffixIcon,
            hintText: hint,
          ),
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.controller,
    this.label = 'Mot de passe',
    this.hint = '******',
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      icon: Icons.lock,
      obscureText: _hidden,
      validator: widget.validator,
      suffixIcon: IconButton(
        onPressed: () => setState(() => _hidden = !_hidden),
        icon: Icon(_hidden ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}

class SimpleTextField extends StatelessWidget {
  const SimpleTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.minLines = 1,
    this.maxLines = 3,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: TextInputAction.send,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(hintText: hint),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.username, this.size = 24});

  final String username;
  final double size;

  String get _initial {
    final trimmed = username.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.15),
      radius: size,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.all(size / 4),
          child: Text(_initial, style: AppTextStyles.title),
        ),
      ),
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Icon(icon, size: 48, color: Colors.black26),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Icon(
              Icons.cloud_off,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            Text(
              message,
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Réessayer')),
          ],
        ),
      ),
    );
  }
}
