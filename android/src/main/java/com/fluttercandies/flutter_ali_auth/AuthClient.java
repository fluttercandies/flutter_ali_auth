package com.fluttercandies.flutter_ali_auth;

import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.MSG_GET_MASK_SUCCESS;
import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.errorArgumentsMsg;
import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.initFailedMsg;
import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.preLoginSuccessMsg;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.fluttercandies.flutter_ali_auth.config.BaseUIConfig;
import com.fluttercandies.flutter_ali_auth.mask.DecoyMaskActivity;
import com.fluttercandies.flutter_ali_auth.model.AuthModel;
import com.fluttercandies.flutter_ali_auth.model.AuthResponseModel;
import com.fluttercandies.flutter_ali_auth.model.AuthUIModel;
import com.fluttercandies.flutter_ali_auth.utils.Constant;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.PreLoginResultListener;
import com.mobile.auth.gatewayauth.ResultCode;
import com.mobile.auth.gatewayauth.TokenResultListener;
import com.mobile.auth.gatewayauth.model.TokenRet;

import java.lang.ref.WeakReference;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class AuthClient {

    private static final String TAG = AuthClient.class.getSimpleName();

    public static final String DART_CALL_METHOD_ON_INIT = "onEvent";

//    public static final String DART_CALL_METHOD_ON_LOGIN = "loginEvent";

    public PhoneNumberAuthHelper mAuthHelper;

    private TokenResultListener tokenResultListener;

    private WeakReference<Activity> mActivity;

    private AuthModel authModel;

//    private EventChannel.EventSink eventSink;

    private BaseUIConfig baseUIConfig;

    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;

    private boolean sdkAvailable = true;

    private boolean initSdkSuccess = false;

    private int mLoginTimeout = 5;

    private static volatile AuthClient instance;

    private MethodChannel mChannel;

    //Singleton
    private AuthClient() {

    }

    public static Activity decoyMaskActivity;

    public static AuthClient getInstance() {
        if (instance == null) {
            synchronized (AuthClient.class) {
                if (instance == null) {
                    instance = new AuthClient();
                }
            }
        }
        return instance;
    }



    public void initSdk(Object arguments, @NonNull MethodChannel.Result result) {

        try {
            Gson gson = new Gson();
            String jsonBean = gson.toJson(arguments);
            authModel = gson.fromJson(jsonBean, AuthModel.class);
            AuthUIModel authUIModel = gson.fromJson(jsonBean, AuthUIModel.class);
            authModel.setAuthUIModel(authUIModel);
            Log.d(TAG, "initSdk: " + jsonBean);
        } catch (Exception e) {
            Log.e(TAG, "解析AuthModel遇到错误：" + e);
            result.error(ResultCode.CODE_ERROR_INVALID_PARAM, errorArgumentsMsg + ": " + e.getMessage(), e.getStackTrace());
            return;
        }

        if (Objects.isNull(authModel) ||
                Objects.isNull(authModel.getAndroidSdk()) ||
                TextUtils.isEmpty(authModel.getAndroidSdk())) {
            AuthResponseModel authResponseModel = AuthResponseModel.nullSdkError();
//            eventSink.success(authResponseModel.toJson());
            result.error(authResponseModel.getResultCode(), authResponseModel.getMsg(), null);
            return;
        }

        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                TokenRet tokenRet;
                try {
                    System.out.println("String s: " + s);
                    tokenRet = TokenRet.fromJson(s);
                    Log.d(TAG, "onTokenSuccess: " + tokenRet);
                    AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
                    //消息回调到flutter
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                    if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                        sdkAvailable = true;
                    } else if (ResultCode.CODE_ERROR_ENV_CHECK_SUCCESS.equals(tokenRet.getCode())) {
                        //终端支持认证 当前环境可以进行一键登录 并且加速拉起授权页面
                        accelerateLoginPage();
                    }
                } catch (Exception e) {
                    Log.e(TAG, "错误", e);

                    e.printStackTrace();
                    AuthResponseModel responseModel = AuthResponseModel.initFailed("初始化失败：" + e.getMessage());
                    //消息回调到flutter
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                }
            }

            @Override
            public void onTokenFailed(String s) {
                Log.i(TAG, "onTokenFailed:" + s);
                sdkAvailable = false;
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
                    //消息回调到flutter
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
//                    eventSink.success(authResponseModel.toJson());
                } catch (Exception e) {
                    AuthResponseModel responseModel = AuthResponseModel.tokenDecodeFailed();
                    //消息回调到flutter
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                    e.printStackTrace();
                }
                mAuthHelper.setAuthListener(null);
            }
        };
        Activity activity = mActivity.get();
        if (activity == null) {
            result.error(ResultCode.MSG_ERROR_UNKNOWN_FAIL, "当前无法获取Flutter Activity,请重启再试", null);
            return;
        }
        result.success(true);
        if (!initSdkSuccess) {
            mAuthHelper = PhoneNumberAuthHelper.getInstance(activity, tokenResultListener);
            mAuthHelper.getReporter().setLoggerEnable(authModel.getEnableLog());
            ///开始初始化
            mAuthHelper.setAuthSDKInfo(authModel.getAndroidSdk());
            mAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN);
            initSdkSuccess = true;
        } else {
            ///检查环境
            mAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN);
        }
    }

    /**
     * 检查环境是否可用
     */
