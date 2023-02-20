import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_ali_auth_example/main.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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
    //uncomment this line to initialize sdk;
    //initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialize() {
    AliAuthClient.handleEvent(onEvent: _onEvent);
  }

  /// 登录成功处理
  Future<void> _onEvent(AuthResponseModel responseModel) async {
    final AuthResultCode resultCode = AuthResultCode.fromCode(
      responseModel.resultCode!,
    );
    switch (resultCode) {
      case AuthResultCode.success:
        if (responseModel.token != null && responseModel.token!.isNotEmpty) {
          //验证成功，获取到token
          // await onToken(token: responseModel.token!);
        }
        break;
      case AuthResultCode.envCheckSuccess:
        SmartDialog.showToast('当前环境支持一键登录');
        break;
      case AuthResultCode.getMaskPhoneSuccess:
        SmartDialog.showToast('预先取号成功');
        //预先取号成功再调起授权页面
        await AliAuthClient.login(timeout: 5);
        break;
      default:
        // implement your logic
        break;
    }
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
              try {
                AliAuthClient.initSdk(authConfig: _authConfig);
              } on PlatformException catch (e) {
                final AuthResultCode resultCode = AuthResultCode.fromCode(
                  e.code,
                );
                SmartDialog.showToast(resultCode.message);
              }
            },
          ),
          // ElevatedButton(
          //   child: const Text('一键登陆'),
          //   onPressed: () async {
          //     try {
          //       await AliAuthClient.login();
          //     } on PlatformException catch (e) {
          //       final AuthResultCode resultCode = AuthResultCode.fromCode(
          //         e.code,
          //       );
          //       SmartDialog.showToast(resultCode.message);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
