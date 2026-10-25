import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/core/utils/validators.dart';

void main() {
  test('valide les e-mails', () {
    expect(Validators.isValidEmail('test@mail.com'), isTrue);
    expect(Validators.isValidEmail('test@mail'), isFalse);
    expect(Validators.isValidEmail(''), isFalse);
  });

  test('valide les mots de passe', () {
    expect(Validators.isValidPassword('secret123'), isTrue);
    expect(Validators.isValidPassword('123'), isFalse);
  });

  test('retourne des messages de validation', () {
    expect(Validators.email(null), isNotNull);
    expect(Validators.password(''), isNotNull);
    expect(Validators.requiredField('   '), isNotNull);
    expect(Validators.requiredField('ok'), isNull);
  });
}
