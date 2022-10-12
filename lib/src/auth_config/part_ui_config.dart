part of flutter_ali_auth;

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
@CopyWith(skipFields: true, copyWithNull: false)
class NavConfig {
  bool? navIsHidden;
  String? navTitle;
  String? navTitleColor;
  int? navTitleSize;
  double? navFrameOffsetX;
  double? navFrameOffsetY;

  String? navColor;

  bool? hideNavBackItem;

  String? navBackImage;
  double? navBackButtonOffsetX;
  double? navBackButtonOffsetY;

  NavConfig({
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
@CopyWith(skipFields: true, copyWithNull: false)
class AlertTitleBarConfig {
  bool? alertBarIsHidden;
  bool? alertCloseItemIsHidden;
  String? alertTitleBarColor;

  String? alertTitleText;
  String? alertTitleTextColor;
  int? alertTittleTextSize;

  String? alertCloseImage;
  double? alertCloseImageOffsetX;
  double? alertCloseImageOffsetY;

  AlertTitleBarConfig({
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
@CopyWith(skipFields: true, copyWithNull: false)
class LogoConfig {
  bool? logoIsHidden; //默认显示
  String? logoImage;
  double? logoWidth;
  double? logoHeight;

  double? logoFrameOffsetX;
  double? logoFrameOffsetY;

  LogoConfig({
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
@CopyWith(skipFields: true, copyWithNull: false)
class SloganConfig {
  bool? sloganIsHidden;
  String? sloganText;
  String? sloganTextColor;
  int? sloganTextSize;

  double? sloganFrameOffsetX;
  double? sloganFrameOffsetY;

  SloganConfig({
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
@CopyWith(skipFields: true, copyWithNull: false)
class PhoneNumberConfig {
  String? numberColor;
  int? numberFontSize;

  double? numberFrameOffsetX;
  double? numberFrameOffsetY;

  PhoneNumberConfig({
    this.numberColor,
    this.numberFontSize,
    this.numberFrameOffsetX,
    this.numberFrameOffsetY,
  });

  MapWithStringKey toJson() => _$PhoneNumberConfigToJson(this);
}

//login button设置
@JsonSerializable(createFactory: false, includeIfNull: false)
@CopyWith(skipFields: true, copyWithNull: false)
class LoginButtonConfig {
  String? loginBtnText;
  String? loginBtnTextColor;
  int? loginBtnTextSize;

  ////登录按钮背景图片组  [激活状态的图片,失效状态的图片,高亮状态的图片]
  String? loginBtnNormalImage;
  String? loginBtnUnableImage;
  String? loginBtnPressedImage;

  double? loginBtnFrameOffsetX;
  double? loginBtnFrameOffsetY;

  double? loginBtnWidth;
  double? loginBtnHeight; //登录按钮高度 默认高度50.0pt 小于20.0pt不生效

  LoginButtonConfig({
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
@CopyWith(skipFields: true, copyWithNull: false)
class ChangeButtonConfig {
  bool? changeBtnIsHidden;
  String? changeBtnTitle;
  String? changeBtnTextColor;
  int? changeBtnTextSize;
  double? changeBtnFrameOffsetX;
  double? changeBtnFrameOffsetY;

  ChangeButtonConfig({
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
@CopyWith(skipFields: true, copyWithNull: false)
class CheckBoxConfig {
  bool? checkBoxIsChecked;
  bool? checkBoxIsHidden;
  String? checkedImage; //[uncheckedImg,checkedImg]*
  String? uncheckImage;
  double? checkBoxWH;

  CheckBoxConfig({
    this.checkBoxIsChecked,
    this.checkBoxIsHidden,
    this.checkedImage,
    this.uncheckImage,
    this.checkBoxWH,
  });

  MapWithStringKey toJson() => _$CheckBoxConfigToJson(this);
}

@JsonSerializable(createFactory: false, includeIfNull: false)
@CopyWith(skipFields: true, copyWithNull: false)
class PrivacyConfig {
  String? privacyOneName;
  String? privacyOneUrl;
  String? privacyTwoName;
  String? privacyTwoUrl;
  String? privacyThreeName;
  String? privacyThreeUrl;

  int? privacyFontSize;
  String? privacyFontColor;

  double? privacyFrameOffsetX;
  double? privacyFrameOffsetY;

  //协议名称之间连接字符串数组，默认 ["和","、","、"] ，即第一个为"和"，其他为"、"，按顺序读取，为空则取默认 ["和", "和"]
  String? privacyConnectTexts;

  // privacyAlignment	long long	0
  String? privacyPreText; // 协议文案支持居中、居左、居右设置，默认居左
  String? privacySufText;

  String? privacyOperatorPreText; //协议整体文案，后缀部分文案

  String? privacyOperatorSufText; //协议整体文案，后缀部分文案

  int? privacyOperatorIndex; // 运营商协议指定显示顺序，默认0，即第1个协议显示，最大值可为3，即第4个协议显示

  PrivacyConfig({
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

// @JsonSerializable(createFactory: false,includeIfNull: false)
// class PrivacyItem {
//   String? name;
//   String? url;
//
//   MapWithStringKey toJson() => _$PrivacyItemToJson(this);
// }
//
// //[激活状态的图片,失效状态的图片,高亮状态的图片]
// @JsonSerializable(createFactory: false,includeIfNull: false)
// class ImageConfig {
//   String? normal;
//   String? unable;
//   String? pressed;
//
//   MapWithStringKey toJson() => _$ImageConfigToJson(this);
// }
