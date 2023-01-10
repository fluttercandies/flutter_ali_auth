import 'auth_ui_config.dart';
import 'part_ui_config.dart';

//part 'auth_config.g.dart';

class AuthConfig {
  AuthConfig({
    required this.iosSdk,
    required this.androidSdk,
    required this.enableLog,
    this.authUIStyle = AuthUIStyle.fullScreen,
    this.authUIConfig,
  });

  final String iosSdk;
  final String androidSdk;
  AuthUIStyle authUIStyle;
  AuthUIConfig? authUIConfig;
  final bool enableLog;

  Map<String, dynamic> toJson() {
    return {
      'iosSdk': iosSdk,
      'androidSdk': androidSdk,
      'enableLog': enableLog,
      'authUIStyle': authUIStyle.index,
      ...?authUIConfig?.toJson(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'AuthConfig{iosSdk: $iosSdk, androidSdk: $androidSdk, authUIStyle: $authUIStyle, authUIConfig: $authUIConfig, enableLog: $enableLog}';
  }
}
