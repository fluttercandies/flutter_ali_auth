/// 接口成功
const String PNSCodeSuccess = "600000";

/// 获取运营商配置信息失败
const String PNSCodeGetOperatorInfoFailed = "600004";

/// 未检测到sim卡
const String PNSCodeNoSIMCard = "600007";

/// 蜂窝网络未开启或不稳定
const String PNSCodeNoCellularNetwork = "600008";

/// 无法判运营商
const String PNSCodeUnknownOperator = "600009";

/// 未知异常
const String PNSCodeUnknownError = "600010";

/// 获取token失败
const String PNSCodeGetTokenFailed = "600011";

/// 预取号失败
const String PNSCodeGetMaskPhoneFailed = "600012";

/// 运营商维护升级，该功能不可用
const String PNSCodeInterfaceDemoted = "600013";

/// 运营商维护升级，该功能已达最大调用次数
const String PNSCodeInterfaceLimited = "600014";

/// 接口超时
const String PNSCodeInterfaceTimeout = "600015";

/// 接口超时
const String PNSCodeDecodeAppInfoFailed = "600017";

/// 预取号成功
const String PNSCodeGetMaskPhoneSuccess = "600016";

/// 运营商已切换
const String PNSCodeCarrierChanged = "600021";

/// 终端环境检测失败（终端不支持认证 / 终端检测参数错误）
const String PNSCodeEnvCheckFail = "600025";

/*************** 号码认证授权页相关返回码 START ***************/

/// 唤起授权页成功
const String PNSCodeLoginControllerPresentSuccess = "600001";

/// 唤起授权页失败
const String PNSCodeLoginControllerPresentFailed = "600002";

/// 授权页已加载时不允许调用加速或预取号接口
const String PNSCodeCallPreLoginInAuthPage = "600026";

/// 点击返回，⽤户取消一键登录
const String PNSCodeLoginControllerClickCancel = "700000";

/// 点击切换按钮，⽤户取消免密登录
const String PNSCodeLoginControllerClickChangeBtn = "700001";

/// 点击登录按钮事件
const String PNSCodeLoginControllerClickLoginBtn = "700002";

/// 点击CheckBox事件
const String PNSCodeLoginControllerClickCheckBoxBtn = "700003";

/// 点击协议富文本文字
const String PNSCodeLoginControllerClickProtocol = "700004";

/*************** 号码认证授权页相关返回码 FINISH ***************/

/*************** 活体认证相关返回码 START ***************/

/// 点击一键登录拉起授权页二次弹窗
const String PNSCodeLoginClickPrivacyAlertView = "700006";

/// 隐私协议二次弹窗关闭
const String PNSCodeLoginPrivacyAlertViewClose = "700007";

/// 隐私协议二次弹窗点击确认并继续
const String PNSCodeLoginPrivacyAlertViewClickContinue = "700008";

/// 点击隐私协议二次弹窗上的协议富文本文字
const String PNSCodeLoginPrivacyAlertViewPrivacyContentClick = "700009";

/*************** 活体认证相关返回码 FINISH ***************/

/*************** 活体认证相关返回码 START ***************/

/// 接口请求失败
const String PNSCodeFailed = "600030";

/// 网络错误
const String PNSCodeErrorNetwork = "600031";

/// 客户端设备时间错误
const String PNSCodeErrorClientTimestamp = "600032";

/// 功能不可用，需要到控制台开通对应功能
const String PNSCodeFeatureInvalid = "600033";

/// 不合法的SDK密钥
const String PNSCodeSDKInfoInvalid = "600034";

/// 状态繁忙
const String PNSCodeStatusBusy = "600035";

/// 业务停机
const String PNSCodeOutOfSerivce = "600036";

/// 活体认证页面准备启动
const String PNSCodeLiftBodyVerifyReadyStating = "700005";

/// 用户主动取消操作UI事件，用户取消操作
const String PNSCodeErrorUserCancel = "700000";
