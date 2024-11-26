package com.ducpv.vtb_device_info.event_handlers

import android.content.Context
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Handler
import android.os.Looper
import androidx.core.location.LocationManagerCompat
import io.flutter.plugin.common.EventChannel

internal class LocationEventHandler(
    private val context: Context?,
) : EventChannel.StreamHandler {
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var mLocationManager: LocationManager? = null
    private var mLocationListener: LocationListener? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        mLocationManager = context?.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        mLocationListener = LocationListener { mLocation -> sendEvent(mLocation) }
        if (mLocationManager != null) {
            if (LocationManagerCompat.isLocationEnabled(mLocationManager!!)) {
                try {
                    mLocationManager?.requestLocationUpdates(
                        LocationManager.GPS_PROVIDER, 5000L, 10f, mLocationListener!!
                    )
                    mLocationManager?.requestLocationUpdates(
                        LocationManager.NETWORK_PROVIDER, 5000L, 10f, mLocationListener!!
                    )
                } catch (e: Exception) {
                    sendError(Exception("Location permission not granted"))
                }
            } else {
                sendError(Exception("Location services are disabled"))
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        if (mLocationListener != null) {
            mLocationManager?.removeUpdates(mLocationListener!!)
            mLocationListener = null
        }
        mLocationManager = null
        eventSink = null
    }

    private fun sendEvent(mLocation: Location) {
        mainHandler.post {
            eventSink?.success(
                mapOf(
                    "latitude" to mLocation.latitude,
                    "longitude" to mLocation.longitude,
                )
            )
        }
    }

    private fun sendError(error: Exception) {
        mainHandler.post {
            eventSink?.error("LOCATION_ERROR", error.message, null);
        }
    }
}
