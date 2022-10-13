import 'dart:ui' show Color;

import 'package:json_annotation/json_annotation.dart';

part 'part_ui_config.g.dart';

typedef MapWithStringKey = Map<String, dynamic>;

enum AuthUIStyle {
  fullScreen,
  bottomSheet,
  alert,
}

extension HexColor on Color {
  String get toHex {
    int ignoreAlpha = 0xFFFFFF & value;
    return '#${ignoreAlpha.toRadixString(16).padLeft(6, '0')}';
  }
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class NavConfig {
  final bool? navIsHidden;
  final String? navTitle;
  final String? navTitleColor;
  final int? navTitleSize;
  final double? navFrameOffsetX;
  final double? navFrameOffsetY;

  final String? navColor;

  final bool? hideNavBackItem;

  final String? navBackImage;
  final double? navBackButtonOffsetX;
  final double? navBackButtonOffsetY;

  const NavConfig({
    this.navIsHidden,
    this.navTitle,
    this.navTitleColor,
    this.navTitleSize,
    this.navFrameOffsetX,
    this.navFrameOffsetY,
    this.navColor,
    this.hideNavBackItem,
    this.navBackImage,
    this.navBackButtonOffsetX,
    this.navBackButtonOffsetY,
  });

  MapWithStringKey toJson() => _$NavConfigToJson(this);
}

//alert title bar 设置 仅弹窗生效
@JsonSerializable(createFactory: false, includeIfNull: false)
class AlertTitleBarConfig {
  final bool? alertBarIsHidden;
  final bool? alertCloseItemIsHidden;
  final String? alertTitleBarColor;

  final String? alertTitleText;
  final String? alertTitleTextColor;
  final int? alertTittleTextSize;

  final String? alertCloseImage;
  final double? alertCloseImageOffsetX;
  final double? alertCloseImageOffsetY;

  const AlertTitleBarConfig({
    this.alertBarIsHidden,
    this.alertCloseItemIsHidden,
    this.alertTitleBarColor,
    this.alertTitleText,
    this.alertTitleTextColor,
    this.alertTittleTextSize,
    this.alertCloseImage,
    this.alertCloseImageOffsetY,
    this.alertCloseImageOffsetX,
  });

  MapWithStringKey toJson() => _$AlertTitleBarConfigToJson(this);
}

//logo设置
@JsonSerializable(createFactory: false, includeIfNull: false)
class LogoConfig {
  final bool? logoIsHidden; //默认显示
  final String? logoImage;
  final double? logoWidth;
  final double? logoHeight;

  final double? logoFrameOffsetX;
  final double? logoFrameOffsetY;

  const LogoConfig({
    this.logoIsHidden,
    this.logoImage,
    this.logoWidth,
    this.logoHeight,
    this.logoFrameOffsetX,
    this.logoFrameOffsetY,
  });

  MapWithStringKey toJson() => _$LogoConfigToJson(this);
}

//slogan设置
@JsonSerializable(createFactory: false, includeIfNull: false)
class SloganConfig {
  final bool? sloganIsHidden;
  final String? sloganText;
  final String? sloganTextColor;
  final int? sloganTextSize;

  final double? sloganFrameOffsetX;
  final double? sloganFrameOffsetY;

  const SloganConfig({
    this.sloganIsHidden,
    this.sloganText,
    this.sloganTextColor,
    this.sloganTextSize,
    this.sloganFrameOffsetX,
    this.sloganFrameOffsetY,
  });

  MapWithStringKey toJson() => _$SloganConfigToJson(this);
}

//phone number设置
@JsonSerializable(createFactory: false, includeIfNull: false)
class PhoneNumberConfig {
  final String? numberColor;
  final int? numberFontSize;

  final double? numberFrameOffsetX;
  final double? numberFrameOffsetY;

  const PhoneNumberConfig({
    this.numberColor,
    this.numberFontSize,
    this.numberFrameOffsetX,
    this.numberFrameOffsetY,
  });

  MapWithStringKey toJson() => _$PhoneNumberConfigToJson(this);
}

//login button设置
@JsonSerializable(createFactory: false, includeIfNull: false)
class LoginButtonConfig {
  final String? loginBtnText;
  final String? loginBtnTextColor;
  final int? loginBtnTextSize;

  ////登录按钮背景图片组  [激活状态的图片,失效状态的图片,高亮状态的图片]
  final String? loginBtnNormalImage;
  final String? loginBtnUnableImage;
  final String? loginBtnPressedImage;

