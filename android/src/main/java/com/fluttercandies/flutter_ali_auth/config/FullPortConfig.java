package com.fluttercandies.flutter_ali_auth.config;

import static com.fluttercandies.flutter_ali_auth.utils.Constant.*;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.widget.ImageView;

import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

import java.util.Optional;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class FullPortConfig extends BaseUIConfig {
    public FullPortConfig(Activity activity, PhoneNumberAuthHelper authHelper, MethodChannel methodChannel, FlutterPlugin.FlutterAssets flutterAssets) {
        super(activity, authHelper, methodChannel, flutterAssets);
    }

    @Override
    public void configAuthPage(AuthUIModel authUIModel) {

        CustomAuthUIControlClickListener customAuthUIControlClickListener = new CustomAuthUIControlClickListener(mAuthHelper, mContext, mChannel);

        mAuthHelper.setUIClickListener(customAuthUIControlClickListener);

        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }

        updateScreenSize(authPageOrientation);

        String appName = getAppName(mContext);

        int navColor = mActivity.getResources().getColor(R.color.white);

        String logoPath = null;

        boolean logoIsHidden = authUIModel.logoIsHidden != null ? authUIModel.logoIsHidden : true;
        if (!logoIsHidden) {
            try {
                logoPath = mFlutterAssets.getAssetFilePathByName(authUIModel.logoImage);
            } catch (Exception e) {
                e.printStackTrace();
                logoPath = "mytel_app_launcher";
            }
        }
        double logoSize = authUIModel.logoWidth == null ? kLogoSize : authUIModel.logoWidth;
        double logoOffsetY = authUIModel.logoFrameOffsetY == null ? kLogoOffset : authUIModel.logoFrameOffsetY;

        boolean sloganIsHidden = authUIModel.sloganIsHidden == null || authUIModel.sloganIsHidden;
        int sloganColor = authUIModel.sloganTextColor == null ? mActivity.getResources().getColor(R.color.deepGrey) : Color.parseColor(authUIModel.sloganTextColor);
        String sloganText = authUIModel.sloganText == null ? "欢迎登录" + appName : authUIModel.sloganText;
        double sloganFrameOffsetY = authUIModel.sloganFrameOffsetY == null ? (logoOffsetY + logoSize + kPadding) : authUIModel.sloganFrameOffsetY;
        double sloganTextSize = authUIModel.sloganTextSize == null ? Font_24 : authUIModel.sloganTextSize;

        int numberFontSize = authUIModel.numberFontSize == null ? Font_20 : authUIModel.numberFontSize;
        int numberFontColor = authUIModel.numberColor == null ? Color.parseColor("#FF4081") : Color.parseColor(authUIModel.numberColor);
        double numberFrameOffsetY = authUIModel.numberFrameOffsetY == null ? (sloganFrameOffsetY + Font_24 + kPadding) : authUIModel.numberFrameOffsetY;

        double loginBtnOffsetY = authUIModel.loginBtnFrameOffsetY == null ? mScreenHeightDp * .5 : authUIModel.loginBtnFrameOffsetY;
        double loginBtnWidth = authUIModel.loginBtnWidth == null ? mScreenWidthDp * 0.85 : authUIModel.loginBtnWidth;
        double loginBtnHeight = authUIModel.loginBtnHeight == null ? 48 : authUIModel.loginBtnHeight;
        String loginBtnImage = null;
        if (authUIModel.loginBtnNormalImage != null) {
            try {
                loginBtnImage = mFlutterAssets.getAssetFilePathByName(authUIModel.loginBtnNormalImage);
            } catch (Exception e) {
                e.printStackTrace();
                loginBtnImage = "login_btn_bg";
            }
        }

        boolean changeBtnIsHidden = authUIModel.changeBtnIsHidden != null && authUIModel.changeBtnIsHidden;
        double changeBtnFrameOffsetY = authUIModel.changeBtnFrameOffsetY == null ? loginBtnOffsetY + loginBtnHeight + kPadding * 2 : authUIModel.changeBtnFrameOffsetY;

        double privacyFrameOffsetYFromBottom = authUIModel.privacyFrameOffsetY == null ? 32 : authUIModel.privacyFrameOffsetY;
        String privacyPreText = authUIModel.privacyPreText == null ? "已经阅读并同意" : authUIModel.privacyPreText;
        boolean checkBoxIsHidden = authUIModel.checkBoxIsHidden != null && authUIModel.checkBoxIsHidden;
        String checkedImage;
        if (authUIModel.checkedImage != null) {
            checkedImage = mFlutterAssets.getAssetFilePathByName(authUIModel.checkedImage);
        } else {
            checkedImage = "icon_check";
        }
        String unCheckImage;
        if (authUIModel.uncheckImage != null) {
            unCheckImage = mFlutterAssets.getAssetFilePathByName(authUIModel.uncheckImage);
        } else {
            unCheckImage = "icon_uncheck";
        }

        String backgroundImagePath = null;
        if (authUIModel.backgroundImage != null) {
            try {
                backgroundImagePath = mFlutterAssets.getAssetFilePathByName(authUIModel.backgroundImage);
                System.out.println(backgroundImagePath);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        ///自定义控件
        if (authUIModel.customViewBlockList != null) {
            buildCustomView(authUIModel.customViewBlockList);
        }

        mAuthHelper.setAuthUIConfig(new AuthUIConfig.Builder()
                .setStatusBarColor(Color.WHITE)
                .setLightColor(true)

                //沉浸式状态栏
                .setNavHidden(authUIModel.navIsHidden)
                .setNavColor(navColor)
                .setNavReturnImgPath("icon_close")
                .setNavReturnScaleType(ImageView.ScaleType.CENTER_INSIDE)
                .setNavReturnImgWidth(20)
                .setNavReturnImgHeight(20)
                .setNavText("")

                .setWebViewStatusBarColor(Color.GRAY)
                .setWebNavColor(Color.WHITE)
                .setWebNavTextColor(Color.DKGRAY)

                .setLogoHidden(logoIsHidden)
                .setLogoOffsetY(((int) logoOffsetY))
                .setLogoWidth(((int) logoSize))
                .setLogoHeight(((int) logoSize))
                .setLogoImgPath(logoPath)

                .setSloganHidden(sloganIsHidden)
                .setSloganTextSizeDp(((int) sloganTextSize))
                .setSloganText(sloganText)
                .setSloganTextColor(sloganColor)
                .setSloganOffsetY(((int) sloganFrameOffsetY))

                .setNumberSizeDp(numberFontSize)
                .setNumberColor(numberFontColor)
                .setNumFieldOffsetY(((int) numberFrameOffsetY))

                .setLogBtnText(authUIModel.loginBtnText)
                .setLogBtnOffsetY((int) loginBtnOffsetY)
                .setLogBtnOffsetX(0)
                .setLogBtnWidth(((int) loginBtnWidth))
                .setLogBtnHeight(((int) loginBtnHeight))
                .setLogBtnBackgroundPath(loginBtnImage)

                .setSwitchAccHidden(changeBtnIsHidden)
                .setSwitchAccText(authUIModel.changeBtnTitle)
                .setSwitchAccTextSizeDp(authUIModel.changeBtnTextSize)
                .setSwitchAccTextColor(Color.parseColor(authUIModel.changeBtnTextColor))
                .setSwitchOffsetY((int) changeBtnFrameOffsetY)

                .setAppPrivacyOne(authUIModel.privacyOneName, authUIModel.privacyOneUrl)
                .setAppPrivacyTwo(authUIModel.privacyTwoName, authUIModel.privacyTwoUrl)
                .setAppPrivacyThree(authUIModel.privacyThreeName, authUIModel.privacyThreeUrl)
                .setAppPrivacyColor(Color.GRAY, Color.parseColor(authUIModel.privacyFontColor))
                .setPrivacyOffsetY_B(((int) privacyFrameOffsetYFromBottom))
                .setPrivacyTextSize(Font_12)
                .setPrivacyBefore(privacyPreText)
                .setPrivacyEnd(authUIModel.privacySufText)
                .setVendorPrivacyPrefix(authUIModel.privacyOperatorPreText)
                .setVendorPrivacySuffix(authUIModel.privacyOperatorSufText)
                .setPrivacyConectTexts(new String[]{authUIModel.privacyConnectTexts, authUIModel.privacyConnectTexts})

                .setCheckboxHidden(checkBoxIsHidden)
                .setPrivacyState(authUIModel.checkBoxIsChecked)
                .setCheckedImgPath(checkedImage)
                .setUncheckedImgPath(unCheckImage)
                .setCheckBoxWidth(authUIModel.checkBoxWH.intValue())
                .setCheckBoxHeight(authUIModel.checkBoxWH.intValue())
                .setPageBackgroundPath(backgroundImagePath)
                .setAuthPageActIn(String.valueOf(R.anim.slide_up), String.valueOf(R.anim.slide_down))
                .setAuthPageActOut(String.valueOf(R.anim.slide_up), String.valueOf(R.anim.slide_down))
                .create());
    }


}
