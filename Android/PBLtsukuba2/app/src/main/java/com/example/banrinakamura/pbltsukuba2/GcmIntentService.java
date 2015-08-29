package com.example.banrinakamura.pbltsukuba2;

import android.app.IntentService;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Binder;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteCallbackList;
import android.os.RemoteException;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.google.android.gms.cast.CastRemoteDisplayLocalService;
import com.google.android.gms.gcm.GoogleCloudMessaging;

import java.util.Iterator;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

/**
 * Created by Owner_2 on 2015/08/26.
 */
public class GcmIntentService extends IntentService {
    public static final int NOTIFICATION_ID = 1;
    private static NotificationManager mNotificationManager;
    NotificationCompat.Builder builder;

    //コールバックインターフェース設定
    private final RemoteCallbackList<IMyAidlInterface> list = new RemoteCallbackList<IMyAidlInterface>();

    public GcmIntentService() {
        super("GcmIntentService");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        Bundle extras = intent.getExtras();
        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
        String messageType = gcm.getMessageType(intent);

        if (!extras.isEmpty()) {
            if (GoogleCloudMessaging.MESSAGE_TYPE_SEND_ERROR.equals(messageType)) {
                Log.d("LOG", "messageType(error): " + messageType + ",body:" + extras.toString());
            } else if (GoogleCloudMessaging.MESSAGE_TYPE_DELETED.equals(messageType)) {
                Log.d("LOG", "messageType(deleted): " + messageType + ",body:" + extras.toString());
            } else if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
                Log.d("LOG", "messageType(message): " + messageType + ",body:" + extras.toString());

                Iterator<String> it = extras.keySet().iterator();
                String key;
                String value;
                while (it.hasNext()) {
                    key = it.next();
                    value = extras.getString(key);

                }


                //通知バーに表示
                //sendNotification("test push notification");

                int numListners = list.beginBroadcast();
                for (int i = 0; i < numListners; i++) {
                    try {
                        list.getBroadcastItem(i).callbackMethod(intent);
                    } catch (RemoteException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        GcmBroadcastReceiver.completeWakefulIntent(intent);
    }

    public void sendNotification(String msg) {
        mNotificationManager = (NotificationManager)
                this.getSystemService(Context.NOTIFICATION_SERVICE);

        PendingIntent contentIntent = PendingIntent.getActivity(this, 0, new Intent(this, MainActivity.class), 0);

        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentTitle("GCM Notification")
                        .setStyle(new NotificationCompat.BigTextStyle()
                                .bigText(msg))
                        .setContentText(msg);

        mBuilder.setContentIntent(contentIntent);
        mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
    }

    //コールバック用

    private IMyAidlService.Stub serviceIf = new IMyAidlService.Stub() {
        @Override
        public void registerCallback(IMyAidlInterface callback) throws RemoteException {
            list.register(callback);
        }

        @Override
        public void unregisterCallback(IMyAidlInterface callback) throws RemoteException {
            list.unregister(callback);
        }
    };

    /*private CastRemoteDisplayLocalService.Callbacks _myClassCallbacks;

    public void setCallbacks(CastRemoteDisplayLocalService.Callbacks myClassCallbacks) {
        _myClassCallbacks = myClassCallbacks;
    }*/

    @Override
    public IBinder onBind(Intent intent) {
        if (IMyAidlService.class.getName().equals(intent.getAction())) {
            return serviceIf;
        }
        return null;
    }
}