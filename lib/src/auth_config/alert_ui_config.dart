import 'dart:convert' show jsonEncode;

import '../auth_config/part_ui_config.dart';
import 'auth_ui_config.dart';

part 'alert_ui_config.g.dart';

class AlertUIConfig extends AuthUIConfig {
  final AlertTitleBarConfig? alertTitleBarConfig;
  final String? alertContentViewColor; //十六进制的颜色
  final String? alertBlurViewColor; //底部蒙层背景颜色，默认黑色
  final double? alertBlurViewAlpha; //底部蒙层背景透明度，默认0.5
  final double? alertBorderRadius; // 四个角的圆角，默认为10
  final double? alertWindowWidth;
  final double? alertWindowHeight;

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

  @override
  MapWithStringKey toJson() {
    final json = <String, dynamic>{};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }

    writeNotNull('alertContentViewColor', alertContentViewColor);
    writeNotNull('alertBlurViewColor', alertBlurViewColor);
    writeNotNull('alertBlurViewAlpha', alertBlurViewAlpha);
    writeNotNull('alertBorderRadius', alertBorderRadius);
    writeNotNull('alertWindowWidth', alertWindowWidth);
    writeNotNull('alertWindowHeight', alertWindowHeight);
    if (customViewBlockList != null &&
        (customViewBlockList?.isNotEmpty ?? false)) {
      List<String> customViewBlockJsonList = <String>[];
      for (final element in customViewBlockList!) {
        customViewBlockJsonList.add(jsonEncode(element));
      }
      json['customViewBlockList'] = customViewBlockJsonList;
    }
    if (alertTitleBarConfig != null) {
      json.addAll(alertTitleBarConfig!.toJson());
    }
    if (logoConfig != null) {
      json.addAll(logoConfig!.toJson());
    }
    if (sloganConfig != null) {
      json.addAll(sloganConfig!.toJson());
    }
    if (phoneNumberConfig != null) {
      json.addAll(phoneNumberConfig!.toJson());
    }
    if (loginButtonConfig != null) {
      json.addAll(loginButtonConfig!.toJson());
    }
    if (changeButtonConfig != null) {
      json.addAll(changeButtonConfig!.toJson());
    }
    if (checkBoxConfig != null) {
      json.addAll(checkBoxConfig!.toJson());
    }
    if (privacyConfig != null) {
      json.addAll(privacyConfig!.toJson());
    }
    return json;
  }
}
