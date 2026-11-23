# Money

An amount and its currency symbol, as every app shows money.

## Behaviour

- `amount` is in minor units as a string, as the API sends it: «41000» with two decimals is «410 ₺». A whole amount drops its fraction; any other shows every minor digit («10.50 $»).
- Western digits, tabular, with a Western comma between thousands («3,300,000 ل.س»). The minus is U+2212 and reads first; `signed` puts a plus on a gain.
- The ₺ comes from «Fox Lira», the fallback after CoFo, which lacks the glyph.

## RTL and accessibility

The amount and its symbol are one right-to-left isolate: in Arabic the symbol sits to the amount's left, and no neighbouring Latin run moves it. A zero fee is written in words by the app («مجاني»), not «0 ₺».
