package com.fluttercandies.flutter_ali_auth.config;

import static com.fluttercandies.flutter_ali_auth.Constant.*;
import static com.fluttercandies.flutter_ali_auth.utils.AppUtils.dp2px;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.fluttercandies.flutter_ali_auth.AuthClient;
import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.helper.CustomAuthUIControlClickListener;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.fluttercandies.flutter_ali_auth.model.CustomViewBlock;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

import java.io.InputStream;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

public class FullPortConfig extends BaseUIConfig {
    private final String TAG = "全屏竖屏样式";

    public FullPortConfig(Activity activity, PhoneNumberAuthHelper authHelper, EventChannel.EventSink eventSink) {
        super(activity, authHelper, eventSink);
    }


    @Override
    public void configAuthPage(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, AuthUIModel authUIModel) {

        FlutterPlugin.FlutterAssets flutterAssets = flutterPluginBinding.getFlutterAssets();

        CustomAuthUIControlClickListener customAuthUIControlClickListener = new CustomAuthUIControlClickListener(mAuthHelper, mContext, mEventSink);

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
                logoPath = flutterAssets.getAssetFilePathByName(authUIModel.logoImage);
                Log.i("FullPortConfig", "logoPath:" + logoPath);
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

        double sloganFrameOffsetY = authUIModel.sloganFrameOffsetY == null ? (kLogoOffset + kLogoSize + kPadding) : authUIModel.sloganFrameOffsetY;

        int numberFontSize = authUIModel.numberFontSize == null ? Font_20 : authUIModel.numberFontSize;

        int numberFontColor = authUIModel.numberColor == null ? Color.parseColor("#FF4081") : Color.parseColor(authUIModel.numberColor);

        double numberFrameOffsetY = authUIModel.numberFrameOffsetY == null ? (sloganFrameOffsetY + Font_24 + kPadding) : authUIModel.numberFrameOffsetY;

        double loginBtnOffsetY = authUIModel.loginBtnFrameOffsetY == null ? mScreenHeightDp * .5 : authUIModel.loginBtnFrameOffsetY;

        double loginBtnWidth = authUIModel.loginBtnWidth == null ? mScreenWidthDp * 0.85 : authUIModel.loginBtnWidth;

        double loginBtnHeight = authUIModel.loginBtnHeight == null ? 48 : authUIModel.loginBtnHeight;

        String loginBtnImage = null;
        if (authUIModel.loginBtnNormalImage != null) {
            try {
                loginBtnImage = flutterAssets.getAssetFilePathByName(authUIModel.loginBtnNormalImage);
            } catch (Exception e) {
                e.printStackTrace();
                loginBtnImage = "login_btn_bg";
            }
        }

        boolean changeBtnIsHidden = authUIModel.changeBtnIsHidden == null || authUIModel.changeBtnIsHidden;

        double changeBtnFrameOffsetY = authUIModel.changeBtnFrameOffsetY == null ? loginBtnOffsetY + loginBtnHeight + kPadding * 2 : authUIModel.changeBtnFrameOffsetY;

        double privacyFrameOffsetYFromBottom = authUIModel.privacyFrameOffsetY == null ? 32 : authUIModel.privacyFrameOffsetY;

        String privacyPreText = authUIModel.privacyPreText == null ? "已经阅读并同意" : authUIModel.privacyPreText;

        boolean checkBoxIsHidden = authUIModel.checkBoxIsHidden != null && authUIModel.checkBoxIsHidden;

        String checkedImage = authUIModel.checkedImage == null ? "icon_check" : authUIModel.checkedImage;

        String unCheckImage = authUIModel.uncheckImage == null ? "icon_uncheck" : authUIModel.uncheckImage;

        String backgroundImagePath = null;
        if (authUIModel.backgroundImage != null) {
            try {
                backgroundImagePath = flutterAssets.getAssetFilePathByName(authUIModel.backgroundImage);
                System.out.println(backgroundImagePath);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        ///自定义控件
        if (authUIModel.customViewBlockList != null) {
            buildCustomView(flutterAssets, authUIModel.customViewBlockList.get(0));
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
                .setSloganTextSizeDp(Font_24)
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

    private void buildCustomView(FlutterPlugin.FlutterAssets flutterAssets, CustomViewBlock customViewBlock) {
        System.out.println("customViewBlock:"+customViewBlock);
        ImageView imageView = new ImageView(mContext);
        String flutterAssetFilePath = flutterAssets.getAssetFilePathByName(customViewBlock.image);
        AssetManager assets = mContext.getAssets();
        try {
            InputStream open = assets.open(flutterAssetFilePath);
            Bitmap bitmap = BitmapFactory.decodeStream(open);
            imageView.setImageBitmap(bitmap);
        }catch (Exception e){
            System.out.println("加载失败");
            e.printStackTrace();
        }
        imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);

        int width = dp2px(mContext, customViewBlock.width == null ? 30 : customViewBlock.width.floatValue());

        int height = dp2px(mContext, customViewBlock.height == null ? 30 : customViewBlock.height.floatValue());

        RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(width, height);

        int offsetX = dp2px(mContext, customViewBlock.offsetX == null ? 0 : customViewBlock.offsetX.floatValue());

        int offsetY = dp2px(mContext, customViewBlock.offsetY == null ? 0 : customViewBlock.offsetY.floatValue());

        layoutParams.setMargins(customViewBlock.offsetX.intValue(),  customViewBlock.offsetY.intValue(), 0, 0);

        System.out.println("offsetY:" + offsetY);

        imageView.setLayoutParams(layoutParams);

        mAuthHelper.addAuthRegistViewConfig(customViewBlock.viewId.toString(), new AuthRegisterViewConfig.Builder()
                .setView(initBackBtn())
                .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                .setCustomInterface(new CustomInterface() {
                    @Override
                    public void onClick(Context context) {
                        mAuthHelper.quitLoginPage();
                        AuthClient.getInstance().clearCached();
                    }
                }).build()
        );
    }

    private ImageView initBackBtn() {
        ImageView pImageView = new ImageView(mContext);
        pImageView.setImageResource(R.drawable.icon_close);
        pImageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
        RelativeLayout.LayoutParams pParams = new RelativeLayout.LayoutParams(dp2px(mContext, 20), dp2px(mContext, 20));
        pParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT, RelativeLayout.TRUE);
        pParams.addRule(RelativeLayout.CENTER_VERTICAL, RelativeLayout.TRUE);
        pParams.setMargins(dp2px(mContext, 12.0F), 0, 0, 0);
        pImageView.setLayoutParams(pParams);
        return pImageView;
    }

}
