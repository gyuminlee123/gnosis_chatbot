package com.example.gnosis_chatbot

import io.flutter.embedding.android.FlutterActivity
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes
import com.microsoft.appcenter.distribute.Distribute
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        AppCenter.start(getApplication(), "5e15ac77-409e-45e8-b589-827410707570", Distribute::class.java)
        AppCenter.setEnabled(true)
        super.onCreate(savedInstanceState)
    }
}
