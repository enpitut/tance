package com.example.banrinakamura.pbltsukuba2;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;

/**
 * Created by Owner_2 on 2015/08/24.
 */
public class SubActivity extends Activity{
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.sub);


        ListView list = (ListView)findViewById(R.id.listview_id);
        // アダプターに項目を追加
        String[] items = {"Item1","Item2","Item3","Item4","Item5"};
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, R.layout.list, items);
        // アダプターを設定
        list.setAdapter(adapter);


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
