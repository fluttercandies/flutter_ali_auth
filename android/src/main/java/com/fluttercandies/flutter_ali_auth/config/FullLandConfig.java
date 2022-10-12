package com.fluttercandies.flutter_ali_auth.config;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.Gravity;
import android.view.View;

import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

public class FullLandConfig extends BaseUIConfig {

    private int mOldScreenOrientation;

    public FullLandConfig(Activity activity, PhoneNumberAuthHelper authHelper, EventChannel.EventSink eventSink) {
        super(activity, authHelper,eventSink);
    }

    @Override
    public void configAuthPage(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, AuthUIModel authUIModel) {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();

        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
                .setLayout(R.layout.custom_port_dialog_action_bar, new AbstractPnsViewDelegate() {
                    @Override
                    public void onViewCreated(View view) {
                        findViewById(R.id.tv_title).setVisibility(View.GONE);
                        findViewById(R.id.btn_close).setOnClickListener(new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                mAuthHelper.quitLoginPage();
                            }
                        });
                    }
                })
                .build());
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE;
        if (Build.VERSION.SDK_INT == 26) {
            mOldScreenOrientation = mActivity.getRequestedOrientation();
            mActivity.setRequestedOrientation(authPageOrientation);
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }
        updateScreenSize(authPageOrientation);
        //sdk默认控件的区域是marginTop50dp
        int designHeight = mScreenHeightDp - 50;
        int unit = designHeight / 10;
        int logBtnHeight = (int) (unit * 1.2);
        int dialogHeight = (int) (mScreenHeightDp /2f);
        int dialogWidth= (int) (mScreenWidthDp*3/4f);
        mAuthHelper.setAuthUIConfig(new AuthUIConfig.Builder()
                .setAppPrivacyOne("《自定义隐私协议》", "https://www.baidu.com")
                .setAppPrivacyColor(Color.GRAY, Color.RED)
                .setSloganHidden(true)
                .setNavHidden(true)
                .setCheckedImgPath("checked")
                //设置字体大小，以Dp为单位，不同于Sp，不会随着系统字体变化而变化
                .setNumberSizeDp(35)
                //.setUncheckedImgDrawable(mActivity.getResources().getDrawable(R.drawable.unchecked))
                .setStatusBarHidden(true)
                .setLogoOffsetY(unit)
                .setLogoImgPath("phone")
                .setLogoWidth(50)
                .setLogoHeight(50)
                .setNumFieldOffsetY(unit * 3)
                .setLogBtnOffsetY(unit * 5)
                .setLogBtnHeight(logBtnHeight)
                .setSwitchOffsetY(unit * 7)
                .setLogBtnMarginLeftAndRight((mScreenHeightDp - 339) / 2)
                .setPrivacyMargin(115)
                .setLogBtnWidth(339)
                .setAuthPageActIn("in_activity", "out_activity")
                .setAuthPageActOut("in_activity", "out_activity")
                .setProtocolShakePath("protocol_shake")
                .setVendorPrivacyPrefix("《")
                .setVendorPrivacySuffix("》")
                .setPageBackgroundPath("page_background_color")
                .setLogBtnBackgroundPath("login_btn_bg")
                .setScreenOrientation(authPageOrientation)
                .create());
    }

    @Override
    public void onResume() {
        super.onResume();
        if (mOldScreenOrientation != mActivity.getRequestedOrientation()) {
            mActivity.setRequestedOrientation(mOldScreenOrientation);
        }
    }
}
