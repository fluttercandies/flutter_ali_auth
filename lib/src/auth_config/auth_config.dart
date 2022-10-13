import 'auth_ui_config.dart';
import 'part_ui_config.dart';

part 'auth_config.g.dart';

class AuthConfig {
  const AuthConfig({
    required this.iosSdk,
    required this.androidSdk,
    this.authUIStyle = AuthUIStyle.fullScreen,
    this.authUIConfig,
  });

  final String iosSdk;
  final String androidSdk;
  final AuthUIStyle authUIStyle;
  final AuthUIConfig? authUIConfig;

  Map<String, dynamic> toJson() {
    return {
      'iosSdk': iosSdk,
      'androidSdk': androidSdk,
      'authUIStyle': authUIStyle.index,
      ...?authUIConfig?.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}
