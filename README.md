# Solink

**Réseau social minimaliste en temps réel — Flutter + Firebase**

[Live Demo](https://solink-xi.vercel.app/)

[![Flutter CI](https://github.com/Idjibo33/Solink/actions/workflows/flutter.yml/badge.svg?branch=main)](https://github.com/Idjibo33/Solink/actions/workflows/flutter.yml)

Solink est une application de réseau social conçue pour explorer les interactions en temps réel : les utilisateurs publient des posts, échangent via des likes, des commentaires et une messagerie instantanée. Le projet intègre aussi des fonctionnalités avancées de Firebase : Remote Config, ML Kit (identification et traduction de langue) et génération de texte par IA.

## Fonctionnalités

- **Authentification :** inscription et connexion Email / mot de passe, écran d'onboarding.
- **Feed :** affichage des publications en temps réel (Firestore).
- **Interactions :** likes et commentaires.
- **Messagerie :** discussions et chat.
- **Profil :** informations utilisateur.
- **Pilotage à distance :** écran de maintenance et mise à jour forcée via **Firebase Remote Config**.
- **Identification et traduction de texte :** détection de langue et traduction des posts (**ML Kit**).
- **Génération de texte :** rédaction assistée par **IA** (Firebase AI Logic).

## Aperçu

| Connexion | Inscription | Onboarding | Feed |
|---|---|---|---|
| <img src="assets/screenshots/connexion.png" width="180" alt="Connexion"> | <img src="assets/screenshots/inscription.png" width="180" alt="Inscription"> | <img src="assets/screenshots/on%20boarding.png" width="180" alt="Onboarding"> | <img src="assets/screenshots/feed.png" width="180" alt="Feed"> |

| Discussions | Chat | Profil | Maintenance |
|---|---|---|---|
| <img src="assets/screenshots/discussions.png" width="180" alt="Discussions"> | <img src="assets/screenshots/chat.png" width="180" alt="Chat"> | <img src="assets/screenshots/profil.png" width="180" alt="Profil"> | <img src="assets/screenshots/maintenance.png" width="180" alt="Maintenance"> |

<details>
<summary>Voir plus de captures (chat détaillé, mise à jour forcée, génération IA)</summary>

| | | |
|---|---|---|
| <img src="assets/screenshots/chat1.png" width="180" alt="Chat"> | <img src="assets/screenshots/chat2.png" width="180" alt="Chat"> | <img src="assets/screenshots/profil1.png" width="180" alt="Profil"> |
| <img src="assets/screenshots/maj.png" width="180" alt="Mise à jour forcée"> | <img src="assets/screenshots/ai%20generation1.png" width="180" alt="Génération IA"> | <img src="assets/screenshots/ai%20generation2.png" width="180" alt="Génération IA"> |
| <img src="assets/screenshots/ai%20generation3.png" width="180" alt="Génération IA"> | <img src="assets/screenshots/ai%20generation4.png" width="180" alt="Génération IA"> | |

</details>

## Stack technique

| Domaine | Technologie |
|---|---|
| Framework | Flutter / Dart |
| Backend | Firebase — Auth, Cloud Firestore, Storage, Messaging, Remote Config |
| IA & ML | Firebase AI Logic (`firebase_ai`), ML Kit (language ID, traduction) |
| Gestion d'état | Provider + get_it (injection) |
| UI | `google_fonts`, `lordicon`, `gap` |
| Configuration | Clés injectées au build via `--dart-define` (jamais commitées) |

## Structure du projet

```
lib/
├── main.dart                 # Point d'entrée (Firebase.initializeApp)
├── firebase_options.dart     # Configuration Firebase (clés Android/iOS via --dart-define)
├── auth_gate.dart            # Redirection selon l'état de connexion
├── Models/                   # Modèles (Post, Chat, Commentaire, Utilisateur…),
│                             # constantes, navigateurs, helpers
├── Providers/                # État : Auth, Posts, Chats, Utilisateur, Version,
│                             # Remote config, Machine learning, Ai logic
├── Services/Firebase/        # Accès Firebase : Auth, Firestore, Messaging,
│                             # Remote config, ML Kit, AI Logic
└── Views/
    ├── Screens/              # Écrans : Authentification, Feed, Chats,
    │                         # Commentaires, Maintenance, Update, Profil
    └── Widgets/              # Composants UI réutilisables
```

## Composants réutilisables

- `custom_text_field.dart` / `password_text_field.dart` — champs de formulaire.
- `bouton_like.dart` — bouton de like animé.
- `bouton_principale.dart` / `bouton_secondaire.dart` — boutons.
- `custom_container.dart` — conteneur stylé.
- `chat_bubble.dart` — bulle de conversation.
- `logo_widget.dart` — logo.

## Installation

Prérequis : Flutter stable, un projet Firebase (Auth Email/Mot de passe, Firestore, Remote Config activés).

```bash
flutter pub get

# 1. Créer le fichier .env à la racine à partir du modèle
cp .env.example .env
#    puis renseigner AndroidApiKey et IosApiKey (Firebase > Paramètres du projet)

# 2. Lancer l'application en injectant les clés au build
flutter run --dart-define-from-file=.env

# (optionnel) régénérer la configuration Firebase
dart pub global activate flutterfire_cli && flutterfire configure
```

> - Les clés Android/iOS sont lues avec `String.fromEnvironment` : aucun fichier de secrets
>   n'est embarqué ni listé dans `pubspec.yaml`. Sans `--dart-define`, l'application compile
>   mais Firebase ne peut pas démarrer sur Android/iOS.
> - La clé **web** Firebase reste dans `lib/firebase_options.dart` (identifiant client public par nature) ; la sécurité des données repose sur les **règles Firestore/Storage**, à restreindre avant toute mise en production.

## Règles Firebase

Les règles Firestore et Storage sont versionnées (`firestore.rules`, `storage.rules`) et référencées dans `firebase.json`. Leur déploiement reste manuel via la console Firebase ou `firebase deploy --only firestore:rules,storage`.

## Tests

```bash
flutter analyze
flutter test
```

## Licence

[MIT](LICENSE)
