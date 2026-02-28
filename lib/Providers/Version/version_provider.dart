import 'package:flutter/foundation.dart';

class VersionProvider extends ChangeNotifier {
  int currentVersion = 2;
  void changerVersion(int nouvelleVersion) {
    currentVersion = nouvelleVersion;
    notifyListeners();
  }
}
