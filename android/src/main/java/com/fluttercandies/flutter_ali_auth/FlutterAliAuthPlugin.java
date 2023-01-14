package com.fluttercandies.flutter_ali_auth;

import static com.fluttercandies.flutter_ali_auth.model.AuthResponseModel.failedListeningMsg;

import android.app.Activity;
import android.content.res.AssetManager;
import android.util.Log;

import androidx.annotation.NonNull;

import com.fluttercandies.flutter_ali_auth.model.AuthResponseModel;
import com.fluttercandies.flutter_ali_auth.utils.AppUtils;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

import java.lang.ref.WeakReference;
import java.util.Objects;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterAliAuthPlugin
 */
public class FlutterAliAuthPlugin implements FlutterPlugin,
        MethodCallHandler, ActivityAware, EventChannel.StreamHandler {

    public static final String TAG = FlutterAliAuthPlugin.class.getSimpleName();


    private AuthClient authClient;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_ali_auth");

        authClient = AuthClient.getInstance();

        EventChannel auth_event = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "auth_event");

        authClient.setFlutterPluginBinding(flutterPluginBinding);

        auth_event.setStreamHandler(this);

        channel.setMethodCallHandler(this);

    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.i(TAG,call.method);
        switch (call.method) {
            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                return;
            case "getAliAuthVersion":
                getAliAuthVersion(result);
                return;
            case "cancelStream":
                if (authClient.getEventSink() != null) {
                    authClient.getEventSink().endOfStream();
                }
                result.success(null);
                return;
            case "hideLoginLoading":
                authClient.hideLoginLoading();
                result.success(null);
                return;
            case "quitLoginPage":
                authClient.quitLoginPage();
                result.success(null);
                return;
        }
        if (Objects.isNull(authClient.getEventSink())) {
            AuthResponseModel authResponseModel = AuthResponseModel.initFailed(failedListeningMsg);
            result.success(authResponseModel.toJson());
            return;
        }
        ///初始化相关
        switch (call.method) {
            case "init":
                authClient.initSdk(call.arguments);
                break;
            case "checkEnv":
                authClient.checkEnv();
                break;
            case "accelerateLoginPage":
                authClient.accelerateLoginPage();
                break;
            case "login":
                authClient.setLoginTimeout(AppUtils.integerTryParser(call.arguments, 5000));
                authClient.getLoginToken();
                break;
            case "loginWithConfig":
                authClient.getLoginToken(call.arguments);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void getAliAuthVersion(@NonNull Result result) {
        String version = PhoneNumberAuthHelper.getVersion();
        result.success("阿里云一键登录版本:" + version);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        authClient.setFlutterPluginBinding(null);
        onCancel(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        WeakReference<Activity> activityWeakReference = new WeakReference<>(binding.getActivity());
        authClient.setActivity(activityWeakReference);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        if (authClient.getEventSink() != null) {
            authClient.getEventSink().endOfStream();
            authClient.setEventSink(null);
        }
        authClient.setEventSink(events);
    }

    @Override
    public void onCancel(Object arguments) {
        if (Objects.nonNull(authClient.getEventSink())) {
            authClient.setEventSink(null);
        }
        Log.i(FlutterAliAuthPlugin.TAG, "取消监听" + authClient.getEventSink());
    }
}
