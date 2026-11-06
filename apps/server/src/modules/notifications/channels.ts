// Architecture §6.2: the channels, by namespace. Each namespace's
// subscriptions are checked by the API (realtime-access.ts).

// Every signed-in device of the restaurant: its orders.
export const merchantChannel = (restaurantId: string): string => `merchant:${restaurantId}`;

// The customer's devices while the order is active: its status.
export const orderChannel = (orderId: string): string => `order:${orderId}`;
