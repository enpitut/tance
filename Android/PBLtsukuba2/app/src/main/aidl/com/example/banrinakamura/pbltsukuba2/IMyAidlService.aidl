// IMyAidlService.aidl
package com.example.banrinakamura.pbltsukuba2;

import com.example.banrinakamura.pbltsukuba2.IMyAidlInterface;

// Declare any non-default types here with import statements

oneway interface IMyAidlService {
    void registerCallback(IMyAidlInterface callback);

    void unregisterCallback(IMyAidlInterface callback);
}
