import '../auth_config/part_ui_config.dart';
import 'auth_ui_config.dart';

part 'alert_ui_config.g.dart';

class AlertUIConfig extends AuthUIConfig {
  const AlertUIConfig({
    this.alertTitleBarConfig,
    this.alertContentViewColor,
    this.alertBlurViewColor,
    this.alertBlurViewAlpha,
    this.alertBorderRadius,
    this.alertWindowHeight,
    this.alertWindowWidth,
    super.logoConfig,
    super.sloganConfig,
    super.phoneNumberConfig,
    super.loginButtonConfig,
    super.changeButtonConfig,
    super.checkBoxConfig,
    super.privacyConfig,
  });

  final AlertTitleBarConfig? alertTitleBarConfig;

  ///十六进制的颜色
  final String? alertContentViewColor;

  ///底部蒙层背景颜色，默认黑色
  final String? alertBlurViewColor;

  ///底部蒙层背景透明度，默认0.5
  final double? alertBlurViewAlpha;

  /// 四个角的圆角，默认为10
  final double? alertBorderRadius;
  final double? alertWindowWidth;
  final double? alertWindowHeight;

  @override
  Map<String, dynamic> toJson() {
    return {
      'alertContentViewColor': alertContentViewColor,
      'alertBlurViewColor': alertBlurViewColor,
      'alertBlurViewAlpha': alertBlurViewAlpha,
      'alertBorderRadius': alertBorderRadius,
      'alertWindowWidth': alertWindowWidth,
      'alertWindowHeight': alertWindowHeight,
      'customViewBlockList':
          customViewBlockList?.map((e) => e.toJson()).toList(growable: false),
      ...?alertTitleBarConfig?.toJson(),
      ...?logoConfig?.toJson(),
      ...?sloganConfig?.toJson(),
      ...?phoneNumberConfig?.toJson(),
      ...?loginButtonConfig?.toJson(),
      ...?changeButtonConfig?.toJson(),
      ...?checkBoxConfig?.toJson(),
      ...?privacyConfig?.toJson(),
    }..removeWhere((key, value) => value == null);
  }

  @override
  String toString() {
    return 'AlertUIConfig${toJson()}';
  }
}
