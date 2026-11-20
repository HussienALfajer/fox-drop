"""Writes the placeholder sounds of RA §4.4 (owner decision 2026-11-20:
placeholders until the design's sounds): distinct tones, generated here, so
they carry no licence. Run from the package: python3 tool/placeholder_sounds.py
"""
import math
import struct
import wave

RATE = 22050
OUT = 'android/src/main/res/raw'


def tone(freq, seconds, volume=0.8):
    count = int(RATE * seconds)
    fade = int(RATE * 0.01)
    samples = []
    for i in range(count):
        envelope = min(1.0, i / fade, (count - i) / fade)
        samples.append(volume * envelope * math.sin(2 * math.pi * freq * i / RATE))
    return samples


def silence(seconds):
    return [0.0] * int(RATE * seconds)


def write(name, parts):
    samples = [s for part in parts for s in part]
    with wave.open(f'{OUT}/{name}.wav', 'wb') as out:
        out.setnchannels(1)
        out.setsampwidth(2)
        out.setframerate(RATE)
        out.writeframes(b''.join(struct.pack('<h', int(s * 32767)) for s in samples))


# A new order: two quick high beeps, repeated (the loop's unit).
write('fd_new_order', [tone(988, 0.15), silence(0.07), tone(1319, 0.2), silence(0.5)] * 2)
# A pickup request: three rising notes.
write('fd_pickup_request', [tone(659, 0.15), tone(784, 0.15), tone(988, 0.25), silence(0.6)])
# A cancellation or an edit: two falling low notes.
write('fd_cancellation', [tone(587, 0.3), silence(0.05), tone(392, 0.4), silence(0.5)])
# A chime: one soft note, played once.
write('fd_chime', [tone(1047, 0.35, 0.5)])
