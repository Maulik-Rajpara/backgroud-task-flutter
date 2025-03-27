package com.example.ablecred

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.google.firebase.database.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.ablecred/foreground_service"
    private lateinit var database: DatabaseReference

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        database = FirebaseDatabase.getInstance().reference.child("cars")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startService" -> {
                    val serviceIntent = Intent(this, CarForegroundService::class.java)
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        startForegroundService(serviceIntent)
                    } else {
                        startService(serviceIntent)
                    }
                    result.success(null)
                }
                "stopService" -> {
                    val serviceIntent = Intent(this, CarForegroundService::class.java)
                    stopService(serviceIntent)
                    result.success(null)
                }
                "fetchLatestCarData" -> {
                    fetchLatestCarData(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun fetchLatestCarData(result: MethodChannel.Result) {
        database.orderByKey().limitToLast(1).addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                val lastCar = snapshot.children.firstOrNull()?.value as? Map<String, Any>
                database.get().addOnSuccessListener { totalSnapshot ->
                    val totalCount = totalSnapshot.childrenCount.toInt()
                    result.success(mapOf("lastCar" to lastCar, "totalCount" to totalCount))
                }
            }

            override fun onCancelled(error: DatabaseError) {
                result.error("DB_ERROR", "Failed to fetch data: ${error.message}", null)
            }
        })
    }
}
