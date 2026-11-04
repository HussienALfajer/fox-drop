# 6. Real time

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 6.1 Centrifugo

- **Centrifugo** is a dedicated WebSocket server. It holds the connections; the API stays stateless.
- **History and recovery:** each channel keeps recent messages. A client that reconnects with its last offset receives what it missed. When recovery is not possible, the client re-fetches the full state (AP §4.2, RA §4.3).
- **Presence** tells the server which restaurant devices are connected, for the receiving-device rule (RA §4.6).
- Clients connect with a short-lived JWT issued by the API. Channel access is checked by the API (subscription proxy).
- Official clients: `centrifuge` for the web, `centrifuge-dart` for Flutter.

## 6.2 Channels

| Channel                  | Subscribers                                      | Carries                                            |
| ------------------------ | ------------------------------------------------ | -------------------------------------------------- |
| `ops:city.{city_id}`     | Panel users with access to the city              | Orders, alerts, tickets, cash desk, emergency stop |
| `ops_map:city.{city_id}` | Live map screen                                  | Captain positions and states (every 10 s)          |
| `merchant:{merchant_id}` | Every signed-in device of the restaurant         | Orders, pickup requests, edits, state, banners     |
| `captain:{captain_id}`   | The captain's device                             | Offers, assignment changes, order events, banners  |
| `order:{order_id}`       | The customer's devices while the order is active | Status, ETA, captain position after pickup         |
| `customer:{customer_id}` | The customer's devices                           | Account state, codes, banners                      |

## 6.3 Heartbeats and fallbacks

- Restaurant devices send a heartbeat every 20 s; the server marks a device disconnected after 60 s (fixed, RA §4.3).
- Push is a second channel only. The Android apps MUST NOT depend on push alone (RA §4.3).
- The customer app polls every 30 s when the socket is down on an order screen (CU §4.3).
