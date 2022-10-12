package com.fluttercandies.flutter_ali_auth.config;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.os.Build;
import android.view.View;
import android.widget.FrameLayout;
import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.helper.CacheManage;
import com.fluttercandies.flutter_ali_auth.helper.NativeBackgroundAdapter;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig;
import com.mobile.auth.gatewayauth.AuthUIConfig;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate;
import com.nirvana.tools.core.AppUtils;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

/**
 * xml文件方便预览
 * 可以通过addAuthRegisterXmlConfig一次性统一添加授权页的所有自定义view
 */
public class CustomPicConfig extends BaseUIConfig {
    private CacheManage mCacheManage;
    private ExecutorService mThreadExecutor;
    private NativeBackgroundAdapter nativeBackgroundAdapter;
    public CustomPicConfig(Activity activity, PhoneNumberAuthHelper authHelper, EventChannel.EventSink eventSink) {
        super(activity, authHelper,eventSink);
        mCacheManage=new CacheManage(activity.getApplication());
        mThreadExecutor=new ThreadPoolExecutor(Runtime.getRuntime().availableProcessors(),
            Runtime.getRuntime().availableProcessors(),
            0, TimeUnit.SECONDS, new ArrayBlockingQueue<Runnable>(10), new ThreadPoolExecutor.CallerRunsPolicy());
        nativeBackgroundAdapter =
            new NativeBackgroundAdapter(mCacheManage, mThreadExecutor, activity, "imagePath"
                , "background_image.jpeg");
    }
    @Override
    public void configAuthPage(FlutterPlugin.FlutterPluginBinding flutterPluginBinding, AuthUIModel authUIModel) {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();
        int authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
        if (Build.VERSION.SDK_INT == 26) {
            authPageOrientation = ActivityInfo.SCREEN_ORIENTATION_BEHIND;
        }

        mAuthHelper.addAuthRegisterXmlConfig(new AuthRegisterXmlConfig.Builder()
            .setLayout(R.layout.authsdk_widget_custom_layout, new AbstractPnsViewDelegate() {
                @Override
                public void onViewCreated(View view) {
                    final FrameLayout fly_container = view.findViewById(R.id.fly_container);
                    nativeBackgroundAdapter.solveView(fly_container, "#3F51B5");
                }
            })
            .build());
        String packageName = AppUtils.getPackageName(mActivity);
        mAuthHelper.setAuthUIConfig(new AuthUIConfig.Builder()
            .setAppPrivacyOne("《自定义隐私协议》", "https://test.h5.app.tbmao.com/user")
            .setAppPrivacyTwo("《百度》", "https://www.baidu.com")
            .setAppPrivacyColor(Color.GRAY, Color.parseColor("#FFFFFF"))
            .setNavHidden(true)
            .setLogoHidden(true)
            .setHiddenLoading(true)
            .setSloganHidden(true)
            //自定义协议页跳转协议，需要在清单文件配置自定义intent-filter，不需要自定义协议页，则请不要配置ProtocolAction
            .setProtocolAction("com.aliqin.mytel.protocolWeb")
            .setPackageName(packageName)
            .setSwitchAccHidden(true)
            .setPrivacyState(false)
            .setUncheckedImgPath("unchecked")
            //.setCheckedImgDrawable(mActivity.getResources().getDrawable(R.drawable.checked))
            .setLightColor(true)
            .setWebViewStatusBarColor(Color.TRANSPARENT)
            .setStatusBarColor(Color.TRANSPARENT)
            .setPrivacyTextSizeDp(15)
            .setStatusBarUIFlag(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN)
            .setNumberSizeDp(20)
            .setNumberColor(Color.parseColor("#FFFFFF"))
            .setAuthPageActIn("in_activity", "out_activity")
            .setAuthPageActOut("in_activity", "out_activity")
            .setVendorPrivacyPrefix("《")
            .setVendorPrivacySuffix("》")
            .setPageBackgroundPath("page_background_color")
            .setLogoImgPath("mytel_app_launcher")
            .setLogBtnBackgroundDrawable(mActivity.getResources().getDrawable(R.drawable.login_btn_bg))
            .setScreenOrientation(authPageOrientation)
            .create());
    }
}
