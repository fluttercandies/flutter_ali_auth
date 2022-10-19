import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ali_auth_platform_interface.dart';

/// An implementation of [FlutterAliAuthPlatform] that uses method channels.
class MethodChannelFlutterAliAuth extends FlutterAliAuthPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ali_auth');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
