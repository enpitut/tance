package com.example.banrinakamura.pbltsukuba2;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.os.StrictMode;
import android.util.Log;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import com.google.android.gms.gcm.GoogleCloudMessaging;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by Owner_2 on 2015/08/24.
 */
public class SubActivity extends Activity {
    /**
     * Called when the activity is first created.
     */

    private IMyAidlService serviceIf;

    //結果表示用
    private ListView showlist;
    ArrayList<Map<String,Object>> listmap = new ArrayList<Map<String, Object>>();
    SimpleAdapter adapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sub);

        //表示リストセット
        showlist = (ListView) findViewById(R.id.listView);

        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder().permitAll().build());

        //サーバ通知(さそわーとして)
        String url = "http://210.140.68.18/api/confirm";
        HttpClient httpClient = new DefaultHttpClient();
        HttpPost post = new HttpPost(url);

        ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
        params.add(new BasicNameValuePair("inviter", "banri"));

        HttpResponse res = null;

        try {
            post.setEntity(new UrlEncodedFormEntity(params, "utf-8"));
            res = httpClient.execute(post);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            sleep(4000);
        } catch (Exception e) {
            e.printStackTrace();
        }

        //サーバへのGET(さそわーとして)
        try {
            HttpClient httpGetreq = new DefaultHttpClient();
            // 誘われる人リスト
            HttpGet httpGet = new HttpGet("http://210.140.68.18/api/status");
            HttpResponse httpResponse = httpGetreq.execute(httpGet);
            String str = EntityUtils.toString(httpResponse.getEntity(), "UTF-8");
            Log.d("HTTP", str);
        } catch(Exception ex) {
            System.out.println(ex);
        }

        // TODO 文字列から生成した配列に対応する画像のあてはめ

        // リストビューに渡すアダプタを生成
        adapter = new SimpleAdapter(
                this,
                listmap,//ArrayList
                R.layout.list,//ListView内の1項目を定義したxml
        new String[] { "img", "name","status" },//mapのキー
        new int[] {R.id.img, R.id.name, R.id.status });//list.xml内のid

        // リストビューにデータを設定
        showlist.setAdapter(adapter);



        /*//コールバック
        Intent intent = new Intent(this, IMyAidlService.class);
        bindService(intent, conn, BIND_AUTO_CREATE);*/


        /*Button btn = (Button) findViewById(R.id.button02_id);
        btn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                // 次画面のアクティビティ終了
                finish();
                }
        });*/

    }

    @Override
    protected void onDestroy(){
        super.onDestroy();
        //サービスアンバインド
        unbindService(conn);
    }


    private ServiceConnection conn = new ServiceConnection() {
        // サービスとの接続時に呼ばれる
        public void onServiceConnected(ComponentName name, IBinder ibinder) {
            //Ibinder インターフェースから、AIDLのインターフェースにキャストするメソッド
            serviceIf = IMyAidlService.Stub.asInterface(ibinder);
            try{
                serviceIf.registerCallback(callback);
            }catch (RemoteException e){
                e.printStackTrace();
            }

        }

        // サービスとの切断時に呼ばれる
        public void onServiceDisconnected(ComponentName name) {
            serviceIf = null;
        }
    };

    //コールバックインターフェースの実装
    private IMyAidlInterface callback = new IMyAidlInterface.Stub(){
        @Override
        public void callbackMethod(Intent intent){
            Log.d("callbackMethod", "called");
            System.out.println("invitee = " + intent.getStringExtra("invitee"));
            System.out.println("status = " + intent.getStringExtra("status"));
        }
    };

    public synchronized void sleep(long msec)
    {
        try
        {
            wait(msec);
        }catch(InterruptedException e){}
    }
}
