# BannerStack

The banners in their priority order: the first two show, the rest behind a counter that opens them in place.

## Behaviour

- `banners` come in the app's priority order (RA §6.3, CA §6.3, CU §6.2), each with a stable `id`.
- The counter says how many are hidden (`moreLabel`) and opens them in place; `lessLabel` folds them again.
