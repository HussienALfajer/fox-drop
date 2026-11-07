// Architecture §6.2: the channels, by namespace. Each namespace's
// subscriptions are checked by the API (realtime-access.ts).

// Every signed-in device of the restaurant: its orders.
export const merchantChannel = (restaurantId: string): string => `merchant:${restaurantId}`;

// The captain's device: offers and the assigned order (CA §15).
export const captainChannel = (captainId: string): string => `captain:${captainId}`;

// The customer's devices while the order is active: its status.
export const orderChannel = (orderId: string): string => `order:${orderId}`;

// Panel users with access to the city: its orders and alerts (§6.2).
export const opsChannel = (cityId: string): string => `ops:city.${cityId}`;
