//
//  AuthUIBuilder.swift
//  ali_auth
//
//  Created by kangkang on 2022/10/1.
//

import ATAuthSDK
import Foundation

enum AuthUIStyle: Int {
    case FullScreen
    case BottomSheet
    case Alert
}

typealias CustomViewBlockCallback = (ResponseModel) -> Void

class AuthUIBuilder {
    var register: FlutterPluginRegistrar?

    var viewController: UIViewController?

    var customViewBlockCallback: CustomViewBlockCallback?

    public func buildUIModel(authUIStyle: AuthUIStyle, authUIConfig: AuthUIConfig,
                             completionHandler: @escaping CustomViewBlockCallback) -> TXCustomModel
    {
        self.customViewBlockCallback = completionHandler

        switch authUIStyle {
        case .FullScreen:
            return self.buildFullScreenModel(config: authUIConfig)

        case .BottomSheet:
            return self.buildBottomSheetModel(config: authUIConfig)

        case .Alert:
            return self.buildAlertModel(config: authUIConfig)
        }
    }

    // MARK: - 获取Flutter的image

    func FlutterAssetImage(_ key: String?) -> UIImage? {
        if key == nil || (key?.isEmpty) == nil {
            return nil
        }
        guard let path = getFlutterAssetsPath(key: key!) else {
            return nil
        }

        return UIImage(contentsOfFile: path)
    }

    // MARK: - 获取Flutter Assets 路径

    func getFlutterAssetsPath(key: String) -> String? {
        let keyPath = self.register?.lookupKey(forAsset: key)
        // path:Optional("/private/var/containers/Bundle/Application/255AE8A8-DCFC-4907-B127-BBDFA4C86473/Runner.app/Frameworks/App.framework/flutter_assets/images/app_icon.png")
        return Bundle.main.path(forResource: keyPath, ofType: nil)
    }

    // MARK: - 获取插件Assets下的图片

    func BundleImage(_ key: String) -> UIImage? {
        if let image = UIImage(named: key, in: PluginBundle, compatibleWith: nil) {
            return image
        }
        return nil
    }

    // MARK: - 获取插件资源

    var PluginBundle: Bundle? {
        if let path = Bundle(for: SwiftFlutterAliAuthPlugin.self).path(forResource: "ATAuthSDK", ofType: "bundle") {
            let bundle = Bundle(path: path)
            return bundle
        }
        return nil
    }

    // MARK: - 构建自定义控件

    func buildCustomViewBlock(model: TXCustomModel, customViewConfigList: [CustomViewBlock]) {
        var customViewList: [UIView] = []

        for index in 0 ..< customViewConfigList.count {
            let customView = UIButton(type: UIButton.ButtonType.custom)

            let customViewConfig = customViewConfigList[index]

            if let text = customViewConfig.text {
                customView.setTitle(text, for: UIControl.State.normal)
            }

            if let textColor = customViewConfig.textColor {
                customView.setTitleColor(textColor.uicolor(), for: UIControl.State.normal)
            }

            if let textSize = customViewConfig.textSize {
                customView.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(textSize))
            }
            if let backgroundColor = customViewConfig.backgroundColor {
                customView.backgroundColor = backgroundColor.uicolor()
            }
            if let image = customViewConfig.image {
                if let imageFromFlutter = FlutterAssetImage(image) {
                    customView.setImage(imageFromFlutter, for: UIControl.State.normal)
                    customView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    customView.imageView?.contentMode = .scaleAspectFill
                }
            }

            if customViewConfig.enableTap ?? false {
                // 添加点击事件
                if let viewId = customViewConfig.viewId {
                    customView.tag = viewId
                    customView.addTarget(self, action: #selector(self.customBtnOnTap), for: UIControl.Event.touchUpInside)
                }
            }

            customViewList.append(customView)
        }

        model.customViewBlock = { superCustomView in
            for index in 0 ..< customViewList.count {
                superCustomView.addSubview(customViewList[index])
            }
        }

        model.customViewLayoutBlock = { _, _, _, _, _, _, _, _, _, _ in

            for index in 0 ..< customViewConfigList.count {
                let customViewConfig = customViewConfigList[index]
                let customViewBlock = customViewList[index]

                let x: Double = customViewConfig.offsetX ?? 0
                let y: Double = customViewConfig.offsetY ?? 0
                let width: Double = customViewConfig.width ?? 40
                let height: Double = customViewConfig.height ?? 40

                customViewBlock.frame = CGRect(x: x, y: y, width: width, height: height)
            }
        }
    }

    // MARK: - 自定义控件的点击事件

    @objc func customBtnOnTap(sender: UIButton) {
        // 回调自定义控件的点击事件，并且把viewId传递到flutter
        if let callback = customViewBlockCallback {
            let responseModel = ResponseModel(code: OnCustomViewTapCode, msg: String(describing: sender.tag))

            callback(responseModel)
        }

        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true, complete: nil)
    }

    var AppDisplayName: String {
        let infoDictionary = Bundle.main.infoDictionary!
        return infoDictionary["CFBundleDisplayName"] as! String
    }

    func isHorizontal(_ screenSize: CGSize) -> Bool {
        screenSize.width > screenSize.height
    }

    func onDispose() {
        self.register = nil
        self.viewController = nil
        self.customViewBlockCallback = nil
    }
}
