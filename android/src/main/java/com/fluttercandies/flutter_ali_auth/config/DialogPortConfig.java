package com.fluttercandies.flutter_ali_auth.config;

import static com.fluttercandies.flutter_ali_auth.utils.Constant.Font_12;
import static com.fluttercandies.flutter_ali_auth.utils.Constant.Font_16;
import static com.fluttercandies.flutter_ali_auth.utils.Constant.Font_20;
import static com.fluttercandies.flutter_ali_auth.utils.Constant.getAppName;
import static com.fluttercandies.flutter_ali_auth.utils.Constant.kLogoSize;
import static com.fluttercandies.flutter_ali_auth.utils.Constant.kPadding;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.widget.ImageView;

import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.nirvana.tools.core.AppUtils;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

public class DialogPortConfig extends BaseUIConfig {
    /**
     * εΊη¨εε
     */
    private String mPackageName;

    public DialogPortConfig(Activity activity, PhoneNumberAuthHelper authHelper, EventChannel.EventSink eventSink, FlutterPlugin.FlutterAssets flutterAssets) {
        super(activity, authHelper,eventSink,flutterAssets);
        mPackageName = AppUtils.getPackageName(activity);
    }

    @Override
    public void configAuthPage( AuthUIModel authUIModel){
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        int dialogHeight = (int) (authUIModel.alertWindowWidth == null ? mScreenHeightDp * 0.55f : authUIModel.alertWindowWidth);
        int dialogWidth = (int) (authUIModel.alertWindowHeight == null ? mScreenWidthDp * 0.9f : authUIModel.alertWindowHeight);
        //sdkι»θ?€ζ§δ»ΆηεΊεζ―marginTop50dp
        int designHeight = dialogHeight - 50;
        int unit = designHeight / 10;

        String appName = getAppName(mContext);
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
        double logoOffsetY = authUIModel.logoFrameOffsetY == null ? kPadding : authUIModel.logoFrameOffsetY;

        boolean sloganIsHidden = authUIModel.sloganIsHidden == null || authUIModel.sloganIsHidden;
        int sloganColor = authUIModel.sloganTextColor == null ? mActivity.getResources().getColor(R.color.md_grey_700) : Color.parseColor(authUIModel.sloganTextColor);
        String sloganText = authUIModel.sloganText == null ? "ζ¬’θΏη»ε½" + appName : authUIModel.sloganText;
        double sloganFrameOffsetY = authUIModel.sloganFrameOffsetY == null ? (logoOffsetY + logoSize) : authUIModel.sloganFrameOffsetY;
        double sloganTextSize = authUIModel.sloganTextSize == null ? Font_16 : authUIModel.sloganTextSize;

        int numberFontSize = authUIModel.numberFontSize == null ? Font_20 : authUIModel.numberFontSize;
        int numberFontColor = authUIModel.numberColor == null ? Color.parseColor("#FF4081") : Color.parseColor(authUIModel.numberColor);
        double numberFrameOffsetY = authUIModel.numberFrameOffsetY == null ? (sloganFrameOffsetY + sloganTextSize + kPadding) : authUIModel.numberFrameOffsetY;

        double loginBtnOffsetY = authUIModel.loginBtnFrameOffsetY == null ? dialogHeight * .5 : authUIModel.loginBtnFrameOffsetY;
        double loginBtnWidth = authUIModel.loginBtnWidth == null ? dialogWidth * 0.85 : authUIModel.loginBtnWidth;
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

        boolean changeBtnIsHidden = authUIModel.changeBtnIsHidden == null || authUIModel.changeBtnIsHidden;
        double changeBtnFrameOffsetY = authUIModel.changeBtnFrameOffsetY == null ? loginBtnOffsetY + loginBtnHeight + kPadding * 2 : authUIModel.changeBtnFrameOffsetY;
        double privacyFrameOffsetYFromBottom = authUIModel.privacyFrameOffsetY == null ? 32 : authUIModel.privacyFrameOffsetY;
        String privacyPreText = authUIModel.privacyPreText == null ? "ηΉε»δΈι?η»ε½θ‘¨η€Ίζ¨ε·²η»ιθ―»εΉΆεζ" : authUIModel.privacyPreText;
        boolean checkBoxIsHidden = authUIModel.checkBoxIsHidden == null || authUIModel.checkBoxIsHidden;
        String checkedImage = authUIModel.checkedImage == null ? "icon_check" : authUIModel.checkedImage;
        String unCheckImage = authUIModel.uncheckImage == null ? "icon_uncheck" : authUIModel.uncheckImage;

        ///θͺε?δΉζ§δ»Ά
        if (authUIModel.customViewBlockList != null) {
            buildCustomView(authUIModel.customViewBlockList);
        }

        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
                .setLayout(R.layout.dialog_action_bar, new AbstractPnsViewDelegate() {
                    @Override
                    public void onViewCreated(View view) {
                        findViewById(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                mAuthHelper.quitLoginPage();
                                //mActivity.finish();
                            }
                        });
                    }
                })
                .build());

        mAuthHelper.setAuthUIConfig(new AuthUIConfig.Builder()
                .setWebViewStatusBarColor(Color.GRAY)
                .setWebNavColor(Color.WHITE)
                .setWebNavTextColor(Color.DKGRAY)
                .setNavReturnImgPath("icon_return")
                .setNavReturnScaleType(ImageView.ScaleType.CENTER_INSIDE)
                .setNavReturnImgWidth(20)
                .setNavReturnImgHeight(20)

                .setNavHidden(true)
                .setCheckboxHidden(true)

                .setLogoHidden(logoIsHidden)
                .setLogoOffsetY(((int) logoOffsetY))
                .setLogoWidth(((int) logoSize))
                .setLogoHeight(((int) logoSize))
                .setLogoImgPath(logoPath)

                .setSloganTextSizeDp(Font_16)
                .setSloganText("ζ¬’θΏη»ι")
                .setSloganTextColor(sloganColor)
                .setSloganOffsetY(((int) sloganFrameOffsetY))

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

                .setScreenOrientation(authPageOrientation)
                .setDialogHeight(dialogHeight)
                .setDialogWidth(dialogWidth)
                .setDialogOffsetY(0)

                .setAuthPageActIn(String.valueOf(R.anim.zoom_in), String.valueOf(R.anim.zoom_out))
                .setAuthPageActOut(String.valueOf(R.anim.zoom_in), String.valueOf(R.anim.zoom_out))
                .create());
    }
}
