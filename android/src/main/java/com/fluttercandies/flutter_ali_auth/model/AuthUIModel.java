package com.fluttercandies.flutter_ali_auth.model;

import static com.fluttercandies.flutter_ali_auth.utils.Constant.Font_12;
import static com.fluttercandies.flutter_ali_auth.utils.Constant.Font_14;

import androidx.annotation.NonNull;

import java.util.List;

public class AuthUIModel {
    // global config both fullscreen and alert
    public String backgroundColor;  // 十六进制的颜色
    public String backgroundImage;
    public String alertContentViewColor;  // 十六进制的颜色
    public String alertBlurViewColor;  // 底部蒙层背景颜色，默认黑色
    public Double alertBlurViewAlpha;  // 底部蒙层背景透明度，默认0.5

    public Double alertBorderWidth;

    public String alertBorderColor;
    public Double alertBorderRadius;  // 四个角的圆角，默认为10
    public Double alertWindowWidth;
    public Double alertWindowHeight;

    // status bar
    public Boolean prefersStatusBarHidden;

    // nav
    public Boolean navIsHidden = false;
    public String navTitle;
    public String navTitleColor;
    public Integer navTitleSize;
    public Double navFrameOffsetX;
    public Double navFrameOffsetY;
    public String navColor;

    // nav backItem
    public Boolean hideNavBackItem;

    public String navBackImage;
    public Double navBackButtonOffsetX;
    public Double navBackButtonOffsetY;

    // alert bar
    public Boolean alertBarIsHidden;
    public Boolean alertCloseItemIsHidden;
    public String alertTitleBarColor;


    public String alertTitleText;
    public String alertTitleTextColor;
    public Integer alertTittleTextSize;

    public String alertCloseImage;
    public Double alertCloseImageOffsetX;
    public Double alertCloseImageOffsetY;

    // logo
    public Boolean logoIsHidden;
    public String logoImage;
    public Double logoWidth;
    public Double logoHeight;
    public Double logoFrameOffsetX;
    public Double logoFrameOffsetY;

    // slogan
    public Boolean sloganIsHidden;
    public String sloganText;
    public String sloganTextColor;
    public Integer sloganTextSize;

    public Double sloganFrameOffsetX;
    public Double sloganFrameOffsetY;

    // number
    public String numberColor = "#2BD180";
    public Integer numberFontSize;

    public Double numberFrameOffsetX;
    public Double numberFrameOffsetY;


    // login button
    public String loginBtnText = "一键登录";
    public String loginBtnTextColor;
    public Integer loginBtnTextSize;
    public String loginBtnNormalImage;
    public String loginBtnUnableImage;
    public String loginBtnPressedImage;
    public Double loginBtnFrameOffsetX;
    public Double loginBtnFrameOffsetY;
    public Double loginBtnWidth;
    public Double loginBtnHeight;
    public Double loginBtnLRPadding;

    // change button
    public Boolean changeBtnIsHidden;
    public String changeBtnTitle = "切换其他登录方式";
    public String changeBtnTextColor = "#666666";
    public Integer changeBtnTextSize = Font_14;
    public Double changeBtnFrameOffsetX;
    public Double changeBtnFrameOffsetY;


    // checkBox
    public Boolean checkBoxIsChecked = false;
    public Boolean checkBoxIsHidden;
    public Double checkBoxWH = 18.0;
    public String checkedImage;
    public String uncheckImage;

    // priavacy
    public String privacyOneName = "《使用协议》";
    public String privacyOneUrl = "http://******";
    public String privacyTwoName = "《隐私协议》";
    public String privacyTwoUrl = "http://******";
    public String privacyThreeName;
    public String privacyThreeUrl;

    public Integer privacyFontSize = Font_12;
    public String privacyFontColor = "#2196F3";
    public Double privacyFrameOffsetX;
    public Double privacyFrameOffsetY;
    public String privacyConnectTexts = "和";
    public String privacyPreText;
    public String privacySufText;
    public String privacyOperatorPreText = "《";
    public String privacyOperatorSufText  = "》";
    public Integer privacyOperatorIndex;
    public List<CustomViewBlock> customViewBlockList;

