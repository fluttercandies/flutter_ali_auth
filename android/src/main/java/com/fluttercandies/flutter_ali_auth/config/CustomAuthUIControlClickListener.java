package com.fluttercandies.flutter_ali_auth.config;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.fluttercandies.flutter_ali_auth.AuthClient;
import com.fluttercandies.flutter_ali_auth.R;
import com.fluttercandies.flutter_ali_auth.model.AuthResponseModel;
import com.mobile.auth.gatewayauth.AuthUIControlClickListener;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
import com.mobile.auth.gatewayauth.ResultCode;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class CustomAuthUIControlClickListener implements AuthUIControlClickListener {
    private PhoneNumberAuthHelper mAuthHelper;
    private Context mContext;
    private MethodChannel mChannel;
    public CustomAuthUIControlClickListener(PhoneNumberAuthHelper phoneNumberAuthHelper,
                                            Context context, MethodChannel methodChannel){
        mAuthHelper = phoneNumberAuthHelper;
        mContext = context;
        mChannel = methodChannel;
    }
    @Override
    public void onClick(String code, Context context, String jsonString) {
        JSONObject jsonObj = null;
        AuthResponseModel responseModel = null;
        try {
            if(!TextUtils.isEmpty(jsonString)) {
                jsonObj = new JSONObject(jsonString);
            }
        } catch (JSONException e) {
            jsonObj = new JSONObject();
        }
        Log.i("点击回调-","jsonObj:"+jsonObj);
        switch (code) {
            //点击授权页默认样式的返回按钮
            case ResultCode.CODE_ERROR_USER_CANCEL:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));
                responseModel.setResultCode(ResultCode.CODE_ERROR_USER_CANCEL);
                responseModel.setMsg("点击了授权页默认返回按钮");
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());
                mAuthHelper.quitLoginPage();
               // mActivity.finish();
                break;
            //点击授权页默认样式的切换其他登录方式 会关闭授权页
            //如果不希望关闭授权页那就setSwitchAccHidden(true)隐藏默认的  通过自定义view添加自己的
            case ResultCode.CODE_ERROR_USER_SWITCH:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_ERROR_USER_SWITCH);
                responseModel.setMsg("用户切换其他登录方式");
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());
                break;
            //点击一键登录按钮会发出此回调
            //当协议栏没有勾选时 点击按钮会有默认toast 如果不需要或者希望自定义内容 setLogBtnToastHidden(true)隐藏默认Toast
            //通过此回调自己设置toast
            case ResultCode.CODE_ERROR_USER_LOGIN_BTN:
                if (!jsonObj.optBoolean("isChecked")) {
                    Toast.makeText(mContext, R.string.custom_toast, Toast.LENGTH_SHORT).show();
                }

                break;
            //checkbox状态改变触发此回调
            case ResultCode.CODE_ERROR_USER_CHECKBOX:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_ERROR_USER_CHECKBOX);
                responseModel.setMsg("checkbox状态变为" + jsonObj.optBoolean("isChecked"));
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());

                break;
            //点击协议栏触发此回调
            case ResultCode.CODE_ERROR_USER_PROTOCOL_CONTROL:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_ERROR_USER_PROTOCOL_CONTROL);
                responseModel.setMsg("点击协议，" + "name: " + jsonObj.optString("name") + ", url: " + jsonObj.optString("url"));
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());

                break;
            case ResultCode.CODE_START_AUTH_PRIVACY:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_START_AUTH_PRIVACY);
                responseModel.setMsg("点击授权页一键登录按钮拉起了授权页协议二次弹窗");
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());

                break;
            case ResultCode.CODE_AUTH_PRIVACY_CLOSE:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_AUTH_PRIVACY_CLOSE);
                responseModel.setMsg("授权页协议二次弹窗已关闭");
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());

                break;
            case ResultCode.CODE_CLICK_AUTH_PRIVACY_CONFIRM:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_CLICK_AUTH_PRIVACY_CONFIRM);
                responseModel.setMsg("授权页协议二次弹窗点击同意并继续");
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());

                break;
            case ResultCode.CODE_CLICK_AUTH_PRIVACY_WEBURL:
                responseModel = new AuthResponseModel();
                responseModel.setRequestId(Long.toString(System.currentTimeMillis()));

                responseModel.setResultCode(ResultCode.CODE_CLICK_AUTH_PRIVACY_WEBURL);
                responseModel.setMsg("点击授权页协议二次弹窗协议");
//                fEventSink.success(responseModel.toJson());
                mChannel.invokeMethod(AuthClient.DART_CALL_METHOD_ON_INIT,responseModel.toJson());

                break;
            default:
                break;

        }
    }
}
