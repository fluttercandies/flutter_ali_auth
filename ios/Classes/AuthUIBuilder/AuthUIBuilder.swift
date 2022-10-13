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

    var PluginBundle: Bundle? {
        if let path = Bundle(for: SwiftFlutterAliAuthPlugin.self).path(forResource: "ATAuthSDK", ofType: "bundle") {
            let bundle = Bundle(path: path)
            return bundle
        }
        return nil
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
