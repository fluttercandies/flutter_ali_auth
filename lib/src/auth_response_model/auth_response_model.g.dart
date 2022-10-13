// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      resultCode: json['resultCode'] as String?,
      msg: json['msg'] as String?,
      requestId: json['requestId'] as String?,
      token: json['token'] as String?,
      innerMsg: json['innerMsg'] as String?,
      innerCode: json['innerCode'] as String?,
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resultCode', instance.resultCode);
  writeNotNull('msg', instance.msg);
  writeNotNull('requestId', instance.requestId);
  writeNotNull('token', instance.token);
  writeNotNull('innerMsg', instance.innerMsg);
  writeNotNull('innerCode', instance.innerCode);
  return val;
}
