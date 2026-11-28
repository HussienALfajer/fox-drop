# FOX DROP design system

The design system for the five surfaces: the customer, restaurant and captain apps (Flutter) and the admin panel and owner portal (web). Started from nothing on 2026-11-28; the earlier design system was removed and is never reused.

## Where things are

| File                               | What it holds                                                                                                    |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| [`rules.md`](rules.md)             | Every design rule in one sentence, its reason and its date. Read it before any design work.                      |
| [`registry.md`](registry.md)       | Every component: its layer, who uses it, its status and where it lives in Figma and in code.                     |
| [`surfaces.md`](surfaces.md)       | What each surface needs (devices, density, contrast, navigation), and what that means for the system.            |
| [`flows/`](flows/README.md)        | One file per flow: its analysis (spec, API, data, errors), the directions discussed and what was chosen and why. |
| [`figma-audit.md`](figma-audit.md) | The audit script run in Figma after every batch, and what each check means.                                      |
| [`../brand/`](../brand/README.md)  | The identity pack: logo, mark, app icon and the guideline boards.                                                |

The repository is the source of truth for the rules, the registry and the audit. The Figma file's «Read me» page mirrors them for people working in Figma.

## Figma

Team «Fox Drop» on the Professional plan.

| File                     | Holds                                                              | Key                      |
| ------------------------ | ------------------------------------------------------------------ | ------------------------ |
| FOX DROP — Design System | The library: foundations, Core, Mobile and Web components; Read me | `ITmxeo3ipw0UH5OiV0880s` |
| FOX DROP — Customer app  | The customer app's own components and its screens                  | `FhvOwKGrGEv6p3JnIBHOof` |

Folders: `00 Design System`, `01 Customer`, `02 Restaurant`, `03 Captain`, `04 Web`, `90 Explorations`, `99 Archive`. The library is published to the team; each publish gets a version and a description, and the library's «Changelog» page lists them. One file per surface joins as each surface starts (customer first). A surface file holds its own components and its screens, and uses the library; it never copies a library component.

## How design work runs

Every flow of every app goes through the same steps (owner, 2026-11-28). Its record is one file in [`flows/`](flows/README.md).

1. **Analysis.** Read `rules.md`, `registry.md` and, for a new surface, `surfaces.md`; then the flow's spec sections, its server routes and data, every error and limit, and its translated strings. The analysis is written into the flow file and discussed with the owner.
2. **Directions in writing.** The owner and Claude discuss two or three creative directions in text, not drawings, and approve the ones worth drawing.
3. **Explorations.** Only the approved directions are drawn, on the app file's «🧪 Explorations» page, one section per flow. New elements may be drawn on the screens, named `Draft/…`; they do not enter the library until a direction is chosen. The page is exempt from the audit.
4. **Choice.** The owner chooses one direction; for the customer app the designer takes a quick look before polishing when possible. Every idea stays on the page, marked chosen or not chosen with one line of reason, so the designer sees why.
5. **Polish.** The chosen direction is rebuilt to the full standard, not moved as it is: its new parts become components in the layer `registry.md` gives them, with their registry lines; the screens move to the flow's page; every audit count reaches zero ([`figma-audit.md`](figma-audit.md)).
6. **Approval and code.** The owner reviews; for the customer app the designer gives the final approval; the flow is marked «Ready for dev» and only then coded.

Corrections become rules: a correction is fixed on every screen it touches, written into `rules.md` with its reason and date, and added to the audit when a machine can check it.
