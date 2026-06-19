# Ticketing Design Truth

## Overview

Ticketing is the support-desk workspace inside the launcher shell. It is a
local-first mobile surface backed by mock data for now.

## Approved Behavior

- The default view shows a searchable ticket list with open, resolved, and SLA
  summary metrics.
- Ticket tabs split the feed into All, Open, Resolved, and Create views.
- Each ticket card shows the ticket id, status, title, reporter, assignee,
  category, created date, and priority.
- Tapping a ticket opens a detail sheet where status, assignee, and comments can
  be reviewed or updated locally.
- The create-ticket view accepts title, description, category, and priority, and
  inserts a new open ticket into the top of the feed.

## Constraints

- Do not introduce backend calls for ticketing unless a separate API contract is
  approved.
- Do not change auth/session behavior as part of ticketing work.
- Reuse the existing shared shell, cards, selects, text fields, and dock
  patterns.
- Keep ticketing local-first until a backend contract is approved.

## Source of Truth

- Flutter implementation: `lib/features/ticketing/screens/ticketing_screen.dart`
- Shared sample data: `lib/shared/data/mock_data.dart`
