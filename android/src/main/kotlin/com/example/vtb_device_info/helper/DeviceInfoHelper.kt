package com.example.vtb_device_info.helper

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.provider.Settings.Secure.ANDROID_ID
import android.provider.Settings.Secure.getString

object DeviceInfoHelper {
    @SuppressLint("HardwareIds")
    fun getDeviceInfo(context: Context): Map<String, String> {
        return mapOf(
            "deviceId" to getString(context.contentResolver, ANDROID_ID),
            "deviceName" to Build.MODEL,
            "deviceModel" to Build.PRODUCT,
            "systemName" to "Android",
            "systemVersion" to Build.VERSION.RELEASE
        )
    }
}