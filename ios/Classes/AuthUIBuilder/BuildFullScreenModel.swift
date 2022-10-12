//
//  BuildFullScreenModel.swift
//  ali_auth
//
//  Created by kangkang on 2022/10/1.
//

import ATAuthSDK
import CoreData
import Foundation
import UIKit

extension AuthUIBuilder {
    // MARK: - 构建全屏授权页面

    func buildFullScreenModel(config: AuthUIConfig) -> TXCustomModel {
        var kHorizontal: Bool?
        var kLoginButtonSize = CGSize()
        let model = TXCustomModel()

        model.supportedInterfaceOrientations = .portrait

        // status bar
        if #available(iOS 13.0, *) {
            model.preferredStatusBarStyle = UIStatusBarStyle.darkContent
        } else {
            // Fallback on earlier versions
            model.preferredStatusBarStyle = UIStatusBarStyle.default
        }
   
        model.prefersStatusBarHidden = config.prefersStatusBarHidden ?? false

//        if #available(iOS 13.0, *) {
//            model.preferredStatusBarStyle = UIStatusBarStyle.darkContent
//        }

        // Nav
        model.hideNavBackItem = config.hideNavBackItem ?? false
        model.navColor = config.navColor?.uicolor() ?? UIColor.white

        model.navBackImage = { () -> UIImage in
            guard let navBackImage = config.navBackImage else {
                return BundleImage("icon_nav_back_gray")!
            }
            return FlutterAssetImage(navBackImage)!
        }()

        var navTitleAttributes: [NSAttributedString.Key: Any] = [:]

        if let navTitleColor = config.navTitleColor {
            navTitleAttributes.updateValue(navTitleColor.uicolor(), forKey: NSAttributedString.Key.foregroundColor)
        }

        if let navTitleSize = config.navTitleSize {
            navTitleAttributes.updateValue(UIFont(name: PF_Regular, size: CGFloat(navTitleSize))!, forKey: NSAttributedString.Key.font)
        }

        model.navTitle = NSAttributedString(string: config.navTitle ?? "", attributes: navTitleAttributes)
        // Logo
        model.logoIsHidden = false

        if let logoImage = config.logoImage {
            if let logoImageAssets = FlutterAssetImage(logoImage) {
                model.logoImage = logoImageAssets
            }

            // logo的位置
            model.logoFrameBlock = {
                screenSize, _, _ -> CGRect in
                let offsetX: CGFloat = .init(config.logoFrameOffsetX ?? (Float(screenSize.width) / 2 - kLogoSize / 2))
                let offsetY: CGFloat = .init(config.logoFrameOffsetY ?? kLogoOffset)
                let imageWidth: CGFloat = .init(config.logoWidth ?? kLogoSize)
                let imageHeight: CGFloat = .init(config.logoHeight ?? kLogoSize)
                return CGRect(x: offsetX, y: offsetY, width: imageWidth, height: imageHeight)
            }
        }

        // Slogon
        model.sloganIsHidden = config.sloganIsHidden ?? false

        var sloganTextAtrributes: [NSAttributedString.Key: Any] = [:]

        sloganTextAtrributes.updateValue((config.sloganTextColor ?? "#151515").uicolor(), forKey: NSMutableAttributedString.Key.foregroundColor)

        sloganTextAtrributes.updateValue(UIFont(name: PF_Regular, size: CGFloat(config.sloganTextSize ?? Font_28))!, forKey: NSMutableAttributedString.Key.font)

        model.sloganText = NSAttributedString(string: config.sloganText ?? "欢迎登录\(AppDisplayName)", attributes: sloganTextAtrributes)

        model.sloganFrameBlock = {
            screenSize, _, frame -> CGRect in
            if kHorizontal == nil {
                kHorizontal = self.isHorizontal(screenSize)
            }
            if kHorizontal! {
                return CGRect.zero
            }
            let offsetX = CGFloat(config.sloganFrameOffsetX ?? Float(frame.origin.x))

            let offsetY = CGFloat(config.sloganFrameOffsetY ?? kLogoOffset + kLogoSize + kPadding)

            return CGRect(x: offsetX, y: offsetY, width: frame.width, height: frame.height)
        }
        // Phone Number

