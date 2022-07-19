package com.example.gnosis_chatbot;

import io.flutter.embedding.android.FlutterActivity;
import com.microsoft.appcenter.AppCenter;
import com.microsoft.appcenter.analytics.Analytics;
import com.microsoft.appcenter.crashes.Crashes;
import com.microsoft.appcenter.distribute.Distribute;
import android.os.Bundle;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        AppCenter.start(getApplication(), "OUR SECRET KEY", Distribute.class);

        AppCenter.setEnabled(true);

        super.onCreate(savedInstanceState);
    }}
