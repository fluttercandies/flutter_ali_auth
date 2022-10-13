import 'package:flutter/services.dart';

import '../auth_config/auth_config.dart';
import '../auth_response_model/auth_response_model.dart';

class AliAuthClient {
  const AliAuthClient._();

  static const MethodChannel _methodChannel = MethodChannel('flutter_ali_auth');
  static const EventChannel _loginEventChannel = EventChannel('auth_event');

  static Future<String?> getPlatformVersion() {
    return _methodChannel.invokeMethod('getPlatformVersion');
  }

  /// 初始化
  static Future<AuthResponseModel> initSdk({
    required AuthConfig authConfig,
  }) async {
    final res = await _methodChannel.invokeMethod('init', authConfig.toJson());
    return AuthResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  /// 一键登陆
  static Future<AuthResponseModel> login({double timeout = 5.0}) async {
    final res = await _methodChannel.invokeMethod('login', timeout);
    return AuthResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  /// 一键登陆，debug专用, 用新的配置去验证，耗时会比较久
  static Future<AuthResponseModel> loginWithConfig(
    AuthConfig authConfig,
  ) async {
    final res = await _methodChannel.invokeMethod(
      'loginWithConfig',
      authConfig.toJson(),
    );
    return AuthResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  static Stream<dynamic>? _pluginStream;

  static Future<void> onListen(
    ValueChanged onData, {
    Function? onError,
    VoidCallback? onDone,
    bool? cancelOnError,
  }) async {
    if (_pluginStream != null) {
      return;
    }
    _pluginStream = _loginEventChannel.receiveBroadcastStream();
    _pluginStream!.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 判断网络是否支持，一般不需要主动调用
  static Future<AuthResponseModel> checkVerifyEnable() async {
    ///{msg: 无SIM卡, requestId: 941e9389efee47b9, resultCode: 600007}
    final res = await _methodChannel.invokeMethod("checkEnv");
    return AuthResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  /// 预取号，一般不需要主动调用
  static Future<AuthResponseModel> accelerateLoginPage() async {
    final res = await _methodChannel.invokeMethod('accelerateLoginPage');
    return AuthResponseModel.fromJson(Map<String, dynamic>.from(res));
  }

  /// 检查版本
  static Future<dynamic> get version {
    return _methodChannel.invokeMethod('getAliAuthVersion');
  }
}
