# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

IpfOS — a Flutter application for mobile. The package name is `ai_playground` but the app identity is IpfOS. The starter pack dependency (`ipf_flutter_starter_pack`) is loaded from a local sibling path.

### Memory & Handoff (CRITICAL)

This project uses a mandatory memory synchronization protocol. Before starting any work, you MUST read the `memory/` directory to understand the current state and pending tasks.

1. **Read `memory/README.md`** for general context.
2. **Check `memory/progress.md`** for the latest status and next steps.
3. **Review `memory/plan.md`** for the implementation roadmap.

After completing a task, you MUST update the `memory/` files to ensure a seamless handoff to the next agent.

## Commands

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze (lint)
flutter analyze

# Install iPF skills into this project (run after pulling starter pack changes)
dart run ipf_flutter_starter_pack:install_skills

# Code generation (models, repositories)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Architecture

Read `AGENTS.md` for the full execution contract. The short version:

```
screen/widget → provider → service → APIManager → model
service → model → repository/database manager   (when persistence needed)
```

### iPF Flutter Starter Pack

All core infrastructure comes from `ipf_flutter_starter_pack`. Import it via:

```dart
import 'package:ipf_flutter_starter_pack/ipf_flutter_starter_pack.dart';
```

Key classes and their roles:

| Class | Role |
|---|---|
| `BaseAPIManager` | HTTP client — extend it, set base URL + `StarterAPIManagement` for auth headers, SSL pins, token refresh |
| `APIResponse<T>` | Typed HTTP response — use `.transform()`, `.transformMany()`, `.raiseOnError()` |
| `BaseDataProvider<T>` | Provider state — loading flags (`fetching`, `creating`, `updating`, `deleting`) + `data: List<T>` |
| `BaseDatabaseModel` | SQLite row — implement `toMap`, `tableName`, `toSchema` |
| `BaseDatabaseManager` | SQLite manager — extend, pass models list; call `.init()` in `main()` |
| `BaseDataRepository<T>` | CRUD over a `BaseDatabaseModel` — `all`, `save`, `update`, `delete`, `findById`, `findWhere`, `replaceBatch` |
| `BasePreferences` | SharedPreferences wrapper (non-sensitive key/value) |
| `BaseSecurePreferences` | FlutterSecureStorage wrapper — use for tokens, PINs |
| `BaseNotificationService` | Local push notifications — extend, override `selectNotification` for navigation |
| `Scenery` | Navigation (`switchScene`, `replaceScene`, `pushUntil`) + toasts (`showToast`, `showSuccess`, `showError`) |
| `AppUtility` | Logging (`log`), network check, version string, `openUrl`, `openWhatsApp`, `makePhoneCall` |
| `BaseEnvHelper` | `.env` file access via `env("KEY")` |

### Provider consumption pattern

```dart
// Watch (rebuilds on change)
final provider = context.stateWatch<MyProvider>();
// Read (no rebuild)
final provider = context.stateRead<MyProvider>();
// Both at once
final (watch, read) = context.statePair<MyProvider>();
```

### OsColors

The design system palette is defined in `lib/core/theme/os_colors.dart` as `OsColors`.

## Skills (Slash Commands)

The `.claude/commands/` directory contains reference sheets for starter pack APIs. Use them before implementing:

| Command | When to use |
|---|---|
| `/ipf-api` | New service / endpoint wrapper |
| `/ipf-state` | New provider |
| `/ipf-database` | New DB-backed model or repository |
| `/ipf-preferences` | New persisted setting or flag |
| `/ipf-widgets` | Base widget reference |
| `/ipf-extensions` | String/DateTime/num/BuildContext extensions |
| `/ipf-notifications` | New notification type |
| `/ipf-security` | SSL pinning, request signing, encrypted DB |
| `/ipf-codegen` | `BaseModelGenerator` / `RepositoryGenerator` |

## Do Not Hand-Edit

`lib/starter_models/`, `lib/dao/`, `lib/repositories/`, `lib/generated/`, localization outputs. These are generator artifacts.
