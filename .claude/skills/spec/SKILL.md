---
name: spec
description: Interview the owner and write an approved spec for a FOX DROP feature that the written V1 specs do not cover, before any slice plan or code. Use when a feature, change or later version (V2 onward) has no spec section yet.
argument-hint: '<party> <feature>'
---

# Write a feature spec

Input: the party (admin panel AP, restaurant app RA, captain app CA, customer app CU, or shared domain) and the feature. The written specs are the source of truth: if the feature is already in `docs/product/v1/` or `docs/domain/`, say so and stop; `/slice-plan` plans it from there.

1. Read `docs/README.md`, the spec of the party (its README and §2 decisions), the domain sections the feature touches, `docs/roadmap.md` for the version it belongs to, and `docs/open-questions.md`.
2. Interview the owner in Arabic with `AskUserQuestion`: three or four options a question, your recommendation first. Ask only what the docs do not answer. Never guess an open item: ask, then record the answer as a decision in §2 of the document it belongs to, with its date and reason (`docs/README.md`, Decisions).
3. Write the spec in English as new numbered section files of the party's spec (or `docs/product/<version>/<party>/` for a later version), in the style of the existing sections:
   - goal and the requirement it serves;
   - user stories (role, action, outcome), Arabic UI labels in «guillemets»;
   - rules, states, permissions per role (AP §6), settings keys with defaults;
   - edge cases, offline behaviour, timers;
   - money (integer minor units, ledger journals, who pays what), abuse and privacy (scope by city, restaurant, captain and customer; what must never be logged);
   - definition of done: numbered, each item testable, with the test or the staging demonstration that proves it;
   - screens in words (purpose, every state with its data and actions); they are drawn and approved in the slice that builds them (architecture §9.9);
   - out of scope; open items (empty before approval, or listed in `docs/open-questions.md`).
4. Update every section that depends on a new decision in the same change, and `docs/README.md` if a new folder appears.
5. Ask the owner to approve the spec. Then open the docs pull request with auto-merge (squash) and Auto-fix, and name `/slice-plan` in a fresh session as the next step.

Keep each section file short; split by sub-feature when it grows.
