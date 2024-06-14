import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/address_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/error_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/distance_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/location_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';

import '../data/model/response/config_model.dart';
import '../view/screens/address/widget/permission_dialog.dart';
import 'dart:math';

class Coordinate {
  double latitude;
  double longitude;

  Coordinate(this.latitude, this.longitude);
}

double calculateDistance(Coordinate start, Coordinate end) {
  const double earthRadius = 6371; // Radius of the Earth in kilometers

  // Convert latitude and longitude from degrees to radians
  double startLat = radians(start.latitude);
  double startLon = radians(start.longitude);
  double endLat = radians(end.latitude);
  double endLon = radians(end.longitude);

  // Haversine formula
  double dLat = endLat - startLat;
  double dLon = endLon - startLon;

  double a = sin(dLat / 2) * sin(dLat / 2) + cos(startLat) * cos(endLat) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Calculate distance
  double distance = earthRadius * c;

  return distance;
}

double radians(double degrees) {
  return degrees * (pi / 180);
}

class LocationProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  final LocationRepo locationRepo;

  LocationProvider({@required this.sharedPreferences, this.locationRepo});

  Position _position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  Position _pickPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  bool _loading = false;
  bool _isAvailable = true;
  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  String _address = '';
  String _pickAddress = '';
  Branches currentBranch;
  double distance = 0.0;

  String get address => _address;
  bool get isAvailable => _isAvailable;
  String get pickAddress => _pickAddress;
  List<Marker> _markers = <Marker>[];

  List<Marker> get markers => _markers;

  bool _buttonDisabled = true;
  bool _changeAddress = true;
  GoogleMapController _mapController;
  List<Prediction> _predictionList = [];
  bool _updateAddAddressData = true;

  bool get buttonDisabled => _buttonDisabled;
  GoogleMapController get mapController => _mapController;

  updateAddressStatusMessage({String message}) {
    _addressStatusMessage = message;
  }

  resetPickedAddress({String message}) {
    _pickAddress = '';
  }

  // for get current location
  Future<Position> getCurrentLocation(BuildContext context, bool isUpdate, {GoogleMapController mapController}) async {
    _loading = true;
    if (isUpdate) {
      notifyListeners();
    }

    Position _myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _myPosition = newLocalData;
    } catch (e) {
      _myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
      );
    }
    _position = _myPosition;

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_myPosition.latitude, _myPosition.longitude), zoom: 17),
      ));
    }
    // String _myPlaceMark;
    _address = await getAddressFromGeocode(LatLng(_myPosition.latitude, _myPosition.longitude), context);

    print('===address: now:${_address}');
    _loading = false;
    notifyListeners();
    return _myPosition;
  }

  checkRadius() {
    LatLng start = LatLng(double.parse(currentBranch.latitude),
        double.parse(currentBranch.longitude)); // Example coordinates for San Francisco
    LatLng end = LatLng(position.latitude, position.longitude); // Example coordinates for Los Angeles

    getDistanceInMeter(start, end).then((value) {
      print('===distance:${distance} ${currentBranch.coverage}');
      if (distance < currentBranch.coverage) {
        _isAvailable = true;
      } else {
        _isAvailable = false;
      }
    });

    notifyListeners();
  }

  // update Position
  void updatePosition(
      CameraPosition position, bool fromAddress, String address, BuildContext context, bool forceNotify) async {
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
          );
        }
        if (_changeAddress) {
          String _addressFromGeocode =
              await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude), context);
          fromAddress ? _address = _addressFromGeocode : _pickAddress = _addressFromGeocode;
        } else {
          _changeAddress = true;
        }
      } catch (e) {}
      _loading = false;
      notifyListeners();
    } else {
      _updateAddAddressData = true;
    }
  }

  // delete usser address
  void deleteUserAddressByID(int id, int index, Function callback) async {
    ApiResponse apiResponse = await locationRepo.removeAddressByID(id);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _addressList.removeAt(index);
      callback(true, 'Deleted address successfully');
    } else {
      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  Future<bool> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    print('======get distance');
    distance = -1;
    bool _isSuccess = false;
    ApiResponse response = await locationRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.response.statusCode == 200 && jsonDecode(response.response.body)['status'] == 'OK') {
        _isSuccess = true;
        distance = DistanceModel.fromJson(jsonDecode(response.response.body)).rows[0].elements[0].distance.value / 1000;
      } else {
        distance = Geolocator.distanceBetween(
              originLatLng.latitude,
              originLatLng.longitude,
              destinationLatLng.latitude,
              destinationLatLng.longitude,
            ) /
            1000;
      }
    } catch (e) {
      distance = Geolocator.distanceBetween(
            originLatLng.latitude,
            originLatLng.longitude,
            destinationLatLng.latitude,
            destinationLatLng.longitude,
          ) /
          1000;
    }
    notifyListeners();
    return _isSuccess;
  }

  bool _isAvailableLocation = false;

  bool get isAvailableLocation => _isAvailableLocation;

  // user address
  List<AddressModel> _addressList;

  List<AddressModel> get addressList => _addressList;

  Future<ResponseModel> initAddressList(BuildContext context) async {
    ResponseModel _responseModel;
    ApiResponse apiResponse = await locationRepo.getAllAddress();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _addressList = [];
      jsonDecode(apiResponse.response.body).forEach((address) => _addressList.add(AddressModel.fromJson(address)));
      _responseModel = ResponseModel(true, 'successful');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _responseModel;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  String _addressStatusMessage = '';
  String get addressStatusMessage => _addressStatusMessage;

  updateErrorMessage({String message}) {
    _errorMessage = message;
  }

  Future<ResponseModel> addAddress(AddressModel addressModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      debugPrint('======location success');

      Map map = jsonDecode(apiResponse.response.body);
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      debugPrint('======location error');
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for address update screen
  Future<ResponseModel> updateAddress(BuildContext context, {AddressModel addressModel, int addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponse apiResponse = await locationRepo.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      Map map = jsonDecode(apiResponse.response.body);
      initAddressList(context);
      String message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      String errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      responseModel = ResponseModel(false, errorMessage);
      _errorMessage = errorMessage;
    }
    notifyListeners();
    return responseModel;
  }

  // for save user address Section
  Future<void> saveUserAddress({Placemark address}) async {
    String userAddress = jsonEncode(address);
    try {
      await sharedPreferences.setString(AppConstants.USER_ADDRESS, userAddress);
    } catch (e) {
      throw e;
    }
  }

  String getUserAddress() {
    return sharedPreferences.getString(AppConstants.USER_ADDRESS) ?? "";
  }

  // for Label Us
  List<String> _getAllAddressType = [];

  List<String> get getAllAddressType => _getAllAddressType;
  int _selectAddressIndex = 0;

  int get selectAddressIndex => _selectAddressIndex;

  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  initializeAllAddressType({BuildContext context}) {
    if (_getAllAddressType.length == 0) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo.getAllAddressType(context: context);
    }
  }

  setLocation(
    String placeID,
    String address,
  ) async {
    _loading = true;
    notifyListeners();
    PlacesDetailsResponse detail;
    ApiResponse response = await locationRepo.getPlaceDetails(placeID);
    detail = PlacesDetailsResponse.fromJson(jsonDecode(response.response.body));

    _pickPosition = Position(
      longitude: detail.result.geometry.location.lng,
      latitude: detail.result.geometry.location.lat,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1,
    );
    checkRadius();

    _position = _pickPosition;

    // _pickAddress = Placemark(name: address);
    _pickAddress = address;
    _changeAddress = false;

    // if(mapController != null) {
    //   mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
    //     detail.result.geometry.location.lat, detail.result.geometry.location.lng,
    //   ), zoom: 16)));
    // }
    _loading = false;
    notifyListeners();
  }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData() {
    _position = _pickPosition;
    _address = _pickAddress;
    // _address = placeMarkToAddress(_address);
    _updateAddAddressData = false;
    notifyListeners();
  }

  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
  }

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
    notifyListeners();
  }

  Future<String> getAddressFromGeocode(LatLng latLng, BuildContext context) async {
    ApiResponse response = await locationRepo.getAddressFromGeocode(latLng);
    String _address = 'Unknown Location Found';
    if (response.response.statusCode == 200 && jsonDecode(response.response.body)['status'] == 'OK') {
      //_address = jsonDecode(response.response.body)['results'][0]['formatted_address'].toString();
      List add = jsonDecode(response.response.body)['results'][0]['address_components'];
      List tempAddress = [];

      for (var address in add) {
        if (address['types'][0] != 'plus_code' && address['types'][0] != 'administrative_area_level_3') {
          tempAddress.add('${address['long_name']}');
        }
      }

      _address = tempAddress.join(", ");
    } else {
      ApiChecker.checkApi(context, response);
    }
    return _address;
  }

  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if (text != null && text.isNotEmpty) {
      debugPrint('---location searching');

      ApiResponse response = await locationRepo.searchLocation(text);
      if (response.response.statusCode == 200 && jsonDecode(response.response.body)['status'] == 'OK') {
        _predictionList = [];
        jsonDecode(response.response.body)['predictions']
            .forEach((prediction) => _predictionList.add(Prediction.fromJson(prediction)));
        debugPrint('---location searching response: ${_predictionList}');
      } else {
        ApiChecker.checkApi(context, response);
      }
    }
    return _predictionList;
  }

  String placeMarkToAddress(String placeMark) {
    return placeMark;
  }

  Future<LatLng> getCurrentLatLong() async {
    Position _position;
    try {
      _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      debugPrint('error : $e');
    }
    return _position != null ? LatLng(_position.latitude, _position.longitude) : null;
  }

  void checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    print('permission status ::: ${permission}');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
    } else {
      callback();
    }
  }
}
