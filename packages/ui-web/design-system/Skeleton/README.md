# Skeleton

The loading state: grey blocks in the shape of the content to come.

## Behaviour

- Lay out `Skeleton.Block` elements inside, each with a `shape`: line, title, circle, square, media (16:9) or pill.
- The blocks pulse calmly over 1.2 s, and stand still under reduced motion. Never a spinner over content.

## RTL and accessibility

The skeleton is one busy status read once by its `label` («جارٍ التحميل»); the blocks are hidden from screen readers.
