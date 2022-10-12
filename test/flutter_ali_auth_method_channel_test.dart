import 'package:flutter/services.dart';
import 'package:flutter_ali_auth/src/internal/flutter_ali_auth_method_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelFlutterAliAuth platform = MethodChannelFlutterAliAuth();
  const MethodChannel channel = MethodChannel('flutter_ali_auth');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
