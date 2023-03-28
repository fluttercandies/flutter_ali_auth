import ATAuthSDK
import Flutter
import MBProgressHUD
import UIKit

public class SwiftFlutterAliAuthPlugin: NSObject, FlutterPlugin {
//    var _eventSink: FlutterEventSink?

    let authUIBuilder: AuthUIBuilder = .init()

    var _authConfig: AuthConfig?

    var methodChannel: FlutterMethodChannel?

    static var DART_CALL_METHOD_ON_INIT: String = "onEvent"

    var sdkAvailable: Bool = true

    var initSdkSuccess: Bool = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_ali_auth", binaryMessenger: registrar.messenger())

//        let eventChannel = FlutterEventChannel(name: "auth_event", binaryMessenger: registrar.messenger())

        let instance = SwiftFlutterAliAuthPlugin()

        // method channel
        registrar.addMethodCallDelegate(instance, channel: channel)

        // giving access to the plugin registrar and since it's static we can access variables from outer scope:
        instance.methodChannel = channel

        instance.authUIBuilder.register = registrar
        // 验证网络是否可用
        instance.httpAuthority()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getAliAuthVersion":
            getVersion(result: result)
        case "init":
            initSdk(arguments: call.arguments, result: result)
        case "login":
            login(arguments: call.arguments, result: result)
        case "loginWithConfig":
            loginWidthConfig(arguments: call.arguments, result: result)
        case "hideLoginLoading":
            hideLoginLoading(result: result)
        case "quitLoginPage":
            quitLoginPage(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - 检查联网

    public func httpAuthority() {
        if let testUrl = URL(string: "https://www.baidu.com") {
            let urlRequest = URLRequest(url: testUrl)
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Content-type": "application/json"]
            config.timeoutIntervalForRequest = 20
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            let session = URLSession(configuration: config)
            session.dataTask(with: urlRequest) { _, _, error in
                print("FlutterAliAuthPlugin: 联网\(error == nil ? "成功" : "失败")")
            }.resume()
        } else {
            // testUrl == nil
            print("FlutterAliAuthPlugin: 联网失败")
            return
        }
    }

    // MARK: - 获取SDK版本号（getVersion）

    public func getVersion(result: @escaping FlutterResult) {
        let version = TXCommonHandler.sharedInstance().getVersion()

        result("阿里云一键登录版本:\(version)")
    }

    // MARK: - 设置SDK密钥（setAuthSDKInfo）

    public func initSdk(arguments: Any?, result: @escaping FlutterResult) {
        if !sdkAvailable {
            sdkAvailable = false
        }

        guard let params = arguments as? [String: Any] else {
            // 参数有问题
            result(FlutterError(code: PNSCodeEnvCheckFail, message: "初始化失败，参数不正确：AuthConfig不能为空", details: nil))
            return
        }

        guard let sdk = params["iosSdk"] as? String else {
            // 没有sdk
            result(FlutterError(code: PNSCodeEnvCheckFail, message: "初始化失败，参数不正确：iOS的SDK为空", details: nil))
            return
        }

        // 设置参数
        _authConfig = AuthConfig(params: params)

        if !initSdkSuccess {
            // 设置打印
            TXCommonHandler.sharedInstance().getReporter().setConsolePrintLoggerEnable(_authConfig!.enableLog)
            TXCommonHandler.sharedInstance().setAuthSDKInfo(sdk) { resultDict in

                var _responseMoedel: ResponseModel

                guard let dict = resultDict as? [String: Any] else {
                    self.sdkAvailable = false

                    _responseMoedel = ResponseModel(resultDict)

                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                    
                    result(false)

                    return
                }
                _responseMoedel = ResponseModel(dict)
                guard let code = dict["resultCode"] as? String else {
                    self.sdkAvailable = false
                    /// resultCode 未空 无法判断，直接返回
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                    result(false)
                    return
                }

                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)

                if code == PNSCodeSuccess {
                    // 初始化成功：{msg: AppID、Appkey解析成功, resultCode: 600000, requestId: 481a2c9b50264cf3}
                    result(true)
                    self.initSdkSuccess = true
                    self.checkEnvAvailable()
                }else{
                    result(false)
                }
            }
        } else {
            checkEnvAvailable()
        }
    }

    // MARK: - 检查认证环境（checkEnvAvailableWithComplete）

    public func checkEnvAvailable() {
        TXCommonHandler.sharedInstance().checkEnvAvailable(with: PNSAuthType.loginToken) { (resultDict: [AnyHashable: Any]?) in

            var _responseMoedel: ResponseModel

            guard let dict = resultDict as? [String: Any] else {
                _responseMoedel = ResponseModel(resultDict)
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                return
            }
            _responseMoedel = ResponseModel(dict)
            guard dict["resultCode"] is String else {
                /// resultCode 未空 无法判断，直接返回
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                return
            }
            /// 当前环境可以进行验证：{resultCode: 600000, requestId: afa404b4fba34103, msg: }
            if _responseMoedel.resultCode == PNSCodeSuccess {
                /// 终端支持认证：{msg: , carrierFailedResultData: {}, requestId: 143bd2c7e5044e86, innerCode: , resultCode: 600000, innerMsg: }
                _responseMoedel = ResponseModel(code: PNSCodeEnvCheckSuccess, msg: "终端支持认证")
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                // 开始一键登录预取号
                self.accelerateLoginPage()
            } else {
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
            }
        }
    }

