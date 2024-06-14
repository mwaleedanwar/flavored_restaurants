class ResponseModel {
  bool _isSuccess;
  String _message;
  ResponseModel(this._isSuccess, this._message);

  String get message => _message;
  bool get isSuccess => _isSuccess;
}


class OTPResponseModel {
  bool _isSuccess;
  bool _isExist;
  String _message;
  OTPResponseModel(this._isSuccess, this._message,this._isExist);

  String get message => _message;
  bool get isSuccess => _isSuccess;
  bool get isExist => _isExist;
}