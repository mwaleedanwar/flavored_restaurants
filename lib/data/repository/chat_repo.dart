import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/dio/dio_client.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/datasource/remote/exception/api_error_handler.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/body/message_body.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/base/api_response.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/data/model/response/response_model.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/flavors.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/responsive_helper.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/helper/user_type.dart';
import 'package:noapl_dos_maa_kitchen_flavor_test/utill/app_constants.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

class ChatRepo {
  final HttpClient httpClient;
  final SharedPreferences sharedPreferences;
  ChatRepo({required this.httpClient, required this.sharedPreferences});

  Future<ApiResponse> getDeliveryManMessage(int orderId, int offset) async {
    try {
      final response = await httpClient.get(
          '${AppConstants.GET_DELIVERYMAN_MESSAGE_URI}?offset=$offset&limit=100&order_id=$orderId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAdminMessage(int offset) async {
    debugPrint('------getAdminMessage');

    try {
      final response = await httpClient.get(
          '${AppConstants.GET_ADMIN_MESSAGE_URL}?offset=$offset&limit=100');
      debugPrint('------getAdminMessage response :${response.body}');

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<StreamedResponse> sendMessageToDeliveryMan(
      String message, List<XFile>? file, int orderId, String token) async {
    MultipartRequest request = MultipartRequest(
        'POST',
        Uri.parse(
            '${F.BASE_URL}${AppConstants.SEND_MESSAGE_TO_DELIVERY_MAN_URL}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    for (int i = 0; i < (file?.length ?? 0); i++) {
      if (file != null) {
        Uint8List list = await file[i].readAsBytes();
        var part = MultipartFile(
            'image[]', file[i].readAsBytes().asStream(), list.length,
            filename: basename(file[i].path),
            contentType: MediaType('image', 'jpg'));
        request.files.add(part);
      }
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
      'order_id': orderId.toString(),
    });
    request.fields.addAll(fields);
    StreamedResponse response = await request.send();
    return response;
  }

  Future<StreamedResponse> sendMessageToAdmin(
      String message, List<XFile>? file, String token) async {
    debugPrint('----send msg to admin');
    debugPrint(
        '---message body;message:$message,List Files:$file,token: $token');

    MultipartRequest request = MultipartRequest(
        'POST', Uri.parse(F.BASE_URL + AppConstants.SEND_MESSAGE_TO_ADMIN_URL));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    for (int i = 0; i < (file?.length ?? 0); i++) {
      if (file != null) {
        Uint8List list = await file[i].readAsBytes();
        var part = MultipartFile(
            'image[]', file[i].readAsBytes().asStream(), list.length,
            filename: basename(file[i].path),
            contentType: MediaType('image', 'jpg'));
        request.files.add(part);
      }
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'message': message,
    });
    request.fields.addAll(fields);
    StreamedResponse response = await request.send();
    debugPrint('------send AdminMessage response :${response.stream}');

    return response;
  }

  Future<StreamedResponse> sendMessage(
      String message, List<XFile>? images, String token) async {
    MultipartRequest request = MultipartRequest(
        'POST', Uri.parse(F.BASE_URL + AppConstants.GET_IMAGES_URL));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (images != null && ResponsiveHelper.isMobilePhone()) {
      for (int i = 0; i < images.length; i++) {
        File file = File(images[i].path);
        request.files.add(MultipartFile(
            'image[]', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      }
    } else if (images != null && ResponsiveHelper.isWeb()) {
      for (int i = 0; i < images.length; i++) {
        Uint8List list = await images[i].readAsBytes();
        request.files.add(MultipartFile(
            'image[]', images[i].readAsBytes().asStream(), list.length,
            filename: basename(images[0].path)));
      }
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{'message': message});
    request.fields.addAll(fields);
    StreamedResponse response = await request.send();
    return response;
  }

  Future<ResponseModel> sendRealTimeMessage(
    int senderID,
    UserType senderType,
    int receiverID,
    UserType receiverType,
    String message,
    List<XFile>? images, {
    required int? orderID,
  }) async {
    ResponseModel responseModel;
    List<String> imageUrlList = [];
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference ref;
    CollectionReference receiverRef;
    MessageBody message0;
    MultipartRequest request =
        MultipartRequest('POST', Uri.parse(AppConstants.GET_IMAGES_URL));
    request.headers.addAll(<String, String>{
      'Authorization':
          'Bearer ${sharedPreferences.getString(AppConstants.TOKEN)}'
    });

    if (images != null && ResponsiveHelper.isMobilePhone()) {
      for (int i = 0; i < images.length; i++) {
        File file = File(images[i].path);
        request.files.add(MultipartFile(
            'image[]', file.readAsBytes().asStream(), file.lengthSync(),
            filename: file.path.split('/').last));
      }
    } else if (images != null && ResponsiveHelper.isWeb()) {
      for (int i = 0; i < images.length; i++) {
        Uint8List list = await images[i].readAsBytes();
        request.files.add(MultipartFile(
            'image[]', images[i].readAsBytes().asStream(), list.length,
            filename: basename(images[0].path)));
      }
    }
    StreamedResponse response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        imageUrlList.add('${jsonDecode(respStr)['image_urls'][i]}');
      }
    }

    if (orderID != null) {
      ref = fireStore
          .collection('order')
          .doc(orderID.toString())
          .collection('messages');
      fireStore
          .collection('order')
          .doc(orderID.toString())
          .set({'is_seenDM': false, 'is_seenCS': true});
    } else {
      fireStore
          .collection('general')
          .doc('${_getTypeFromEnum(senderType)}$senderID')
          .collection('receivers')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID')
          .set({'is_seen': true});
      ref = fireStore
          .collection('general')
          .doc('${_getTypeFromEnum(senderType)}$senderID')
          .collection('receivers')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID')
          .collection('messages');
    }
    fireStore
        .collection('general')
        .doc('${_getTypeFromEnum(receiverType)}$receiverID')
        .collection('receivers')
        .doc('${_getTypeFromEnum(senderType)}$senderID')
        .set({'is_seen': false});
    receiverRef = fireStore
        .collection('general')
        .doc('${_getTypeFromEnum(receiverType)}$receiverID')
        .collection('receivers')
        .doc('${_getTypeFromEnum(senderType)}$senderID')
        .collection('messages');

    String id = ref.doc().id;
    String receiverId = receiverRef.doc().id;
    message0 = MessageBody(
      id: id,
      orderId: orderID,
      senderId: '${_getTypeFromEnum(senderType)}$senderID',
      receiverId: '${_getTypeFromEnum(receiverType)}$receiverID',
      message: message,
      imageUrls: imageUrlList,
      time: DateTime.now(),
    );
    await ref.doc(id).set(message0.toJson());

    try {
      await receiverRef.doc(receiverId).set(message0.toJson());
      responseModel = ResponseModel(true, 'added');
    } catch (error) {
      responseModel = ResponseModel(false, error.toString());
    }

    return responseModel;
  }

  Map<String, dynamic> getRealTimeMessages(
      int senderID, UserType senderType, int receiverID, UserType receiverType,
      {int? orderID}) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    Query ref;
    DocumentReference isSeenRef;
    if (orderID != null) {
      ref = fireStore
          .collection('order')
          .doc(orderID.toString())
          .collection('messages')
          .orderBy('time');
      isSeenRef = fireStore.collection('order').doc(orderID.toString());
    } else {
      ref = fireStore
          .collection('general')
          .doc('${_getTypeFromEnum(senderType)}$senderID')
          .collection('receivers')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID')
          .collection('messages')
          .orderBy('time');
      isSeenRef = fireStore
          .collection('general')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID')
          .collection('receivers')
          .doc('${_getTypeFromEnum(senderType)}$senderID');
    }
    return {'ref': ref, 'isSeenRef': isSeenRef, 'orderId': orderID};
  }

  void setSeen(
      int senderID, UserType senderType, int receiverID, UserType receiverType,
      {int? orderID}) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    if (orderID == null) {
      fireStore
          .collection('general')
          .doc('${_getTypeFromEnum(senderType)}$senderID')
          .collection('receivers')
          .doc('${_getTypeFromEnum(receiverType)}$receiverID')
          .set({'is_seen': true});
    } else {
      fireStore
          .collection('order')
          .doc(orderID.toString())
          .update({'is_seenCS': true});
    }
  }

  String _getTypeFromEnum(UserType userType) {
    return userType == UserType.customer
        ? 'CS'
        : userType == UserType.admin
            ? 'AD'
            : userType == UserType.deliveryMan
                ? 'DM'
                : '';
  }
}
