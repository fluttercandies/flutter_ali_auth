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
import com.fluttercandies.flutter_ali_auth.utils.Constant;
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

    public void initSdk(Object arguments) {
        try {
            authModel = AuthModel.Builder(arguments);
        } catch (Exception e) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(errorArgumentsMsg);
            eventSink.success(authResponseModel.toJson());
        }

        if (Objects.isNull(authModel.getAndroidSdk()) || TextUtils.isEmpty(authModel.getAndroidSdk())) {
            AuthResponseModel authResponseModel = AuthResponseModel.nullSdkError();
            eventSink.success(authResponseModel.toJson());
            return;
        }

        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                TokenRet tokenRet;
                try {
                    tokenRet = TokenRet.fromJson(s);

                    if (ResultCode.CODE_ERROR_ENV_CHECK_SUCCESS.equals(tokenRet.getCode())) {
                        //?????????????????? ???????????????????????????????????? ??????????????????????????????
                        accelerateLoginPage();
                    }
                    AuthResponseModel authResponseModel = AuthResponseModel.fromTokenRect(tokenRet);
                    eventSink.success(authResponseModel.toJson());
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
        mAuthHelper.getReporter().setLoggerEnable(authModel.getEnableLog());
        ///???????????????
        mAuthHelper.setAuthSDKInfo(authModel.getAndroidSdk());
        checkEnv();
    }

    /**
     * ????????????????????????
     */
    public void checkEnv() {
        mAuthHelper.checkEnvAvailable(PhoneNumberAuthHelper.SERVICE_TYPE_AUTH);
    }

    /**
     * ???????????????app???????????????????????? ????????????????????? ??????????????????????????????
     * ????????????????????????????????? ?????????????????????
     * ????????????????????????????????????????????????????????????????????????????????????????????????
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
        baseUIConfig = BaseUIConfig.init(authModel.getAuthUIStyle(), activity, mAuthHelper, eventSink, flutterPluginBinding.getFlutterAssets());
        assert baseUIConfig != null;
        clearCached();
        baseUIConfig.configAuthPage(authModel.getAuthUIModel());
        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
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
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
            }

            @Override
            public void onTokenFailed(String s) {
                Log.w(TAG, "??????Token??????:" + s);
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
        if (authModel.getAuthUIStyle().equals(Constant.DIALOG_PORT)) {
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
            authModel = AuthModel.Builder(arguments);
            Log.i(TAG, authModel.toString());
        } catch (Exception e) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(errorArgumentsMsg);
            eventSink.success(authResponseModel.toJson());
        }
        baseUIConfig = BaseUIConfig.init(authModel.getAuthUIStyle(), activity, mAuthHelper, eventSink, flutterPluginBinding.getFlutterAssets());
        assert baseUIConfig != null;
        clearCached();
        baseUIConfig.configAuthPage(authModel.getAuthUIModel());
        tokenResultListener = new TokenResultListener() {
            @Override
            public void onTokenSuccess(String s) {
                // Log.w(TAG,"??????Token??????:"+s);
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
                Log.w(TAG, "??????Token??????:" + s);
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
        /// override the decoy activity open enter animation
        if (authModel.getAuthUIStyle().equals(Constant.DIALOG_PORT)) {
            activity.overridePendingTransition(R.anim.zoom_in, 0);
        } else {
            activity.overridePendingTransition(R.anim.slide_up, 0);
        }
        Intent intent = new Intent(context, DecoyMaskActivity.class);

        activity.startActivity(intent);
    }

    /**
     * ???????????????loading
     * SDK??????????????????????????????loading??????????????????????????????hideLoginLoading??????loading
     */
    public void hideLoginLoading() {
        mAuthHelper.hideLoginLoading();
    }

    /**
     * ?????????????????????
     * SDK?????????????????????????????????????????????????????????????????????quitLoginPage???????????????
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
