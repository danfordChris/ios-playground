# Implementation Plan

## Goal

Build a full working Flutter mobile template that recreates the source web
application's mobile view, components, assets, colors, interactions, and data
flow.

## Phase 1: Source Analysis

- Run or inspect the source React app.
- Capture the mobile views for:
  - login
  - launcher
  - meals
  - project management
  - my tasks
  - user management
  - ticketing
- Inventory shared UI components:
  - app shell/layout
  - inputs
  - selects
  - modals
  - slide-overs
  - document uploader
  - cards/lists/tabs/navigation
- Inventory icons, colors, spacing, typography, shadows, borders, and responsive
  behavior from `src/index.css` and component classes.
- Inventory mock data and store behavior from `src/lib/store.ts` and feature
  `services/mockData.ts` files.

## Phase 2: Flutter App Structure (Completed)

- Refactored to modular structure under `lib/features`.
- Used `.claude/skills/scaffold-feature.md` for organization.
- Established shared mobile foundations in `lib/core` and `lib/shared`.
- All shared UI tokens (colors, text styles) extracted to `OsColors`.

## Phase 3: Feature Rebuild Order

1. Auth/login (Completed)
2. Launcher/home (Completed)
3. Meals (Completed)
4. Ticketing (Current focus)
5. My tasks (In Progress)
6. Project management (In Progress)
7. User management (In Progress)

This order starts with navigation and high-frequency operational surfaces, then
fills out the remaining modules.

## Phase 3 Ticketing Notes

- Use the workflow-contract docs structure under `docs/` for the ticketing
  implementation plan.
- Keep ticketing scope limited to the existing mobile surface and local mock
  data until an API contract is introduced.
- Treat auth as settled for now; do not re-open login/session work while
  ticketing is the active module.
- Current Flutter ticketing shape: All/Open/Resolved/New tabs, searchable list,
  and a detail bottom sheet that mutates local state.
- Startup currently bypasses auth and lands on the launcher dashboard; keep that
  as a pending follow-up rather than reintroducing login immediately.

## Phase 4: Data Flow

- Recreate the Zustand store behavior in Flutter provider/state classes.
- Keep mock data typed and parsed early.
- Do not introduce backend calls unless the source web app uses them or the
  requirement changes.
- Preserve user/session gating from the React app: no current user means login;
  after login, show the launcher and routed modules.

## Phase 5: Assets

- Identify whether source app uses external image assets, generated visuals, or
  CSS-only UI.
- Recreate assets needed for mobile.
- Register Flutter assets in `pubspec.yaml`.
- Do not leave missing asset references.

## Phase 6: Verification

- Run `flutter analyze`.
- Run `flutter test`.
- Run the app and inspect mobile layout.
- Check for overflow, clipped text, missing routes, blank screens, broken state,
  and color mismatches.
- Record verification results in `memory/progress.md`.
