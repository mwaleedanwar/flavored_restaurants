import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/onboarding_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/onboarding_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider with ChangeNotifier {
  final OnBoardingRepo onboardingRepo;
  final SharedPreferences sharedPreferences;

  OnBoardingProvider({@required this.onboardingRepo, @required this.sharedPreferences}) {
    _loadShowOnBoardingStatus();
  }

  List<OnBoardingModel> _onBoardingList = [];
  bool _showOnBoardingStatus = false;
  bool get showOnBoardingStatus => _showOnBoardingStatus;
  List<OnBoardingModel> get onBoardingList => _onBoardingList;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  changeSelectIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void _loadShowOnBoardingStatus() async {
    _showOnBoardingStatus = sharedPreferences.getBool(AppConstants.ON_BOARDING_SKIP) ?? true;
  }

  void toggleShowOnBoardingStatus() {
    sharedPreferences.setBool(AppConstants.ON_BOARDING_SKIP, false);
  }

  void initBoardingList(BuildContext context) async {
    var _list = await onboardingRepo.getOnBoardingList(context);
    if (_list.isNotEmpty) {
      _onBoardingList.clear();
      _onBoardingList.addAll(_list);
      notifyListeners();
    } else {
      print('error');
    }
  }
}
