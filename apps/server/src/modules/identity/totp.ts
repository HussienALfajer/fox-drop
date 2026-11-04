import { verify } from 'otplib';

// One 30-second step either side, for a phone clock that is slightly off.
const TOLERANCE_SECONDS = 30;

// RFC 6238 with otplib (architecture §10.3). Returns the accepted time step,
// or null. A step at or before `afterTimeStep` is refused, so a code that was
// accepted once is never accepted again.
export async function verifyTotp(
  secret: string,
  code: string,
  now: Date,
  afterTimeStep: number | null = null,
): Promise<number | null> {
  try {
    const result = await verify({
      secret,
      token: code,
      epoch: Math.floor(now.getTime() / 1000),
      epochTolerance: TOLERANCE_SECONDS,
      ...(afterTimeStep === null ? {} : { afterTimeStep }),
    });
    return result.valid && 'timeStep' in result ? result.timeStep : null;
  } catch {
    // otplib throws when the last accepted step is ahead of this clock's
    // window, as after a server clock stepped back: the code is refused.
    return null;
  }
}
