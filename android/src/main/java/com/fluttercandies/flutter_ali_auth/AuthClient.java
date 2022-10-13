package com.fluttercandies.flutter_ali_auth;

import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.MSG_GET_MASK_SUCCESS;
import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.errorArgumentsMsg;
import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.initFailedMsg;
import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.preLoginSuccessMsg;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import com.fluttercandies.flutter_ali_auth.config.BaseUIConfig;
import com.fluttercandies.flutter_ali_auth.mask.DecoyMaskActivity;
import com.fluttercandies.flutter_ali_auth.model.AuthModel;
import com.fluttercandies.flutter_ali_auth.model.AuthResponseModel;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.ResultCode;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;

import java.lang.ref.WeakReference;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;

public class AuthClient {

    private static final String TAG = AuthClient.class.getSimpleName();

    public PhoneNumberAuthHelper mAuthHelper;

    private TokenResultListener tokenResultListener;

    private WeakReference<Activity> mActivity;

    private AuthModel authModel;

    private EventChannel.EventSink eventSink;

    private BaseUIConfig baseUIConfig;

    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private boolean sdkAvailable = true;

    private int mLoginTimeout;

    private static volatile AuthClient instance;

    //Singleton
    private AuthClient() {

    }

    public static AuthClient getInstance(){
        if (instance == null){
            synchronized (AuthClient.class){
                if (instance  == null){
                    instance = new AuthClient();
                }
            }
        }
        return instance;
    }

    public void initSdk(Object arguments) {
        try {
            authModel = AuthModel.fromJson(arguments);
        } catch (Exception e) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(errorArgumentsMsg);
            eventSink.success(authResponseModel.toJson());
        }