  final double? loginBtnFrameOffsetX;
  final double? loginBtnFrameOffsetY;

  final double? loginBtnWidth;
  final double? loginBtnHeight; //登录按钮高度 默认高度50.0pt 小于20.0pt不生效

  const LoginButtonConfig({
    this.loginBtnText,
    this.loginBtnTextColor,
    this.loginBtnTextSize,
    this.loginBtnNormalImage,
    this.loginBtnUnableImage,
    this.loginBtnPressedImage,
    this.loginBtnFrameOffsetX,
    this.loginBtnFrameOffsetY,
    this.loginBtnWidth,
    this.loginBtnHeight,
  });

  MapWithStringKey toJson() => _$LoginButtonConfigToJson(this);
}

// change button 设置
@JsonSerializable(createFactory: false, includeIfNull: false)
class ChangeButtonConfig {
  final bool? changeBtnIsHidden;
  final String? changeBtnTitle;
  final String? changeBtnTextColor;
  final int? changeBtnTextSize;
  final double? changeBtnFrameOffsetX;
  final double? changeBtnFrameOffsetY;

  const ChangeButtonConfig({
    this.changeBtnIsHidden,
    this.changeBtnTitle,
    this.changeBtnTextColor,
    this.changeBtnTextSize,
    this.changeBtnFrameOffsetX,
    this.changeBtnFrameOffsetY,
  });

  MapWithStringKey toJson() => _$ChangeButtonConfigToJson(this);
}

//check box 设置
@JsonSerializable(createFactory: false, includeIfNull: false)
class CheckBoxConfig {
  final bool? checkBoxIsChecked;
  final bool? checkBoxIsHidden;
  final String? checkedImage; //[uncheckedImg,checkedImg]*
  final String? uncheckImage;
  final double? checkBoxWH;

  const CheckBoxConfig({
    this.checkBoxIsChecked,
    this.checkBoxIsHidden,
    this.checkedImage,
    this.uncheckImage,
    this.checkBoxWH,
  });

  MapWithStringKey toJson() => _$CheckBoxConfigToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class PrivacyConfig {
  final String? privacyOneName;
  final String? privacyOneUrl;
  final String? privacyTwoName;
  final String? privacyTwoUrl;
  final String? privacyThreeName;
  final String? privacyThreeUrl;

  final int? privacyFontSize;
  final String? privacyFontColor;

  final double? privacyFrameOffsetX;
  final double? privacyFrameOffsetY;

  //协议名称之间连接字符串数组，默认 ["和","、","、"] ，即第一个为"和"，其他为"、"，按顺序读取，为空则取默认 ["和", "和"]
  final String? privacyConnectTexts;

  // privacyAlignment	long long	0
  final String? privacyPreText; // 协议文案支持居中、居左、居右设置，默认居左
  final String? privacySufText;

  final String? privacyOperatorPreText; //协议整体文案，后缀部分文案

  final String? privacyOperatorSufText; //协议整体文案，后缀部分文案

  final int? privacyOperatorIndex; // 运营商协议指定显示顺序，默认0，即第1个协议显示，最大值可为3，即第4个协议显示

  const PrivacyConfig({
    this.privacyOneName,
    this.privacyOneUrl,
    this.privacyConnectTexts,
    this.privacyFontColor,
    this.privacyFontSize,
    this.privacyFrameOffsetX,
    this.privacyFrameOffsetY,
    this.privacyOperatorIndex,
    this.privacyOperatorPreText,
    this.privacyOperatorSufText,
    this.privacyPreText,
    this.privacySufText,
    this.privacyThreeName,
    this.privacyThreeUrl,
    this.privacyTwoName,
    this.privacyTwoUrl,
  });

  MapWithStringKey toJson() => _$PrivacyConfigToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
class CustomViewBlock {
  final int viewId; // 用于回调时候判断返回的Id判断
  final String? text;
  final String? textColor;
  final double? textSize;
  final String? backgroundColor;
  final String? image;
  final double offsetX;
  final double offsetY;
  final double width;
  final double height;

  const CustomViewBlock({
    required this.viewId,
    required this.offsetX,
    required this.offsetY,
    required this.width,
    required this.height,
    this.text,
    this.textColor,
    this.textSize,
    this.backgroundColor,
    this.image,
  });

  MapWithStringKey toJson() => _$CustomViewBlockToJson(this);
}
