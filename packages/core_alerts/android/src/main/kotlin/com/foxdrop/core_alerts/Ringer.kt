package com.foxdrop.core_alerts

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager

// RA §4.4, architecture §12.2: the ring loops its bundled sound on the alarm
// stream (the media volume and silent mode do not mute it) until the app
// stops it, with a notification whose full-screen intent opens the app over
// the lock screen where the system allows it; otherwise the system shows it
// heads-up (RA §21 item 4). The chime plays once on the notification stream.
// CA §4.4 (slice 2.43): the captain's offer also vibrates while it rings and
// stops by itself at the offer's end, since a ring a push started may have
// no app running to stop it.
object Ringer {
    private const val CHANNEL = "core_alerts_ring"
    private const val NOTIFICATION_ID = 4202

    private var player: MediaPlayer? = null
    private var playing: String? = null
    private var screen: PowerManager.WakeLock? = null
    private var vibrator: Vibrator? = null
    private val main = Handler(Looper.getMainLooper())
    private var timeout: Runnable? = null

    // The plugin shows the activity over the lock screen while this is true.
    var ringing = false
        private set
    var onRingingChanged: (() -> Unit)? = null

    fun ring(
        context: Context,
        sound: String,
        title: String,
        body: String,
        vibrate: Boolean = false,
        stopAfterMs: Long? = null,
    ) {
        val app = context.applicationContext
        if (playing != sound) {
            stopPlayer()
            player = loop(app, sound)
            playing = sound
        }
        notify(app, title, body)
        if (vibrate && vibrator == null) vibrator = vibrate(app)
        if (!vibrate) stopVibration()
        timeout?.let { main.removeCallbacks(it) }
        timeout =
            stopAfterMs?.let { after ->
                Runnable { stop(app) }.also { main.postDelayed(it, after.coerceAtLeast(0)) }
            }
        if (!ringing) {
            ringing = true
            wakeScreen(app)
            onRingingChanged?.invoke()
        }
    }

    fun stop(context: Context) {
        stopPlayer()
        stopVibration()
        timeout?.let { main.removeCallbacks(it) }
        timeout = null
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(NOTIFICATION_ID)
        screen?.let { if (it.isHeld) it.release() }
        screen = null
        if (ringing) {
            ringing = false
            onRingingChanged?.invoke()
        }
    }

    fun chime(context: Context, sound: String = "fd_chime") {
        // One sound at a time: the ring is louder anyway.
        if (ringing) return
        val app = context.applicationContext
        val chime = create(app, sound, AudioAttributes.USAGE_NOTIFICATION) ?: return
        chime.setOnCompletionListener { it.release() }
        chime.start()
    }

    private fun loop(context: Context, sound: String): MediaPlayer? {
        val loop = create(context, sound, AudioAttributes.USAGE_ALARM) ?: return null
        loop.isLooping = true
        loop.start()
        return loop
    }

    private fun create(context: Context, sound: String, usage: Int): MediaPlayer? {
        val id = context.resources.getIdentifier(sound, "raw", context.packageName)
        if (id == 0) return null
        return try {
            MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(usage)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
                setDataSource(context, Uri.parse("android.resource://${context.packageName}/$id"))
                prepare()
            }
        } catch (error: Exception) {
            null
        }
    }

    // A pattern repeated until the ring stops: 0.8 s on, 0.6 s off.
    @Suppress("DEPRECATION")
    private fun vibrate(context: Context): Vibrator? {
        val found =
            if (Build.VERSION.SDK_INT >= 31) {
                context.getSystemService(VibratorManager::class.java)?.defaultVibrator
            } else {
                context.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            }
        if (found == null || !found.hasVibrator()) return null
        val pattern = longArrayOf(0, 800, 600)
        val attributes =
            AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .build()
        if (Build.VERSION.SDK_INT >= 26) {
            found.vibrate(VibrationEffect.createWaveform(pattern, 0), attributes)
        } else {
            found.vibrate(pattern, 0, attributes)
        }
        return found
    }

    private fun stopVibration() {
        vibrator?.cancel()
        vibrator = null
    }

    private fun stopPlayer() {
        player?.let {
            try {
                it.stop()
            } catch (error: IllegalStateException) {
                // Already stopped.
            }
            it.release()
        }
        player = null
        playing = null
    }

    private fun notify(context: Context, title: String, body: String) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val builder =
            if (Build.VERSION.SDK_INT >= 26) {
                // The app plays the sound itself, looping, so the channel is
                // silent; it is high importance for the heads-up fallback.
                manager.createNotificationChannel(
                    NotificationChannel(
                        CHANNEL,
                        context.getString(R.string.core_alerts_channel_ring),
                        NotificationManager.IMPORTANCE_HIGH,
                    ).apply {
                        setSound(null, null)
                        enableVibration(true)
                        lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                    },
                )
                Notification.Builder(context, CHANNEL)
            } else {
                @Suppress("DEPRECATION")
                Notification.Builder(context).setPriority(Notification.PRIORITY_MAX)
            }
        val open = ReceivingService.launchIntent(context, ring = true)
        builder
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(context.applicationInfo.icon)
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
        if (open != null) {
            builder.setContentIntent(open).setFullScreenIntent(open, true)
        }
        manager.notify(NOTIFICATION_ID, builder.build())
    }

    // The screen turns on for the ring even where the full-screen prompt is
    // not allowed, for 30 seconds at a time. Deprecated, and newer Android
    // versions may ignore it: the full-screen intent and the activity's
    // setTurnScreenOn are the main path; this is kept for older phones.
    @Suppress("DEPRECATION")
    private fun wakeScreen(context: Context) {
        val power = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        screen =
            power.newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "fox_drop:ring",
            ).apply { acquire(30_000) }
    }
}
