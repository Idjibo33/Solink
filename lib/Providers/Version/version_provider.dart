import 'package:flutter/foundation.dart';

class VersionProvider extends ChangeNotifier {
  int currentVersion = 1;
  void changerVersion(int nouvelleVersion) {
    currentVersion = nouvelleVersion;
    notifyListeners();
  }
}
