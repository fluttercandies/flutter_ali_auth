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
  final ScrollController _scrollController = ScrollController();
  final List<String> _logs = <String>[];

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

  @override
  void dispose() {
    AliAuthClient.removeListener();
    _scrollController.dispose();
    super.dispose();
  }

  /// 登录页面点击事件回调处理
  void _onEvent(dynamic event) async {
    final responseModel = AuthResponseModel.fromJson(Map.from(event));
    final AuthResultCode resultCode =
        AuthResultCode.fromCode(responseModel.resultCode!);
    _addLog('[${resultCode.code}] ${resultCode.message}');
    switch (resultCode) {
      case AuthResultCode.success:
        if (responseModel.token != null && responseModel.token!.isNotEmpty) {
          //验证成功，获取到token
          // await onToken(token: responseModel.token!);
          _addLog('验证成功! token: ${responseModel.token!}');
        }
        break;
      case AuthResultCode.envCheckFail:
        SmartDialog.showToast("当前网络环境不支持一键登录，请稍后重试(${resultCode.code})");
        break;
      case AuthResultCode.noCellularNetwork:
        SmartDialog.showToast('移动数据网络未开启,请切换为移动网络后再尝试(${resultCode.code})');
        break;
      case AuthResultCode.loginControllerClickChangeBtn:
        //点击切换按钮，切换到其他方式
        // showSignDialog();
        break;
      case AuthResultCode.noSIMCard:
        SmartDialog.showToast("当前设备不支持一键登录(${resultCode.code})");
        break;
      case AuthResultCode.getMaskPhoneSuccess:
        SmartDialog.showToast('预先取号成功');
        break;
      case AuthResultCode.envCheckSuccess:
        SmartDialog.showToast('当前环境支持一键登录');
        break;
      case AuthResultCode.unknownError:
      case AuthResultCode.getTokenFailed:
      case AuthResultCode.interfaceTimeout:
      case AuthResultCode.loginControllerPresentFailed:
      case AuthResultCode.decodeAppInfoFailed:
        SmartDialog.showToast('暂时无法一键登录，请使用其他登录方式(${resultCode.code})');
        break;
      case AuthResultCode.codeSDKInfoInvalid:
        SmartDialog.showToast('SDK设置错误');
        break;
      case AuthResultCode.interfaceDemoted:
      case AuthResultCode.interfaceLimited:
      case AuthResultCode.featureInvalid:
      case AuthResultCode.outOfService:
        SmartDialog.showToast('暂时无法一键登录，请使用其他登录方式(${resultCode.code})');
        break;
      case AuthResultCode.failed:
      case AuthResultCode.errorNetwork:
      case AuthResultCode.errorClientTimestamp:
      case AuthResultCode.statusBusy:
        SmartDialog.showToast('请求遇到问题，请稍后重试(${resultCode.code})');
        break;
      case AuthResultCode.onCustomViewTap:
        break;
      case AuthResultCode.getMaskPhoneFailed:
      case AuthResultCode.carrierChanged:
      case AuthResultCode.callPreLoginInAuthPage:
      case AuthResultCode.liftBodyVerifyReadyStating:
      case AuthResultCode.getOperatorInfoFailed:
      case AuthResultCode.unknownOperator:
        SmartDialog.showToast('一键登录暂时不可用，请稍后再试(${resultCode.code})');
        break;
      case AuthResultCode.loginControllerPresentSuccess:
        SmartDialog.showToast('唤起授权页成功');
        break;
      case AuthResultCode.loginControllerClickLoginBtn:
      case AuthResultCode.loginControllerClickCancel:
      case AuthResultCode.loginControllerClickCheckBoxBtn:
      case AuthResultCode.loginControllerClickProtocol:
      case AuthResultCode.loginClickPrivacyAlertView:
      case AuthResultCode.loginPrivacyAlertViewClose:
      case AuthResultCode.loginPrivacyAlertViewClickContinue:
      case AuthResultCode.loginPrivacyAlertViewPrivacyContentClick:
        debugPrint(responseModel.toString());
        //SmartDialog.showToast('一键登录暂时不可用，请稍后再试(${resultCode.code})');
        //AliAuthClient.quitLoginPage();
        break;
    }
  }

  /// 登录错误处理
  void _onError(Object error) {
    //print("-------------失败分割线------------");
    debugPrint("error:$error");
  }

  void _addLog(String log) {
    if (mounted) {
      setState(() {
        _logs.insert(0, log);
      });
      debugPrint(log);
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 200),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        _divider('初始化操作'),
        Flexible(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: const Text('注册监听'),
                  onPressed: () async {
                    try {
                      await AliAuthClient.onListen(
                        _onEvent,
                        onError: _onError,
                        onDone: () {
                          ///remove listener will trigger onDone
                          debugPrint('$runtimeType onDone');
                        },
                      );
                      SmartDialog.showToast('注册监听成功');
                      _addLog('注册监听成功');
                    } catch (e) {
                      SmartDialog.showToast('注册监听失败');
                      _addLog('注册监听失败');
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
                ElevatedButton(
                  child: const Text('取消登录事件监听'),
                  onPressed: () async {
                    try {
                      final success = await AliAuthClient.removeListener();
                      if (!success) {
                        SmartDialog.showToast("你还没对登录事件进行监听");
                        _addLog('你还没对登录事件进行监听');
                      } else {
                        SmartDialog.showToast("取消监听成功");
                        _addLog('取消监听成功');
                      }
                    } catch (e) {
                      SmartDialog.dismiss(status: SmartStatus.loading);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        _divider('授权页面操作'),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: [
              OutlinedButton(
                child: _iconWithLabel(
                  icon: Icons.phone_android,
                  label: '全屏',
                ),
                onPressed: () async {
                  _authConfig.authUIStyle = AuthUIStyle.fullScreen;
                  _authConfig.authUIConfig = _extraUIBuilder(context);
                  await AliAuthClient.loginWithConfig(_authConfig);
                },
              ),
              OutlinedButton(
                child: _iconWithLabel(
                  icon: Icons.call_to_action_outlined,
                  label: '底部弹窗',
                ),
                onPressed: () async {
                  const alertConfig = AlertUIConfig(
                    logoConfig: LogoConfig(
                      logoIsHidden: false,
                      logoImage: "images/flutter_candies_logo.png",
                    ),
                    sloganConfig: SloganConfig(
                      sloganIsHidden: false,
                      sloganText: '哈哈哈哈',
                    ),
                    changeButtonConfig: ChangeButtonConfig(
                      changeBtnIsHidden: true,
                    ),
                    loginButtonConfig: LoginButtonConfig(
                      loginBtnHeight: kMinInteractiveDimension,
                    ),
                  );
                  _authConfig.authUIStyle = AuthUIStyle.bottomSheet;
                  _authConfig.authUIConfig = alertConfig;
                  await AliAuthClient.loginWithConfig(_authConfig);
                },
              ),
              OutlinedButton(
                child: _iconWithLabel(
                  icon: Icons.video_label,
                  label: '弹窗',
                ),
                onPressed: () async {
                  _authConfig.authUIStyle = AuthUIStyle.alert;
                  _authConfig.authUIConfig = const AlertUIConfig(
                    logoConfig: LogoConfig(
                      logoIsHidden: false,
                      logoImage: "images/flutter_candies_logo.png",
                    ),
                    sloganConfig: SloganConfig(
                      sloganIsHidden: false,
                      sloganText: '666',
                    ),
                  );
                  await AliAuthClient.loginWithConfig(_authConfig);
                },
              ),
            ],
          ),
        ),
        _divider("操作日志"),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            margin: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 8.0,
            ),
            decoration: ShapeDecoration(
              color: Colors.grey.shade200,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: ListView(
              reverse: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              children: List.generate(_logs.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: SelectableText(
                    _logs.elementAt(index),
                  ),
                );
              }),
            ),
          ),
        ),

        //if (_token != null) _tokenWidget()
      ],
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
