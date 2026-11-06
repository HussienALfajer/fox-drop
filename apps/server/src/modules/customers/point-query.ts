import { z } from 'zod';

// A query value: a number, never an empty string read as 0.
const coordinate = z.string().min(1).pipe(z.coerce.number());

// The selected point in a query string (CU §7.1), in degrees.
export const pointQuery = z.object({
  latitude: coordinate.pipe(z.number().min(-90).max(90)),
  longitude: coordinate.pipe(z.number().min(-180).max(180)),
});
