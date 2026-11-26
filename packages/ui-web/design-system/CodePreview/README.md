# CodePreview

What the WhatsApp message with the sign-in code will look like: the brand's round mark, a bubble with the sender, the words and the time.

## Behaviour

- The words are the real message, with the code masked: six dots in its place; the component never takes the code.
- `compact` (the keyboard up) drops the sender line. No WhatsApp logo or green: the brand's tokens only.

## RTL and accessibility

Read once, by `label`; its parts are hidden from screen readers. The bubble's small corner sits beside the mark, at the start.
