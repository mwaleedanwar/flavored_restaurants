import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/notification_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/repository/notification_repo.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/api_checker.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo notificationRepo;
  NotificationProvider({@required this.notificationRepo});

  List<NotificationModel> _notificationList;
  List<NotificationModel> get notificationList =>
      _notificationList != null ? _notificationList.reversed.toList() : _notificationList;

  Future<void> initNotificationList(BuildContext context) async {
    ApiResponse apiResponse = await notificationRepo.getNotificationList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _notificationList = [];
      jsonDecode(apiResponse.response.body)
          .forEach((notificatioModel) => _notificationList.add(NotificationModel.fromJson(notificatioModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }
}
