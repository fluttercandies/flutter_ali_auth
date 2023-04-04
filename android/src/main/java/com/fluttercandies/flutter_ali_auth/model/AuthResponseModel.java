package com.fluttercandies.flutter_ali_auth.model;


import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.mobile.auth.gatewayauth.ResultCode;
import com.mobile.auth.gatewayauth.model.TokenRet;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class AuthResponseModel {
    private String resultCode;
    private String msg;
    private String requestId;
    private String token;
    private String innerMsg;
    private String innerCode;

    public static String initFailedMsg = "初始化失败或未初始化";
    public static String nullSdkErrorMsg = "初始化失败，sdk为空";
    public static String failedListeningMsg = "请先对插件进行监听";
    public static String errorArgumentsMsg = "初始化失败,[AuthModel]解析失败";
    public static String tokenDecodeFailedMsg = "回调信息解析失败";
    public static String MSG_GET_MASK_SUCCESS = "600016";
    public static String preLoginSuccessMsg = "预取号成功";

    public static AuthResponseModel customModel(String resultCode, String msg) {
        String now = Long.toString(System.currentTimeMillis());
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode(resultCode);
        authResponseModel.setRequestId(now);
        authResponseModel.setMsg(msg);
        return authResponseModel;
    }

    public static AuthResponseModel initFailed(@Nullable String msg) {
        String now = Long.toString(System.currentTimeMillis());
        assert msg != null;
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode(ResultCode.CODE_ERROR_INVALID_PARAM);
        authResponseModel.setMsg(msg);
        authResponseModel.setRequestId(now);
        return authResponseModel;
    }

    public static AuthResponseModel nullSdkError() {
        String now = Long.toString(System.currentTimeMillis());
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode(ResultCode.CODE_ERROR_ANALYZE_SDK_INFO);
        authResponseModel.setMsg(nullSdkErrorMsg);
        authResponseModel.setRequestId(now);
        return authResponseModel;
    }

    public static AuthResponseModel tokenDecodeFailed() {
        String now = Long.toString(System.currentTimeMillis());
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode(ResultCode.MSG_ERROR_UNKNOWN_FAIL);
        authResponseModel.setMsg(tokenDecodeFailedMsg);
        authResponseModel.setRequestId(now);
        return authResponseModel;
    }

    public static AuthResponseModel onCustomViewBlocTap(Integer viewId) {
        String now = Long.toString(System.currentTimeMillis());
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode("700010");
        authResponseModel.setMsg(viewId.toString());
        authResponseModel.setRequestId(now);
        return authResponseModel;
    }

    public static AuthResponseModel accelerateLoginPageSuccess() {
        String now = Long.toString(System.currentTimeMillis());
        AuthResponseModel authResponseModel = new AuthResponseModel();
        authResponseModel.setResultCode(MSG_GET_MASK_SUCCESS);
        authResponseModel.setMsg("加速拉起授权页面成功");
        authResponseModel.setRequestId(now);
        return authResponseModel;
    }

    public static AuthResponseModel fromTokenRect(TokenRet tokenRet) throws JSONException {

        //TokenRet{vendorName='ct_sjl', code='600024', msg='终端支持认证', carrierFailedResultData=', requestId=8147329b-1618-4b9f-98ce-02e468d237ba', requestCode=0, token='null'}

        AuthResponseModel authResponseModel = new AuthResponseModel();

        authResponseModel.setResultCode(tokenRet.getCode());

        authResponseModel.setRequestId(tokenRet.getRequestId());

        authResponseModel.setMsg(tokenRet.getMsg());

        String token = tokenRet.getToken();

        if (Objects.nonNull(token) && !TextUtils.isEmpty(token) && !String.valueOf(token).equals("null")) {
            authResponseModel.setToken(token);
        }
        Map<String, Object> carrierFailedResultData = null;
        if (Objects.nonNull(tokenRet.getCarrierFailedResultData()) && !TextUtils.isEmpty(tokenRet.getCarrierFailedResultData()) && !String.valueOf(tokenRet.getCarrierFailedResultData()).equals("null")) {
            Gson gson = new Gson();
            carrierFailedResultData = gson.fromJson(tokenRet.getCarrierFailedResultData(), new TypeToken<Map<String, Object>>() {
            }.getType()); //反序列化
        }
        if (Objects.nonNull(carrierFailedResultData)) {
            assert carrierFailedResultData != null;
            if (Objects.nonNull(carrierFailedResultData.get("innerCode"))) {
                authResponseModel.setInnerCode((String) carrierFailedResultData.get("innerCode"));
            }
            if (Objects.nonNull(carrierFailedResultData.get("innerMsg"))) {
                authResponseModel.setInnerMsg(((String) carrierFailedResultData.get("innerMsg")));
            }
        }

        return authResponseModel;
    }

    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public void setInnerMsg(String innerMsg) {
        this.innerMsg = innerMsg;
    }

    public void setInnerCode(String innerCode) {
        this.innerCode = innerCode;
    }

    public String getResultCode() {
        return resultCode;
    }

    public String getMsg() {
        return msg;
    }

    public String getRequestId() {
        return requestId;
    }

    public String getToken() {
        return token;
    }

    public String getInnerMsg() {
        return innerMsg;
    }

    public String getInnerCode() {
        return innerCode;
    }

    public Map<String, Object> toJson() {
        Map<String, Object> map = new HashMap<>();
        map.put("requestId", requestId);
        map.put("resultCode", resultCode);
        map.put("msg", msg);
        map.put("token", token);
        map.put("innerCode", innerCode);
        map.put("innerMsg", innerMsg);
        return map;
    }
}