        if (Objects.isNull(authModel.androidSdk) || TextUtils.isEmpty(authModel.androidSdk)) {
            AuthResponseModel authResponseModel = AuthResponseModel.nullSdkError();
            eventSink.success(authResponseModel.toJson());
            return;
        }
        Log.i(TAG, "authModel:" + authModel);

        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    if (ResultCode.CODE_ERROR_ENV_CHECK_SUCCESS.equals(tokenRet.getCode())) {
                        //终端支持认证 当前环境可以进行一键登录
                        AuthResponseModel authResponseModel = AuthResponseModel.fromTokenRect(tokenRet);
                        eventSink.success(authResponseModel.toJson());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onTokenFailed(String s) {
                sdkAvailable = false;
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    AuthResponseModel authResponseModel = AuthResponseModel.fromTokenRect(tokenRet);
                    eventSink.success(authResponseModel.toJson());
                } catch (Exception e) {
                    AuthResponseModel authResponseModel = AuthResponseModel.tokenDecodeFailed();
                    eventSink.success(authResponseModel.toJson());
                    e.printStackTrace();
                }
                mAuthHelper.setAuthListener(null);
            }
        };
        Context context = mActivity.get().getBaseContext();
        mAuthHelper = PhoneNumberAuthHelper.getInstance(context, tokenResultListener);
        mAuthHelper.getReporter().setLoggerEnable(true);
        mAuthHelper.setAuthSDKInfo(authModel.androidSdk);
        checkEnv();
    }

    /**
     * 检查环境是否可用
     */
    public void checkEnv() {
        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(initFailedMsg);
            eventSink.success(authResponseModel.toJson());
            return;
        }
        mAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_AUTH);
    }

    /**
     * 在不是一进app就需要登录的场景 建议调用此接口 加速拉起一键登录页面
     * 等到用户点击登录的时候 授权页可以秒拉
     * 预取号的成功与否不影响一键登录功能，所以不需要等待预取号的返回。
     *
     */
    public void accelerateLoginPage() {
        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(initFailedMsg);
            eventSink.success(authResponseModel.toJson());
            return;
        }
        mAuthHelper.accelerateLoginPage(mLoginTimeout, new PreLoginResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                Log.i(TAG, "预取成功：" + s);
                try {
                    AuthResponseModel authResponseModel = AuthResponseModel.customModel(
                            MSG_GET_MASK_SUCCESS, preLoginSuccessMsg
                    );
                    eventSink.success(authResponseModel.toJson());
                } catch (Exception e) {
                    AuthResponseModel authResponseModel = AuthResponseModel.tokenDecodeFailed();
                    eventSink.success(authResponseModel.toJson());
                    e.printStackTrace();
                }
            }

            @Override
            public void onTokenFailed(String s, String s1) {
                Log.e(TAG, "预取号失败：" + s);
                try {
                    AuthResponseModel authResponseModel = AuthResponseModel.customModel(
                            ResultCode.CODE_GET_MASK_FAIL, ResultCode.MSG_GET_MASK_FAIL
                    );
                    eventSink.success(authResponseModel.toJson());
                } catch (Exception e) {
                    AuthResponseModel authResponseModel = AuthResponseModel.tokenDecodeFailed();
                    eventSink.success(authResponseModel.toJson());
                    e.printStackTrace();
                }
            }
        });
    }

    public void getLoginToken() {

        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(initFailedMsg);
            eventSink.success(authResponseModel.toJson());
            return;
        }

        Activity activity = mActivity.get();

        Context context = activity.getBaseContext();

        baseUIConfig = BaseUIConfig.init(authModel.authUIStyle, activity, mAuthHelper, eventSink);

        assert baseUIConfig != null;

        clearCached();

        baseUIConfig.configAuthPage(flutterPluginBinding, authModel.authUIModel);

        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                // Log.w(TAG,"获取Token成功:"+s);
                activity.runOnUiThread(() -> {
                    TokenRet tokenRet;
                    try {
                        tokenRet = TokenRet.fromJson(s);

                        AuthResponseModel authResponseModel = AuthResponseModel.fromTokenRect(tokenRet);

                        eventSink.success(authResponseModel.toJson());
                        if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                            mAuthHelper.quitLoginPage();
                            mAuthHelper.setAuthListener(null);
                            clearCached();
                        }
                        Log.i(TAG, "tokenRet:" + tokenRet);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
            }

            @Override
            public void onTokenFailed(String s) {
                Log.w(TAG, "获取Token失败:" + s);
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    Log.i(TAG, "tokenRet:" + tokenRet);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                mAuthHelper.setAuthListener(null);
                clearCached();
            }
        };
        mAuthHelper.setAuthListener(tokenResultListener);

        // override the decoy activity open enter animation
        if (authModel.authUIStyle.equals(Constant.DIALOG_PORT)) {
            activity.overridePendingTransition(R.anim.zoom_in, 0);
        } else {
            activity.overridePendingTransition(R.anim.slide_up, 0);
        }

        Intent intent = new Intent(context, DecoyMaskActivity.class);

        activity.startActivity(intent);
    }

    public void getLoginToken(Object arguments) {

        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(initFailedMsg);
            eventSink.success(authResponseModel.toJson());
            return;
        }

        Activity activity = mActivity.get();

        Context context = activity.getBaseContext();

        try {
            authModel = AuthModel.fromJson(arguments);
        } catch (Exception e) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(errorArgumentsMsg);
            eventSink.success(authResponseModel.toJson());
        }

        Log.i(TAG, "AuthModel:" + authModel);

        baseUIConfig = BaseUIConfig.init(authModel.authUIStyle, activity, mAuthHelper, eventSink);

        assert baseUIConfig != null;

        clearCached();

        baseUIConfig.configAuthPage(flutterPluginBinding, authModel.authUIModel);

        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                // Log.w(TAG,"获取Token成功:"+s);
                activity.runOnUiThread(() -> {
                    TokenRet tokenRet;
                    try {
                        tokenRet = TokenRet.fromJson(s);

                        AuthResponseModel authResponseModel = AuthResponseModel.fromTokenRect(tokenRet);

                        eventSink.success(authResponseModel.toJson());
                        if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                            mAuthHelper.quitLoginPage();
                            mAuthHelper.setAuthListener(null);
                            clearCached();
                        }
                        Log.i(TAG, "tokenRet:" + tokenRet);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
            }

            @Override
            public void onTokenFailed(String s) {
                Log.w(TAG, "获取Token失败:" + s);
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    Log.i(TAG, "tokenRet:" + tokenRet);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                mAuthHelper.setAuthListener(null);
                clearCached();
            }
        };
        mAuthHelper.setAuthListener(tokenResultListener);

        // override the decoy activity open enter animation
        if (authModel.authUIStyle.equals(Constant.DIALOG_PORT)) {
            activity.overridePendingTransition(R.anim.zoom_in, 0);
        } else {
            activity.overridePendingTransition(R.anim.slide_up, 0);
        }

        Intent intent = new Intent(context, DecoyMaskActivity.class);

        activity.startActivity(intent);
    }

    public void clearCached() {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();
    }

    public void setActivity(WeakReference<Activity> activity) {
        this.mActivity = activity;
    }

    public void setEventSink(EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    public EventChannel.EventSink getEventSink() {
        return eventSink;
    }

    public AuthModel getAuthModel() {
        return authModel;
    }

    public void setFlutterPluginBinding(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    public void setLoginTimeout(int mLoginTimeout) {
        this.mLoginTimeout = mLoginTimeout;
    }

    public int getLoginTimeout() {
        return mLoginTimeout;
    }
}
