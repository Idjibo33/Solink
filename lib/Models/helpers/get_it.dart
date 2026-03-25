import 'package:get_it/get_it.dart';
import 'package:so_link/Models/helpers/forms_validation.dart';
import 'package:so_link/Models/helpers/snackbar_services.dart';
import 'package:so_link/Services/Firebase/Ai%20Logic/ai_services.dart';
import 'package:so_link/Services/Firebase/Auth/auth.dart';
import 'package:so_link/Services/Firebase/Firestore/chats_collection.dart';
import 'package:so_link/Services/Firebase/Firestore/utilisateur_collection.dart';
import 'package:so_link/Services/Firebase/Firestore/post_collection.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_id.dart';
import 'package:so_link/Services/Firebase/Machine%20Learning/language_translation.dart';
import 'package:so_link/Services/Firebase/Messaging/messaging.dart';
import 'package:so_link/Services/Firebase/Remote%20config/remote_config.dart';

final getIt = GetIt.instance;
void configureDependencies() {
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<AiServices>(AiServices());
  getIt.registerSingleton<ChatsCollection>(ChatsCollection());
  getIt.registerSingleton<UtilisateurCollection>(UtilisateurCollection());
  getIt.registerSingleton<PostCollection>(PostCollection());
  getIt.registerSingleton<Snackbarservices>(Snackbarservices());
  getIt.registerSingleton<LanguageId>(LanguageId());
  getIt.registerSingleton<LanguageTranslation>(LanguageTranslation());
  getIt.registerSingleton<Messaging>(Messaging());
  getIt.registerSingleton<RemoteConfigServices>(RemoteConfigServices());
  getIt.registerSingleton<FormsValidation>(FormsValidation());
}
