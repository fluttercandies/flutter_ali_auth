import 'dart:convert';

part 'auth_response_model.g.dart';

class AuthResponseModel {
  const AuthResponseModel({
    this.resultCode,
    this.msg,
    this.requestId,
    this.token,
    this.innerMsg,
    this.innerCode,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  final String? resultCode;
  final String? msg;
  final String? requestId;
  final String? token;
  final String? innerMsg;
  final String? innerCode;

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
