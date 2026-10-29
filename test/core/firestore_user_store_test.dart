import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

void main() {
  test('le profil Firestore est converti avec sa bio', () {
    final data = <String, dynamic>{
      'id': 'abc',
      'nom': 'Koffi',
      'prenom': 'Awa',
      'bio': 'Cafe, marche et debat.',
      'posts': 4,
      'followers': 20,
      'followings': 1,
      'creeLe': Timestamp.fromDate(DateTime.utc(2026, 10, 29)),
    };

    final model = UserModel.fromJson({
      ...data,
      'id': 'abc',
      'creeLe': (data['creeLe'] as Timestamp).toDate(),
    });

    expect(model.bio, 'Cafe, marche et debat.');
    expect(model.hasCompletedProfile, isTrue);
    expect(model.displayName, 'Awa Koffi');
  });
}
