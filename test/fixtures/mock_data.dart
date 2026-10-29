import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/chats/data/models/chat_message_model.dart';
import 'package:so_link/features/posts/data/models/post_model.dart';

final _baseDate = DateTime(2026, 10, 1, 9);

DateTime _at(int minutes) => _baseDate.add(Duration(minutes: minutes));

final mockUsers = <UserModel>[
  UserModel(
    id: 'user-ismael',
    nom: 'Djibo',
    prenom: 'Ismaël',
    bio: 'Développeur Flutter',
    posts: 3,
    followers: 12,
    followings: 8,
    creeLe: _at(-60 * 24 * 30),
  ),
  UserModel(
    id: 'user-amina',
    nom: 'Diallo',
    prenom: 'Amina',
    bio: 'Designer UI/UX',
    posts: 2,
    followers: 30,
    followings: 15,
    creeLe: _at(-60 * 24 * 20),
  ),
  UserModel(
    id: 'user-lucas',
    nom: 'Martin',
    prenom: 'Lucas',
    bio: '',
    posts: 1,
    followers: 4,
    followings: 6,
    creeLe: _at(-60 * 24 * 5),
  ),
];

final mockPosts = <PostModel>[
  PostModel(
    id: 'post-1',
    userId: 'user-ismael',
    userName: 'Ismaël Djibo',
    content: 'Premier post de test dans Solink !',
    comments: 2,
    likes: const ['user-amina', 'user-lucas'],
    creeLe: _at(0),
  ),
  PostModel(
    id: 'post-2',
    userId: 'user-amina',
    userName: 'Amina Diallo',
    content: 'Une nouvelle maquette est prête, dites-moi ce que vous en pensez.',
    comments: 1,
    likes: const ['user-ismael'],
    creeLe: _at(45),
  ),
  PostModel(
    id: 'post-3',
    userId: 'user-lucas',
    userName: 'Lucas Martin',
    content: 'Bonjour à tous, ravi de rejoindre la communauté.',
    comments: 0,
    likes: const [],
    creeLe: _at(90),
  ),
  PostModel(
    id: 'post-4',
    userId: 'user-ismael',
    userName: 'Ismaël Djibo',
    content: 'Les données mock sont maintenant disponibles pour les tests.',
    comments: 0,
    likes: const ['user-amina'],
    creeLe: _at(120),
  ),
];

final mockMessages = <ChatMessageModel>[
  ChatMessageModel(
    id: 'message-1',
    senderId: 'user-ismael',
    content: 'Salut Amina, tu as vu la nouvelle maquette ?',
    envoyeLe: _at(200),
  ),
  ChatMessageModel(
    id: 'message-2',
    senderId: 'user-amina',
    content: 'Oui, je l’ai reçue hier. Je te fais un retour demain.',
    envoyeLe: _at(205),
  ),
  ChatMessageModel(
    id: 'message-3',
    senderId: 'user-ismael',
    content: 'Parfait, merci !',
    envoyeLe: _at(210),
  ),
];
