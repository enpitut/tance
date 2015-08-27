package com.example.banrinakamura.pbltsukuba2;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.support.v4.content.WakefulBroadcastReceiver;

import com.google.android.gms.gcm.GoogleCloudMessaging;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

/**
 * Created by Owner_2 on 2015/08/26.
 */

public class GcmBroadcastReceiver extends WakefulBroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("in receiver");
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(context);
        String messageType = gcm.getMessageType(intent);
        System.out.println("xxxxxxxxx" + intent.getExtras().toString());


//        try {
//            String action = intent.getAction();
//            String channel = intent.getExtras().getString("com.nifty.Channel");
//            JSONObject json = new JSONObject(intent.getExtras().getString("com.nifty.Data"));
//
//            Iterator itr = json.keys();
//            while (itr.hasNext()) {
//                String key = (String) itr.next();
//            }
//        } catch (JSONException e) {
//            System.out.println("receive failed");
//        // エラー処理
//        }


        // Explicitly specify that GcmMessageHandler will handle the intent.
        ComponentName comp = new ComponentName(context.getPackageName(),
                GcmIntentService.class.getName());

        // Start the service, keeping the device awake while it is launching.
        startWakefulService(context, (intent.setComponent(comp)));
        setResultCode(Activity.RESULT_OK);
    }
}