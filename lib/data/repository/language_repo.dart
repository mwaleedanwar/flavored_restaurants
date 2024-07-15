import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/language_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';

class LanguageRepo {
  List<LanguageModel> get getAllLanguages => AppConstants.languages;
}
