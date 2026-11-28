# Slices

A slice is the unit of work: one session, one pull request, one risk tier (`docs/process/development-workflow.md`). Each slice has one file here, named `<id>-<kebab-title>.md` after its roadmap line (for example `D.11a-every-country-sign-in.md`). The file holds that slice's plan, progress and hand-over only, so no shared task file grows without limit.

Rules:

- `/slice-plan` creates the file from [`_template.md`](_template.md) in a fresh session in plan mode; `/build-slice` builds from it.
- Keep it short: point to spec lines instead of copying them. Lasting facts go to the spec, `docs/code/<folder path>.md` or a folder's `CLAUDE.md`, never only here.
- The "Stopped at" line is updated at every green checkpoint, so any session can resume.
- When the slice merges, its status is Done and the file is not edited again. Overall status lives only in [`roadmap.md`](../roadmap.md); open items that outlive the slice go to [`backlog.md`](../backlog.md).
