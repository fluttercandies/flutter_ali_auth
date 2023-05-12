package com.fluttercandies.flutter_ali_auth.config;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.Surface;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.fluttercandies.flutter_ali_auth.AuthClient;
import com.fluttercandies.flutter_ali_auth.utils.Constant;
import com.fluttercandies.flutter_ali_auth.model.AuthResponseModel;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.fluttercandies.flutter_ali_auth.model.CustomViewBlock;
import com.fluttercandies.flutter_ali_auth.utils.AppUtils;
import com.mobile.auth.gatewayauth.AuthRegisterViewConfig;
import com.mobile.auth.gatewayauth.CustomInterface;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import static com.fluttercandies.flutter_ali_auth.utils.AppUtils.dp2px;

import androidx.annotation.NonNull;

import com.fluttercandies.flutter_ali_auth.R;

import java.io.InputStream;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;


public abstract class BaseUIConfig {
    public Activity mActivity;
    public Context mContext;
    public PhoneNumberAuthHelper mAuthHelper;
    public int mScreenWidthDp;
    public int mScreenHeightDp;
    //    public EventChannel.EventSink mEventSink;
    public MethodChannel mChannel;
    public FlutterPlugin.FlutterAssets mFlutterAssets;

    public BaseUIConfig(Activity activity, PhoneNumberAuthHelper authHelper,MethodChannel methodChannel, FlutterPlugin.FlutterAssets flutterAssets) {
        mActivity = activity;
        mContext = activity.getApplicationContext();
        mAuthHelper = authHelper;
        mChannel = methodChannel;
        mFlutterAssets = flutterAssets;
    }


    public static BaseUIConfig init(int type, Activity activity, PhoneNumberAuthHelper authHelper, MethodChannel methodChannel,FlutterPlugin.FlutterAssets flutterAssets) {
        switch (type) {
            case Constant.FULL_PORT:
                return new FullPortConfig(activity, authHelper,methodChannel,flutterAssets);
            case Constant.DIALOG_BOTTOM:
                return new DialogBottomConfig(activity, authHelper,methodChannel,flutterAssets);
            case Constant.DIALOG_PORT:
                return new DialogPortConfig(activity, authHelper,methodChannel,flutterAssets);
            default:
                return null;
        }
    }



    protected View initSwitchView() {
        TextView switchTV = new TextView(mActivity);
        RelativeLayout.LayoutParams mLayoutParams = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.WRAP_CONTENT, dp2px(mActivity, 50));
        //一键登录按钮默认marginTop 270dp
        mLayoutParams.setMargins(0, dp2px(mContext, 350), 0, 0);
        mLayoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL, RelativeLayout.TRUE);
        switchTV.setText(R.string.switch_msg);
        switchTV.setTextColor(Color.BLACK);
        switchTV.setTextSize(TypedValue.COMPLEX_UNIT_SP, 13.0F);
        switchTV.setLayoutParams(mLayoutParams);
        return switchTV;
    }

    protected void updateScreenSize(int authPageScreenOrientation) {
        int screenHeightDp = AppUtils.px2dp(mContext, AppUtils.getPhoneHeightPixels(mContext));
        int screenWidthDp = AppUtils.px2dp(mContext, AppUtils.getPhoneWidthPixels(mContext));
        int rotation = mActivity.getWindowManager().getDefaultDisplay().getRotation();
        if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_BEHIND) {
            authPageScreenOrientation = mActivity.getRequestedOrientation();
        }
        if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_USER_LANDSCAPE) {
            rotation = Surface.ROTATION_90;
        } else if (authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT
                || authPageScreenOrientation == ActivityInfo.SCREEN_ORIENTATION_USER_PORTRAIT) {
            rotation = Surface.ROTATION_180;
        }
        switch (rotation) {
            case Surface.ROTATION_0:
            case Surface.ROTATION_180:
                mScreenWidthDp = screenWidthDp;
                mScreenHeightDp = screenHeightDp;
                break;
            case Surface.ROTATION_90:
            case Surface.ROTATION_270:
                mScreenWidthDp = screenHeightDp;
                mScreenHeightDp = screenWidthDp;
                break;
            default:
                break;
        }
    }

    public abstract void configAuthPage(AuthUIModel authUIModel);

    /**
     *  在横屏APP弹竖屏一键登录页面或者竖屏APP弹横屏授权页时处理特殊逻辑
     *  Android8.0只能启动SCREEN_ORIENTATION_BEHIND模式的Activity
     */
    public void onResume() {

    }

    public void buildCustomView( @NonNull List<CustomViewBlock> customViewConfigList) {
        for (CustomViewBlock customViewBlock : customViewConfigList) {
            View view = null;
            if (customViewBlock.image != null){
                ImageView imageView = new ImageView(mContext);
                String flutterAssetFilePath = mFlutterAssets.getAssetFilePathByName(customViewBlock.image);
                AssetManager assets = mContext.getAssets();
                try {
                    InputStream open = assets.open(flutterAssetFilePath);
                    Bitmap bitmap = BitmapFactory.decodeStream(open);
                    imageView.setImageBitmap(bitmap);
                }catch (Exception e){
                    e.printStackTrace();
                }
                imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
                view = imageView;
            }
            else if (customViewBlock.text != null){
                TextView textView = new TextView(mContext);
                textView.setText(customViewBlock.text);
                textView.setTextColor(Color.parseColor(customViewBlock.textColor));
                textView.setTextSize(customViewBlock.textSize.floatValue());
                textView.setGravity(Gravity.CENTER);
                view = textView;
            }

            int width = dp2px(mContext, customViewBlock.width == null ? 30 : customViewBlock.width.floatValue());
            int height = dp2px(mContext, customViewBlock.height == null ? 30 : customViewBlock.height.floatValue());
            RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(width, height);
            int offsetX = dp2px(mContext, customViewBlock.offsetX == null ? 0 : customViewBlock.offsetX.floatValue());
            int offsetY = dp2px(mContext, customViewBlock.offsetY == null ? 0 : customViewBlock.offsetY.floatValue());
            layoutParams.setMargins(offsetX,  offsetY, 0, 0);
            if(view != null){
                view.setLayoutParams(layoutParams);
            }
            CustomInterface customInterface = null;
            if (customViewBlock.enableTap != null && customViewBlock.enableTap){
                customInterface = context -> {
                    AuthResponseModel responseModel = AuthResponseModel.onCustomViewBlocTap(customViewBlock.viewId);
//                    mEventSink.success(authResponseModel.toJson());
                    mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());
                    mAuthHelper.quitLoginPage();
                    AuthClient.getInstance().clearCached();
                };
            }
            mAuthHelper.addAuthRegistViewConfig(customViewBlock.viewId.toString(), new AuthRegisterViewConfig.Builder()
                    .setView(view)
                    .setRootViewId(AuthRegisterViewConfig.RootViewId.ROOT_VIEW_ID_BODY)
                    .setCustomInterface(customInterface).build()
            );
        }
    }


}