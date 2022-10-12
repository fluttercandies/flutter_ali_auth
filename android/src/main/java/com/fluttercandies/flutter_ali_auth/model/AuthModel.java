package com.fluttercandies.flutter_ali_auth.model;

import androidx.annotation.NonNull;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.mobile.auth.gatewayauth.AuthUIConfig;

import java.util.Map;

public class AuthModel {
   public String androidSdk;
   public Integer authUIStyle;
   public AuthUIModel authUIModel;

   @NonNull
   static public AuthModel fromJson(Object params){
      JSONObject json = (JSONObject) JSON.toJSON(params);
      Integer authUIStyle = (Integer) json.get("authUIStyle");
      //AuthUIStyle authUIStyle  = AuthUIStyle.values()[authUIStyleIndex];
      AuthModel authModel = new AuthModel();
      authModel.setAndroidSdk(json.getString("androidSdk"));
      authModel.setAuthUIStyle(authUIStyle);
      AuthUIModel  mAuthUIModel = JSON.to(AuthUIModel.class, json);
      authModel.setAuthUIModel(mAuthUIModel);

      return authModel;
   }

   public void setAndroidSdk(String androidSdk) {
      this.androidSdk = androidSdk;
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

   public Integer getAuthUIStyle() {
      return authUIStyle;
   }

   public AuthUIModel getAuthUIModel() {
      return authUIModel;
   }

   @NonNull
   @Override
   public String toString() {
      return "AuthModel{" +
              "androidSdk='" + androidSdk + '\'' +
              ", authUIStyle=" + authUIStyle +
              ", authUIModel=" + authUIModel +
              '}';
   }
}
