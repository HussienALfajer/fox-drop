import { useEffect, useState } from 'react';

// The server's clock (architecture §5.3: every response carries Server-Time
// in Unix milliseconds), so the time in a status and the SLA colours do not
// follow a browser clock that is off.
let offsetMs = 0;

export function recordServerTime(header: string | null, receivedAt = Date.now()) {
  const serverMs = Number(header);
  if (header !== null && Number.isFinite(serverMs) && serverMs > 0)
    offsetMs = serverMs - receivedAt;
}

export function serverNow(): number {
  return Date.now() + offsetMs;
}

// The server's time now, read again every second while the page is open.
export function useServerNow(): number {
  const [now, setNow] = useState(serverNow);
  useEffect(() => {
    const timer = setInterval(() => setNow(serverNow()), 1000);
    return () => clearInterval(timer);
  }, []);
  return now;
}
