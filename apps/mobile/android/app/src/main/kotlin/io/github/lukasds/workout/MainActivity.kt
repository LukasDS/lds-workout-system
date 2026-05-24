package io.github.lukasds.workout

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "io.github.lukasds.workout/stopwatch"
    private var methodChannel: MethodChannel? = null

    // Signal Receiver: Catches signals from notification buttons and tells Flutter to reload
    private val syncReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            methodChannel?.invokeMethod("reloadState", null)
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler {
            call, result ->
            val startTime = call.argument<Number>("startTime")?.toLong() ?: 0L
            val previousDuration = call.argument<Number>("previousDuration")?.toLong() ?: 0L

            when (call.method) {
                "startTimer" -> {
                    startRestStopwatchService("ACTION_UPDATE", startTime, previousDuration)
                    result.success(null)
                }
                "pauseTimer" -> {
                    startRestStopwatchService("ACTION_UPDATE", 0L, previousDuration)
                    result.success(null)
                }
                "resetTimer" -> {
                    startRestStopwatchService("ACTION_UPDATE", 0L, 0L)
                    result.success(null)
                }
                "stopTimer" -> {
                    val intent = Intent(this, StopwatchForegroundService::class.java)
                    stopService(intent)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Register the signal receiver
        val filter = IntentFilter("io.github.lukasds.workout.STOPWATCH_SYNC")
        registerReceiver(syncReceiver, filter)
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unregisterReceiver(syncReceiver)
        } catch (e: Exception) {}
    }

    private fun startRestStopwatchService(action: String, startTime: Long, previousDuration: Long) {
        val intent = Intent(this, StopwatchForegroundService::class.java).apply {
            this.action = action
            putExtra("startTime", startTime)
            putExtra("previousDuration", previousDuration)
        }
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }
}
