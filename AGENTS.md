# AGENTS.md

This file is the execution guide for AI coding agents working in this repository. It is intentionally directive. Use it alongside `CLAUDE.md`.

## Primary Rules

- Base every change on the current repository state, not on framework defaults.
- Check `.claude/skills` before implementing non-trivial work.
- Prefer existing project patterns over introducing new abstractions.
- Do not hand-edit generated files in `lib/starter_models/`, `lib/dao/`, or generated localization outputs.
- Do not bypass `APIManager` for normal API work.
- Do not bypass `PageShell` / shared widgets unless the target screen clearly uses a different pattern already.
- Do not revert unrelated user changes in the worktree.
- Always read and update the `memory/` directory to keep task state in sync across agent sessions. Refer to `memory/README.md` for the handoff protocol. This is mandatory for every session.

## Start Here

Read these in order for general orientation:

1. `memory/README.md` (Context & Handoff)
2. `memory/progress.md` (Current Status)
3. `CLAUDE.md`
4. `lib/main.dart`
5. `lib/root/app.dart`
6. `lib/core/router/router.dart`
7. `lib/shared/providers/providers.dart`
8. `lib/services/api_manager.dart`

Then read the feature-specific files you are about to modify:

- provider
- service
- screen
- related model/helper DTO

## Architecture Contract

Default implementation path:

`screen/widget -> provider -> service -> APIManager -> model`

Persistence path when needed:

`service -> model -> repository/database manager`

Use this contract unless the local code around the target area already differs.

## Feature Ownership Map

- `lib/features/auth/`: onboarding, OTP, KYC, identity, LDM
- `lib/features/home/`: home surface, wallet entry points, marquee
- `lib/features/markets/`: equities, IPOs, bonds, market detail flows
- `lib/features/orders/`: order retrieval and order submission state
- `lib/features/my_story/`: portfolio analytics, goals, returns
- `lib/features/updates/`: news, reports, topicals
- `lib/features/notifications/`: notification feed UI
- `lib/features/profile/`: profile, PIN, biometrics, settings, FAQ, statements

## Skills Routing

Use the matching repo skill before or during implementation.

### Scaffolding and structure

- New feature module:
  - `.claude/skills/scaffold-feature.md`
- New provider:
  - `.claude/skills/add-provider.md`
- New route or navigation wiring:
  - `.claude/skills/add-route.md`
- New widget or shared widget evaluation:
  - `.claude/skills/add-widget.md`

### API and storage

- New service / endpoint wrapper:
  - `.claude/skills/api-service.md`
  - `.claude/skills/ipf-api.md`
- New generated model or DB schema:
  - `.claude/skills/ipf-gen.md`
  - `.claude/skills/ipf-codegen.md`
  - `.claude/skills/ipf-database.md`

### App plumbing and settings

- Provider-state conventions:
  - `.claude/skills/ipf-state.md`
- Preferences:
  - `.claude/skills/add-preference.md`
  - `.claude/skills/ipf-preferences.md`
- Lifecycle/session behavior:
  - `.claude/skills/app-lifecycle.md`

### UI, localization, and enums

- New enum:
  - `.claude/skills/add-enum.md`
- New l10n keys:
  - `.claude/skills/add-l10n.md`
- Shared/base widgets:
  - `.claude/skills/ipf-widgets.md`
- Starter-pack extensions and helpers:
  - `.claude/skills/ipf-extensions.md`
  - `.claude/skills/ipf-utils.md`

### Notifications and security

- New notification type:
  - `.claude/skills/add-notification.md`
  - `.claude/skills/ipf-notifications.md`
- Security-sensitive infra changes:
  - `.claude/skills/ipf-security.md`

## Standard Change Recipes

### Add a new API-backed feature

1. Read `scaffold-feature.md`.
2. Create feature folders under `lib/features/<feature>/`.
3. Create service methods using `APIManager`.
4. Create provider state around those service methods.
5. Register provider if needed globally.
6. Build screen/widgets with shared components.
7. Add route in `lib/core/router/router.dart`.
8. Add l10n keys if UI strings are new.

### Add a new DB-backed model

1. Read `ipf-gen.md`.
2. Update `ipf_generator.dart`.
3. Register the model in `lib/services/database_manager.dart`.
4. Regenerate artifacts.
5. Extend the generated base in `lib/models/`.
6. Use repository access from provider/service where appropriate.

### Add a new setting or persisted flag

1. Read `add-preference.md`.
2. Add keys/getters/setters to the appropriate preference class.
3. Clear those prefs on logout if the data is session-scoped.
4. Wire UI through a provider instead of directly from widgets where the setting affects app state.

### Add a new notification flow

1. Read `add-notification.md`.
2. Update notification type enum and payload parsing.
3. Add navigation handling.
4. Confirm the target route already exists or add it.

## Project Conventions To Preserve

- Providers extend `BaseProvider` or related base classes.
- Loading flags live in providers.
- Services are mostly static utility classes with `_Endpoints`.
- Shared text should go through `Strings.instance`.
- Models are typed and parsed early.
- Use `LoggerMixin` for logs instead of ad-hoc prints.
- Reuse `InputField`, `AppButton`, `AppBottomsheet`, `AppAlert`, and `PageShell`.

## Generated And Sensitive Areas

Be careful in these areas:

- `ipf_generator.dart`
- `lib/starter_models/`
- `lib/dao/`
- `lib/repositories/`
- `lib/generated/`
- `lib/services/api_manager.dart`
- `lib/services/jwt_service.dart`
- `lib/services/session_manager.dart`
- `lib/services/notifications/`
- order placement and wallet service/provider code

If touching auth, tokens, wallet, orders, KYC, or notifications, assume the change is high impact and verify call paths carefully.

## Known Repository Risks

- App settings init currently runs from `App.build()`.
- `LocalAuthenticationProvider.authenticate()` is misleading because it returns `false`.
- `NewsProvider.fetchNews()` duplicates the fetch.
- Some repository/DAO infrastructure is present but underused by feature code.
- Some names are misspelled in existing code. Preserve compatibility over cosmetic cleanup.

## Before Finishing

- Re-read the edited feature’s provider/service/screen together.
- Confirm the route and navigation path still line up.
- Confirm loading/error handling still follows local patterns.
- Confirm you did not edit generated files manually.
- Confirm you did not overwrite unrelated user changes.
- Update `memory/progress.md` with your changes and ensure the `memory/` directory reflects the current state before submitting.
