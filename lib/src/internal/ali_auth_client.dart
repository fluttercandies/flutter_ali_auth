import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../flutter_ali_auth.dart';

class AliAuthClient {
  const AliAuthClient._();

  static const MethodChannel _methodChannel = MethodChannel('flutter_ali_auth');
  // static const EventChannel _loginEventChannel = EventChannel('auth_event');

  static Future<String?> getPlatformVersion() {
    return _methodChannel.invokeMethod('getPlatformVersion');
  }

  /// 初始化
  /// 如果初始化错误，会抛出异常,需要用try-catch[PlatformException]捕获插件返回的异常
  /// 返回是否成功
  static Future<bool?> initSdk({
    required AuthConfig authConfig,
  }) async {
    return await _methodChannel.invokeMethod<bool>(
      'init',
      authConfig.toJson(),
    );
  }

  /// 初始化之后的SDK的异步回调
  /// [onEvent] 初始化之后会进行环境检查和加速拉起授权页面，这些回调会在这里返回，
  /// 可根据[AuthResponseModel.resultCode]和[AuthResponseModel.innerCode]的进行判断，
  /// 详情可以参考[AuthResultCode]
  ///
  static void handleEvent({
    required AsyncValueSetter<AuthResponseModel> onEvent,
    // required ValueChanged<AuthResponseModel> onLoginEvent,
  }) {
    _methodChannel.setMethodCallHandler((call) async {
      print("call.method:${call.method}");
      switch (call.method) {
        case "onEvent":
          final AuthResponseModel responseModel = AuthResponseModel.fromJson(
            Map.from(call.arguments),
          );
          await onEvent.call(responseModel);
          break;
        default:
          throw UnsupportedError('Unrecognized JSON message');
      }
    });
  }

  /// 一键登陆 需要用try-catch[PlatformException]捕获插件返回的异常
  /// 无返回内容,调用之后，会在[handleEvent]的[onEvent]返回回调
  static Future<void> login({int timeout = 5}) {
    return _methodChannel.invokeMethod('login', timeout);
  }

  /// 一键登陆，建议debug时使用, 用新的配置去拉起授权页 需要用try-catch[PlatformException]捕获插件返回的异常
  /// 无返回内容,调用之后，会在[onHandle]的[onLogin]返回回调
  static Future<void> loginWithConfig(
    AuthConfig authConfig,
  ) {
    return _methodChannel.invokeMethod(
      'loginWithConfig',
      authConfig.toJson(),
    );
  }

  static void removeHandler() {
    _methodChannel.setMethodCallHandler(null);
  }

  // static Stream<dynamic>? _pluginStream;
  // static StreamSubscription<dynamic>? _streamSubscription;
  //
  // static Future<void> onListen(
  //   ValueChanged onData, {
  //   Function? onError,
  //   VoidCallback? onDone,
  //   bool? cancelOnError,
  // }) async {
  //   if (_pluginStream != null) {
  //     return;
  //   }
  //   _pluginStream = _loginEventChannel.receiveBroadcastStream();
  //   _streamSubscription = _pluginStream!.listen(
  //     onData,
  //     onError: onError,
  //     onDone: onDone,
  //     cancelOnError: cancelOnError,
  //   );
  // }
  //
  // static FutureOr<bool> removeListener() async {
  //   if (_streamSubscription == null) {
  //     return false;
  //   }
  //   //call this method will trigger native side: [EventChannel.EventSink]#endOfStream,flutter side:[Stream]#onDone
  //   await _methodChannel.invokeMethod('cancelStream');
  //   _streamSubscription!.cancel();
  //   _streamSubscription = null;
  //   _pluginStream = null;
  //   return true;
  // }
  //
  // /// 判断网络是否支持，一般不需要主动调用
  // static Future<void> checkVerifyEnable() {
  //   ///{msg: 无SIM卡, requestId: 941e9389efee47b9, resultCode: 600007}
  //   return _methodChannel.invokeMethod("checkEnv");
  // }
  //
  // /// 预取号，一般不需要主动调用
  // static Future<void> accelerateLoginPage() {
  //   return _methodChannel.invokeMethod('accelerateLoginPage');
  // }

  /// 检查版本
  static Future<dynamic> get version {
    return _methodChannel.invokeMethod('getAliAuthVersion');
  }

  /// 关闭授权页loading
  /// 安卓 SDK完成回调之后不会关闭loading，需要开发者主动调用hideLoginLoading关闭loading
  /// IOS 手动隐藏一键登录获取登录Token之后的等待动画，默认为自动隐藏
  static Future<void> hideLoginLoading() {
    return _methodChannel.invokeMethod("hideLoginLoading");
  }

  /// 退出授权认证页,IOS一般不用主动调用，除非个人需要，安卓看情况
  /// 安卓 SDK完成回调之后不会关闭授权页，需要开发者主动调⽤quitLoginPage退出授权页
  /// IOS 注销授权页，建议用此方法，对于移动卡授权页的消失会清空一些数据
  static Future<void> quitLoginPage() {
    return _methodChannel.invokeMethod("quitLoginPage");
  }
}
