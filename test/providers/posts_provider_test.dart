import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:so_link/Models/helpers/get_it.dart';
import 'package:so_link/Providers/Posts/posts_provider.dart';
import 'package:so_link/Services/Firebase/Firestore/post_collection.dart';

import '../fixtures/fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePostCollection collection;

  setUp(() async {
    collection = FakePostCollection();
    await enregistrerFakesGetIt(posts: collection);
  });

  test('erreur addComment : chargement retombé et message', () async {
    collection.erreurAddComment = Exception('réseau indisponible');
    final provider = PostsProvider();
    await provider.addComment(
      context: _ContexteFactice(),
      commentaire: commentaireTest(),
      docId: 'post-1',
      userId: 'user-1',
    );
    expect(provider.chargement, isFalse);
    expect(provider.message, isNotEmpty);
  });

  test('erreur addLike : attrapée sans crash et message', () async {
    collection.erreurAddLike = Exception('écriture refusée');
    final provider = PostsProvider();
    await provider.addLike(docId: 'post-1', userId: 'user-1');
    expect(provider.message, isNotEmpty);
  });

  test('contenu vide : aucun appel au service', () async {
    final provider = PostsProvider();
    await provider.ajouterPost(newpost: postTest(content: ''), userId: 'u');
    expect(collection.appelsCreerPost, 0);
    expect(provider.chargement, isFalse);
  });

  test('lecture des posts : expose le stream du service', () async {
    final provider = PostsProvider();
    expect(getIt<PostCollection>().readPosts(), isNotNull);
    expect(provider.posts, isNotNull);
  });
}

class _ContexteFactice implements BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
