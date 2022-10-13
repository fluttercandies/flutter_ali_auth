import 'auth_ui_config.dart';
import 'part_ui_config.dart';

part 'auth_config.g.dart';

class AuthConfig {
  const AuthConfig({
    required this.iosSdk,
    required this.androidSdk,
    required this.enableLog,
    this.authUIStyle = AuthUIStyle.fullScreen,
    this.authUIConfig,
  });

  final String iosSdk;
  final String androidSdk;
  final AuthUIStyle authUIStyle;
  final AuthUIConfig? authUIConfig;
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
}