//    public void checkEnv() {
//        mAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN);
//    }

    /**
     * 在不是一进app就需要登录的场景 建议调用此接口 加速拉起一键登录页面
     * 等到用户点击登录的时候 授权页可以秒拉
     * 预取号的成功与否不影响一键登录功能，所以不需要等待预取号的返回。
     */
    public void accelerateLoginPage() {
        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel responseModel = AuthResponseModel.initFailed(initFailedMsg);
//            eventSink.success(responseModel.toJson());
            mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
            return;
        }
        mAuthHelper.accelerateLoginPage(mLoginTimeout, new PreLoginResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                try {
                    TokenRet tokenRet = TokenRet.fromJson(s);
                    Log.d(TAG, "onTokenSuccess: " + tokenRet);
                    if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                        AuthResponseModel responseModel = AuthResponseModel.customModel(
                                MSG_GET_MASK_SUCCESS, preLoginSuccessMsg
                        );
                        mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                    } else {
                        AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
                        mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                    }
                } catch (Exception e) {
                    AuthResponseModel responseModel = AuthResponseModel.tokenDecodeFailed();
//                    eventSink.success(responseModel.toJson());
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                    e.printStackTrace();
                }
            }

            @Override
            public void onTokenFailed(String s, String s1) {
                try {

                    AuthResponseModel responseModel = AuthResponseModel.customModel(
                            ResultCode.CODE_GET_MASK_FAIL, ResultCode.MSG_GET_MASK_FAIL
                    );
//                    eventSink.success(authResponseModel.toJson());
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                } catch (Exception e) {
                    AuthResponseModel responseModel = AuthResponseModel.tokenDecodeFailed();
//                    eventSink.success(responseModel.toJson());
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * 拉起登录授权页面并获取Token
     */
    public void getLoginToken(Object arguments, @NonNull MethodChannel.Result result) {
        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel responseModel = AuthResponseModel.initFailed(initFailedMsg);
//            eventSink.success(responseModel.toJson());
            result.error(responseModel.getResultCode(), responseModel.getMsg(), null);
            return;
        }
        Activity activity = mActivity.get();
        if (activity == null) {
            result.error(ResultCode.MSG_ERROR_UNKNOWN_FAIL, "当前无法获取Flutter Activity,请重启再试", null);
            return;
        }
        //设置超时
        setLoginTimeout((int) arguments);
        Context context = activity.getBaseContext();
        baseUIConfig = BaseUIConfig.init(authModel.getAuthUIStyle(), activity, mAuthHelper, mChannel, flutterPluginBinding.getFlutterAssets());
        assert baseUIConfig != null;
        clearCached();
        baseUIConfig.configAuthPage(authModel.getAuthUIModel());

        // override the decoy activity open enter animation
        if (authModel.getAuthUIStyle().equals(Constant.DIALOG_PORT)) {
            activity.overridePendingTransition(R.anim.zoom_in, 0);
        } else {
            activity.overridePendingTransition(R.anim.slide_up, 0);
        }
        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                activity.runOnUiThread(() -> {
                    TokenRet tokenRet;
                    try {
                        if (s != null && !s.equals("")) {
                            tokenRet = TokenRet.fromJson(s);
                            AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
                            mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
//                            eventSink.success(authResponseModel.toJson());
                            if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                                mAuthHelper.hideLoginLoading();
                                mAuthHelper.quitLoginPage();
                                mAuthHelper.setAuthListener(null);
                                clearCached();
                            } else if (ResultCode.CODE_ERROR_FUNCTION_TIME_OUT.equals(tokenRet.getCode())
                                    || ResultCode.MSG_ERROR_START_AUTHPAGE_FAIL.equals(tokenRet.getCode())) {
                                if (decoyMaskActivity != null) {
                                    decoyMaskActivity.finish();

                                }
                            }
                            Log.d(TAG, "onTokenSuccess: " + tokenRet);
                        } else {
                            if (decoyMaskActivity != null) {
                                decoyMaskActivity.finish();

                            }
                        }
                    } catch (Exception e) {
                        AuthResponseModel responseModel = AuthResponseModel.tokenDecodeFailed();
                        mChannel.invokeMethod(ResultCode.MSG_ERROR_UNKNOWN_FAIL, responseModel.toJson());
                        e.printStackTrace();
                        if (decoyMaskActivity != null) {
                            decoyMaskActivity.finish();

                        }
                    }
                });
            }

            @Override
            public void onTokenFailed(String s) {
                Log.w(TAG, "获取Token失败:" + s + " ," + "DecoyMaskActivity.isRunning:" + decoyMaskActivity);
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    Log.i(TAG, "tokenRet:" + tokenRet);
                    AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (decoyMaskActivity != null) {
                    decoyMaskActivity.finish();

                }
                mAuthHelper.setAuthListener(null);
                clearCached();
            }
        };
        mAuthHelper.setAuthListener(tokenResultListener);
        Intent intent = new Intent(context, DecoyMaskActivity.class);
        activity.startActivity(intent);
        result.success(null);
    }

    public void getLoginTokenWithConfig(Object arguments, @NonNull MethodChannel.Result result) {
        if (Objects.isNull(mAuthHelper) || !sdkAvailable) {
            AuthResponseModel responseModel = AuthResponseModel.initFailed(initFailedMsg);
//            eventSink.success(authResponseModel.toJson());
            result.error(responseModel.getResultCode(), responseModel.getMsg(), null);
            return;
        }
        Activity activity = mActivity.get();
        if (activity == null) {
            result.error(ResultCode.MSG_ERROR_UNKNOWN_FAIL, "当前无法获取Flutter Activity,请重启再试", null);
            return;
        }
        ///设置超时
        try {
            String jsonBean = new Gson().toJson(arguments);
            authModel = new Gson().fromJson(jsonBean, AuthModel.class);
            AuthUIModel authUIModel = new Gson().fromJson(jsonBean, AuthUIModel.class);
            authModel.setAuthUIModel(authUIModel);
        } catch (JsonSyntaxException e) {
            Log.e(TAG, errorArgumentsMsg + ": " + e);
            AuthResponseModel responseModel = AuthResponseModel.initFailed(errorArgumentsMsg + ": " + e.getMessage());
//            eventSink.success(responseModel.toJson());
            result.error(responseModel.getResultCode(), responseModel.getMsg(), e.getStackTrace());
            return;
        } catch (Exception e) {
            Log.e(TAG, "解析AuthModel遇到错误：" + e);
            AuthResponseModel responseModel = AuthResponseModel.initFailed("解析AuthModel遇到错误：" + e.getMessage());
//            eventSink.success(authResponseModel.toJson());
            result.error(responseModel.getResultCode(), responseModel.getMsg(), e.getStackTrace());
            return;
        }
        baseUIConfig = BaseUIConfig.init(authModel.getAuthUIStyle(), activity, mAuthHelper, mChannel, flutterPluginBinding.getFlutterAssets());
        assert baseUIConfig != null;
        clearCached();
        baseUIConfig.configAuthPage(authModel.getAuthUIModel());
        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                // Log.w(TAG,"获取Token成功:"+s);
                activity.runOnUiThread(() -> {
                    TokenRet tokenRet;
                    try {
                        if (s != null && !s.equals("")) {
                            tokenRet = TokenRet.fromJson(s);

                            AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
//                            eventSink.success(responseModel.toJson());
                            mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                            if (ResultCode.CODE_SUCCESS.equals(tokenRet.getCode())) {
                                mAuthHelper.hideLoginLoading();
                                mAuthHelper.quitLoginPage();
                                mAuthHelper.setAuthListener(null);
                                clearCached();
                            } else if (ResultCode.CODE_ERROR_FUNCTION_TIME_OUT.equals(tokenRet.getCode())
                                    || ResultCode.MSG_ERROR_START_AUTHPAGE_FAIL.equals(tokenRet.getCode())) {
                                if (decoyMaskActivity != null) {
                                    decoyMaskActivity.finish();

                                }
                            }

                            Log.i(TAG, "onTokenSuccess tokenRet:" + tokenRet);
                        }else{
                            if (decoyMaskActivity != null) {
                                decoyMaskActivity.finish();

                            }
                        }
                    } catch (Exception e) {
                        AuthResponseModel responseModel = AuthResponseModel.tokenDecodeFailed();
                        mChannel.invokeMethod(ResultCode.MSG_ERROR_UNKNOWN_FAIL, responseModel.toJson());
                        e.printStackTrace();
                        if (decoyMaskActivity != null) {
                            decoyMaskActivity.finish();

                        }
                    }
                });
            }

            @Override
            public void onTokenFailed(String s) {
                Log.w(TAG, "获取Token失败:" + s + " ," + "DecoyMaskActivity.isRunning:" + decoyMaskActivity);
                if (decoyMaskActivity != null) {
                    decoyMaskActivity.finish();

                }
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);
                    Log.i(TAG, "onTokenFailed tokenRet:" + tokenRet);
                    AuthResponseModel responseModel = AuthResponseModel.fromTokenRect(tokenRet);
                    mChannel.invokeMethod(DART_CALL_METHOD_ON_INIT, responseModel.toJson());
                } catch (Exception e) {
                    e.printStackTrace();
                }
                mAuthHelper.setAuthListener(null);
                clearCached();
            }
        };
        mAuthHelper.setAuthListener(tokenResultListener);
        /// override the decoy activity open enter animation
        if (authModel.getAuthUIStyle().equals(Constant.DIALOG_PORT)) {
            activity.overridePendingTransition(R.anim.zoom_in, 0);
        } else {
            activity.overridePendingTransition(R.anim.slide_up, 0);
        }
        Intent intent = new Intent(activity, DecoyMaskActivity.class);
        activity.startActivity(intent);
        result.success(null);
    }

    /**
     * 关闭授权页loading
     * SDK完成回调之后不会关闭loading，需要开发者主动调用hideLoginLoading关闭loading
     */
    public void hideLoginLoading() {
        mAuthHelper.hideLoginLoading();
    }

    /**
     * 退出授权认证页
     * SDK完成回调之后不会关闭授权页，需要开发者主动调⽤quitLoginPage退出授权页
     */
    public void quitLoginPage() {
        mAuthHelper.quitLoginPage();
    }

    public void clearCached() {
        mAuthHelper.removeAuthRegisterXmlConfig();
        mAuthHelper.removeAuthRegisterViewConfig();
    }

    public void setActivity(WeakReference<Activity> activity) {
        this.mActivity = activity;
    }


    public AuthModel getAuthModel() {
        return authModel;
    }

    public void setFlutterPluginBinding(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding;
    }

    public void setLoginTimeout(int timeout) {
        this.mLoginTimeout = timeout;
    }

    public int getLoginTimeout() {
        return mLoginTimeout;
    }

    public MethodChannel getChannel() {
        return mChannel;
    }

    public void setChannel(MethodChannel mChannel) {
        this.mChannel = mChannel;
    }
}
