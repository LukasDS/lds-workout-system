package io.github.lukasds.workout

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class StopwatchActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action ?: return
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

        var newStartTime = 0L
        var newPreviousDuration = -1L

        when (action) {
            "ACTION_PLAY_PAUSE" -> {
                val isRunning = prefs.getBoolean("flutter.stopwatch_is_running", false)
                if (isRunning) {
                    // Pause
                    val startTimeMillis = prefs.getLong("flutter.stopwatch_start_time", 0)
                    val previousDurationMillis = prefs.getLong("flutter.stopwatch_previous_duration", 0)
                    newPreviousDuration = previousDurationMillis + (System.currentTimeMillis() - startTimeMillis)

                    prefs.edit()
                        .putBoolean("flutter.stopwatch_is_running", false)
                        .putLong("flutter.stopwatch_previous_duration", newPreviousDuration)
                        .remove("flutter.stopwatch_start_time")
                        .apply()
                } else {
                    // Start
                    newStartTime = System.currentTimeMillis()
                    newPreviousDuration = prefs.getLong("flutter.stopwatch_previous_duration", 0)
                    prefs.edit()
                        .putBoolean("flutter.stopwatch_is_running", true)
                        .putLong("flutter.stopwatch_start_time", newStartTime)
                        .apply()
                }
            }
            "ACTION_RESET" -> {
                val isRunning = prefs.getBoolean("flutter.stopwatch_is_running", false)
                newPreviousDuration = 0L
                if (isRunning) {
                    newStartTime = System.currentTimeMillis()
                    prefs.edit()
                        .putLong("flutter.stopwatch_start_time", newStartTime)
                        .putLong("flutter.stopwatch_previous_duration", 0)
                        .apply()
                } else {
                    prefs.edit()
                        .putLong("flutter.stopwatch_previous_duration", 0)
                        .remove("flutter.stopwatch_start_time")
                        .apply()
                }
            }
            "ACTION_STOP" -> {
                prefs.edit()
                    .putBoolean("flutter.stopwatch_is_running", false)
                    .putLong("flutter.stopwatch_previous_duration", 0)
                    .remove("flutter.stopwatch_start_time")
                    .apply()
                
                val stopIntent = Intent(context, StopwatchForegroundService::class.java)
                context.stopService(stopIntent)
                
                // Notify MainActivity to stop
                val syncIntent = Intent("io.github.lukasds.workout.STOPWATCH_SYNC")
                context.sendBroadcast(syncIntent)
                return
            }
        }

        // Notify service to update notification with EXPLICIT values
        val serviceIntent = Intent(context, StopwatchForegroundService::class.java).apply {
            this.action = "ACTION_UPDATE"
            putExtra("startTime", newStartTime)
            putExtra("previousDuration", newPreviousDuration)
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(serviceIntent)
        } else {
            context.startService(serviceIntent)
        }

        // Notify MainActivity to tell Flutter to reload (Sync Upward)
        val syncIntent = Intent("io.github.lukasds.workout.STOPWATCH_SYNC")
        context.sendBroadcast(syncIntent)
    }
}
