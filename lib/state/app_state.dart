import 'package:flutter/foundation.dart';

import '../models/app_language.dart';
import '../models/leaf_category.dart';

/// Session state for the onboarding choices. Browsing needs no account, so
/// nothing here requires a login — see screen 03.
class AppState extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  LeafCategory? _category;
  bool _termsAccepted = false;

  AppLanguage get language => _language;
  LeafCategory? get category => _category;
  bool get termsAccepted => _termsAccepted;

  /// The category to display with when the user has not chosen one yet.
  LeafCategory get activeCategory => _category ?? LeafCategory.green;

  void setLanguage(AppLanguage value) {
    if (_language == value) return;
    _language = value;
    notifyListeners();
  }

  void setCategory(LeafCategory value) {
    if (_category == value) return;
    _category = value;
    notifyListeners();
  }

  void acceptTerms() {
    if (_termsAccepted) return;
    _termsAccepted = true;
    notifyListeners();
  }
}
