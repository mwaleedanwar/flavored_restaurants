import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/place_order_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/error_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/delivery_man_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/distance_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_details_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/order_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/timeslote_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/order_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/date_converter.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/provider/splash_provider.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/stripe_payment_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo orderRepo;
  final SharedPreferences sharedPreferences;

  OrderProvider({@required this.sharedPreferences, @required this.orderRepo});
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  List<OrderModel> _runningOrderList;
  List<OrderModel> _historyOrderList;
  List<OrderDetailsModel> _orderDetails;
  int _paymentMethodIndex = 0;
  OrderModel _trackModel;
  ResponseModel _responseModel;
  int _addressIndex = -1;
  int _cardIndex = -1;
  bool _isLoading = false;
  bool _showCancelled = false;
  DeliveryManModel _deliveryManModel;
  StripeIntentModel _stripeIntentModel;

  String _orderType = 'delivery';
  int _branchIndex = 0;
  List<TimeSlotModel> _timeSlots;
  List<TimeSlotModel> _allTimeSlots;
  int _selectDateSlot = 0;
  int _selectTimeSlot = 0;
  double _distance = -1;
  bool _isRestaurantCloseShow = true;

  List<OrderModel> get runningOrderList => _runningOrderList;

  List<OrderModel> get historyOrderList => _historyOrderList;

  List<OrderDetailsModel> get orderDetails => _orderDetails;

  int get paymentMethodIndex => _paymentMethodIndex;

  OrderModel get trackModel => _trackModel;

  ResponseModel get responseModel => _responseModel;

  int get addressIndex => _addressIndex;

  int get cardIndex => _cardIndex;

  bool get isLoading => _isLoading;

  bool get showCancelled => _showCancelled;

  DeliveryManModel get deliveryManModel => _deliveryManModel;
  StripeIntentModel get stripeModel => _stripeIntentModel;

  String get orderType => _orderType;

  int get branchIndex => _branchIndex;

  List<TimeSlotModel> get timeSlots => _timeSlots;

  List<TimeSlotModel> get allTimeSlots => _allTimeSlots;

  int get selectDateSlot => _selectDateSlot;

  int get selectTimeSlot => _selectTimeSlot;

  double get distance => _distance;

  bool get isRestaurantCloseShow => _isRestaurantCloseShow;

  void changeStatus(bool status, {bool notify = false}) {
    _isRestaurantCloseShow = status;
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getOrderList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      jsonDecode(apiResponse.response.body).forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'out_for_delivery' ||
            orderModel.orderStatus == 'confirmed') {
          _runningOrderList.add(orderModel);
        } else if (orderModel.orderStatus == 'delivered' ||
            orderModel.orderStatus == 'returned' ||
            orderModel.orderStatus == 'failed' ||
            orderModel.orderStatus == 'canceled') {
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<List<OrderDetailsModel>> getOrderDetails(String orderID, BuildContext context) async {
    _orderDetails = null;
    _isLoading = true;
    _showCancelled = false;

    ApiResponse apiResponse = await orderRepo.getOrderDetails(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      print('order Details: ${apiResponse.response.body}');
      _orderDetails = [];
      jsonDecode(apiResponse.response.body)
          .forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
    return _orderDetails;
  }

  Future<void> getDeliveryManData(String orderID, BuildContext context) async {
    ApiResponse apiResponse = await orderRepo.getDeliveryManData(orderID);
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _deliveryManModel = DeliveryManModel.fromJson(jsonDecode(apiResponse.response.body));
      print('==getDeliveryManData: ${apiResponse.response.body}');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }

  Future<ResponseModel> trackOrder(
      String orderID, OrderModel orderModel, BuildContext context, bool fromTracking) async {
    _trackModel = null;
    _responseModel = null;
    if (!fromTracking) {
      _orderDetails = null;
    }
    _showCancelled = false;
    if (orderModel == null) {
      _isLoading = true;
      ApiResponse apiResponse = await orderRepo.trackOrder(orderID);
      if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
        _trackModel = OrderModel.fromJson(jsonDecode(apiResponse.response.body));
        _responseModel = ResponseModel(true, apiResponse.response.body.toString());
        debugPrint('responseModel : ${_responseModel.message}');
      } else {
        _responseModel = ResponseModel(false, apiResponse.error.errors[0].message);
        ApiChecker.checkApi(context, apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }
    return _responseModel;
  }

  Future<ResponseModel> makePayment(String token, double amount, String name, String email) async {
    _isLoading = true;

    ApiResponse apiResponse = await orderRepo.makePayment(token, amount, name, email);

    // Handle the response from the backend
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _stripeIntentModel = StripeIntentModel.fromJson(jsonDecode(apiResponse.response.body));
      _responseModel = ResponseModel(true, 'Successful');

      print('=======Payment intent was created successfully}');
    } else {
      _responseModel = ResponseModel(false, apiResponse.error.errors[0].message);

      // Handle any errors from the backend
    }
    return _responseModel;
  }

  Future<void> placeOrder(PlaceOrderBody placeOrderBody, Function callback) async {
    _isLoading = true;
    notifyListeners();
    print('order body : ${placeOrderBody.toJson()}');
    ApiResponse apiResponse = await orderRepo.placeOrder(placeOrderBody);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      String message = jsonDecode(apiResponse.response.body)['message'];
      String orderID = jsonDecode(apiResponse.response.body)['order_id'].toString();
      cardNumber = '';
      expiryDate = '';
      cardHolderName = '';
      cvvCode = '';
      isCvvFocused = false;
      callback(true, message, orderID, -1);
    } else {
      _isLoading = false;

      String errorMessage;
      if (apiResponse.error is String) {
        print(apiResponse.error.toString());
        errorMessage = apiResponse.error.toString();
      } else {
        _isLoading = false;

        ErrorResponse errorResponse = apiResponse.error;
        print(errorResponse.errors[0].message);
        errorMessage = errorResponse.errors[0].message;
      }
      callback(false, errorMessage, '-1', -1);
    }
    notifyListeners();
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void startLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }

  void setCardIndex(int index) {
    _cardIndex = index;
    notifyListeners();
  }

  void clearPrevData() {
    _addressIndex = -1;
    _branchIndex = 0;
    _paymentMethodIndex = 0;
    _distance = -1;
  }

  void cancelOrder(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.cancelOrder(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      OrderModel orderModel;
      _runningOrderList.forEach((order) {
        if (order.id.toString() == orderID) {
          orderModel = order;
        }
      });
      _runningOrderList.remove(orderModel);
      _showCancelled = true;
      callback(jsonDecode(apiResponse.response.body)['message'], true, orderID);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false, '-1');
    }
    notifyListeners();
  }

  Future<void> updatePaymentMethod(String orderID, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo.updatePaymentMethod(orderID);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      int orderIndex;
      for (int index = 0; index < _runningOrderList.length; index++) {
        if (_runningOrderList[index].id.toString() == orderID) {
          orderIndex = index;
          break;
        }
      }
      if (orderIndex != null) {
        _runningOrderList[orderIndex].paymentMethod = 'cash_on_delivery';
      }
      _trackModel.paymentMethod = 'cash_on_delivery';
      callback(jsonDecode(apiResponse.response.body)['message'], true);
    } else {
      print(apiResponse.error.errors[0].message);
      callback(apiResponse.error.errors[0].message, false);
    }
    notifyListeners();
  }

  void setOrderType(String type, {bool notify = true}) {
    _orderType = type;
    if (notify) {
      notifyListeners();
    }
  }

  void setBranchIndex(int index) {
    _branchIndex = index;
    _addressIndex = -1;
    _distance = -1;
    notifyListeners();
  }

  Future<void> initializeTimeSlot(BuildContext context) async {
    final _scheduleTime = Provider.of<SplashProvider>(context, listen: false).configModel.restaurantScheduleTime;
    int _duration = Provider.of<SplashProvider>(context, listen: false).configModel.scheduleOrderSlotDuration;
    _timeSlots = [];
    _allTimeSlots = [];
    _selectDateSlot = 0;
    int _minutes = 0;
    DateTime _now = DateTime.now();
    for (int index = 0; index < _scheduleTime.length; index++) {
      DateTime _openTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        DateConverter.convertStringTimeToDate(_scheduleTime[index].openingTime).hour,
        DateConverter.convertStringTimeToDate(_scheduleTime[index].openingTime).minute,
      );

      DateTime _closeTime = DateTime(
        _now.year,
        _now.month,
        _now.day,
        DateConverter.convertStringTimeToDate(_scheduleTime[index].closingTime).hour,
        DateConverter.convertStringTimeToDate(_scheduleTime[index].closingTime).minute,
      );

      if (_closeTime.difference(_openTime).isNegative) {
        _minutes = _openTime.difference(_closeTime).inMinutes;
      } else {
        _minutes = _closeTime.difference(_openTime).inMinutes;
      }
      if (_duration > 0 && _minutes > _duration) {
        DateTime _time = _openTime;
        for (;;) {
          if (_time.isBefore(_closeTime)) {
            DateTime _start = _time;
            DateTime _end = _start.add(Duration(minutes: _duration));
            if (_end.isAfter(_closeTime)) {
              _end = _closeTime;
            }
            _timeSlots
                .add(TimeSlotModel(day: int.tryParse(_scheduleTime[index].day), startTime: _start, endTime: _end));
            _allTimeSlots
                .add(TimeSlotModel(day: int.tryParse(_scheduleTime[index].day), startTime: _start, endTime: _end));
            _time = _time.add(Duration(minutes: _duration));
          } else {
            break;
          }
        }
      } else {
        _timeSlots
            .add(TimeSlotModel(day: int.tryParse(_scheduleTime[index].day), startTime: _openTime, endTime: _closeTime));
        _allTimeSlots
            .add(TimeSlotModel(day: int.tryParse(_scheduleTime[index].day), startTime: _openTime, endTime: _closeTime));
      }
    }
    validateSlot(_allTimeSlots, 0, notify: false);
  }

  void sortTime() {
    _timeSlots.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });

    _allTimeSlots.sort((a, b) {
      return a.startTime.compareTo(b.startTime);
    });
  }

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if (_allTimeSlots != null) {
      validateSlot(_allTimeSlots, index);
    }
    notifyListeners();
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex, {bool notify = true}) {
    _timeSlots = [];
    int _day = 0;
    if (dateIndex == 0) {
      _day = DateTime.now().weekday;
    } else {
      _day = DateTime.now().add(Duration(days: 1)).weekday;
    }
    if (_day == 7) {
      _day = 0;
    }
    slots.forEach((slot) {
      if (_day == slot.day && (dateIndex == 0 ? slot.endTime.isAfter(DateTime.now()) : true)) {
        _timeSlots.add(slot);
      }
    });

    if (notify) {
      notifyListeners();
    }
  }

  Future<bool> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    print('======get distance');
    _distance = -1;
    bool _isSuccess = false;
    ApiResponse response = await orderRepo.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if (response.response.statusCode == 200 && jsonDecode(response.response.body)['status'] == 'OK') {
        _isSuccess = true;
        _distance =
            DistanceModel.fromJson(jsonDecode(response.response.body)).rows[0].elements[0].distance.value / 1000;
      } else {
        _distance = Geolocator.distanceBetween(
              originLatLng.latitude,
              originLatLng.longitude,
              destinationLatLng.latitude,
              destinationLatLng.longitude,
            ) /
            1000;
      }
    } catch (e) {
      _distance = Geolocator.distanceBetween(
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

  Future<void> setPlaceOrder(String placeOrder) async {
    await sharedPreferences.setString(AppConstants.PLACE_ORDER_DATA, placeOrder);
  }

  String getPlaceOrder() {
    return sharedPreferences.getString(AppConstants.PLACE_ORDER_DATA);
  }

  Future<void> clearPlaceOrder() async {
    await sharedPreferences.remove(AppConstants.PLACE_ORDER_DATA);
  }
}