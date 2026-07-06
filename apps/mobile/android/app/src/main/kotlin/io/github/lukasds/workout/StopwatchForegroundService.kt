package io.github.lukasds.workout

import android.app.*
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.os.SystemClock
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat

class StopwatchForegroundService : Service() {

    private val CHANNEL_ID = "stopwatch_channel_v13"
    private val NOTIFICATION_ID = 888

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        createNotificationChannel()

        val action = intent?.action
        if (action == "ACTION_STOP") {
            stopForeground(true)
            stopSelf()
            return START_NOT_STICKY
        }

        // Extract explicit values from Intent extras
        val intentStartTime = intent?.getLongExtra("startTime", 0L) ?: 0L
        val intentPreviousDuration = intent?.getLongExtra("previousDuration", -1L) ?: -1L

        updateNotification(intentStartTime, intentPreviousDuration)
        return START_STICKY
    }

    private fun updateNotification(intentStartTime: Long, intentPreviousDuration: Long) {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        
        // Resolve the true state: use Intent extras if provided, otherwise fallback to storage
        val isRunning = if (intentStartTime > 0) true 
                       else if (intentPreviousDuration >= 0) false
                       else prefs.getBoolean("flutter.stopwatch_is_running", false)

        val startTimeMillis = if (intentStartTime > 0) intentStartTime 
                             else prefs.getLong("flutter.stopwatch_start_time", 0)

        val previousDurationMillis = if (intentPreviousDuration >= 0) intentPreviousDuration
                                    else prefs.getLong("flutter.stopwatch_previous_duration", 0)

        val notificationLayout = RemoteViews(packageName, R.layout.custom_stopwatch_notification)

        // Align Wall Clock (System.currentTimeMillis) with Monotonic Clock (SystemClock.elapsedRealtime)
        val nowWall = System.currentTimeMillis()
        val nowMonotonic = SystemClock.elapsedRealtime()

        val elapsedMillis = if (isRunning) {
            (nowWall - startTimeMillis) + previousDurationMillis
        } else {
            previousDurationMillis
        }

        notificationLayout.setChronometer(
            R.id.notification_chronometer,
            nowMonotonic - elapsedMillis,
            null,
            isRunning
        )

        // Update Play/Pause icon in the custom layout
        notificationLayout.setImageViewResource(
            R.id.notification_action_play_pause,
            if (isRunning) R.drawable.ic_pause else R.drawable.ic_play
        )

        // Set click handlers for RemoteViews layout buttons
        notificationLayout.setOnClickPendingIntent(R.id.notification_action_play_pause, getPendingIntent("ACTION_PLAY_PAUSE"))
        notificationLayout.setOnClickPendingIntent(R.id.notification_action_reset, getPendingIntent("ACTION_RESET"))
        notificationLayout.setOnClickPendingIntent(R.id.notification_action_stop, getPendingIntent("ACTION_STOP"))

        // Main notification tap intent (opens app)
        val mainIntent = Intent(this, MainActivity::class.java)
        val mainPendingIntent = PendingIntent.getActivity(this, 0, mainIntent, PendingIntent.FLAG_IMMUTABLE)

        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_timer)
            .setCustomContentView(notificationLayout)
            .setContentIntent(mainPendingIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setCategory(NotificationCompat.CATEGORY_STOPWATCH)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()

        startForeground(NOTIFICATION_ID, notification)
    }

    private fun getPendingIntent(action: String): PendingIntent {
        val intent = Intent(this, StopwatchActionReceiver::class.java).apply {
            this.action = action
        }
        return PendingIntent.getBroadcast(this, action.hashCode(), intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            
            // Clean up the old channels
            try {
                manager.deleteNotificationChannel("stopwatch_channel_v10")
                manager.deleteNotificationChannel("stopwatch_channel_v11")
                manager.deleteNotificationChannel("stopwatch_channel_v12")
            } catch (e: Exception) {
                // Ignore if not present
            }

            val serviceChannel = NotificationChannel(
                CHANNEL_ID,
                "Rest Timer",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            serviceChannel.setSound(null, null)
            serviceChannel.enableVibration(false)
            serviceChannel.enableLights(false)
            
            manager.createNotificationChannel(serviceChannel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
