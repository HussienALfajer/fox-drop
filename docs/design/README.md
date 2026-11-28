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

The repository is the source of truth for the rules, the registry and the audit. The Figma files' «Read me» pages point here and copy nothing, so they cannot drift.

## Figma

Team «Fox Drop» on the Professional plan.

| File                     | Holds                                                                                                                                                                                                                                                                                                                                                              | Key                      |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| FOX DROP — Design System | The library (v0.4 published; v0.5, the customer sign-in's Core and Mobile components, prepared for the owner to publish): Cover, Read me, Changelog, «🎨 Foundations» (variables and text styles), «🏷️ Brand» (the identity's lockups, marks and app icons as `Core/Brand/…` components) and «🧩 Components» (Core, Mobile and Web components, added flow by flow) | `ITmxeo3ipw0UH5OiV0880s` |
| FOX DROP — Customer app  | The customer app's own components and its screens                                                                                                                                                                                                                                                                                                                  | `FhvOwKGrGEv6p3JnIBHOof` |

Folders: `00 Design System`, `01 Customer`, `02 Restaurant`, `03 Captain`, `04 Web`, `90 Explorations` (work that belongs to no app yet), `99 Archive`. One file per surface joins as each surface starts (customer first). A surface file has the pages «Cover», «Read me», «🧩 <App> components» (its own components), «🧪 Explorations», and one page per flow; it uses the library and never copies a library component. The library is the only one added to a surface file (Assets, Libraries): Figma's UI kits and sample libraries are removed, so a search cannot return a foreign component (customer file, 2026-11-28).

## Foundations

The library's variables, in five collections, each with WEB code syntax `var(--fd-…)`, a scope and a description ([`rules.md`](rules.md), Tokens and colour):

| Collection | Holds                                                                                                                                        | Modes                                          |
| ---------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Primitives | The ramps: orange, blue, sand (0 to 900 with 450), green, red, amber (50 to 900), and `alpha/blue-900-45`. Hidden from publishing            | «Value»                                        |
| Color      | The semantic tokens: `bg/*`, `text/*`, `border/*`, `icon/*`, a full set per state (success, error, warning, info), disabled and `bg/overlay` | Themes: «Light» now, Dark with the captain V2  |
| Spacing    | `space/*` and `size/*`                                                                                                                       | «Base» now; density per surface when it starts |
| Shape      | `radius/*` and `border-width/*`                                                                                                              | «Value»                                        |
| Typography | `font/family/base`, `font/size/*`, `font/line-height/*`, bound by the 14 text styles                                                         | «Default» and «Text 130%» (sizes × 1.3)        |

Professional allows four modes per collection ([`surfaces.md`](surfaces.md) lists the planned ones). «Text 130%» is the check of «Ready for dev» item 4: applied to a copy of a screen, it grows every text style by 30%.

Shadows, motion, grids and semantic spacing are not in the library yet: each arrives, with its description, in the batch of the first flow that needs it. `text/info` and `text/accent` share `blue/700`, and `bg/info-soft` and `bg/accent-soft` share `blue/50`, until the first information message shows whether information needs its own hue. The «🎨 Foundations» page shows every token with its use and contrast, a contrast matrix (its forbidden pairs are named `Expected fail`), the ramps, the type scale, spacing, shape and sizes. Both audits ([`figma-audit.md`](figma-audit.md)) run on the library before every publish.

## How design work runs

Every flow of every app goes through the same steps (owner, 2026-11-28). Its record is one file in [`flows/`](flows/README.md).

