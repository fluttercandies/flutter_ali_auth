import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_ali_auth_example/main.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String? _token;

  final AuthConfig _authConfig = AuthConfig(
    iosSdk:
        "HoeXxTF5epZEkjl3bqTgjPmnpIoufj10VOnSGoZAHE0S2wvv95eWAzV18vTllsaDXAdjoDOsCe4curE7IblQqHGP9cBQiCsjSQcAQJGbKkSa27/zbgENswdjiVF91SDMtHiVT0lok13kyI1fCg0bHWxvPQXG9zYszxUy9svAGL8hfHuoQGoatuK6xe6Zwb18MrtfpCAabeU7K0gtMJxf0sPAVUvwLupuq98uWPcTgqq5swkRp13kOq7Kv/YAADfK65XqGv0RDCMSSpN08lJDbd+L/stVtooIhJwyy4MXE4A=",
    androidSdk:
        "cDayqs3OUxdTERwuS4cCSEHuTqqsEvva7nkfdxKqfxAOIq46rES8NiSGFzU7xyk1qD02WkPsLAwfs82Oi1xpn+cOv3lr4nUzcsjdIgzgphoLlky9JKcMkGZW9i6ZM6WX8o9htuufxJV90bEtHYH/im5ZLxVDB1hbAi1Bg4zZ9sHeG160cAt0lLmAh3btrKvPqglD++Zel5L0N/Y4bVm2hvgRqusRvHW8Uqng9MzHOc9FgW9oXoA1AwvyQWXRXR98Hh2gBiF2VJGL1fwgkC2xFUvzIM2sMw5JMJ8KxRspWmKyLIp1EOOgUd6bY4TctbzX2DGgiTPtdrVF3ZZ8q6BCQQ==",
    enableLog: false,
    authUIStyle: AuthUIStyle.fullScreen,
    authUIConfig: FullScreenUIConfig(
      navConfig: NavConfig(navColor: Colors.cyan.toHex()),
      logoConfig: const LogoConfig(
        logoIsHidden: false,
        logoImage: "images/flutter_candies_logo.png",
      ),
      sloganConfig: const SloganConfig(sloganText: '欢迎登录FlutterCandies'),
    ),
  );

  /// 登录成功处理
  void _onEvent(dynamic event) async {
    final responseModel = AuthResponseModel.fromJson(Map.from(event));
    final resultCode = AuthResultCode.fromCode(responseModel.resultCode!);
    switch (resultCode) {
      case AuthResultCode.success:
        if (responseModel.token != null) {
          setState(() {
            _token = responseModel.token;
          });
        }
        break;
      case AuthResultCode.envCheckFail:
        SmartDialog.showToast("当前网络环境不支持一键登录，请稍后重试");
        break;
      case AuthResultCode.noCellularNetwork:
        SmartDialog.showToast('移动数据网络未开启,请切换为移动网络后再尝试');
        break;
      case AuthResultCode.loginControllerClickChangeBtn:
        //点击切换按钮，切换到其他方式
        break;
      case AuthResultCode.noSIMCard:
        SmartDialog.showToast("当前设备不支持一键登录");
        break;
      case AuthResultCode.unknownError:
      case AuthResultCode.getTokenFailed:
      case AuthResultCode.interfaceTimeout:
      case AuthResultCode.loginControllerPresentFailed:
        SmartDialog.showToast('登录失败，请稍后重试');
        break;
      case AuthResultCode.codeSDKInfoInvalid:
        SmartDialog.showToast('SDK设置错误');
        break;
      case AuthResultCode.interfaceDemoted:
      case AuthResultCode.interfaceLimited:
      case AuthResultCode.featureInvalid:
      case AuthResultCode.outOfService:
        SmartDialog.showToast('暂时无法一键登录，请使用其他登录方式');
        break;
      case AuthResultCode.failed:
      case AuthResultCode.errorNetwork:
      case AuthResultCode.errorClientTimestamp:
      case AuthResultCode.statusBusy:
        SmartDialog.showToast('请求遇到问题，请稍后重试');
        break;
      case AuthResultCode.decodeAppInfoFailed:
        SmartDialog.showToast(responseModel.msg ?? 'SDK密钥错误');
        break;
      case AuthResultCode.onCustomViewTap:
        SmartDialog.showToast("点击自定义控件：${responseModel.msg}");
        break;
      case AuthResultCode.getMaskPhoneFailed:
      case AuthResultCode.getMaskPhoneSuccess:
      case AuthResultCode.carrierChanged:
      case AuthResultCode.loginControllerPresentSuccess:
      case AuthResultCode.callPreLoginInAuthPage:
      case AuthResultCode.loginControllerClickCancel:
      case AuthResultCode.loginControllerClickLoginBtn:
      case AuthResultCode.loginControllerClickCheckBoxBtn:
      case AuthResultCode.loginControllerClickProtocol:
      case AuthResultCode.loginClickPrivacyAlertView:
      case AuthResultCode.loginPrivacyAlertViewClose:
      case AuthResultCode.loginPrivacyAlertViewClickContinue:
      case AuthResultCode.loginPrivacyAlertViewPrivacyContentClick:
      case AuthResultCode.liftBodyVerifyReadyStating:
      case AuthResultCode.errorUserCancel:
      default:
        break;
    }
  }

  /// 登录错误处理
  void _onError(Object error) {
    //print("-------------失败分割线------------");
    debugPrint("error:$error");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _divider('初始化操作'),
            ElevatedButton(
              child: const Text('注册监听'),
              onPressed: () async {
                try {
                  await AliAuthClient.onListen(_onEvent, onError: _onError);
                  SmartDialog.showToast('注册监听成功');
                } catch (e) {
                  SmartDialog.showToast('注册监听失败');
                }
              },
            ),
            ElevatedButton(
              child: const Text('初始化SDK'),
              onPressed: () async {
                try {
                  SmartDialog.showToast("正在初始化...");
                  await AliAuthClient.initSdk(
                    authConfig: _authConfig,
                  );
                } catch (e) {
                  SmartDialog.dismiss(status: SmartStatus.loading);
                }
              },
            ),
            ElevatedButton(
              child: const Text('检查环境是否支持认证'),
              onPressed: () async {
                try {
                  await AliAuthClient.checkVerifyEnable();
                } catch (e) {
                  SmartDialog.dismiss(status: SmartStatus.loading);
                }
              },
            ),
            ElevatedButton(
              child: const Text('加速一键登录授权页弹起'),
              onPressed: () async {
                try {
                  await AliAuthClient.accelerateLoginPage();
                } catch (e) {
                  SmartDialog.dismiss(status: SmartStatus.loading);
                }
              },
            ),
            _divider('授权页面操作'),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                children: [
                  OutlinedButton(
                    child: _iconWithLabel(
                      icon: Icons.phone_android,
                      label: '全屏',
                    ),
                    onPressed: () async {
                      final extraUIConfig = _extraUIBuilder(context);
                      await AliAuthClient.loginWithConfig(
                        _authConfig.copyWith(
                          authUIConfig: extraUIConfig,
                        ),
                      );
                    },
                  ),
                  OutlinedButton(
                    child: _iconWithLabel(
                      icon: Icons.call_to_action_outlined,
                      label: '底部弹窗',
                    ),
                    onPressed: () async {
                      await AliAuthClient.loginWithConfig(_authConfig.copyWith(
                        authUIStyle: AuthUIStyle.bottomSheet,
                      ));
                    },
                  ),
                  OutlinedButton(
                    child: _iconWithLabel(
                      icon: Icons.video_label,
                      label: '弹窗',
                    ),
                    onPressed: () async {
                      await AliAuthClient.loginWithConfig(_authConfig.copyWith(
                        authUIStyle: AuthUIStyle.alert,
                      ));
                    },
                  ),
                ],
              ),
            ),
            if (_token != null) _tokenWidget()
          ],
        ),
      ),
    );
  }

  FullScreenUIConfig _extraUIBuilder(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const padding = 8.0;
    double loginSize = 100;
    double logoFrameOffsetY = (Platform.isAndroid ? 20 : 120) + kToolbarHeight;
    double sloganFrameOffsetY = logoFrameOffsetY + loginSize + padding;
    int sloganTextSize = 28;
    double numberFrameOffsetY = sloganFrameOffsetY + sloganTextSize + padding;
    int changeBtnTextSize = 14;
    double changeBtnFrameOffsetY =
        screenSize.height * (Platform.isAndroid ? 0.65 : 0.75);
    double iconSize = 48;
    double iconPadding = 12;
    double iconTotalSize = 48 * 3 + iconPadding * 2;
    double iconOffsetX1 = screenSize.width * 0.5 - iconTotalSize * 0.5;
    double iconOffsetY = changeBtnFrameOffsetY + changeBtnTextSize + 18;
    return FullScreenUIConfig(
      navConfig: const NavConfig(
        navIsHidden: true,
      ),
      backgroundImage: "images/app_bg.png",
      logoConfig: LogoConfig(
        logoIsHidden: false,
        logoImage: "images/flutter_candies_logo.png",
        logoWidth: loginSize,
        logoHeight: loginSize,
        logoFrameOffsetY: logoFrameOffsetY,
      ),
      sloganConfig: SloganConfig(
        sloganIsHidden: false,
        sloganText: '欢迎登录FlutterCandies',
        sloganTextSize: sloganTextSize,
        sloganFrameOffsetY: sloganFrameOffsetY,
      ),
      phoneNumberConfig: PhoneNumberConfig(
        numberFontSize: 24,
        numberFrameOffsetY: numberFrameOffsetY,
        numberColor: Colors.pinkAccent.toHex(),
      ),
      loginButtonConfig: const LoginButtonConfig(
        loginBtnTextColor: "#F9F9F9",
        loginBtnNormalImage: "images/login_btn_normal.png",
        loginBtnUnableImage: "images/login_btn_unable.png",
        loginBtnPressedImage: "images/login_btn_press.png",
      ),
      changeButtonConfig: ChangeButtonConfig(
        changeBtnTextColor: "#A1A1A1",
        changeBtnFrameOffsetY: changeBtnFrameOffsetY,
        changeBtnTextSize: changeBtnTextSize,
      ),
      customViewBlockList: [
        //关闭按钮
        CustomViewBlock(
          viewId: 1,
          width: 18,
          height: 18,
          offsetX: 20,
          offsetY: Platform.isAndroid ? 0 : kToolbarHeight,
          image: "images/icon_close_gray.png",
          enableTap: true,
        ),
        //其他登录方式
        CustomViewBlock(
          viewId: 2,
          width: iconSize,
          height: iconSize,
          offsetX: iconOffsetX1,
          offsetY: iconOffsetY,
          image: "images/wx.png",
          enableTap: true,
        ),
        CustomViewBlock(
          viewId: 3,
          width: iconSize,
          height: iconSize,
          offsetX: iconOffsetX1 + iconSize + iconPadding,
          offsetY: iconOffsetY,
          image: "images/tb.png",
          enableTap: true,
        ),
        CustomViewBlock(
          viewId: 4,
          width: iconSize,
          height: iconSize,
          offsetX: iconOffsetX1 + iconSize * 2 + iconPadding * 2,
          offsetY: iconOffsetY,
          image: "images/wb.png",
          enableTap: true,
        ),
      ],
    );
  }

  Widget _divider(String text) {
    const dividerGap = Flexible(flex: 2, child: Divider());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          dividerGap,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
          ),
          dividerGap,
        ],
      ),
    );
  }

  Widget _tokenWidget() {
    return Column(children: [_divider("Token"), Text(_token!)]);
  }

  Widget _iconWithLabel({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const SizedBox(height: 8.0),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}
