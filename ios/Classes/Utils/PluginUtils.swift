//
//  Extension.swift
//  ali_auth
//
//  Created by kangkang on 2022/9/29.
//

import Foundation

extension SwiftFlutterAliAuthPlugin {
    // MARK: - 获取flutterviewcontroller

    func getFlutterViewController() -> FlutterViewController? {
        let viewController: UIViewController? = window?.rootViewController
        if (viewController?.isKind(of: FlutterViewController.self)) != nil {
            print("viewController as? FlutterViewController")
            return viewController as? FlutterViewController
        } else {
            print("getCurrentViewController() as? FlutterViewController")
            return getCurrentViewController() as? FlutterViewController
        }
    }

    // MARK: - 在view上添加UIViewController，查找当前的ViewController

    func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getCurrentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentViewController(base: presented)
        }
        return base
    }

    // MARK: - 获取视窗

    var window: UIWindow? {
        UIApplication.shared.keyWindow
    }

    // MARK: - 获取根视图

    var getRootViewController: UIViewController? {
        // let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        return window?.rootViewController
    }
}