1. **Analysis.** Read `rules.md`, `registry.md` and, for a new surface, `surfaces.md`; then the flow's spec sections, its server routes and data, every error and limit, and its translated strings. The analysis is written into the flow file and discussed with the owner.
2. **Directions in writing.** The owner and Claude discuss creative directions in text (as many as the owner wants, rules.md, Explorations), not drawings, and approve the ones worth drawing.
3. **Explorations.** Only the approved directions are drawn, on the app file's «🧪 Explorations» page (rules.md, Explorations).
4. **Choice and layers.** The owner chooses one direction. The flow file's «Choice» section then lists every `Draft/…` element of it with its decision: the registry component it reuses or extends (searched first), or a new component with its proposed layer by rules.md (Layers and naming). The owner approves the list with the choice; that is the approval of any new shared component. For the customer app, the designer looks at the chosen direction now if they can, before the polish.
5. **Polish.** The chosen direction is rebuilt to the full standard, not moved as it is, in this order: new Core, Mobile and Web components are built in the library, given registry lines as `Proposed` with their component keys and a description starting `[Proposed]` until the flow is approved, audited on the library's components page, and the library is published (Publishing, below); new surface components are built on the app file's components page with their registry lines; components made only for directions that lost are removed (rules.md, Explorations); then the screens are rebuilt on the flow's page from published instances, and every audit count reaches zero ([`figma-audit.md`](figma-audit.md)).
6. **Approval and code.** The owner reviews, then, for the customer app, the designer (Reviews, below). When the flow meets «Ready for dev» (below), the owner marks its frames so in Dev Mode (Figma does not let the agent set that status; Claude reads it back), its components lose `[Proposed]` and become `Beta`, and only then is it coded. A component becomes `Stable` when its coded widget is merged and the registry's «Code» column names it.

Corrections become rules: a correction from the owner or the designer is fixed on every screen it touches, written into `rules.md` with its reason and date, and added to the audit when a machine can check it.

## Reviews

- **The owner** reviews in Figma or on a phone with the prototype, and answers in the chat; each decision is written into the flow file with its date.
- **The designer** has a View seat and comments in Figma. Claude reads the comments (the Figma MCP reads comments but cannot write them), applies each fix on every screen it touches, turns it into a rule when it is one, and writes in the chat what changed for each comment; the owner replies to and resolves the comments in Figma. The designer's approval is written into the flow file with their name and date.
- **Each approval** gets a named checkpoint in the file's version history («<Flow> approved, 2026-…»), saved by the owner (File, «Save to version history»), and the flow file cites it.

## «Ready for dev»

A flow is ready when all of these hold:

1. Every audit count is zero on its page.
2. Every screen and state from the flow file's analysis is drawn, including loading, errors, empty and offline where they apply.
3. Every text layer is named after its `core_l10n` key, and the `new:` proposals are approved and added to the translation files.
4. It was checked with the Typography mode «Text 130%» on a copy of each screen, and at 360, 390 and 430 wide (rules.md, Accessibility).
5. The prototype links the flow's screens.
6. Its frames carry annotations for behaviour the drawing cannot show: what each control does, timers, what a screen reader says for icons and the countdown.
7. The owner and, for the customer app, the designer approved it, as recorded in the flow file.

## Publishing the library

- **When:** after a batch that changed foundations or shared components, once every library page and the foundations audit are at zero.
- **Who:** the owner clicks «Publish» (Figma's APIs cannot publish). Claude prepares the version, the publish description and the «Changelog» entry, and checks afterwards that the surface files accepted the update.
- **How:** the version is `v0.x` until the first app ships (`v1.0`), then semantic: a removed or renamed component, property, variant or variable is a major change. Version numbers are never reused: v0.1 to v0.3 published before the reset of 2026-11-28 were withdrawn, the reset restarted at v0.1, and numbering continues from v0.4. The publish description and the «Changelog» page carry the version and what changed. Surface files then accept the update (Assets, Updates, «Update all»).
- **Deprecating:** the component is renamed with a `Deprecated/` prefix, its description names the replacement, its registry line says `Deprecated`, and it is deleted once no file uses it; with no library analytics on Professional, Claude checks each surface file with a script before deleting.

## Tokens in code

From the first coded flow (step 2 of the plan, see the roadmap), a `use_figma` script exports the variables as DTCG JSON into the repository, from which the Flutter theme and the CSS variables are generated. Figma is the source and the export only goes one way; after each library publish the export runs again and the pull request shows the difference. The export reads one collection per call (Figma caps a call's result at 20 KB in its help centre and 48 KB in its developer docs) and keeps the descriptions, which Figma's own «Export» menu drops. It maps `font/family/base` (Almarai, Figma's stand-in) to CoFo Sans Pro Arabic. The code names are the WEB code syntax: `--fd-` plus the variable name with `/` as `-`, with `color-` added for the Color collection (the foundations audit checks it).
