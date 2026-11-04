# 21. Options considered and not chosen

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

| Option                                   | Why not                                                                                                                          |
| ---------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| Microservices from day one               | Too much operational cost for the team size, and distributed transactions around money (§4.1)                                    |
| Firebase or Supabase as the main backend | Not suited to a complex order state machine, strict ledgers and guaranteed timers. Firebase is used for push and App Check only. |
| MongoDB                                  | Money needs relational constraints and multi-row transactions                                                                    |
| Laravel (BeeOrder's likely backend)      | Weaker for long-lived connections, real time and dense timers                                                                    |
| Socket.IO inside the API                 | Couples connections to API scaling; no built-in history and recovery                                                             |
| GraphQL                                  | Caching complexity without benefit on weak networks                                                                              |
| Separate native apps per platform        | Six codebases instead of three Flutter apps with shared packages                                                                 |
| React Native                             | Weak on Windows for the restaurant app; one framework for all three apps is worth more                                           |
| Flutter Web for the panel or portal      | Weaker for large tables, long Arabic text and accessibility                                                                      |
| Next.js for the panel                    | Server rendering and SEO are not needed behind a sign-in                                                                         |
| Radix and shadcn/ui                      | Replaced by Base UI with FOX DROP's own components (T2)                                                                          |
| Google Maps everywhere                   | Per-use billing; MapLibre with OSM covers V1, with Google Maps kept as a display fallback (§7.2)                                 |
| Relying on push alone for rings          | Forbidden by the specs (RA §4.3)                                                                                                 |
