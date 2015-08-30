// IMyAidlInterface.aidl
package com.example.banrinakamura.pbltsukuba2;

import android.content.Intent;
//コールバックインターフェースを登録するメソッドの定義
// Declare any non-default types here with import statements

oneway interface IMyAidlInterface {
     void callbackMethod(in Intent intent);
}