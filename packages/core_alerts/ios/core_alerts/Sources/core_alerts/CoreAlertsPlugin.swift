import AVFoundation
import AudioToolbox
import Flutter
import UIKit
import UserNotifications

/// The captain app's ringing layer on iOS (architecture §14.2, CA §4.4–4.5,
/// K15; slice 2.46), on the channel `fox_drop/core_alerts` the Android and
/// Windows layers answer too.
///
/// - While the app is in the foreground a ring loops its bundled sound
///   (`AVAudioPlayer` on the playback category, so the ring/silent switch
///   does not mute it) and vibrates.
/// - When the app leaves the foreground while a ring plays (the captain locks
///   the phone, or a ring starts in the background, the background location
///   keeping the app running), the ring becomes one local notification:
///   time-sensitive with the sound file (iOS plays at most 30 s, which the
///   switch may mute), or critical once the user allowed Critical Alerts
///   (Apple's entitlement, K15). Back in the foreground the loop plays again.
/// - The receiving service is Android's: `startReceiving`, `stopReceiving`
///   and `wake` do nothing here.
public class CoreAlertsPlugin: NSObject, FlutterPlugin {
  private static let ringIdentifier = "fd_ring"

  private struct Ring {
    let sound: String
    let title: String
    let body: String
    let vibrate: Bool
  }

