# so_link

A simple social-style Flutter app (junior dev description). Users can sign up / sign in, create posts, like and comment. Firebase is used for auth and Firestore.

## Quick overview



## Main features
- Email/password auth (providers):
  - [`ConnexionProvider`](lib/Providers/Auth/connexion_provider.dart) — [lib/Providers/Auth/connexion_provider.dart](lib/Providers/Auth/connexion_provider.dart)  
  - [`InscriptionProvider`](lib/Providers/Auth/inscription_provider.dart) — [lib/Providers/Auth/inscription_provider.dart](lib/Providers/Auth/inscription_provider.dart)  
  - [`DeconnexionProvider`](lib/Providers/Auth/deconnexion_provider.dart) — [lib/Providers/Auth/deconnexion_provider.dart](lib/Providers/Auth/deconnexion_provider.dart)  
  - Auth service: [`AuthService`](lib/Services/Firebase/Auth/auth.dart) — [lib/Services/Firebase/Auth/auth.dart](lib/Services/Firebase/Auth/auth.dart)

- Posts & comments:
  - Firestore post service: [`Post`](lib/Services/Firebase/Firestore/post.dart) — [lib/Services/Firebase/Firestore/post.dart](lib/Services/Firebase/Firestore/post.dart)  
  - UI providers: [`PostsProvider`](lib/Providers/Posts/posts_provider.dart) — [lib/Providers/Posts/posts_provider.dart](lib/Providers/Posts/posts_provider.dart)  
  - Models: [`PostModel`](lib/Models/post.dart) — [lib/Models/post.dart](lib/Models/post.dart), [`Commentaire`](lib/Models/commentaire.dart) — [lib/Models/commentaire.dart](lib/Models/commentaire.dart)

- Key UI widgets/screens:
  - Post UI: [`PostWidget`](lib/Views/Widgets/post_widget.dart) — [lib/Views/Widgets/post_widget.dart](lib/Views/Widgets/post_widget.dart)  
  - Comments: [`CommentairesScreen`](lib/Views/Widgets/commentaires_screen.dart) — [lib/Views/Widgets/commentaires_screen.dart](lib/Views/Widgets/commentaires_screen.dart) and [`CommentaireWidget`](lib/Views/Widgets/commentaire_widget.dart) — [lib/Views/Widgets/commentaire_widget.dart](lib/Views/Widgets/commentaire_widget.dart)  
  - New post: [`NewPost1`](lib/Views/Widgets/new_post_1.dart) — [lib/Views/Widgets/new_post_1.dart](lib/Views/Widgets/new_post_1.dart)  
  - Form fields: [`CustomTextField`](lib/Views/Widgets/custom_text_field.dart) — [lib/Views/Widgets/custom_text_field.dart](lib/Views/Widgets/custom_text_field.dart), [`PasswordTextField`](lib/Views/Widgets/password_text_field.dart) — [lib/Views/Widgets/password_text_field.dart](lib/Views/Widgets/password_text_field.dart)

- User model & provider:
  - [`UtilisateurModel`](lib/Models/utilisateur.dart) — [lib/Models/utilisateur.dart](lib/Models/utilisateur.dart)  
  - [`UtililsateurProvider`](lib/Providers/Utilisateur/utililsateur_provider.dart) — [lib/Providers/Utilisateur/utililsateur_provider.dart](lib/Providers/Utilisateur/utililsateur_provider.dart)

## Run locally (basic)
1. Install Flutter SDK and platform tools.
2. Create a `.env` at repo root with the required API keys (used by [lib/firebase_options.dart](lib/firebase_options.dart)).
3. Get packages:
```sh
flutter pub get
```
4. Run on device/desktop:
```sh
flutter run
```
or pick platform:
```sh
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

See project config: [pubspec.yaml](pubspec.yaml)

## Notes / Junior tips
- Firebase options are in [lib/firebase_options.dart](lib/firebase_options.dart). If keys change, update `.env` and regenerate if needed.
- UI is organized under [lib/Views](lib/Views) and reuses small widgets (good to keep components small).
- Providers live in [lib/Providers](lib/Providers) — state is managed with Provider.

## Project structure (selected)
- [lib/main.dart](lib/main.dart) — app bootstrap and provider registration  
- [lib/auth_gate.dart](lib/auth_gate.dart) — decides auth vs feed  
- [lib/Services](lib/Services) — Firebase services  
- [lib/Views](lib/Views) — screens & widgets  
- Platform runners: [windows/](windows/), [linux/](linux/), [macos/](macos/), [android/](android/), [ios/](ios/)


## License
Add a LICENSE file as needed.
