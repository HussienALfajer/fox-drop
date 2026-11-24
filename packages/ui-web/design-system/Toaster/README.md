# Toaster

Holds an app's toasts at the bottom end corner: short results of the user's own actions.

## Behaviour

- Wrap the app once; show one with `FoxDrop.useToast().show({ tone, text, action })`.
- Success and info stay 4 s, warning 6 s, a toast with an action 8 s; danger stays until closed. Hover and focus pause the timer.
- Polite live region; danger is assertive. Never the only signal of an alert: those are banners with sound.
