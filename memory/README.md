# Agent Memory

This folder is the handoff point for agents working on the delegate requirement:
recreate the mobile view of the source web application as a full Flutter mobile
template.

## Requirement Source

- Local requirement file: `delegate/requirements.md`
- Source web app: `/Users/danfordchris/projects/ipf_apps/OS/remix_-ipf-os---ux-design`
- Target Flutter app: `/Users/danfordchris/projects/ipf_apps/ai_playground`

## Current Confirmed Context

- The source web app exists and is a Vite React app.
- The web app uses React Router, Zustand, Tailwind CSS, lucide icons, Recharts,
  dnd-kit, and feature-local mock data.
- The web app has these major routes/features:
  - `/` launcher
  - `/meals/*`
  - `/projects/*`
  - `/tasks/*`
  - `/users/*`
  - `/ticketing/*`
  - login gate before routes
- The Flutter target has been refactored into a modular architecture following
  the `scaffold-feature.md` skill.
- Feature modules (Meals, Tasks, Projects, etc.) are separated into their own
  directories under `lib/features/`.
- The Meals module is the first fully verified feature matching the web mobile
  view.
- The Flutter target is not a git repository at this path, so agents should use
  file inspection rather than git history for change tracking.

## Non-Negotiable Rules

- Follow `AGENTS.md` and `CLAUDE.md`.
- Use `.claude/skills` for non-trivial implementation work.
- Base changes on the current repository state.
- Do not hand-edit generated files in `lib/starter_models/`, `lib/dao/`,
  `lib/repositories/`, or `lib/generated/`.
- The Flutter app must mirror the web app mobile view as closely as possible.
- Use the same color scheme and visual language as the source web app.
- All web components that matter to the mobile experience should have mobile
  Flutter equivalents.

## How To Continue

1. Read `delegate/requirements.md`.
2. Read this folder, especially `memory/plan.md` and `memory/source-map.md`.
3. Inspect the source web app feature by feature.
4. Implement the Flutter mobile template in phases.
5. Update `memory/progress.md` after each meaningful change.
6. Update `memory/open-questions.md` whenever a blocker or ambiguity appears.

