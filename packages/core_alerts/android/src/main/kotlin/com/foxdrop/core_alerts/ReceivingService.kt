package com.foxdrop.core_alerts

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

// RA §4.3, architecture §12.2: the foreground service with the permanent
// notification «FOX DROP يستقبل طلباتك». It keeps the process, and the Flutter
// engine that holds the restaurant's connection, alive while the app is in
// the background or the screen is off. A partial wake lock keeps the CPU
// awake for the heartbeat and the ring (the device check turns battery
// optimisation off, so Doze leaves the network on).
class ReceivingService : Service() {
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = receivingNotification(this)
        try {
            if (Build.VERSION.SDK_INT >= 34) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (error: Exception) {
            // Android 12 and later refuse a foreground service started from
            // the background without an exemption (the system restarting a
            // sticky service, without the battery exemption the device check
            // asks for): stop rather than crash; the app's next start, a push
            // or a reboot starts it again.
            if (Build.VERSION.SDK_INT >= 31 &&
                error is android.app.ForegroundServiceStartNotAllowedException
            ) {
                stopSelf()
                return START_NOT_STICKY
            }
            throw error
        }
        running = true
        if (wakeLock == null) {
            val power = getSystemService(Context.POWER_SERVICE) as PowerManager
            wakeLock =
                power.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "fox_drop:receiving").apply {
                    setReferenceCounted(false)
                    acquire()
                }
        }
        // After a reboot, an update or the system ending the process, no
        // activity runs the app: the service starts its Dart code itself.
        engine(this)
        return START_STICKY
    }

    override fun onDestroy() {
        running = false
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
        super.onDestroy()
    }

    companion object {
        private const val NOTIFICATION_ID = 4201
        private const val CHANNEL = "core_alerts_receiving"
        private const val PREFERENCES = "core_alerts"
        private const val ENABLED = "receiving"

        // Whether the service runs in this process now.
        @Volatile
        var running = false
            private set

        // The one Flutter engine of the app, shared by the activity and the
        // service, so the board, its connection and its ring outlive the
        // activity (the app's MainActivity provides it).
        const val ENGINE_ID = "fox_drop_main"

        fun engine(context: Context): FlutterEngine {
            val cache = FlutterEngineCache.getInstance()
            cache.get(ENGINE_ID)?.let { return it }
            val engine = FlutterEngine(context.applicationContext)
            engine.dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            cache.put(ENGINE_ID, engine)
            return engine
        }

        fun start(context: Context) {
            preferences(context).edit().putBoolean(ENABLED, true).apply()
            val intent = Intent(context, ReceivingService::class.java)
            if (Build.VERSION.SDK_INT >= 26) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            preferences(context).edit().putBoolean(ENABLED, false).apply()
            context.stopService(Intent(context, ReceivingService::class.java))
        }

        // Whether a signed-in device asked to receive, so a reboot or an
        // update starts the service again only then.
        fun enabled(context: Context): Boolean = preferences(context).getBoolean(ENABLED, false)

        private fun preferences(context: Context) =
            context.getSharedPreferences(PREFERENCES, Context.MODE_PRIVATE)

        private fun receivingNotification(context: Context): Notification {
            val text = context.getString(R.string.core_alerts_receiving)
            val builder =
                if (Build.VERSION.SDK_INT >= 26) {
                    val manager = context.getSystemService(NotificationManager::class.java)
                    manager.createNotificationChannel(
                        NotificationChannel(
                            CHANNEL,
                            context.getString(R.string.core_alerts_channel_receiving),
                            NotificationManager.IMPORTANCE_LOW,
                        ),
                    )
                    Notification.Builder(context, CHANNEL)
                } else {
                    @Suppress("DEPRECATION")
                    Notification.Builder(context)
                }
            return builder
                .setContentTitle(text)
                .setSmallIcon(context.applicationInfo.icon)
                .setOngoing(true)
                .setContentIntent(launchIntent(context, ring = false))
                .build()
        }

        fun launchIntent(context: Context, ring: Boolean): PendingIntent? {
            val intent =
                context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return null
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
            return PendingIntent.getActivity(
                context,
                if (ring) 1 else 0,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }
    }
}

// RA §4.3: the service starts again after a reboot and after an app update,
// when a signed-in device asked for it.
class StartReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            return
        }
        if (ReceivingService.enabled(context)) ReceivingService.start(context)
    }
}
