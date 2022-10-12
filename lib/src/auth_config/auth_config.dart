part of flutter_ali_auth;

@CopyWith(skipFields: true, copyWithNull: false)
class AuthConfig {
  final String iosSdk;
  final String androidSdk;
  final AuthUIStyle authUIStyle;
  final AuthUIConfig? authUIConfig;

  const AuthConfig({
    required this.iosSdk,
    required this.androidSdk,
    this.authUIStyle = AuthUIStyle.fullScreen,
    this.authUIConfig,
  });

  MapWithStringKey toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['iosSdk'] = iosSdk;
    json['androidSdk'] = androidSdk;
    json['authUIStyle'] = authUIStyle.index;
    if (authUIConfig != null) {
      json.addAll(authUIConfig!.toJson());
    }
    return json;
  }

  // AuthConfig copyWith({
  //   String? otherIosSdk,
  //   String? otherAndroidSdk,
  //   AuthUIStyle? otherAuthUIStyle,
  //   AuthUIConfig? otherAuthUIConfig,
  // }) {
  //   return AuthConfig(
  //     iosSdk: otherIosSdk ?? iosSdk,
  //     androidSdk: otherAndroidSdk ?? androidSdk,
  //     authUIStyle: otherAuthUIStyle ?? authUIStyle,
  //     authUIConfig: otherAuthUIConfig ?? authUIConfig,
  //   );
  // }
}
