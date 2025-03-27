package com.example.ablecred

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import java.util.*

class CarForegroundService : Service() {
    private val CHANNEL_ID = "CarServiceChannel"
    private val NOTIFICATION_ID = 1
    private lateinit var database: FirebaseDatabase
    private var timer: Timer? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        database = Firebase.database
        startForeground(NOTIFICATION_ID, createNotification())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startPeriodicTask()
        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Car Service Channel",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Channel for Car Foreground Service"
            }
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Car Service")
            .setContentText("Running in background")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun startPeriodicTask() {
        timer = Timer()
        timer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                insertCar()
            }
        }, 0, 15 * 60 * 1000) // 15 minutes
    }

    private fun insertCar() {
        val carRef = database.getReference("cars").push()
        val car = HashMap<String, Any>()
        car["model"] = "Mahindra-${Random().nextInt(1000)}"
        car["year"] = 2022
        car["vehicleTag"] = "XY${Random().nextInt(1000)}"
        car["timestamp"] = System.currentTimeMillis()
        
        carRef.setValue(car)
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        timer?.cancel()
    }
} 