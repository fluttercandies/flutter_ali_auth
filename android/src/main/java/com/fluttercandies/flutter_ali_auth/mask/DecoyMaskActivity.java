package com.fluttercandies.flutter_ali_auth.mask;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

import com.fluttercandies.flutter_ali_auth.AuthClient;
import com.fluttercandies.flutter_ali_auth.utils.Constant;
import com.fluttercandies.flutter_ali_auth.R;
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class DecoyMaskActivity extends Activity {


    public static final String TAG = DecoyMaskActivity.class.getSimpleName();

//    public static boolean isRunning = false;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
//        isRunning = true;
        Log.i(TAG, "onCreate");
        AuthClient authClient = AuthClient.getInstance();
        AuthClient.decoyMaskActivity = this;
        // override the auth path open enter animation
        if (authClient.getAuthModel().getAuthUIStyle() == Constant.DIALOG_PORT) {
            overridePendingTransition(R.anim.zoom_in, R.anim.stay_animation);
        } else {
            overridePendingTransition(R.anim.slide_up, R.anim.stay_animation);
        }
        PhoneNumberAuthHelper authHelper = authClient.mAuthHelper;
        authHelper.getLoginToken(this.getBaseContext(), authClient.getLoginTimeout());
        super.onCreate(savedInstanceState);
    }

    boolean isPause = false;

    @Override
    protected void onPause() {
        Log.i(TAG, "onPause");
        isPause = true;
        super.onPause();
    }

    @Override
    protected void onResume() {
        Log.i(TAG, "onResume");

        if (isPause) {
            //TopActivityBack
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    finish();
                }
            };
            ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(1);
            scheduledExecutorService.schedule(runnable, 0, TimeUnit.MILLISECONDS);
        }
        super.onResume();
    }


    @Override
    public void finish() {
        super.finish();
        Log.i(TAG, "finish");
        AuthClient.decoyMaskActivity = null;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
//        isRunning = false;
    }
}
