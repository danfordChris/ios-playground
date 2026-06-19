# Ticketing Workspace Alignment

## Status

in-progress

## Objective

Keep the ticketing workspace documentation and implementation aligned with the
current Flutter mobile surface.

## Scope Boundary

### In Scope

- `lib/features/ticketing/screens/ticketing_screen.dart`
- `lib/shared/data/mock_data.dart` ticket entries used by ticketing
- `lib/shared/widgets/shared_widgets.dart` only if a shared widget must be
  adjusted for ticketing parity
- `docs/design/features/ticketing.md`
- `docs/implementation/phases/ticketing.md`

### Out of Scope

- Authentication and session logic
- Generated files
- Project management, my tasks, and user management modules
- Backend/API integration for ticketing unless a separate contract is approved

## Acceptance Criteria

- The design doc states the approved ticketing behavior for feed, create,
  detail, and create views.
- The implementation docs name ticketing as the current focus and do not
  redefine auth/session behavior.
- The task scope excludes unrelated modules and generated files.
- The mock-data-backed ticketing surface is described with the same labels and
  states used by the current UI.

## Agent Context

- Skills: add-widget, ipf-widgets, scaffold-feature
- Design docs: `docs/design/features/ticketing.md`, `docs/implementation/project.md`
- Constraints: keep the work local-first; do not add backend calls without a
  contract
- Do not touch: auth flows, generated folders, unrelated feature modules

## Implementation Checklist

- [ ] Keep the ticket feed summary cards documented as open/resolved/SLA.
- [ ] Keep the create-ticket flow documented as a local insert into the feed.
- [ ] Keep the ticket detail sheet documented as a local review/update surface.
- [ ] Keep the scope boundary explicit in future ticketing updates.

## Verification

- `make -C ai/workflow-contract check` is not required for this ticketing doc
  update because the submodule bootstrap conflicts with the repo's existing
  `.claude/skills` layout.
- The ticketing docs must remain consistent with the Flutter screen and mock
  data.
