// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/error_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/location_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/config_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/view/screens/address/widget/permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);
}

class LocationProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final LocationRepo locationRepo;

  LocationProvider({
    required this.sharedPreferences,
    required this.locationRepo,
  });

  List<AddressModel>? _addressList = [];
  final _markers = <Marker>[];
  bool _loading = false;
  bool _isAvailable = true;
  String? _address = '';
  String? _pickAddress = '';
  Branches? currentBranch;
  double distance = 0.0;
  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController? _mapController;
  List<Prediction> _predictionList = [];
  bool _updateAddAddressData = true;
  String? _addressStatusMessage = '';
  String? _errorMessage = '';
  bool _isLoading = false;
  // ignore: prefer_final_fields
  bool _isAvailableLocation = false;
  List<String> _getAllAddressType = [];
  int _selectAddressIndex = 0;

  Position? _position = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1,
    altitudeAccuracy: 1,
    headingAccuracy: 1,
  );
  Position _pickPosition = Position(
    longitude: 0,
    latitude: 0,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1,
    altitudeAccuracy: 1,
    headingAccuracy: 1,
  );

  bool get loading => _loading;

  Position? get position => _position;

  Position get pickPosition => _pickPosition;

  List<AddressModel>? get addressList => _addressList;

  bool get isAvailableLocation => _isAvailableLocation;

  String? get address => _address;

  bool get isAvailable => _isAvailable;

  String? get pickAddress => _pickAddress;

  List<Marker> get markers => _markers;

  bool get buttonDisabled => _buttonDisabled;

  GoogleMapController? get mapController => _mapController;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String? get addressStatusMessage => _addressStatusMessage;

  int get selectAddressIndex => _selectAddressIndex;

  List<String> get getAllAddressType => _getAllAddressType;

  void updateAddressStatusMessage({required String message}) {
    _addressStatusMessage = message;
  }

  void resetPickedAddress() {
    _pickAddress = '';
  }

  Future<Position> getCurrentLocation(BuildContext context, bool isUpdate, {GoogleMapController? mapController}) async {
    _loading = true;
    if (isUpdate) {
      notifyListeners();
    }

    Position myPosition;
    try {
      myPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
        altitudeAccuracy: 1,
        headingAccuracy: 1,
      );
    }
    _position = myPosition;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 17),
      ));
    }
    _address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude), context);

    debugPrint('===address: now:$_address');
    _loading = false;
    notifyListeners();
    return myPosition;
  }

  void checkRadius() {
    distance = FlutterMapMath().distanceBetween(
      double.parse(currentBranch!.latitude),
      double.parse(currentBranch!.longitude),
      position!.latitude,
      position!.longitude,
      "miles",
    );
    log('distance $distance');
    _isAvailable = distance < currentBranch!.coverage;
    notifyListeners();
  }

  // update Position
  void updatePosition(CameraPosition position, bool fromAddress, BuildContext context, bool forceNotify) async {
    if (_updateAddAddressData || forceNotify) {
      _loading = true;
      notifyListeners();
      try {
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
            altitudeAccuracy: 1,
            headingAccuracy: 1,
          );
        } else {
          _pickPosition = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
            altitudeAccuracy: 1,
            headingAccuracy: 1,
          );
        }
        if (_changeAddress) {
          String addressFromGeocode =
              await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude), context);
          fromAddress ? _address = addressFromGeocode : _pickAddress = addressFromGeocode;
        } else {
          _changeAddress = true;
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      _loading = false;
      notifyListeners();
    } else {
      _updateAddAddressData = true;
    }
  }

  void deleteUserAddressByID(int id, int index, Function callback) async {
    ApiResponse apiResponse = await locationRepo.removeAddressByID(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList?.removeAt(index);
      callback(true, 'Deleted address successfully');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?.first.message);
        errorMessage = errorResponse.errors?.first.message ?? 'UNKOWN ERROR DELETING ADDRESS';
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  Future<ResponseModel?> initAddressList(BuildContext context) async {
    ResponseModel? responseModel;
    ApiResponse apiResponse = await locationRepo.getAllAddress();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList = [];
      jsonDecode(apiResponse.response!.body).forEach((address) => _addressList?.add(AddressModel.fromJson(address)));
      responseModel = ResponseModel(true, 'successful');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return responseModel;
  }

  updateErrorMessage({required String message}) {
    _errorMessage = message;
  }

  Future<ResponseModel> addAddress(
    BuildContext context,
    AddressModel addressModel,
  ) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint('======location success');

      Map map = jsonDecode(apiResponse.response!.body);
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      debugPrint('location error');
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors!.first.message);
        errorMessage = errorResponse.errors!.first.message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  Future<ResponseModel> updateAddress(
    BuildContext context, {
    required AddressModel addressModel,
    required int addressId,
  }) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse = await locationRepo.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response!.body);
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        debugPrint(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        debugPrint(errorResponse.errors?.first.message);
        errorMessage = errorResponse.errors?.first.message ?? 'UNKOWN ERROR UPDATING ADDRESS';
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? "";
  }

  void updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  void initializeAllAddressType() {
    if (_getAllAddressType.isEmpty) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo.getAllAddressType();
    }
  }

  Future<void> setLocation(String placeID, String address) async {
    _loading = true;
    notifyListeners();
    ApiResponse response = await locationRepo.getPlaceDetails(placeID);
    PlacesDetailsResponse detail = PlacesDetailsResponse.fromJson(jsonDecode(response.response!.body));

    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lng,
      latitude: detail.result.geometry!.location.lat,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
      altitudeAccuracy: 1,
      headingAccuracy: 1,
    );
    _position = _pickPosition;
    checkRadius();
    _address = address;
    _changeAddress = false;
    _loading = false;
    notifyListeners();
  }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress ?? '';
    _updateAddAddressData = false;
    notifyListeners();
  }

  void setPickData() {
    _pickPosition = _position!;
    _pickAddress = _address;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }

  Future<String> getAddressFromGeocode(LatLng latLng, BuildContext context) async {
    ApiResponse response = await locationRepo.getAddressFromGeocode(latLng);
    String address = 'Unknown Location Found';
    if (response.response != null &&
        response.response!.statusCode == 200 &&
        jsonDecode(response.response!.body)['status'] == 'OK') {
      List add = jsonDecode(response.response!.body)['results'][0]['address_components'];
      List tempAddress = [];
      for (var address in add) {
        if (address['types'][0] != 'plus_code' && address['types'][0] != 'administrative_area_level_3') {
          tempAddress.add('${address['long_name']}');
        }
      }
      address = tempAddress.join(", ");
    } else {
      ApiChecker.checkApi(context, response);
    }
    return address;
  }

  Future<List<Prediction>> searchLocation(BuildContext context, String? text) async {
    if (text != null && text.isNotEmpty) {
      ApiResponse response = await locationRepo.searchLocation(text);
      if (response.response != null &&
          response.response!.statusCode == 200 &&
          jsonDecode(response.response!.body)['status'] == 'OK') {
        _predictionList = [];
        jsonDecode(response.response!.body)['predictions']
            .forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
        debugPrint('---location searching response: $_predictionList');
      } else {
        ApiChecker.checkApi(context, response);
      }
    }
    return _predictionList;
  }

  Future<LatLng?> getCurrentLatLong() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      debugPrint('error : $e');
    }
    return position != null ? LatLng(position.latitude, position.longitude) : null;
  }

  void checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    debugPrint('permission status ::: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      await showDialog(context: context, barrierDismissible: false, builder: (context) => const PermissionDialog());
    } else {
      callback();
    }
  }
}
