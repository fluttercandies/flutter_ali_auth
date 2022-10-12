part of flutter_ali_auth;

abstract class AuthUIConfig {
  LogoConfig? logoConfig;
  SloganConfig? sloganConfig;
  PhoneNumberConfig? phoneNumberConfig;
  LoginButtonConfig? loginButtonConfig;
  ChangeButtonConfig? changeButtonConfig;
  CheckBoxConfig? checkBoxConfig;
  PrivacyConfig? privacyConfig;

  AuthUIConfig({
    this.logoConfig,
    this.sloganConfig,
    this.phoneNumberConfig,
    this.loginButtonConfig,
    this.changeButtonConfig,
    this.checkBoxConfig,
    this.privacyConfig,
  });

  MapWithStringKey toJson();

  // factory AuthUIConfig.copyWith(AuthUIConfig otherConfig) {
  //   if(otherConfig is AlertUIConfig){
  //     return AlertUIConfig(
  //       alertTitleBarConfig:otherConfig.alertTitleBarConfig,
  //       alertContentViewColor:otherConfig.alertContentViewColor,
  //       alertBlurViewColor:otherConfig.alertBlurViewColor,
  //       alertBlurViewAlpha:otherConfig.alertBlurViewAlpha,
  //       alertBorderRadius:otherConfig.alertBorderRadius,
  //       alertWindowHeight:otherConfig.alertWindowHeight,
  //       alertWindowWidth:otherConfig.alertWindowWidth,
  //       logoConfig:otherConfig.logoConfig,
  //       sloganConfig:otherConfig.sloganConfig,
  //       phoneNumberConfig:otherConfig.phoneNumberConfig,
  //       loginButtonConfig:otherConfig.loginButtonConfig,
  //       changeButtonConfig:otherConfig.changeButtonConfig,
  //       checkBoxConfig:otherConfig.checkBoxConfig,
  //       privacyConfig:otherConfig.privacyConfig,
  //     );
  //   }else if(otherConfig is FullScreenUIConfig){
  //     return FullScreenUIConfig();
  //   }else{
  //     return FullScreenUIConfig();
  //   }
  // }
}
