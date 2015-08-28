package com.example.banrinakamura.pbltsukuba2;

import android.app.Activity;
import android.os.Bundle;
import android.os.StrictMode;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by Owner_2 on 2015/08/24.
 */
public class SubActivity extends Activity{
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sub);

        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder().permitAll().build());


        ListView list = (ListView)findViewById(R.id.listview_id);
        // アダプターに項目を追加
        String[] items = {"Item1","Item2","Item3","Item4","Item5"};
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.list, items);
        // アダプターを設定
        list.setAdapter(adapter);

            String url = "http://210.140.68.18/api/confirm";
            HttpClient httpClient = new DefaultHttpClient();
            HttpPost post = new HttpPost(url);

            ArrayList<NameValuePair> params = new ArrayList<NameValuePair>();
            params.add( new BasicNameValuePair("inviter", "banri"));

            HttpResponse res = null;

            try {
                post.setEntity(new UrlEncodedFormEntity(params, "utf-8"));
                res = httpClient.execute(post);
            } catch (Exception e) {
                e.printStackTrace();
             }


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
}
