//
//  Extension.swift
//  ali_auth
//
//  Created by kangkang on 2022/9/29.
//

import Foundation

class WindowUtils {
    // MARK: - 获取flutterviewcontroller

    static func getFlutterViewController() -> FlutterViewController? {
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

     static func getCurrentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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

     static var window: UIWindow? {
        UIApplication.shared.keyWindow
    }

    // MARK: - 获取根视图

     static var getRootViewController: UIViewController? {
        // let window: UIWindow? = (UIApplication.shared.delegate?.window)!
        
        return window?.rootViewController
    }
    
    
    //MARK: - 顶部安全区高度
    static func xp_safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0;
    }
    
    //MARK: - 底部安全区高度
    static func xp_safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0;
    }
    
    //MARK: - 顶部状态栏高度（包括安全区）
    static func xp_statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    //MARK: - 导航栏高度
    static func xp_navigationBarHeight() -> CGFloat {
        return 44.0
    }
    
    //MARK: - 状态栏+导航栏的高度
    static func xp_navigationFullHeight() -> CGFloat {
        return xp_statusBarHeight() + xp_navigationBarHeight()
    }
    
    //MARK: - 底部导航栏高度
    static func xp_tabBarHeight() -> CGFloat {
        return 49.0
    }
    
    //MARK: - 底部导航栏高度（包括安全区）
    static func xp_tabBarFullHeight() -> CGFloat {
        return xp_tabBarHeight() + xp_safeDistanceBottom()
    }

}
