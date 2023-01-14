package com.fluttercandies.flutter_ali_auth.model;

import androidx.annotation.NonNull;

import com.google.gson.Gson;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Map;


public class AuthModel {
    private String androidSdk;
    private Boolean enableLog;
    private Integer authUIStyle;
    private AuthUIModel authUIModel;

//    @NonNull
//    static public AuthModel Builder(Object params) {
//        AuthModel authModel = new Gson().fromJson(params.toString(), AuthModel.class);
//
//        AuthUIModel authUIModel = JSON.to(AuthUIModel.class, json);
//        //Integer authUIStyle = (Integer) json.get("authUIStyle");
//        Integer authUIStyle = authModel.authUIStyle;
//        authModel.setAndroidSdk(json.getString("androidSdk"));
//        authModel.setEnableLog(Boolean.valueOf(json.getString("enableLog")));
//        authModel.setAuthUIStyle(authUIStyle);
//        authModel.setAuthUIModel(authUIModel);
//        return authModel;
//    }


    public void setAndroidSdk(String androidSdk) {
        this.androidSdk = androidSdk;
    }

    public void setEnableLog(Boolean enableLog) {
        this.enableLog = enableLog;
    }

    public void setAuthUIStyle(Integer authUIStyle) {
        this.authUIStyle = authUIStyle;
    }

    public void setAuthUIModel(AuthUIModel authUIModel) {
        this.authUIModel = authUIModel;
    }

    public String getAndroidSdk() {
        return androidSdk;
    }

    public Boolean getEnableLog() {
        return enableLog;
    }

    public Integer getAuthUIStyle() {
        return authUIStyle;
    }

    public AuthUIModel getAuthUIModel() {
        return authUIModel;
    }

}