        model.numberColor = (config.numberColor ?? "#2BD180").uicolor()
        model.numberFont = UIFont(name: PF_Bold, size: CGFloat(config.numberFontSize ?? Font_24))!

        model.numberFrameBlock = {
            screenSize, _, frame -> CGRect in
            if kHorizontal == nil {
                kHorizontal = self.isHorizontal(screenSize)
            }
            if kHorizontal! {
                return CGRect.zero
            }

            let offsetX = CGFloat(config.numberFrameOffsetX ?? Float(frame.origin.x))

            let offsetY = CGFloat(config.numberFrameOffsetY ?? kLogoOffset + kLogoSize + Float(Font_28) + kPadding * 3)

            return CGRect(x: offsetX, y: offsetY, width: frame.width, height: frame.height)
        }

        // login button
        var loginBtnBgImgs = [UIImage]()

        if let loginBtnNormalImage = config.loginBtnNormalImage {
            if let loginBtnNormal = FlutterAssetImage(loginBtnNormalImage) {
                loginBtnBgImgs.append(loginBtnNormal)
            }
        }
        if let loginBtnUnableImage = config.loginBtnUnableImage {
            if let loginBtnUnable = FlutterAssetImage(loginBtnUnableImage) {
                loginBtnBgImgs.append(loginBtnUnable)
            }
        }
        if let loginBtnPressedImage = config.loginBtnPressedImage {
            if let loginBtnPressed = FlutterAssetImage(loginBtnPressedImage) {
                loginBtnBgImgs.append(loginBtnPressed)
            }
        }

        if !loginBtnBgImgs.isEmpty {
            model.loginBtnBgImgs = loginBtnBgImgs
        }

        var loginAttribute: [NSAttributedString.Key: Any] = [:]

        loginAttribute.updateValue(config.loginBtnTextColor?.uicolor() ?? UIColor.white, forKey: NSAttributedString.Key.foregroundColor)

        loginAttribute.updateValue(UIFont(name: PF_Regular, size: CGFloat(config.loginBtnTextSize ?? Font_17))!, forKey: NSAttributedString.Key.font)

        model.loginBtnText = NSAttributedString(string: config.loginBtnText ?? "一键登录", attributes: loginAttribute)

        var loginButtonOffsetY: Float = 0.0

        model.loginBtnFrameBlock = { screenSize, _, _ -> CGRect in

            if kHorizontal == nil {
                kHorizontal = self.isHorizontal(screenSize)
            }
            if kHorizontal! {
                kLoginButtonSize.width = CGFloat(config.loginBtnWidth ?? 296)
                kLoginButtonSize.height = CGFloat(config.loginBtnHeight ?? 48)
            } else {
                kLoginButtonSize.width = CGFloat(config.loginBtnWidth ?? Float(screenSize.width) * 0.85)
                kLoginButtonSize.height = CGFloat(config.loginBtnHeight ?? 48)
            }

            let offsetX = CGFloat(config.loginBtnFrameOffsetX ?? Float(screenSize.width / 2 - kLoginButtonSize.width / 2))

            let kMiddleHeight = Float(screenSize.height / 2)

            loginButtonOffsetY = config.loginBtnFrameOffsetY ?? kMiddleHeight + kPadding

            let offsetY = CGFloat(loginButtonOffsetY)

            return CGRect(x: offsetX, y: offsetY, width: kLoginButtonSize.width, height: kLoginButtonSize.height)
        }

        // 其他登录
        model.changeBtnIsHidden = config.changeBtnIsHidden ?? false

        var changeBtnAttribute: [NSAttributedString.Key: Any] = [:]