    // MARK: - 一键登录预取号（accelerateLoginPageWithTimeout）

    public func accelerateLoginPage() {
        // print("开始一键登录预取号")
        TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 5.0) { resultDict in

            var _responseMoedel: ResponseModel

            guard let dict = resultDict as? [String: Any] else {
                _responseMoedel = ResponseModel(resultDict)
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                return
            }
            _responseMoedel = ResponseModel(dict)
            guard dict["resultCode"] is String else {
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
                return
            }

            if _responseMoedel.resultCode == PNSCodeSuccess {
                /// 终端支持认证：{msg: , carrierFailedResultData: {}, requestId: 143bd2c7e5044e86, innerCode: , resultCode: 600000, innerMsg: }
                _responseMoedel = ResponseModel(code: PNSCodeGetMaskPhoneSuccess, msg: "预取号成功")
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
            } else {
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseMoedel.json)
            }
        }
    }

    // MARK: - 一键登录获取Token（getLoginTokenWithTimeout）

    public func login(arguments: Any?, result: @escaping FlutterResult) {
        let timeout: TimeInterval = (arguments as? TimeInterval) ?? 5.0

        if !sdkAvailable || _authConfig == nil {
            result(FlutterError(code: PNSCodeEnvCheckFail, message: "初始化失败，SDK未初始化或参数不正确", details: nil))
            return
        }

        guard let viewController = WindowUtils.getCurrentViewController() else {
//            let responseModel = ResponseModel(code: PNSCodeLoginControllerPresentFailed, msg: "当前无法获取Flutter Activity,请重启再试")
            result(FlutterError(code: PNSCodeLoginControllerPresentFailed, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }

        let model = authUIBuilder.buildUIModel(authUIStyle: _authConfig!.authUIStyle, authUIConfig: _authConfig!.authUIConfig, completionHandler: {
            responseModel in
            self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: responseModel.json)
        })

        TXCommonHandler.sharedInstance().checkEnvAvailable(with: PNSAuthType.loginToken) { (resultDict: [AnyHashable: Any]?) in

            var _responseModel: ResponseModel

            guard let dict = resultDict as? [String: Any] else {
                _responseModel = ResponseModel(resultDict)
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                return
            }
            _responseModel = ResponseModel(dict)
            guard let code = dict["resultCode"] as? String else {
                /// resultCode 未空 无法判断，直接返回
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                return
            }
            /// 当前环境可以进行验证：{resultCode: 600000, requestId: afa404b4fba34103, msg: }
            if code != PNSCodeSuccess {
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                return
            }
            // print("开始一键登录预取号")
            TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: timeout) { resultDict in

                guard let dict = resultDict as? [String: Any] else {
                    _responseModel = ResponseModel(resultDict)
//                    self.onSend(_responseMoedel)
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                    return
                }

                guard let code = dict["resultCode"] as? String else {
                    /// resultCode 未空 无法判断，直接返回
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                    return
                }
                _responseModel = ResponseModel(dict)

                if code != PNSCodeSuccess {
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)

                    return
                }
                /// 加速成功：{msg: , carrierFailedResultData: {}, requestId: 143bd2c7e5044e86, innerCode: , resultCode: 600000, innerMsg: }
                TXCommonHandler.sharedInstance().getLoginToken(withTimeout: timeout, controller: viewController, model: model) { resultDict in

                    guard let dict = resultDict as? [String: Any] else {
                        _responseModel = ResponseModel(resultDict)
                        self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                        return
                    }

                    _responseModel = ResponseModel(resultDict)

                    guard let resultCode = dict["resultCode"] as? String else {
                        self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)

                        return
                    }

                    // 发送消息到flutter，Flutter侧边自行判断
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)

                    if resultCode == PNSCodeLoginControllerClickLoginBtn {
//                        print("用户点击一键登录：\(dict)")
                        var isChecked = 0
                        if let checked = dict["isChecked"] as? Int {
                            isChecked = checked
                        }
                        if isChecked == 0 {
                            guard let currentViewController = WindowUtils.getCurrentViewController() else {
                                return
                            }
                            let hud = MBProgressHUD.showAdded(to: currentViewController.view, animated: true)
                            hud.mode = MBProgressHUDMode.text
                            hud.offset.y = 180
                            hud.label.text = "请先同意相关开发协议哦"
                            hud.hide(animated: true, afterDelay: 2) // 2秒钟后自动隐藏
                        }
                    }
                    let shouldCancelLoginVC: Bool =
                        resultCode == PNSCodeSuccess || resultCode == PNSCodeLoginControllerClickCancel ||
                        resultCode == PNSCodeLoginControllerClickChangeBtn
                    if shouldCancelLoginVC {
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                    }
                }
            }
        }
    }

    // MARK: - 一键登陆，debug专用, 用新的配置去验证，耗时会比较久

    func loginWidthConfig(arguments: Any?, result: @escaping FlutterResult) {
        if !sdkAvailable {
            result(FlutterError(code: PNSCodeEnvCheckFail, message: "初始化失败，SDK未初始化或参数不正确", details: nil))
            return
        }

        guard let viewController = WindowUtils.getCurrentViewController() else {
            result(FlutterError(code: PNSCodeLoginControllerPresentFailed, message: "当前无法获取Flutter Activity,请重启再试", details: nil))
            return
        }

        var _config: AuthConfig?
        var _timeout: TimeInterval = 5.0
        
        if let argumentList = arguments as? [Any]{
            if let configMap = argumentList.first as? [String: Any]  {
                _config = AuthConfig(params: configMap)
            }else{
                result(FlutterError(code: PNSCodeEnvCheckFail, message: "初始化失败，SDK未初始化或参数不正确", details: nil))
                return
            }
            //(arguments as? TimeInterval) ?? 5.0
            if let timeout = argumentList.last as? TimeInterval{
                _timeout = timeout;
            }
        }else{
            result(FlutterError(code: PNSCodeLoginControllerPresentFailed, message: "初始化失败，SDK未初始化或参数不正确", details: nil))
            return
        }
        

        if let rawConfig = arguments as? [String: Any] {
            _config = AuthConfig(params: rawConfig)
        }

        _config = _config ?? _authConfig

        let model: TXCustomModel = authUIBuilder.buildUIModel(authUIStyle: _config!.authUIStyle, authUIConfig: _config!.authUIConfig, completionHandler: {
            responseModel in
            self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: responseModel.json)
        })

        authUIBuilder.viewController = viewController

        TXCommonHandler.sharedInstance().checkEnvAvailable(with: PNSAuthType.loginToken) { (resultDict: [AnyHashable: Any]?) in

            var _responseModel: ResponseModel

            guard let dict = resultDict as? [String: Any] else {
                _responseModel = ResponseModel(resultDict)
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                return
            }
            _responseModel = ResponseModel(dict)
            guard let code = dict["resultCode"] as? String else {
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                return
            }
            /// 当前环境可以进行验证：{resultCode: 600000, requestId: afa404b4fba34103, msg: }
            if code != PNSCodeSuccess {
                self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                return
            }
            // print("开始一键登录预取号")
            TXCommonHandler.sharedInstance().accelerateLoginPage(withTimeout: 5.0) { resultDict in
                guard let dict = resultDict as? [String: Any] else {
                    _responseModel = ResponseModel(resultDict)
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                    return
                }
                _responseModel = ResponseModel(dict)
                guard let code = dict["resultCode"] as? String else {
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                    return
                }
                /// 加速成功：{msg: , carrierFailedResultData: {}, requestId: 143bd2c7e5044e86, innerCode: , resultCode: 600000, innerMsg: }
                if code != PNSCodeSuccess {
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                    return
                }

                // print("拉起授权页面")
                TXCommonHandler.sharedInstance().getLoginToken(withTimeout: _timeout, controller: viewController, model: model) { resultDict in

                    guard let dict = resultDict as? [String: Any] else {
                        _responseModel = ResponseModel(resultDict)
                        self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                        return
                    }
                    _responseModel = ResponseModel(resultDict)
                    guard let resultCode = dict["resultCode"] as? String else {
                        self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)
                        return
                    }
                    // 发送消息到flutter，Flutter侧边自行判断
                    self.methodChannel?.invokeMethod(SwiftFlutterAliAuthPlugin.DART_CALL_METHOD_ON_INIT, arguments: _responseModel.json)

                    if resultCode == PNSCodeLoginControllerClickLoginBtn {
                        // print("用户点击一键登录：\(dict)")
                        var isChecked = 0
                        if let checked = dict["isChecked"] as? Int {
                            isChecked = checked
                        }
                        if isChecked == 0 {
                            guard let currentViewController = WindowUtils.getCurrentViewController() else {
                                return
                            }
                            let hud = MBProgressHUD.showAdded(to: currentViewController.view, animated: true)
                            hud.mode = MBProgressHUDMode.text
                            hud.offset.y = 200
                            hud.label.text = "请先同意相关开发协议哦"
                            hud.hide(animated: true, afterDelay: 3) // 2秒钟后自动隐藏
                        }
                    }
                    let shouldCancelLoginVC: Bool =
                        resultCode == PNSCodeSuccess || resultCode == PNSCodeLoginControllerClickCancel ||
                        resultCode == PNSCodeLoginControllerClickChangeBtn
                    if shouldCancelLoginVC {
                        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
                    }
                }
            }
        }
    }

    public func hideLoginLoading(result: @escaping FlutterResult) {
        TXCommonHandler.sharedInstance().hideLoginLoading()
        result(nil)
    }

    public func quitLoginPage(result: @escaping FlutterResult) {
        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true)
        result(nil)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        _authConfig = nil
        authUIBuilder.onDispose()
    }

//    public func cancelListenLoginEvent(result: @escaping FlutterResult) {
//        let flutterError: FlutterError? = onCancel(withArguments: nil)
//        result(flutterError)
//    }
}
