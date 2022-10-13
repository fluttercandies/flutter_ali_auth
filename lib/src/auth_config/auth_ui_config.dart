import '../auth_config/part_ui_config.dart';

abstract class AuthUIConfig {
  const AuthUIConfig({
    this.logoConfig,
    this.sloganConfig,
    this.phoneNumberConfig,
    this.loginButtonConfig,
    this.changeButtonConfig,
    this.checkBoxConfig,
    this.privacyConfig,
    this.customViewBlockList,
  });

  final LogoConfig? logoConfig;
  final SloganConfig? sloganConfig;
  final PhoneNumberConfig? phoneNumberConfig;
  final LoginButtonConfig? loginButtonConfig;
  final ChangeButtonConfig? changeButtonConfig;
  final CheckBoxConfig? checkBoxConfig;
  final PrivacyConfig? privacyConfig;
  final List<CustomViewBlock>? customViewBlockList;

  Map<String, dynamic> toJson();
}
