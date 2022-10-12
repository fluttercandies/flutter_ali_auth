enum AuthResultCode {
  /// 接口成功
  success("600000"),

  /// 获取运营商配置信息失败
  getOperatorInfoFailed("600004"),

  /// 获取运营商配置信息失败

  /// 未检测到sim卡
  noSIMCard("600007"),

  /// 蜂窝网络未开启或不稳定
  noCellularNetwork("600008"),

  /// 无法判运营商
  unknownOperator("600009"),

  /// 未知异常
  unknownError("600010"),

  /// 获取token失败
  getTokenFailed("600011"),

  /// 预取号失败
  getMaskPhoneFailed("600012"),

  /// 运营商维护升级，该功能不可用
  interfaceDemoted("600013"),

  /// 运营商维护升级，该功能已达最大调用次数
  interfaceLimited("600014"),

  /// 接口超时
  interfaceTimeout("600015"),

  /// 预取号成功
  getMaskPhoneSuccess("600016"),

  /// 接口超时
  decodeAppInfoFailed("600017"),

  /// 运营商已切换
  carrierChanged("600021"),

  /// 终端环境检测失败（终端不支持认证 / 终端检测参数错误）
  envCheckFail("600025"),

  /*************** 号码认证授权页相关返回码 START ***************/

  /// 唤起授权页成功
  loginControllerPresentSuccess("600001"),

  /// 唤起授权页失败
  loginControllerPresentFailed("600002"),

  /// 授权页已加载时不允许调用加速或预取号接口
  callPreLoginInAuthPage("600026"),

  /// 点击返回，⽤户取消一键登录
  loginControllerClickCancel("700000"),

  /// 点击切换按钮，⽤户取消免密登录
  loginControllerClickChangeBtn("700001"),

  /// 点击登录按钮事件
  loginControllerClickLoginBtn("700002"),

  /// 点击CheckBox事件
  loginControllerClickCheckBoxBtn("700003"),

  /// 点击协议富文本文字
  loginControllerClickProtocol("700004"),

  /*************** 号码认证授权页相关返回码 FINISH ***************/

  /*************** 活体认证相关返回码 START ***************/

  /// 点击一键登录拉起授权页二次弹窗
  loginClickPrivacyAlertView("700006"),

  /// 隐私协议二次弹窗关闭
  loginPrivacyAlertViewClose("700007"),

  /// 隐私协议二次弹窗点击确认并继续
  loginPrivacyAlertViewClickContinue("700008"),

  /// 点击隐私协议二次弹窗上的协议富文本文字
  loginPrivacyAlertViewPrivacyContentClick("700009"),

  /*************** 活体认证相关返回码 FINISH ***************/

  /*************** 活体认证相关返回码 START ***************/

  /// 接口请求失败
  failed("600030"),

  /// 网络错误
  errorNetwork("600031"),

  /// 客户端设备时间错误
  errorClientTimestamp("600032"),

  /// 功能不可用，需要到控制台开通对应功能
  featureInvalid("600033"),

  /// 不合法的SDK密钥
  codeSDKInfoInvalid("600034"),

  /// 状态繁忙
  statusBusy("600035"),

  /// 业务停机
  outOfService("600036"),

  /// 活体认证页面准备启动
  liftBodyVerifyReadyStating("700005"),

  /// 用户主动取消操作UI事件，用户取消操作
  errorUserCancel("700000");

  const AuthResultCode(this.code);

  final String code;
}
