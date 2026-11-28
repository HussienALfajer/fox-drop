# Flows

One file per flow of an app, named `<app>-<flow>.md`. It is the flow's decision record through the steps in [`../README.md`](../README.md) (How design work runs): the analysis, the directions discussed, what was chosen and why, and where the screens live in Figma.

| Flow                                     | Step         | Date       |
| ---------------------------------------- | ------------ | ---------- |
| [Customer: sign-in](customer-sign-in.md) | 2 Directions | 2026-11-28 |

Each file has the same sections: **Analysis** (entry points, steps, server routes and data, errors and limits, strings, states to design), **Directions** (each discussed idea with the owner's decision), **Choice** (the chosen direction, why, and the table of its `Draft/…` elements with their decision and layer), **Figma** (the Explorations section, the flow page and the latest audit result), **Reviews** (each approval with its date, who and the version-history checkpoint) and **Open points**. A new flow file starts from this skeleton:

```markdown
# <App>: <flow>

Step: <1 Analysis | 2 Directions | 3 Explorations | 4 Choice | 5 Polish | 6 Ready for dev>, <date>

## Analysis

Spec sections, entry points, steps, server routes and data, errors and limits, strings (`core_l10n` keys and `new:` proposals), states to design.

## Directions

| Direction | Idea | What it changes in components | Risk | Owner's decision and date |
| --------- | ---- | ----------------------------- | ---- | ------------------------- |

## Choice

The chosen direction, why, and the losing ones with their reason.

| `Draft/…` element | Decision (reuse, extend, new) | Registry match | Layer | Approved |
| ----------------- | ----------------------------- | -------------- | ----- | -------- |

## Figma

Explorations section id, flow page id, screens, latest audit result and date, `use_figma` calls used.

## Reviews

| Date | Who | What was approved | Version-history checkpoint |
| ---- | --- | ----------------- | -------------------------- |

## Open points
```
