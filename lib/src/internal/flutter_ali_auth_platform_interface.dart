import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ali_auth_method_channel.dart';

abstract class FlutterAliAuthPlatform extends PlatformInterface {
  /// Constructs a FlutterAliAuthPlatform.
  FlutterAliAuthPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAliAuthPlatform _instance = MethodChannelFlutterAliAuth();

  /// The default instance of [FlutterAliAuthPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAliAuth].
  static FlutterAliAuthPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAliAuthPlatform] when
  /// they register themselves.
  static set instance(FlutterAliAuthPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
