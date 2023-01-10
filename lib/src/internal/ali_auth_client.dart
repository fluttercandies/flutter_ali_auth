import 'dart:async';

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
  static StreamSubscription<dynamic>? _streamSubscription;

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
    _streamSubscription = _pluginStream!.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  static FutureOr<bool> removeListener() async {
    if (_streamSubscription == null) {
      return false;
    }
    //call this method will trigger native side: [EventChannel.EventSink]#endOfStream,flutter side:[Stream]#onDone
    await _methodChannel.invokeMethod('cancelStream');
    _streamSubscription!.cancel();
    _streamSubscription = null;
    _pluginStream = null;
    return true;
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

  /// 关闭授权页loading
  /// 安卓 SDK完成回调之后不会关闭loading，需要开发者主动调用hideLoginLoading关闭loading
  /// IOS 手动隐藏一键登录获取登录Token之后的等待动画，默认为自动隐藏
  static Future<void> hideLoginLoading() async {
    return _methodChannel.invokeMethod("hideLoginLoading");
  }

  /// 退出授权认证页,IOS一般不用主动调用，除非个人需要，安卓看情况
  /// 安卓 SDK完成回调之后不会关闭授权页，需要开发者主动调⽤quitLoginPage退出授权页
  /// IOS 注销授权页，建议用此方法，对于移动卡授权页的消失会清空一些数据
  static Future<void> quitLoginPage() async {
    return _methodChannel.invokeMethod("quitLoginPage");
  }
}
