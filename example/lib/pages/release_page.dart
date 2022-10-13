import 'package:flutter/material.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_ali_auth_example/main.dart';

class ReleasePage extends StatefulWidget {
  const ReleasePage({Key? key}) : super(key: key);

  @override
  State<ReleasePage> createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage> {
  final AuthConfig _authConfig = AuthConfig(
    iosSdk:
        "HoeXxTF5epZEkjl3bqTgjPmnpIoufj10VOnSGoZAHE0S2wvv95eWAzV18vTllsaDXAdjoDOsCe4curE7IblQqHGP9cBQiCsjSQcAQJGbKkSa27/zbgENswdjiVF91SDMtHiVT0lok13kyI1fCg0bHWxvPQXG9zYszxUy9svAGL8hfHuoQGoatuK6xe6Zwb18MrtfpCAabeU7K0gtMJxf0sPAVUvwLupuq98uWPcTgqq5swkRp13kOq7Kv/YAADfK65XqGv0RDCMSSpN08lJDbd+L/stVtooIhJwyy4MXE4A=",
    androidSdk:
        "cDayqs3OUxdTERwuS4cCSEHuTqqsEvva7nkfdxKqfxAOIq46rES8NiSGFzU7xyk1qD02WkPsLAwfs82Oi1xpn+cOv3lr4nUzcsjdIgzgphoLlky9JKcMkGZW9i6ZM6WX8o9htuufxJV90bEtHYH/im5ZLxVDB1hbAi1Bg4zZ9sHeG160cAt0lLmAh3btrKvPqglD++Zel5L0N/Y4bVm2hvgRqusRvHW8Uqng9MzHOc9FgW9oXoA1AwvyQWXRXR98Hh2gBiF2VJGL1fwgkC2xFUvzIM2sMw5JMJ8KxRspWmKyLIp1EOOgUd6bY4TctbzX2DGgiTPtdrVF3ZZ8q6BCQQ==",
    enableLog: false,
    authUIStyle: AuthUIStyle.fullScreen,
    authUIConfig: FullScreenUIConfig(
      navConfig: NavConfig(navColor: Colors.pinkAccent.toHex()),
      logoConfig: const LogoConfig(logoImage: "images/app_icon"),
    ),
  );

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
