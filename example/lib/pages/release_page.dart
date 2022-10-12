import 'package:flutter/material.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';

class ReleasePage extends StatefulWidget {
  const ReleasePage({Key? key}) : super(key: key);

  @override
  State<ReleasePage> createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  final AuthConfig _authConfig = AuthConfig(
    iosSdk:
        "EEGVnUjgK/lcFybx8iobKUqab8H9W6wL9RVPKljmwO2ry6w09qN5sP2JL1SQl14Fsz/ljtsrZMmrCbRPOb2fxHVUoDrwTZVrZ3jWVcjiCi0ousFGZNj+HGb90LAWDwt6oCyDLPayy2ktuowEPDIQFU3U8fcuB/Oc5wDUKT+HS/CeY4fB5ZQMsjVv0EkGTqkFbhReOV0h0IqBkRMdUyngXyTB/y+QLB1EeDgW4zX91nQSsaVqRrYYb5zK8EL4JrNXA1TLDpE6+dc9Ceun4791rQ==",
    androidSdk: "",
    authUIStyle: AuthUIStyle.fullScreen,
    authUIConfig: FullScreenUIConfig(
      navConfig: NavConfig(
        navColor: Colors.pinkAccent.toHex,
      ),
      logoConfig: LogoConfig(
        logoImage: "images/app_icon",
      ),
    ),
  );

  /// 登录成功处理
  void _onEvent(dynamic event) async {
    //print("-------------成功分割线-------------");
    print(event);
  }

  /// 登录错误处理
  void _onError(Object error) {
    print("-------------失败分割线------------");
    print(error);
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
              final res = await AliAuthClient.initSdk(
                authConfig: _authConfig,
              );
              print(res);
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
