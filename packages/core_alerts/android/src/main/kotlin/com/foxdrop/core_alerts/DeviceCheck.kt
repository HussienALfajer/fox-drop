package com.foxdrop.core_alerts

import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings

// RA §4.5 checks 1–5: what the app can read of the phone, and the settings
// page of each check. The auto-start setting of some brands cannot be read:
// the device check opens the brand's page and the user confirms it.
object DeviceCheck {
    fun readings(context: Context): Map<String, Any> {
        val notifications =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val power = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val audio = context.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val max = audio.getStreamMaxVolume(AudioManager.STREAM_ALARM).coerceAtLeast(1)
        val volume = audio.getStreamVolume(AudioManager.STREAM_ALARM) * 100 / max
        return mapOf(
            "notificationsAllowed" to notifications.areNotificationsEnabled(),
            "batteryOptimizationOff" to power.isIgnoringBatteryOptimizations(context.packageName),
            "fullScreenAllowed" to
                (Build.VERSION.SDK_INT < 34 || notifications.canUseFullScreenIntent()),
            "alarmVolumePercent" to volume,
            "doNotDisturbBlocks" to doNotDisturbBlocks(notifications),
            "autostartPage" to (autostartIntent(context) != null),
        )
    }

    // Alarms play through Do Not Disturb unless it is total silence, or
    // priority only without alarms.
    private fun doNotDisturbBlocks(manager: NotificationManager): Boolean =
        when (manager.currentInterruptionFilter) {
            NotificationManager.INTERRUPTION_FILTER_NONE -> true
            NotificationManager.INTERRUPTION_FILTER_PRIORITY ->
                manager.notificationPolicy.priorityCategories and
                    NotificationManager.Policy.PRIORITY_CATEGORY_ALARMS == 0
            else -> false
        }

    fun open(context: Context, setting: String) {
        val app = context.packageName
        val intent =
            when (setting) {
                "notifications" -> notificationSettings(app)
                "battery" ->
                    Intent(
                        Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS,
                        Uri.parse("package:$app"),
                    )
                "fullScreen" ->
                    if (Build.VERSION.SDK_INT >= 34) {
                        Intent(
                            Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                            Uri.parse("package:$app"),
                        )
                    } else {
                        notificationSettings(app)
                    }
                "alarmVolume" -> Intent(Settings.ACTION_SOUND_SETTINGS)
                "doNotDisturb" -> Intent("android.settings.ZEN_MODE_SETTINGS")
                "autostart" -> autostartIntent(context)
                else -> null
            }
        val details = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, Uri.parse("package:$app"))
        for (candidate in listOfNotNull(intent, details)) {
            candidate.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            try {
                context.startActivity(candidate)
                return
            } catch (error: Exception) {
                // The page does not exist on this phone: the next one.
            }
        }
    }

    private fun notificationSettings(app: String): Intent =
        Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, app)

    // The auto-start pages of the brands RA §4.5 names.
    private val autostartPages =
        listOf(
            "com.miui.securitycenter" to "com.miui.permcenter.autostart.AutoStartManagementActivity",
            "com.huawei.systemmanager" to
                "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity",
            "com.huawei.systemmanager" to
                "com.huawei.systemmanager.optimize.process.ProtectActivity",
            "com.hihonor.systemmanager" to
                "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity",
            "com.coloros.safecenter" to
                "com.coloros.safecenter.permission.startup.StartupAppListActivity",
            "com.oplus.safecenter" to
                "com.oplus.safecenter.permission.startup.StartupAppListActivity",
            "com.vivo.permissionmanager" to
                "com.vivo.permissionmanager.activity.BgStartUpManagerActivity",
            "com.iqoo.secure" to "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager",
            "com.samsung.android.lool" to "com.samsung.android.sm.battery.ui.BatteryActivity",
        )

    private fun autostartIntent(context: Context): Intent? =
        autostartPages
            .map { (pkg, activity) -> Intent().setComponent(ComponentName(pkg, activity)) }
            .firstOrNull { it.resolveActivity(context.packageManager) != null }
}
