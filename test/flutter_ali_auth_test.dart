import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_ali_auth/src/internal/flutter_ali_auth_method_channel.dart';
import 'package:flutter_ali_auth/src/internal/flutter_ali_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAliAuthPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAliAuthPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAliAuthPlatform initialPlatform =
      FlutterAliAuthPlatform.instance;

  test('$MethodChannelFlutterAliAuth is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAliAuth>());
  });

  test('getPlatformVersion', () async {
    MockFlutterAliAuthPlatform fakePlatform = MockFlutterAliAuthPlatform();
    FlutterAliAuthPlatform.instance = fakePlatform;

    expect(await AliAuthClient.getPlatformVersion(), '42');
  });
}
