package com.ducpv.vtb_device_info.services

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class StopLocationServiceReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        context.stopService(Intent(context, LocationService::class.java))
    }
}
