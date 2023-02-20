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
        MethodCallHandler, ActivityAware {

    public static final String TAG = FlutterAliAuthPlugin.class.getSimpleName();


    private AuthClient authClient;

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        MethodChannel methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_ali_auth");
        authClient = AuthClient.getInstance();
        authClient.setChannel(methodChannel);
        methodChannel.setMethodCallHandler(this);
        authClient.setFlutterPluginBinding(flutterPluginBinding);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.i(TAG,"call.method:"+call.method);
        switch (call.method) {

            case "getPlatformVersion":
                result.success("Android " + android.os.Build.VERSION.RELEASE);
                break;
            case "getAliAuthVersion":
                getAliAuthVersion(result);
                break;
            case "init":
                authClient.initSdk(call.arguments, result);
                break;
            case "login":
                authClient.getLoginToken(call.arguments, result);
                break;
            case "loginWithConfig":
                authClient.getLoginTokenWithConfig(call.arguments, result);
                break;
            case "hideLoginLoading":
                authClient.hideLoginLoading();
                result.success(null);
                break;
            case "quitLoginPage":
                authClient.quitLoginPage();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void getAliAuthVersion(@NonNull Result result) {
        String version = PhoneNumberAuthHelper.getVersion();
        result.success("阿里云一键登录版本:" + version);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        authClient.setFlutterPluginBinding(null);
        authClient.getChannel().setMethodCallHandler(null);
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
        authClient.setFlutterPluginBinding(null);
        authClient.getChannel().setMethodCallHandler(null);
    }



//    @Override
//    public void onListen(Object arguments, EventChannel.EventSink events) {
//        if (authClient.getEventSink() != null) {
//            authClient.getEventSink().endOfStream();
//            authClient.setEventSink(null);
//        }
//        authClient.setEventSink(events);
//    }
//
//    @Override
//    public void onCancel(Object arguments) {
//        if (Objects.nonNull(authClient.getEventSink())) {
//            authClient.setEventSink(null);
//        }
//        Log.i(FlutterAliAuthPlugin.TAG, "取消监听" + authClient.getEventSink());
//    }
}
