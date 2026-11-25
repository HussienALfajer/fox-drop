# TextLink

Underlined words that act, such as «ليس الآن», «تعديل الرقم» and «الشروط»: primary ink, bold, with a 48 target around them.

## States

- Rest, hover (`primary-hover`), pressed (`primary-pressed`) and keyboard focus (the blue ring); colours fade, nothing moves.

## Props worth knowing

`href` makes it a real link to an address; without it, it acts through `onClick`. The words come from the app's translation files.

## RTL and accessibility

It is always read as a link, reachable with Tab and run with Enter. The 48 target never changes the words' size.
