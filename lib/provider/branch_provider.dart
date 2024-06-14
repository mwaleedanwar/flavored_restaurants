import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/splash_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/home/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class BranchProvider extends ChangeNotifier {
  final SplashRepo splashRepo;

  BranchProvider({@required this.splashRepo});

  int _selectedBranchId;
  int branch;

  int get selectedBranchId => _selectedBranchId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int _branchTabIndex = 0;

  int get branchTabIndex => _branchTabIndex;

  void updateTabIndex(int index, {bool isUpdate = true}) {
    _branchTabIndex = index;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void updateBranchId(int value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    branch = value;

    if (isUpdate) {
      notifyListeners();
    }
  }

  int getBranchId() => splashRepo.getBranchId();

  setCurrentId() {
    _selectedBranchId = splashRepo.getBranchId();
    branch = splashRepo.getBranchId() == -1 ? null : splashRepo.getBranchId();
  }

  Future<void> setBranch(int id) async {
    branch = id;

    await splashRepo.setBranchId(id);

    await HomeScreen.loadData(true);
    notifyListeners();
  }

  Branches getBranch({int id}) {
    int branchId = id != null ? id : getBranchId();
    print('===erro: branch:$branchId');

    Branches branch;
    ConfigModel _config = Provider.of<SplashProvider>(Get.context, listen: false).configModel;
    if (_config.branches != null && _config.branches.length > 0) {
      try {
        branch = _config.branches.firstWhere((branch) => branch.id == branchId, orElse: null);
      } catch (e) {
        print('===erro: branch');
        branch = _config.branches[0];
        splashRepo.setBranchId(_config.branches[0].id);
      }
    }
    return branch;
  }

  List<BranchValue> branchSort(LatLng currentLatLng) {
    _isLoading = true;
    List<BranchValue> _branchValueList = [];

    Provider.of<SplashProvider>(Get.context, listen: false).configModel.branches.forEach((_branch) {
      double _distance = -1;
      if (currentLatLng != null) {
        _distance = Geolocator.distanceBetween(
              double.parse(_branch.latitude),
              double.parse(_branch.longitude),
              currentLatLng.latitude,
              currentLatLng.longitude,
            ) /
            1000;
      }

      _branchValueList.add(BranchValue(_branch, _distance));
    });
    _branchValueList.sort((a, b) => a.distance.compareTo(b.distance));

    _isLoading = false;
    notifyListeners();

    return _branchValueList;
  }
}
