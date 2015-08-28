package com.example.banrinakamura.pbltsukuba2;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.support.v4.content.WakefulBroadcastReceiver;
import android.util.Log;
import android.widget.Switch;
import android.widget.ToggleButton;

import com.google.android.gms.gcm.GoogleCloudMessaging;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;

/**
 * Created by Owner_2 on 2015/08/26.
 */

public class GcmBroadcastReceiver extends WakefulBroadcastReceiver implements LocationListener {


    // GPS用
    private LocationManager mLocationManager;
    private Context mContext;

    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("in receiver");
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(context);
        String messageType = gcm.getMessageType(intent);
        System.out.println("xxxxxxxxx" + intent.getExtras().toString());

        System.out.println("xxxxxx name = " + intent.getStringExtra("name"));
        System.out.println("xxxxxx message = " + intent.getStringExtra("message"));

        //さそわ～（inviter）
        System.out.println("xxxxxx inviter = " + intent.getStringExtra("inviter"));

        mContext = context;

        mLocationManager = (LocationManager)context.getSystemService(Context.LOCATION_SERVICE);
        // GPS
        //mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, this);
        //Wifi
        mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER, 0, 0, this);


        //double lat=Double.valueOf(locationManager.getLatitude());
        //double lon=Double.valueOf(locationManager.getLongitude());

        //System.out.println(lat);
        //System.out.println(lon);




//        try {
//
//
//        } catch (JSONException e) {
//
//        }

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

    @Override
    public void onLocationChanged(Location location) {

        System.out.println("onLocationChangedに行きました。");

        // GPS
        double lat = location.getLatitude();
        double lng = location.getLongitude();
        System.out.println(lat + "," + lng);

        //２点間の距離
        //中心点を指定
        double centerLat = 36.1104929;
        double centerLng = 140.0994325;
        // 結果を格納するための配列を生成
        float[] results = new float[3];
        // 距離計算
        Location.distanceBetween(centerLat, centerLng, lat, lng, results);

        // 結果を表示
        Log.v("Distance", "results[0]: " + results[0]); // 距離（メートル）
        Log.v("Kakudo1", "results[1]: " + results[1]); // 始点から終点までの方位角
        Log.v("Kakudo2", "results[2]: " + results[2]); // 終点から始点までの方位角

        boolean switchStatement = MainActivity.getSwitchstatement();
        Log.v("Switch", "switchStatement: " + switchStatement); // スイッチ ONはtrue OFFはfalse

        int status;
        if(results[0]<=500 && switchStatement==true){
            status = 1;

            NotificationCompat.Builder builder = new NotificationCompat.Builder(mContext);
            builder.setSmallIcon(R.drawable.btn_main);

            builder.setContentTitle("campus dé lunch"); // 1行目
            builder.setContentText("inviter" + "さんからお誘いが届きました。"); // 2行目
            //builder.setSubText(""); // 3行目
            //builder.setContentInfo("Info"); // 右端
            builder.setWhen(System.currentTimeMillis()); // タイムスタンプ（現在時刻、メール受信時刻、カウントダウンなどに使用）

            // 通知時の音・バイブ・ライト
            builder.setDefaults(Notification.DEFAULT_SOUND
                    | Notification.DEFAULT_VIBRATE
                    | Notification.DEFAULT_LIGHTS);


            NotificationManagerCompat manager = NotificationManagerCompat.from(mContext);
            manager.notify(1, builder.build());

        }else{
            status = 0;
        }

        Log.v("OKorNG", "status: " + status); //誘いOK status=1  誘いNG status=0





        mLocationManager.removeUpdates(this);
    }


    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {

    }

    @Override
    public void onProviderEnabled(String provider) {

    }

    @Override
    public void onProviderDisabled(String provider) {

    }
}