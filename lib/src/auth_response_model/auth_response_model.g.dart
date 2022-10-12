// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel()
      ..resultCode = json['resultCode'] as String?
      ..msg = json['msg'] as String?
      ..requestId = json['requestId'] as String?
      ..token = json['token'] as String?
      ..innerMsg = json['innerMsg'] as String?
      ..innerCode = json['innerCode'] as String?;

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'resultCode': instance.resultCode,
      'msg': instance.msg,
      'requestId': instance.requestId,
      'token': instance.token,
      'innerMsg': instance.innerMsg,
      'innerCode': instance.innerCode,
    };
