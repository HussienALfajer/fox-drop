# ConfirmDialog

The panel's confirmation of a destructive or financial action (AP §7.4): reason, money effect, who is notified.

## Behaviour

- The reason is required: «تأكيد» will not confirm without one and, after a try, the error shows next to the field.
- `effect` takes the money-effect preview (an AmountsSummary); `notified` lists who will be notified.
- `onConfirm` receives the reason, trimmed; focus starts on the reason field.
