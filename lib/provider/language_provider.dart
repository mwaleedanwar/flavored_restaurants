import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/language_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/language_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';

class LanguageProvider with ChangeNotifier {
  final LanguageRepo languageRepo;

  LanguageProvider({required this.languageRepo});

  int _selectIndex = 0;
  List<LanguageModel> _languages = [];

  int get selectIndex => _selectIndex;

  List<LanguageModel> get languages => _languages;

  void setSelectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages = AppConstants.languages;
    } else {
      _selectIndex = -1;
      _languages = [];
      for (var product in AppConstants.languages) {
        if (product.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(product);
        }
      }
    }
    notifyListeners();
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages = AppConstants.languages;
    }
  }
}
