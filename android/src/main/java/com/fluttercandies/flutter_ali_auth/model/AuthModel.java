package com.fluttercandies.flutter_ali_auth.model;

import androidx.annotation.NonNull;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.alibaba.fastjson2.JSONReader;
import com.mobile.auth.gatewayauth.AuthUIConfig;

import java.util.Map;

public class AuthModel {
   private String androidSdk;
   private Boolean enableLog;
   private Integer authUIStyle;
   private AuthUIModel authUIModel;

   @NonNull
   static public AuthModel Builder(Object params){
      JSONObject json = (JSONObject) JSON.toJSON(params);
      AuthUIModel authUIModel = JSON.to(AuthUIModel.class, json);
      AuthModel authModel = new AuthModel();
      Integer authUIStyle = (Integer) json.get("authUIStyle");
      authModel.androidSdk  = json.getString("androidSdk");
      authModel.enableLog = Boolean.valueOf(json.getString("enableLog"));
      authModel.authUIStyle = authUIStyle;
      authModel.authUIModel = authUIModel;
      return authModel;
   }


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
