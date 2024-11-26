package com.ducpv.vtb_device_info.event_handlers

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.content.ContextCompat
import com.ducpv.vtb_device_info.helpers.PermissionHelper
import com.ducpv.vtb_device_info.helpers.PermissionHelper.Companion.PermissionResultCallback
import com.ducpv.vtb_device_info.services.LocationService
import io.flutter.plugin.common.EventChannel

internal class LocationBackgroundEventHandler(
    private val context: Context?,
    private val activity: Activity?,
    private val permissionHelper: PermissionHelper,
) : EventChannel.StreamHandler {
    private var mLocationServiceIntent: Intent? = null
    private var mainHandler = Handler(Looper.getMainLooper())

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (context == null) {
            sendError(
                error = Exception("Context is missing."),
                events = events,
            )
            return
        }
        if (activity == null) {
            sendError(
                error = Exception("Activity is missing."),
                events = events,
            )
            return
        }
        if (mLocationServiceIntent == null) {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
                startForegroundService(context)
            } else {
                val notificationGranted =
                    permissionHelper.isPermissionGranted(Manifest.permission.POST_NOTIFICATIONS)
                if (notificationGranted) {
                    startForegroundService(context)
                } else {
                    permissionHelper.requestPermission(
                        activity = activity,
                        permission = Manifest.permission.POST_NOTIFICATIONS,
                        resultCallback = object : PermissionResultCallback {
                            override fun onResult(granted: Boolean) {
                                if (granted) {
                                    mainHandler.post {
                                        startForegroundService(context)
                                    }
                                } else {
                                    sendError(
                                        error = Exception("Notification permission not granted"),
                                        events = events,
                                    )
                                }
                            }
                        },
                    )
                }
            }
        }
        mainHandler.post {
            LocationService.eventSink = events
        }
    }

    fun startForegroundService(context: Context) {
        mLocationServiceIntent = Intent(context, LocationService::class.java)
        ContextCompat.startForegroundService(context, mLocationServiceIntent!!)
    }

    override fun onCancel(arguments: Any?) {
        if (mLocationServiceIntent != null) {
            context?.stopService(mLocationServiceIntent)
            mLocationServiceIntent = null
        }
    }

    private fun sendError(error: Exception, events: EventChannel.EventSink?) {
        mainHandler.post {
            events?.error("LOCATION_ERROR", error.message, null);
        }
    }
}
