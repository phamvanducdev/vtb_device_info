package com.example.vtb_device_info

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.provider.Settings.Secure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class VtbDeviceInfoPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "vtb_device_info")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    @SuppressLint("HardwareIds")
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getDeviceInfo" -> {
                result.success(
                    mapOf(
                        "deviceId" to Secure.getString(context.contentResolver, Secure.ANDROID_ID),
                        "deviceName" to Build.MODEL,
                        "deviceModel" to Build.PRODUCT,
                        "systemName" to "Android",
                        "systemVersion" to Build.VERSION.RELEASE
                    )
                )
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
