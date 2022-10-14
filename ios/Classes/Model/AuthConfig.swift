//
//  AuthConfig.swift
//  aliauth
//
//  Created by kangkang on 2022/10/1.
//

import Foundation

struct AuthConfig {
    var iosSdk: String
    var enableLog: Bool
    var authUIStyle: AuthUIStyle
    var authUIConfig: AuthUIConfig

    init(params: [String: Any]) {
        iosSdk = params["iosSdk"] as? String ?? ""
        enableLog = params["enableLog"] as? Bool ?? false
        let index = params["authUIStyle"] as? Int ?? 0
        authUIStyle = AuthUIStyle(rawValue: index) ?? AuthUIStyle.FullScreen
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        authUIConfig = (try? decoder.decode(AuthUIConfig.self, from: JSONSerialization.data(withJSONObject: params, options: []))) ?? AuthUIConfig()
    }
}

struct AuthUIConfig: Codable {
    // gloabal config both fullscreen and alert

    var backgroundColor: String? // 十六进制的颜色

    var backgroundImage: String?

    var alertContentViewColor: String? // 十六进制的颜色

    var alertBlurViewColor: String? // 底部蒙层背景颜色，默认黑色

    var alertBlurViewAlpha: Float? // 底部蒙层背景透明度，默认0.5

    var alertBorderRadius: Float? // 四个角的圆角，默认为10

    var alertWindowWidth: Float?

    var alertWindowHeight: Float?

    // status bar
    var prefersStatusBarHidden: Bool?

    // nav
    var navIsHidden: Bool?
    var navTitle: String?
    var navTitleColor: String?
    var navTitleSize: Int?
    var navFrameOffsetX: Float?
    var navFrameOffsetY: Float?
    var navColor: String?

    // nav backItem
    var hideNavBackItem: Bool?

    var navBackImage: String?
    var navBackButtonOffsetX: Float?
    var navBackButtonOffsetY: Float?

    // alert bar
    var alertBarIsHidden: Bool?
    var alertCloseItemIsHidden: Bool?
    var alertTitleBarColor: String?

    var alertTitleText: String?
    var alertTitleTextColor: String?
    var alertTittleTextSize: Int?

    var alertCloseImage: String?
    var alertCloseImageOffsetX: Float?
    var alertCloseImageOffsetY: Float?

    // logo
    var logoIsHidden: Bool?
    var logoImage: String?
    var logoWidth: Float?
    var logoHeight: Float?

    var logoFrameOffsetX: Float?
    var logoFrameOffsetY: Float?

    // slogan
    var sloganIsHidden: Bool?
    var sloganText: String?
    var sloganTextColor: String?
    var sloganTextSize: Int?

    var sloganFrameOffsetX: Float?
    var sloganFrameOffsetY: Float?

    // number
    var numberColor: String?
    var numberFontSize: Int?

    var numberFrameOffsetX: Float?
    var numberFrameOffsetY: Float?

    // login button
    var loginBtnText: String?
    var loginBtnTextColor: String?
    var loginBtnTextSize: Int?

    var loginBtnNormalImage: String?
    var loginBtnUnableImage: String?
    var loginBtnPressedImage: String?

    var loginBtnFrameOffsetX: Float?
    var loginBtnFrameOffsetY: Float?

    var loginBtnWidth: Float?
    var loginBtnHeight: Float?

    var loginBtnLRPadding: Float?

    // change button
    var changeBtnIsHidden: Bool?
    var changeBtnTitle: String?
    var changeBtnTextColor: String?
    var changeBtnTextSize: Int?
    var changeBtnFrameOffsetX: Float?
    var changeBtnFrameOffsetY: Float?

    // checkBox
    var checkBoxIsChecked: Bool?
    var checkBoxIsHidden: Bool?
    var checkBoxWH: Float?

    var checkedImage: String?
    var uncheckImage: String?

    // priavacy
    var privacyOneName: String?
    var privacyOneUrl: String?
    var privacyTwoName: String?
    var privacyTwoUrl: String?
    var privacyThreeName: String?
    var privacyThreeUrl: String?

    var privacyFontSize: Int?
    var privacyFontColor: String?

    var privacyFrameOffsetX: Float?
    var privacyFrameOffsetY: Float?

    var privacyConnectTexts: String?

    var privacyPreText: String?
    var privacySufText: String?

    var privacyOperatorPreText: String?

    var privacyOperatorSufText: String?

    var privacyOperatorIndex: Int?

    var customViewBlockList: [CustomViewBlock]?
}

struct CustomViewBlock: Codable {
    var viewId: Int?
    var text: String?
    var textColor: String?
    var textSize: Double?
    var backgroundColor: String?
    var image: String?
    var offsetX: Double?
    var offsetY: Double?
    var width: Double?
    var height: Double?
    var enableTap: Bool?
}

