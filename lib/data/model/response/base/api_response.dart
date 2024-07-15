import 'package:http/http.dart';

class ApiResponse {
  final Response? response;
  final dynamic error;

  ApiResponse(this.response, this.error);

  factory ApiResponse.withError(dynamic errorValue) =>
      ApiResponse(null, errorValue);

  factory ApiResponse.withSuccess(Response responseValue) =>
      ApiResponse(responseValue, null);
}
