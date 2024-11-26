package com.ducpv.vtb_device_info.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.EventChannel

class LocationService : Service() {
    companion object {
        private const val CHANNEL_ID = "LocationServiceChannel"
        private const val CHANNEL_NAME = "LocationService"
        private const val NOTIFICATION_ID = 1

        var eventSink: EventChannel.EventSink? = null
    }

    private lateinit var mLocationManager: LocationManager

    private val mainHandler = Handler(Looper.getMainLooper())

    private val mLocationListener = LocationListener { mLocation ->
        sendSuccess(
            latitude = mLocation.latitude,
            longitude = mLocation.longitude,
        )
        updateNotification(
            latitude = mLocation.latitude,
            longitude = mLocation.longitude,
        )
    }

    override fun onCreate() {
        super.onCreate()
        try {
            createNotificationChannel()
            startForeground(NOTIFICATION_ID, createNotification())
        } catch (error: Exception) {
            sendError(error = error)
        }
        mLocationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        try {
            mLocationManager.requestLocationUpdates(
                LocationManager.GPS_PROVIDER,
                5000L,
                10f,
                mLocationListener,
                Looper.getMainLooper(),
            )
        } catch (error: SecurityException) {
            error.printStackTrace()
            sendError(error = error)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        sendError(error = Exception("End task."))
        mLocationManager.removeUpdates(mLocationListener)
        eventSink = null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun updateNotification(latitude: Double, longitude: Double) {
        mainHandler.post {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val notificationText = "Lat: $latitude, Lng: $longitude"
                val updatedNotification =
                    NotificationCompat.Builder(this, CHANNEL_ID).setContentTitle("Location Service")
                        .setContentText("Tracking Location: $notificationText")
                        .setSmallIcon(android.R.drawable.ic_menu_mylocation)
                        .setPriority(NotificationCompat.PRIORITY_LOW)
                        .setCategory(NotificationCompat.CATEGORY_SERVICE).setOngoing(true)
                        .addAction(
                            android.R.drawable.ic_menu_close_clear_cancel,
                            "Stop",
                            stopServicePendingIntent()
                        ).build()

                val notificationManager = getSystemService(NotificationManager::class.java)
                notificationManager.notify(NOTIFICATION_ID, updatedNotification)
            }
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID).setContentTitle("Location Service")
            .setContentText("Tracking Location in the background...")
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE).setOngoing(true).addAction(
                android.R.drawable.ic_menu_close_clear_cancel, "Stop", stopServicePendingIntent()
            ).build()
    }

    private fun stopServicePendingIntent(): PendingIntent {
        val stopIntent = Intent(this, StopLocationServiceReceiver::class.java)
        return PendingIntent.getBroadcast(this, 0, stopIntent, PendingIntent.FLAG_IMMUTABLE)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(
                CHANNEL_ID, CHANNEL_NAME,
                NotificationManager.IMPORTANCE_LOW,
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(notificationChannel)
        }
    }

    private fun sendSuccess(latitude: Double, longitude: Double) {
        mainHandler.post {
            eventSink?.success(
                mapOf(
                    "latitude" to latitude,
                    "longitude" to longitude,
                )
            )
        }
    }

    private fun sendError(error: Exception) {
        mainHandler.post {
            eventSink?.error("LOCATION_SERVICE_ERROR", error.message, null);
        }
    }
}
