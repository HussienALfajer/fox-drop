import { useEffect, useRef, useState } from 'react';
import { type AlertSound, createAlertSound } from './alert-sound.js';
import { type AdminAlert, CRITICAL_REPEAT_MS, needsRepeat, soundPlan } from './alerts.js';

// AP §7.3: the alarm of the alerts the session receives. The sound cannot be
// muted (D22); until the user enables it the page shows the banner. A
// critical alert seen first while the tab is in the background also shows a
// desktop notification, when the browser allows them.
export function useAlertAlarm(
  alerts: AdminAlert[] | undefined,
  // Stable across renders (useCallback), or each render reads the plan again.
  describe: (alert: AdminAlert) => { title: string; body: string },
) {
  const [sound] = useState<AlertSound>(createAlertSound);
  const [enabled, setEnabled] = useState(false);
  const heard = useRef(new Set<string>());
  const repeat = alerts ? needsRepeat(alerts) : false;

  useEffect(() => sound.onChange(setEnabled), [sound]);

  async function enable() {
    setEnabled(await sound.enable());
    if ('Notification' in window && Notification.permission === 'default') {
      // Asked at the same click, which browsers require.
      void Notification.requestPermission().catch(() => undefined);
    }
  }

  // Alerts read before the sound was enabled are still new once it is.
  useEffect(() => {
    if (!alerts || !enabled) return;
    const plan = soundPlan(alerts, heard.current);
    // A repeating critical sound would cover a warning's chime, so a warning
    // stays unheard until it can play (AP §7.3: it plays once).
    const deferred = plan.repeat && plan.chime;
    heard.current = new Set(
      alerts
        .filter((alert) => !deferred || alert.severity !== 'warning' || heard.current.has(alert.id))
        .map((alert) => alert.id),
    );
    if (plan.chime && !plan.repeat) sound.warning();
    if (document.hidden && 'Notification' in window && Notification.permission === 'granted') {
      for (const alert of plan.notify) {
        const { title, body } = describe(alert);
        new Notification(title, { body, tag: alert.id });
      }
    }
  }, [alerts, enabled, describe, sound]);

  // The critical sound repeats until a recipient acknowledges every critical
  // alert, which stops it for everyone at their next read.
  useEffect(() => {
    if (!enabled || !repeat) return;
    sound.critical();
    const timer = setInterval(() => sound.critical(), CRITICAL_REPEAT_MS);
    return () => clearInterval(timer);
  }, [enabled, repeat, sound]);

  return { enabled, enable };
}
