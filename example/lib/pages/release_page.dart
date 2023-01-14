import 'package:flutter/material.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_ali_auth_example/main.dart';

class ReleasePage extends StatefulWidget {
  const ReleasePage({Key? key}) : super(key: key);

  @override
  State<ReleasePage> createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  String get iosSdk {
    // TODO: provide your own iosSdkKey
    throw UnimplementedError();
  }

  String get androidSdk {
    // TODO: provide your own iosSdkKey
    throw UnimplementedError();
  }

  late final AuthConfig _authConfig = AuthConfig(
    iosSdk: iosSdk,
    androidSdk: androidSdk,
    enableLog: false,
    authUIStyle: AuthUIStyle.fullScreen,
    authUIConfig: FullScreenUIConfig(
      navConfig: NavConfig(navColor: Colors.pinkAccent.toHex()),
      logoConfig: const LogoConfig(logoImage: "images/app_icon"),
    ),
  );

  @override
  void initState() {
    super.initState();
    //uncomment this line to initialize();
  }

  @override
  void dispose() {
    AliAuthClient.removeListener();
    super.dispose();
  }

  void initialize() {
    try {
      AliAuthClient.onListen(
        _onEvent,
        onError: _onError,
        onDone: () {
          ///remove listener will trigger onDone
          debugPrint('$runtimeType onDone');
        },
      );
    } catch (e) {
      //SmartDialog.showToast('注册监听失败');
    }
  }

  /// 登录成功处理
  void _onEvent(dynamic event) async {
    //print(event);
  }

  /// 登录错误处理
  void _onError(Object error) {
    //print(error);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: const Text('初始化SDK'),
            onPressed: () async {
              await AliAuthClient.onListen(_onEvent, onError: _onError);
              await AliAuthClient.initSdk(
                authConfig: _authConfig,
              );
              //print(res);
            },
          ),
          ElevatedButton(
            child: const Text('一键登陆'),
            onPressed: () async {
              await AliAuthClient.login();
            },
          ),
        ],
      ),
    );
  }
}
