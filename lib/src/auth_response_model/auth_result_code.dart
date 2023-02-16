///阿里云SDK返回回调Enum
///@author kangkang
///@date 2023-01-10
///
///新备注（2023-02-04）
///#pragma mark - 该返回码为阿里云号码认证SDK⾃身的返回码，请注意600011及600012错误内均含有运营商返回码，（如果没有返回码请提ISSUE）
///具体错误在碰到之后查阅 https://help.aliyun.com/document_detail/85351.html?spm=a2c4g.11186623.6.561.32a7360cxvWk6H
enum AuthResultCode {
  success('600000', '接口返回成功'),
  getOperatorInfoFailed('600004', '获取运营商配置信息失败'),

  /// 获取运营商配置信息失败
  noSIMCard('600007', '未检测到sim卡'),
  noCellularNetwork('600008', '蜂窝网络未开启或不稳定'),
  unknownOperator('600009', '无法判运营商'),
  unknownError('600010', '未知异常'),
  getTokenFailed('600011', '获取token失败'),
  getMaskPhoneFailed('600012', '预取号失败'),
  interfaceDemoted('600013', '运营商维护升级，该功能不可用'),
  interfaceLimited('600014', '运营商维护升级，该功能已达最大调用次数'),
  interfaceTimeout('600015', '接口超时'),
  getMaskPhoneSuccess('600016', '预取号成功'),
  decodeAppInfoFailed('600017', 'AppID Secret解析失败'),
  carrierChanged('600021', '运营商已切换'),
  envCheckSuccess('600024', '终端支持认证'),
  envCheckFail('600025', '终端环境检测失败（1.终端不支持认证;2.终端检测参数错误;3.初始化未成功）'),

  ///  号码认证授权页相关返回码 START
  loginControllerPresentSuccess('600001', '唤起授权页成功'),
  loginControllerPresentFailed('600002', '唤起授权页失败'),
  callPreLoginInAuthPage('600026', '授权页已加载时不允许调用加速或预取号接口'),
  loginControllerClickCancel('700000', '点击返回，⽤户取消一键登录'),
  loginControllerClickChangeBtn('700001', '点击切换按钮，⽤户取消免密登录'),
  loginControllerClickLoginBtn('700002', '点击登录按钮事件'),
  loginControllerClickCheckBoxBtn('700003', ' 点击CheckBox事件'),
  loginControllerClickProtocol('700004', '点击协议富文本文字'),

  ///  活体认证相关返回码 START
  loginClickPrivacyAlertView('700006', '点击一键登录拉起授权页二次弹窗'),
  loginPrivacyAlertViewClose('700007', '隐私协议二次弹窗关闭'),
  loginPrivacyAlertViewClickContinue('700008', '隐私协议二次弹窗点击确认并继续'),
  loginPrivacyAlertViewPrivacyContentClick('700009', '点击隐私协议二次弹窗上的协议富文本文字'),
  onCustomViewTap('700010', '用户点击了自定义控件的按钮，此时会[msg]会回调控件的viewId'),

  ///  活体认证相关返回码 START /
  failed('600030', ' 接口请求失败'),
  errorNetwork('600031', '网络错误'),
  errorClientTimestamp('600032', '客户端设备时间错误'),
  featureInvalid('600033', '功能不可用，需要到控制台开通对应功能'),
  codeSDKInfoInvalid('600034', '不合法的SDK密钥'),
  statusBusy('600035', '状态繁忙'),
  outOfService('600036', '业务停机'),
  liftBodyVerifyReadyStating('700005', '活体认证页面准备启动'),
  ;

  factory AuthResultCode.fromCode(String resultCode) {
    return values.firstWhere(
      (element) => element.code == resultCode,
      orElse: () => AuthResultCode.unknownError,
    );
  }

  const AuthResultCode(this.code, this.message);

  final String code;
  final String message;
}