    @NonNull
    @Override
    public String toString() {
        return "AuthUIModel{" +
                "backgroundColor='" + backgroundColor + '\'' +
                ", backgroundImage='" + backgroundImage + '\'' +
                ", alertContentViewColor='" + alertContentViewColor + '\'' +
                ", alertBlurViewColor='" + alertBlurViewColor + '\'' +
                ", alertBlurViewAlpha=" + alertBlurViewAlpha +
                ", alertBorderRadius=" + alertBorderRadius +
                ", alertWindowWidth=" + alertWindowWidth +
                ", alertWindowHeight=" + alertWindowHeight +
                ", prefersStatusBarHidden=" + prefersStatusBarHidden +
                ", navIsHidden=" + navIsHidden +
                ", navTitle='" + navTitle + '\'' +
                ", navTitleColor='" + navTitleColor + '\'' +
                ", navTitleSize=" + navTitleSize +
                ", navFrameOffsetX=" + navFrameOffsetX +
                ", navFrameOffsetY=" + navFrameOffsetY +
                ", navColor='" + navColor + '\'' +
                ", hideNavBackItem=" + hideNavBackItem +
                ", navBackImage='" + navBackImage + '\'' +
                ", navBackButtonOffsetX=" + navBackButtonOffsetX +
                ", navBackButtonOffsetY=" + navBackButtonOffsetY +
                ", alertBarIsHidden=" + alertBarIsHidden +
                ", alertCloseItemIsHidden=" + alertCloseItemIsHidden +
                ", alertTitleBarColor='" + alertTitleBarColor + '\'' +
                ", alertTitleText='" + alertTitleText + '\'' +
                ", alertTitleTextColor='" + alertTitleTextColor + '\'' +
                ", alertTittleTextSize=" + alertTittleTextSize +
                ", alertCloseImage='" + alertCloseImage + '\'' +
                ", alertCloseImageOffsetX=" + alertCloseImageOffsetX +
                ", alertCloseImageOffsetY=" + alertCloseImageOffsetY +
                ", logoIsHidden=" + logoIsHidden +
                ", logoImage='" + logoImage + '\'' +
                ", logoWidth=" + logoWidth +
                ", logoHeight=" + logoHeight +
                ", logoFrameOffsetX=" + logoFrameOffsetX +
                ", logoFrameOffsetY=" + logoFrameOffsetY +
                ", sloganIsHidden=" + sloganIsHidden +
                ", sloganText='" + sloganText + '\'' +
                ", sloganTextColor='" + sloganTextColor + '\'' +
                ", sloganTextSize=" + sloganTextSize +
                ", sloganFrameOffsetX=" + sloganFrameOffsetX +
                ", sloganFrameOffsetY=" + sloganFrameOffsetY +
                ", numberColor='" + numberColor + '\'' +
                ", numberFontSize=" + numberFontSize +
                ", numberFrameOffsetX=" + numberFrameOffsetX +
                ", numberFrameOffsetY=" + numberFrameOffsetY +
                ", loginBtnText='" + loginBtnText + '\'' +
                ", loginBtnTextColor='" + loginBtnTextColor + '\'' +
                ", loginBtnTextSize=" + loginBtnTextSize +
                ", loginBtnNormalImage='" + loginBtnNormalImage + '\'' +
                ", loginBtnUnableImage='" + loginBtnUnableImage + '\'' +
                ", loginBtnPressedImage='" + loginBtnPressedImage + '\'' +
                ", loginBtnFrameOffsetX=" + loginBtnFrameOffsetX +
                ", loginBtnFrameOffsetY=" + loginBtnFrameOffsetY +
                ", loginBtnWidth=" + loginBtnWidth +
                ", loginBtnHeight=" + loginBtnHeight +
                ", loginBtnLRPadding=" + loginBtnLRPadding +
                ", changeBtnIsHidden=" + changeBtnIsHidden +
                ", changeBtnTitle='" + changeBtnTitle + '\'' +
                ", changeBtnTextColor='" + changeBtnTextColor + '\'' +
                ", changeBtnTextSize=" + changeBtnTextSize +
                ", changeBtnFrameOffsetX=" + changeBtnFrameOffsetX +
                ", changeBtnFrameOffsetY=" + changeBtnFrameOffsetY +
                ", checkBoxIsChecked=" + checkBoxIsChecked +
                ", checkBoxIsHidden=" + checkBoxIsHidden +
                ", checkBoxWH=" + checkBoxWH +
                ", checkedImage='" + checkedImage + '\'' +
                ", uncheckImage='" + uncheckImage + '\'' +
                ", privacyOneName='" + privacyOneName + '\'' +
                ", privacyOneUrl='" + privacyOneUrl + '\'' +
                ", privacyTwoName='" + privacyTwoName + '\'' +
                ", privacyTwoUrl='" + privacyTwoUrl + '\'' +
                ", privacyThreeName='" + privacyThreeName + '\'' +
                ", privacyThreeUrl='" + privacyThreeUrl + '\'' +
                ", privacyFontSize=" + privacyFontSize +
                ", privacyFontColor='" + privacyFontColor + '\'' +
                ", privacyFrameOffsetX=" + privacyFrameOffsetX +
                ", privacyFrameOffsetY=" + privacyFrameOffsetY +
                ", privacyConnectTexts='" + privacyConnectTexts + '\'' +
                ", privacyPreText='" + privacyPreText + '\'' +
                ", privacySufText='" + privacySufText + '\'' +
                ", privacyOperatorPreText='" + privacyOperatorPreText + '\'' +
                ", privacyOperatorSufText='" + privacyOperatorSufText + '\'' +
                ", privacyOperatorIndex=" + privacyOperatorIndex +
                ", customViewBlockList=" + customViewBlockList +
                '}';
    }
}


