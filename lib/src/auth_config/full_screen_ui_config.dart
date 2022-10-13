import '../auth_config/part_ui_config.dart';
import 'auth_ui_config.dart';

part 'full_screen_ui_config.g.dart';

class FullScreenUIConfig extends AuthUIConfig {
  final NavConfig? navConfig;
  final String? backgroundColor; //十六进制的颜色
  final String? backgroundImage;
  final bool? prefersStatusBarHidden; //状态栏是否隐藏，默认显示

  const FullScreenUIConfig({
    this.navConfig,
    this.backgroundImage,
    this.backgroundColor,
    this.prefersStatusBarHidden,
    super.logoConfig,
    super.sloganConfig,
    super.phoneNumberConfig,
    super.loginButtonConfig,
    super.changeButtonConfig,
    super.checkBoxConfig,
    super.privacyConfig,
    super.customViewBlockList,
  });

  @override
  MapWithStringKey toJson() {
    final json = <String, dynamic>{};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }

    writeNotNull('backgroundColor', backgroundColor);
    writeNotNull('backgroundImage', backgroundImage);
    writeNotNull('prefersStatusBarHidden', prefersStatusBarHidden);
    if (customViewBlockList != null &&
        (customViewBlockList?.isNotEmpty ?? false)) {
      List<MapWithStringKey> customViewBlockJsonList = <MapWithStringKey>[];
      for (final element in customViewBlockList!) {
        customViewBlockJsonList.add(element.toJson());
      }
      json['customViewBlockList'] = customViewBlockJsonList;
    }
    if (navConfig != null) {
      json.addAll(navConfig!.toJson());
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
