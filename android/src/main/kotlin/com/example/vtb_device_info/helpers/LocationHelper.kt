package com.example.vtb_device_info.helpers

import android.content.Context
import android.location.LocationManager

class LocationHelper(private val context: Context) {
    fun getCurrentLocation(): Map<String, Double>? {
        if (!PermissionHelper(context).isLocationPermissionGranted()) {
            throw IllegalStateException("Permission is not granted.")
        }
        val mLocationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val mLocation =
            mLocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER) ?: return null
        return mapOf(
            "latitude" to mLocation.latitude,
            "longitude" to mLocation.longitude,
        )
    }
}