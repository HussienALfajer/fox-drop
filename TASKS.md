# Tasks

The handover note between sessions: the current task, its branch, its plan, and where work stopped. Replace it when a task starts; keep it current while the task runs.

## Current task

Phase 0, slice 0.1: workspace, single check command and CI (`docs/roadmap.md`).

- **Implements:** architecture §18.4 (gates), §19.1 (one repository, T6), §19.4 (pinned versions, Renovate), §11.1 (Flutter pinned with FVM); the agent checks of the build workflow.
- **Branch:** `chore/workspace-and-ci`
- **Done when:** `pnpm verify` passes locally and in GitHub Actions on the pull request, and `main` requires that check.

## Plan

- [ ] Root TypeScript workspace: `package.json` with the pinned pnpm (`packageManager`) and Node (`engines`, `.node-version`), `pnpm-workspace.yaml` (`apps/*`, `packages/*`, `tools/*`), `turbo.json` with `lint`, `typecheck` and `test` tasks, no cached build output.
- [ ] Root Dart workspace: root `pubspec.yaml` as a pub workspace, Melos scripts for analyze, format check and test, `.fvmrc` pinning the Flutter stable version.
- [ ] Shared tooling: ESLint flat config and Prettier at the root (0.2 adds the boundary rule), `analysis_options.yaml` for Dart, `.editorconfig`, `.gitattributes` with LF line endings.
- [ ] `scripts/verify.mjs` behind `pnpm verify`: format check, lint, type check and tests for TypeScript through Turborepo, then analyze, format check and tests for Dart through Melos; stops at the first failure and passes on the empty workspace.
- [ ] Claude Code layer: format hooks in `.claude/settings.json` (Prettier for TypeScript, JSON and Markdown; `dart format` for Dart), `checker` agent (Haiku) that runs `pnpm verify` and reports failures, `build-slice` skill for building one roadmap slice end to end.
- [ ] GitHub Actions `ci.yml`: on pull requests and pushes to `main`, sets up Node, pnpm and the pinned Flutter, then runs `pnpm verify`.
- [ ] `renovate.json`: grouped update pull requests, lockfiles pinned.
- [ ] `CLAUDE.md` Commands section: `pnpm install`, `pnpm verify`, the Melos bootstrap.
- [ ] Pull request with `## Summary` and `## Test plan`, merged with a merge commit once CI passes.
- [ ] Branch protection on `main` requiring the CI check, through `gh` (owner approval, 2026-11-04).

## Next

Slice 0.2, server skeleton and module boundaries (`docs/roadmap.md`).
