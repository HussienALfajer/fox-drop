# PullToRefresh

Pull a list down from its top to refresh it: the brand mark fills as you pull, and becomes the drop loader while the refresh runs.

## Behaviour

- Touch only: past the threshold, letting go runs `onRefresh` once; a Promise keeps the loader until it settles. A second pull meanwhile does nothing, and a mouse drag never refreshes.
- The component is the list's scroll container and fills its parent. Under reduced motion the loader stands still, half full.

## RTL and accessibility

A button named `refreshLabel` («تحديث») refreshes without a gesture for screen readers and keyboards; it shows when it has keyboard focus. The mark is decoration.
