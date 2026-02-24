# so_link

Une application de réseau social minimaliste pour explorer les interactions en temps réel avec Flutter et Firebase.
Elle permet aux utilisateurs de partager des postes et d'intéragir à travers des likes et des commentaire

L'objectif est l'apprentissage des opérations CRUD avec firebase en utilisant flutter, la gestion des flux de données et UI moderne.

## Fonctionnalités
- **Authentification :** Inscription et connexion avec Email/Mot de passe et on boarding.
- **Feed :** Affichage des publications en temps réel.
- **Interactions :** Système de likes et commentaires.
- **Profil :** Affichage des informations utilisateur.
## Quick overview

## Structure du Projet

- **lib/**
  - Models/         Constantes,Navigators ,thèmes,Modèles de données ***(PostModel,Chat,Commentaire,TextfieldModel,UtilisateurModel)***
  - Providers/      Provider
  - Services/       Logique Firebase (Auth, Firestore)
  - Views/          Écrans et composants UI
  - main.dart       Point d'entrée


## Custom widgets
- ## CustomTextField ['CustomTextField: '](lib/Views/Widgets/custom_text_field.dart)
- ## PasswordTextField ['PasswordTextField: '](lib/Views/Widgets/password_text_field.dart)
- ## Like bouton ['Like bouton: '](lib/Views/Widgets/custom_text_field.dart)
- ## Bouton principale ['Bouton principale: '](lib/Views/Widgets/bouton_principale.dart)
- ## Chat bubble ['Chat bubble: '](lib/Views/Widgets/chat_bubble.dart)
- ## Custom Container ['Custom Container: '](lib/Views/Widgets/bouton_secondaire.dart)
- ## Logo['Logo: '](lib/Views/Widgets/logo_widget.dart)
....

## Aperću 
<img src="assets/screenshots/connexion.png" width="250"> | <img src="assets/screenshots/inscription.png" width="250"> | <img src="assets/screenshots/on boarding.png" width="250"> | <img src="assets/screenshots/feed.png" width="250"> | <img src="assets/screenshots/discussions.png" width="250"> | <img src="assets/screenshots/chat.png" width="250"> | <img src="assets/screenshots/chat1.png" width="250"> | <img src="assets/screenshots/chat2.png" width="250"> | <img src="assets/screenshots/profil.png" width="250"> | <img src="assets/screenshots/profil1.png" width="250">