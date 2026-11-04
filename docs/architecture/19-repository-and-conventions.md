# 19. Repository and conventions

> Part of the [technology stack](README.md). A bare "§n" here means §n of the technology stack.

## 19.1 Repository (T6)

One repository, `fox-drop`, holds everything:

| Folder | Contains | Tooling |
|---|---|---|
| `apps/server`, `apps/admin`, `apps/merchant-portal` | The server and the two web apps | pnpm workspaces and Turborepo |
| `apps/merchant`, `apps/captain`, `apps/customer` | The three Flutter apps | Dart pub workspace and Melos |
| `packages/ui-web`, `packages/design-tokens`, `packages/api-schema` (Zod and OpenAPI) | Shared TypeScript packages | pnpm workspaces and Turborepo |
| `packages/core_*` | Shared Flutter packages (§11.2) | Dart pub workspace and Melos |
| `tools/captain-simulator` | The captain simulator (§18.3) | pnpm workspaces |
| `infra/` | Terraform and Kamal | — |

The design tokens compile into the web theme and the `core_ui` Dart theme in the same build (§9.1); no package is published between repositories. One check command runs the TypeScript and the Dart checks, and a change merges only when both pass (§18.4).

## 19.2 Branches and reviews

- Trunk-based: short-lived branches into `main`, every change through a pull request with review and green checks.
- Conventional commit messages; releases tagged per product.

## 19.3 Code language

Code, comments, commit messages and documentation are in English. User-facing text is Arabic, in translation files only.

## 19.4 Dependencies

Exact versions pinned in lockfiles; Renovate opens update pull requests; runtimes (Node.js, PostgreSQL, Flutter) are upgraded once a quarter on staging first.
