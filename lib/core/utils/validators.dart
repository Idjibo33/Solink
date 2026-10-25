abstract final class Validators {
  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static bool isValidEmail(String value) =>
      _emailPattern.hasMatch(value.trim());

  static bool isValidPassword(String value) => value.trim().length >= 6;

  static String? requiredField(String? value, {String label = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$label est obligatoire.';
    }
    return null;
  }

  static String? email(String? value) {
    final required = requiredField(value, label: "L'e-mail");
    if (required != null) {
      return required;
    }
    return isValidEmail(value!) ? null : 'Adresse e-mail invalide.';
  }

  static String? password(String? value) {
    final required = requiredField(value, label: 'Le mot de passe');
    if (required != null) {
      return required;
    }
    return isValidPassword(value!)
        ? null
        : 'Le mot de passe doit contenir au moins 6 caractères.';
  }
}