  private var ring: Ring?
  // Whether the notification of the current ring was posted, so a ring the
  // app sends again (every 5 s while an offer is open) alerts once.
  private var notified = false
  private var player: AVAudioPlayer?
  private var chimePlayer: AVAudioPlayer?
  private var stopTimer: Timer?
  private var vibrateTimer: Timer?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "fox_drop/core_alerts", binaryMessenger: registrar.messenger())
    let instance = CoreAlertsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    NotificationCenter.default.addObserver(
      instance, selector: #selector(didEnterBackground),
      name: UIApplication.didEnterBackgroundNotification, object: nil)
    NotificationCenter.default.addObserver(
      instance, selector: #selector(didBecomeActive),
      name: UIApplication.didBecomeActiveNotification, object: nil)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "startReceiving", "stopReceiving", "wake":
      result(nil)
    case "ring":
      startRing(
        Ring(
          sound: arguments["sound"] as? String ?? "fd_offer",
          title: arguments["title"] as? String ?? "",
          body: arguments["body"] as? String ?? "",
          vibrate: arguments["vibrate"] as? Bool ?? false),
        stopAfterMs: (arguments["stopAfterMs"] as? NSNumber)?.doubleValue)
      result(nil)
    case "stopRing":
      stopRing()
      result(nil)
    case "chime":
      chime(arguments["sound"] as? String ?? "fd_chime")
      result(nil)
    case "readings":
      readings(result)
    case "openSettings":
      openSettings(arguments["setting"] as? String)
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // A ring already playing changes only its sound or text (RA §4.4).
  private func startRing(_ next: Ring, stopAfterMs: Double?) {
    let changed =
      ring?.sound != next.sound || ring?.title != next.title || ring?.body != next.body
    ring = next
    if changed { notified = false }
    stopTimer?.invalidate()
    stopTimer = nil
    if let stopAfterMs {
      stopTimer = Timer.scheduledTimer(
        withTimeInterval: max(0, stopAfterMs / 1000), repeats: false
      ) { [weak self] _ in self?.stopRing() }
    }
    if UIApplication.shared.applicationState == .active {
      play()
    } else {
      notify()
    }
  }

  private func stopRing() {
    ring = nil
    notified = false
    stopTimer?.invalidate()
    stopTimer = nil
    quiet()
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: [Self.ringIdentifier])
    center.removeDeliveredNotifications(withIdentifiers: [Self.ringIdentifier])
  }

  private func play() {
    guard let ring else { return }
    let file = "\(ring.sound).wav"
    if player?.isPlaying != true || player?.url?.lastPathComponent != file {
      player?.stop()
      player = nil
      guard let url = Bundle.main.url(forResource: ring.sound, withExtension: "wav") else {
        return
      }
      let session = AVAudioSession.sharedInstance()
      try? session.setCategory(.playback, mode: .default)
      try? session.setActive(true)
      player = try? AVAudioPlayer(contentsOf: url)
      player?.numberOfLoops = -1
      player?.volume = 1
      player?.play()
    }
    vibrateTimer?.invalidate()
    vibrateTimer = nil
    if ring.vibrate {
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      vibrateTimer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { _ in
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      }
    }
  }

  private func quiet() {
    player?.stop()
    player = nil
    vibrateTimer?.invalidate()
    vibrateTimer = nil
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
  }

  // The ring as one notification while the app is not in the foreground.
  private func notify() {
    guard let ring, !notified else { return }
    notified = true
    // The app may be suspended right after it left the foreground: the
    // background task lets the notification be posted first.
    let application = UIApplication.shared
    var task = UIBackgroundTaskIdentifier.invalid
    task = application.beginBackgroundTask {
      application.endBackgroundTask(task)
      task = .invalid
    }
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      let content = UNMutableNotificationContent()
      content.title = ring.title
      content.body = ring.body
      // The offer's loop written out for 29 s (a notification plays its
      // sound once).
      let name = UNNotificationSoundName(
        ring.sound == "fd_offer" ? "fd_offer_30s.wav" : "\(ring.sound).wav")
      if settings.criticalAlertSetting == .enabled {
        content.sound = UNNotificationSound.criticalSoundNamed(name, withAudioVolume: 1)
        content.interruptionLevel = .critical
      } else {
        content.sound = UNNotificationSound(named: name)
        content.interruptionLevel = .timeSensitive
      }
      let request = UNNotificationRequest(
        identifier: Self.ringIdentifier, content: content, trigger: nil)
      center.add(request) { _ in
        DispatchQueue.main.async {
          if task != .invalid {
            application.endBackgroundTask(task)
            task = .invalid
          }
        }
      }
    }
  }

  @objc private func didEnterBackground() {
    guard ring != nil else { return }
    quiet()
    notify()
  }

  @objc private func didBecomeActive() {
    guard ring != nil else { return }
    let center = UNUserNotificationCenter.current()
    center.removeDeliveredNotifications(withIdentifiers: [Self.ringIdentifier])
    notified = false
    play()
  }

  // Once, never over a ring; the ambient category, so the switch mutes it
  // like any other notification sound (CA §4.4).
  private func chime(_ sound: String) {
    guard ring == nil, UIApplication.shared.applicationState == .active,
      let url = Bundle.main.url(forResource: sound, withExtension: "wav")
    else { return }
    try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
    chimePlayer = try? AVAudioPlayer(contentsOf: url)
    chimePlayer?.play()
  }

  // CA §4.5's iPhone column: checks 1 (time-sensitive ones included) and 3.
  // The ring switch and a Focus (check 5) cannot be read by an app.
  private func readings(_ result: @escaping FlutterResult) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
      DispatchQueue.main.async {
        result([
          "notificationsAllowed": settings.authorizationStatus == .authorized,
          "timeSensitiveAllowed": settings.timeSensitiveSetting == .enabled,
          "criticalAlertsAllowed": settings.criticalAlertSetting == .enabled,
          "backgroundRefreshOn": UIApplication.shared.backgroundRefreshStatus == .available,
          "lowPowerMode": ProcessInfo.processInfo.isLowPowerModeEnabled,
        ])
      }
    }
  }

  // iOS opens no page of its own settings but the app's: its notifications
  // page from iOS 16, the app's page for the rest.
  private func openSettings(_ setting: String?) {
    var address = UIApplication.openSettingsURLString
    if setting == "notifications", #available(iOS 16.0, *) {
      address = UIApplication.openNotificationSettingsURLString
    }
    guard let url = URL(string: address) else { return }
    UIApplication.shared.open(url)
  }
}
