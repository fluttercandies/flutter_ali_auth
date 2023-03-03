import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ali_auth/flutter_ali_auth.dart';
import 'package:flutter_ali_auth_example/main.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

///TODO:导入自己的[iosSdk]和[androidSdk]
import 'config.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _logs = <String>[];

  late final AuthConfig _authConfig = AuthConfig(
    iosSdk: iosSdk,
    androidSdk: androidSdk,
    enableLog: true,
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 登录页面点击事件回调处理
  Future<void> _onEvent(AuthResponseModel responseModel) async {
    // final responseModel = AuthResponseModel.fromJson(Map.from(event));
    debugPrint('responseModel:$responseModel');
    final AuthResultCode resultCode = AuthResultCode.fromCode(
      responseModel.resultCode!,
    );
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

      case AuthResultCode.envCheckSuccess:
        SmartDialog.showToast('当前环境支持一键登录');
        break;
      case AuthResultCode.getMaskPhoneSuccess:
        SmartDialog.showToast('预先取号成功');
        break;
      case AuthResultCode.interfaceTimeout:
        SmartDialog.showToast(resultCode.message);
        break;
      case AuthResultCode.unknownError:
      case AuthResultCode.getTokenFailed:
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
      case AuthResultCode.getMaskPhoneFailed:
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
                  child: const Text('初始化SDK'),
                  onPressed: () async {
                    try {
                      SmartDialog.showToast("正在初始化...");
                      AliAuthClient.removeHandler();
                      AliAuthClient.handleEvent(onEvent: _onEvent);
                      bool? initSuccess = await AliAuthClient.initSdk(
                        authConfig: _authConfig,
                      );
                      if (!(initSuccess ?? false)) {
                        _addLog("初始化SDK失败");
                      }
                    } on PlatformException catch (e) {
                      final AuthResultCode resultCode = AuthResultCode.fromCode(
                        e.code,
                      );
                      SmartDialog.showToast(resultCode.message);
                      _addLog("初始化SDK出现错误:$e");
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
                  try {
                    _authConfig.authUIStyle = AuthUIStyle.fullScreen;
                    _authConfig.authUIConfig = _extraUIBuilder(context);
                    await AliAuthClient.loginWithConfig(
                      authConfig: _authConfig,
                      timeout: 10,
                    );
                  } on PlatformException catch (e) {
                    final AuthResultCode resultCode = AuthResultCode.fromCode(
                      e.code,
                    );
                    SmartDialog.showToast(resultCode.message);
                    _addLog("初始化SDK出现错误:$e");
                  }
                },
              ),
              OutlinedButton(
                child: _iconWithLabel(
                  icon: Icons.call_to_action_outlined,
                  label: '底部弹窗',
                ),
                onPressed: () async {
                  try {
                    ThemeData theme = Theme.of(context);
                    final alertConfig = AlertUIConfig(
                      alertContentViewColor: theme.canvasColor.toHex(),
                      alertBorderColor: theme.dividerColor.toHex(),
                      alertBorderWidth: 2.0,
                      alertBorderRadius: 20,
                      logoConfig: const LogoConfig(
                        logoIsHidden: false,
                        logoImage: "images/flutter_candies_logo.png",
                      ),
                      sloganConfig: SloganConfig(
                        sloganIsHidden: false,
                        sloganText: '欢迎登录FlutterCandies',
                        sloganTextColor: theme.colorScheme.onBackground.toHex(),
                      ),
                      changeButtonConfig: ChangeButtonConfig(
                        changeBtnIsHidden: false,
                        changeBtnTitle: '切换其他登录方式',
                        changeBtnTextSize: 12,
                        changeBtnTextColor: theme.colorScheme.onSurface.toHex(),
                      ),
                      loginButtonConfig: const LoginButtonConfig(
                        loginBtnHeight: kMinInteractiveDimension,
                      ),
                    );
                    _authConfig.authUIStyle = AuthUIStyle.bottomSheet;
                    _authConfig.authUIConfig = alertConfig;

                    await AliAuthClient.loginWithConfig(
                      authConfig: _authConfig,
                      timeout: 10,
                    );
                  } on PlatformException catch (e) {
                    final AuthResultCode resultCode = AuthResultCode.fromCode(
                      e.code,
                    );
                    SmartDialog.showToast(resultCode.message);
                    _addLog("初始化SDK出现错误:$e");
                  }
                },
              ),
              OutlinedButton(
                child: _iconWithLabel(
                  icon: Icons.video_label,
                  label: '弹窗',
                ),
                onPressed: () async {
                  try {
                    ThemeData theme = Theme.of(context);
                    _authConfig.authUIStyle = AuthUIStyle.alert;
                    _authConfig.authUIConfig = AlertUIConfig(
                      alertContentViewColor: theme.canvasColor.toHex(),
                      alertBorderColor: theme.dividerColor.toHex(),
                      alertBorderWidth: 2.0,
                      alertBorderRadius: 20,
                      logoConfig: const LogoConfig(
                        logoIsHidden: false,
                        logoImage: "images/flutter_candies_logo.png",
                      ),
                      sloganConfig: SloganConfig(
                        sloganIsHidden: false,
                        sloganText: 'Slogan text，请自行替换',
                        sloganTextColor: theme.colorScheme.onBackground.toHex(),
                      ),
                      changeButtonConfig: ChangeButtonConfig(
                        changeBtnIsHidden: false,
                        changeBtnTitle: '切换其他登录方式',
                        changeBtnTextSize: 12,
                        changeBtnTextColor: theme.colorScheme.onSurface.toHex(),
                      ),
                    );
                    await AliAuthClient.loginWithConfig(
                      authConfig: _authConfig,
                      timeout: 10000,
                    );
                  } on PlatformException catch (e) {
                    final AuthResultCode resultCode = AuthResultCode.fromCode(
                      e.code,
                    );
                    SmartDialog.showToast(resultCode.message);
                    _addLog("初始化SDK出现错误:$e");
                  }
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
              color: Theme.of(context).secondaryHeaderColor,
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
