import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/splash_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/screen_barrel.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:provider/provider.dart';

import 'location_provider.dart';

class BranchProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  List<BranchValue> _branchesValue = [];

  BranchProvider({required this.splashRepo});

  int? _selectedBranchId;
  int? branch;

  int? get selectedBranchId => _selectedBranchId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int _branchTabIndex = 0;
  List<BranchValue>? get branchesList => _branchesValue;

  int get branchTabIndex => _branchTabIndex;

  void updateTabIndex(int index, {bool isUpdate = true}) {
    _branchTabIndex = index;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void updateBranchId(int? value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    branch = value;

    if (isUpdate) {
      notifyListeners();
    }
  }

  int get getBranchId => splashRepo.getBranchId;

  setCurrentId() {
    _selectedBranchId = splashRepo.getBranchId;
    branch = splashRepo.getBranchId == -1 ? null : splashRepo.getBranchId;
  }

  Future<void> setBranch(int id) async {
    branch = id;

    await splashRepo.setBranchId(id);

    notifyListeners();
  }

  Branches? getBranch(context, {int? id}) {
    int branchId = id ?? getBranchId;
    debugPrint('===erro: branch:$branchId');

    Branches? branch;
    final config = Provider.of<SplashProvider>(context, listen: false).configModel;
    if (config?.branches != null && config!.branches!.isNotEmpty) {
      try {
        branch = config.branches!.firstWhere((branch) => branch.id == branchId);
      } catch (e) {
        debugPrint('===error: branch');
        branch = config.branches![0];
        splashRepo.setBranchId(config.branches![0].id);
      }
    }
    return branch;
  }

  branchSort(context) {
    _isLoading = true;
    List<BranchValue> branchValueList = [];
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);

    for (var branch in Provider.of<SplashProvider>(context, listen: false).configModel!.branches!) {
      double distance = -1;

      distance = FlutterMapMath().distanceBetween(
        double.parse(branch.latitude),
        double.parse(branch.longitude),
        locationProvider.position!.latitude,
        locationProvider.position!.latitude,
        "miles",
      );

      branchValueList.add(BranchValue(branch, distance));
    }
    branchValueList.sort((a, b) => a.distance.compareTo(b.distance));
    _branchesValue = branchValueList;
    debugPrint('====branch list:$_branchesValue');

    _isLoading = false;
    notifyListeners();
  }
}
