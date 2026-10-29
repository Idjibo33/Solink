import 'package:flutter_test/flutter_test.dart';

import '../fixtures/mock_data.dart';

void main() {
  test('les identifiants des utilisateurs sont uniques', () {
    final ids = mockUsers.map((user) => user.id).toList();

    expect(ids.toSet(), hasLength(ids.length));
  });

  test('les identifiants des posts sont uniques', () {
    final ids = mockPosts.map((post) => post.id).toList();

    expect(ids.toSet(), hasLength(ids.length));
  });

  test('chaque post référence un utilisateur existant', () {
    final userIds = mockUsers.map((user) => user.id).toSet();

    for (final post in mockPosts) {
      expect(userIds, contains(post.userId), reason: post.id);
    }
  });

  test('les likes et le nombre de commentaires des posts sont cohérents', () {
    final userIds = mockUsers.map((user) => user.id).toSet();

    for (final post in mockPosts) {
      expect(post.comments, isNonNegative, reason: post.id);
      for (final like in post.likes) {
        expect(userIds, contains(like), reason: post.id);
      }
    }
  });

  test('chaque message référence un expéditeur existant', () {
    final userIds = mockUsers.map((user) => user.id).toSet();

    for (final message in mockMessages) {
      expect(userIds, contains(message.senderId), reason: message.id);
    }
  });

  test('les messages sont triés chronologiquement', () {
    final dates = mockMessages.map((message) => message.envoyeLe).toList();

    for (var i = 1; i < dates.length; i++) {
      expect(dates[i].compareTo(dates[i - 1]), isNonNegative);
    }
  });
}
