# FOX DROP design system

The design system for the five surfaces: the customer, restaurant and captain apps (Flutter) and the admin panel and owner portal (web). Started from nothing on 2026-11-28; the earlier design system was removed and is never reused.

## Where things are

| File                               | What it holds                                                                                         |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [`rules.md`](rules.md)             | Every design rule in one sentence, its reason and its date. Read it before any design work.           |
| [`registry.md`](registry.md)       | Every component: its layer, who uses it, its status and where it lives in Figma and in code.          |
| [`surfaces.md`](surfaces.md)       | What each surface needs (devices, density, contrast, navigation), and what that means for the system. |
| [`figma-audit.md`](figma-audit.md) | The audit script run in Figma after every batch, and what each check means.                           |
| [`../brand/`](../brand/README.md)  | The identity pack: logo, mark, app icon and the guideline boards.                                     |

The repository is the source of truth for the rules, the registry and the audit. The Figma file's «Read me» page mirrors them for people working in Figma.

## Figma

Team «Fox Drop» on the Professional plan.

| File                     | Holds                                                              | Key                      |
| ------------------------ | ------------------------------------------------------------------ | ------------------------ |
| FOX DROP — Design System | The library: foundations, Core, Mobile and Web components; Read me | `ITmxeo3ipw0UH5OiV0880s` |

One file per surface joins it as each surface starts (customer first). A surface file holds its own components and its screens, and uses the library; it never copies a library component.

## How design work runs

1. **Preflight.** Read `rules.md`, `registry.md` and, for a new surface, `surfaces.md`.
2. **Component first.** A screen only places library or surface components inside auto-layout containers bound to variables. Anything missing becomes a component first, in the layer `registry.md` gives it, and gets its registry line.
3. **Batch and audit.** Work in batches of one flow or one component family. After each batch run the audit; every count must be zero before the next batch.
4. **Review gates.** The owner reviews the foundations, components and each flow; for the customer app a designer gives the final approval. A flow is coded only after it is marked «Ready for dev».
5. **Corrections become rules.** A correction is fixed on every screen it touches, written into `rules.md` with its reason and date, and added to the audit when a machine can check it.
