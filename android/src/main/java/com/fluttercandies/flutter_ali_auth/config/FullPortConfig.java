package com.fluttercandies.flutter_ali_auth.config;

import static com.fluttercandies.flutter_ali_auth.Constant.*;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;
import android.widget.ImageView;

import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.helper.CustomAuthUIControlClickListener;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

public class FullPortConfig extends BaseUIConfig {
    private final String TAG = "全屏竖屏样式";

    public FullPortConfig(Activity activity, PhoneNumberAuthHelper authHelper, EventChannel.EventSink eventSink) {
        super(activity, authHelper, eventSink);
    }


    @Override
    public void configAuthPage(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, AuthUIModel authUIModel) {

        CustomAuthUIControlClickListener customAuthUIControlClickListener = new CustomAuthUIControlClickListener(mAuthHelper, mContext, mEventSink);

        mAuthHelper.setUIClickListener(customAuthUIControlClickListener);

        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }

        updateScreenSize(authPageOrientation);

        String appName = getAppName(mContext);

        int navColor = mActivity.getResources().getColor(R.color.white);

        int sloganColor = mActivity.getResources().getColor(R.color.deepGrey);

        String logoPath = null;

        boolean logoIsHidden = authUIModel.logoIsHidden != null ? authUIModel.logoIsHidden : true;

        if (!logoIsHidden) {
            try {
                FlutterPlugin.FlutterAssets flutterAssets = flutterPluginBinding.getFlutterAssets();
                logoPath = flutterAssets.getAssetFilePathByName(authUIModel.logoImage);
                Log.i("FullPortConfig", "logoPath:" + logoPath);
            } catch (Exception e) {
                e.printStackTrace();
                logoPath = "mytel_app_launcher";
            }
        }

        double sloganFrameOffsetY = authUIModel.sloganFrameOffsetY == null ? (kLogoOffset + kLogoSize + kPadding) : authUIModel.sloganFrameOffsetY;

        double numberFrameOffsetY = authUIModel.numberFrameOffsetY == null ? (sloganFrameOffsetY + Font_24 + kPadding) : authUIModel.numberFrameOffsetY;

        double loginBtnOffsetY = authUIModel.loginBtnFrameOffsetY == null ? mScreenHeightDp * .5 : authUIModel.loginBtnFrameOffsetY;

        double loginBtnWidth = authUIModel.loginBtnWidth == null ? mScreenWidthDp * 0.85 : authUIModel.loginBtnWidth;

        double loginBtnHeight = authUIModel.loginBtnHeight == null ? 48 : authUIModel.loginBtnHeight;

        String loginBtnImage = authUIModel.loginBtnNormalImage == null ? "login_btn_bg" : authUIModel.loginBtnNormalImage;

        boolean changeBtnIsHidden = authUIModel.changeBtnIsHidden == null || authUIModel.changeBtnIsHidden;

        double changeBtnFrameOffsetY = authUIModel.changeBtnFrameOffsetY == null ? loginBtnOffsetY + loginBtnHeight + kPadding * 2 : authUIModel.changeBtnFrameOffsetY;

        double privacyFrameOffsetYFromBottom = authUIModel.privacyFrameOffsetY == null ? 32 : authUIModel.privacyFrameOffsetY;

        String privacyPreText = authUIModel.privacyPreText == null ? "已经阅读并同意" : authUIModel.privacyPreText;

        boolean checkBoxIsHidden = authUIModel.checkBoxIsHidden != null && authUIModel.checkBoxIsHidden;

        String checkedImage = authUIModel.checkedImage == null ? "icon_check" : authUIModel.checkedImage;

        String unCheckImage = authUIModel.uncheckImage == null ? "icon_uncheck" : authUIModel.uncheckImage;


        mAuthHelper.setAuthUIConfig(new AuthUIConfig.Builder()
                .setStatusBarColor(Color.WHITE)
                .setLightColor(true)

                //沉浸式状态栏
                .setNavColor(navColor)
                .setNavReturnImgPath("icon_return")
                .setNavReturnScaleType(ImageView.ScaleType.CENTER_INSIDE)
                .setNavReturnImgWidth(20)
                .setNavReturnImgHeight(20)
                .setNavText("")

                .setWebViewStatusBarColor(Color.GRAY)
                .setWebNavColor(Color.WHITE)
                .setWebNavTextColor(Color.DKGRAY)

                .setLogoHidden(logoIsHidden)
                .setLogoOffsetY(kLogoOffset)
                .setLogoWidth(kLogoSize)
                .setLogoHeight(kLogoSize)
                .setLogoImgPath(logoPath)

                .setSloganTextSizeDp(Font_24)
                .setSloganText("欢迎登陆")
                .setSloganTextColor(sloganColor)
                .setSloganOffsetY(((int) sloganFrameOffsetY))

                .setNumberSizeDp(Font_20)
                .setNumberColor(Color.parseColor(authUIModel.numberColor))
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

                .setPageBackgroundPath(authUIModel.backgroundImage)

                .setAuthPageActIn(String.valueOf(R.anim.slide_up), String.valueOf(R.anim.slide_down))
                .setAuthPageActOut(String.valueOf(R.anim.slide_up), String.valueOf(R.anim.slide_down))
                .create());
    }


}