        changeBtnAttribute.updateValue(config.changeBtnTextColor?.uicolor() ?? UIColor.darkGray, forKey: NSAttributedString.Key.foregroundColor)

        changeBtnAttribute.updateValue(UIFont(name: PF_Regular, size: CGFloat(config.changeBtnTextSize ?? Font_14))!, forKey: NSAttributedString.Key.font)

        model.changeBtnTitle = NSAttributedString(string: config.changeBtnTitle ?? "切换其他登录方式", attributes: changeBtnAttribute)

        model.changeBtnFrameBlock = { screenSize, _, frame -> CGRect in
            if kHorizontal == nil {
                kHorizontal = self.isHorizontal(screenSize)
            }
            if kHorizontal! {
                return CGRect.zero
            }
            let width: CGFloat = frame.width // 150

            let height: CGFloat = frame.height // 38

            let offsetX: CGFloat = screenSize.width / 2 - (width / 2)
            // let offsetY: CGFloat = screenSize.width / 2 + kLoginButtonSize.height + CGFloat(kPadding)

            let offsetY = CGFloat(config.numberFrameOffsetY ?? loginButtonOffsetY + Float(kLoginButtonSize.height) + kPadding)

            return CGRect(x: offsetX, y: offsetY, width: width, height: height)
        }

        // CheckBox
        model.checkBoxIsChecked = config.checkBoxIsChecked ?? false
        model.checkBoxIsHidden = config.checkBoxIsHidden ?? false

        var checkBoxImages = [UIImage]()

        if config.uncheckImage != nil {
            if let uncheckIcon = FlutterAssetImage(config.uncheckImage) {
                checkBoxImages.append(uncheckIcon)
            }
        } else {
            checkBoxImages.append(BundleImage("icon_uncheck")!)
        }

        if config.checkedImage != nil {
            if let checkedIcon = FlutterAssetImage(config.checkedImage) {
                checkBoxImages.append(checkedIcon)
            }
        } else {
            checkBoxImages.append(BundleImage("icon_check")!)
        }

        if !checkBoxImages.isEmpty {
            model.checkBoxImages = checkBoxImages
        }

        model.checkBoxImageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        model.checkBoxWH = 24

        // privacy
        model.privacyOne = [config.privacyOneName ?? "《使用协议》", config.privacyOneUrl ?? "http://******"]

        model.privacyTwo = [config.privacyTwoName ?? "《隐私协议》", config.privacyTwoUrl ?? "http://******"]

        model.privacyConectTexts = [config.privacyConnectTexts ?? "和", config.privacyConnectTexts ?? "和"]

        model.privacyOperatorPreText = config.privacyOperatorPreText ?? "《"

        model.privacyOperatorSufText = config.privacyOperatorSufText ?? "》"

        model.privacyPreText = config.privacyPreText ?? "已阅读并同意"

        model.privacyColors = [UIColor.darkGray, config.privacyFontColor?.uicolor() ?? UIColor.systemBlue]

        model.privacyFont = UIFont(name: PF_Regular, size: CGFloat(config.privacyFontSize ?? Font_14))!

        model.privacyFrameBlock = { screenSize, _, _ -> CGRect in
            if kHorizontal == nil {
                kHorizontal = self.isHorizontal(screenSize)
            }

            let screenHeight = Float(screenSize.height)

            var offsetY: CGFloat

            if kHorizontal! {
                // (18.0, 715.5, 370.0, 39.5)
                offsetY = CGFloat(config.privacyFrameOffsetY ?? screenHeight - kPadding - kBottomInset)
            } else {
                offsetY = CGFloat(config.privacyFrameOffsetY ?? screenHeight - kPadding - 200)
            }

            let offsetX = CGFloat(screenSize.width / 2 - 148)

            return CGRect(x: offsetX, y: offsetY, width: 296, height: 48)
        }

        if let privacyNavBackIcon = BundleImage("icon_nav_back_gray") {
            model.privacyNavBackImage = privacyNavBackIcon
        }

        return model
    }
}
