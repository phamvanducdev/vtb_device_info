package com.ducpv.vtb_device_info.helpers

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.provider.Settings.Secure.ANDROID_ID
import android.provider.Settings.Secure.getString

class DeviceInfoHelper(private val context: Context) {
    @SuppressLint("HardwareIds")
    fun getDeviceInfo(): Map<String, String> {
        return mapOf(
            "deviceId" to getString(context.contentResolver, ANDROID_ID),
            "deviceName" to Build.MODEL,
            "deviceModel" to Build.PRODUCT,
            "systemName" to "Android",
            "systemVersion" to Build.VERSION.RELEASE
        )
    }
}