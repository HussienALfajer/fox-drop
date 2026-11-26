# TrackingSteps

An order's way in equal columns: the sign-in hero's «طلباتي», the blocking screen's order and, later, the active order.

## Behaviour

- Done steps in the brand blue with Bold icons, linked by solid lines; the current step an orange circle with two soft rings (`motion.pulse`); later steps dashed, with Linear icons.
- `current` equal to the steps' count marks every step done. The step names come in as props.

## RTL and accessibility

An ordered list named by `label`; the current step is `aria-current="step"`, and a done or current step adds «تم» or «الآن» (`doneLabel`, `nowLabel`) to its name, never colour alone. The steps run from the start, right in RTL. Under reduced motion one ring stands still.
