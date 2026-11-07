// Architecture §10.3, AP D22: the alert sounds, generated with Web Audio
// (owner decision 2026-11-07: tones made in the browser, no sound files, until
// the design brings its own). Browsers keep audio blocked until the user
// interacts with the page, so `enable` runs from the banner's click.
export interface AlertSound {
  enable(): Promise<boolean>;
  enabled(): boolean;
  // Called when the browser suspends or resumes the audio (an interruption,
  // a device change), so the banner comes back while it is silent.
  onChange(listener: (enabled: boolean) => void): () => void;
  critical(): void;
  warning(): void;
}

// A tone: its pitch in hertz, when it starts and how long it lasts, in
// seconds.
type Tone = { hertz: number; at: number; seconds: number };

// Critical: three high beeps; warning: one lower two-note chime.
const CRITICAL: Tone[] = [
  { hertz: 1046, at: 0, seconds: 0.18 },
  { hertz: 1046, at: 0.28, seconds: 0.18 },
  { hertz: 1046, at: 0.56, seconds: 0.18 },
];
const WARNING: Tone[] = [
  { hertz: 660, at: 0, seconds: 0.2 },
  { hertz: 880, at: 0.25, seconds: 0.3 },
];

export function createAlertSound(): AlertSound {
  let context: AudioContext | undefined;
  const listeners = new Set<(enabled: boolean) => void>();

  function play(tones: Tone[]) {
    if (!context || context.state !== 'running') return;
    const start = context.currentTime;
    for (const tone of tones) {
      const oscillator = context.createOscillator();
      const gain = context.createGain();
      oscillator.type = 'square';
      oscillator.frequency.value = tone.hertz;
      gain.gain.setValueAtTime(0.0001, start + tone.at);
      gain.gain.exponentialRampToValueAtTime(0.3, start + tone.at + 0.02);
      gain.gain.exponentialRampToValueAtTime(0.0001, start + tone.at + tone.seconds);
      oscillator.connect(gain).connect(context.destination);
      oscillator.start(start + tone.at);
      oscillator.stop(start + tone.at + tone.seconds + 0.02);
    }
  }

  return {
    async enable() {
      try {
        if (!context) {
          const created = new AudioContext();
          created.addEventListener('statechange', () => {
            for (const listener of listeners) listener(created.state === 'running');
          });
          context = created;
        }
        await context.resume();
        return context.state === 'running';
      } catch {
        return false;
      }
    },
    enabled: () => context?.state === 'running',
    onChange(listener) {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
    critical: () => play(CRITICAL),
    warning: () => play(WARNING),
  };
}
