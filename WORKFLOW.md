# Project Workflow Documentation

This document explains the workflow, architecture, and development patterns used to build the IpfOS Flutter application. It serves as a guide for both AI agents and human developers to understand how the project is organized and how to continue its development.

## 1. Core Philosophy: AI-First & Directive
The project is built using an "AI-First" approach, where **AGENTS.md** and **CLAUDE.md** act as the "System Prompt" or "Execution Contract". 

### The "System Prompt" as a Workflow Engine
- **AGENTS.md**: This file is not just documentation; it is a **directive guide** for AI agents. It sets the "Primary Rules" (e.g., base changes on repo state, don't guess) and defines the "Architecture Contract". When an agent starts, it reads this file to understand its constraints and expected behavior.
- **CLAUDE.md**: Provides the **operational context**. it contains the specific commands (bash), architecture summaries, and a mapping of the iPF Starter Pack classes to their roles. It bridges the gap between high-level rules and low-level code.

### Key Rules
- **Don't Guess**: If something is unclear, check the `memory/` directory or the source web app.
- **Stay Modular**: Follow the feature-based structure.
- **Preserve Patterns**: Use the established `Screen -> Provider -> Service -> Model` path.
- **Memory Sync**: Every session must start by reading `memory/` and end by updating it.

---

## 2. Project Organization & Structure
The project follows a modular, feature-first architecture. This allows multiple agents to work on different features with minimal conflict.

### Directory Layout
- `lib/core/`: Application-wide constants, enums, themes, and low-level utilities.
  - `theme/`: Global styling (e.g., `OsColors`).
  - `utils/`: Common helper functions.
- `lib/shared/`: Reusable components and data used across multiple features.
  - `widgets/`: Common UI components (e.g., `ModuleShell`, `Dock`).
  - `data/`: Centralized mock data (e.g., `MockData`).
- `lib/features/`: Domain-specific modules. Each folder is a self-contained feature.
  - `auth/`: Login and session management.
  - `launcher/`: The main workspace selection screen.
  - `meals/`, `tasks/`, `projects/`, `users/`, `ticketing/`: Specific "OS Apps" ported from the web.
- `lib/app_root.dart`: The entry point for authenticated state and workspace routing.
- `memory/`: A critical directory for state persistence between agent sessions (see below).
- `.claude/skills/`: Executable "recipes" for common tasks (e.g., adding a provider or scaffolding a feature).

---

## 3. Visual Design System
The app recreates a high-fidelity "IpfOS" aesthetic characterized by:
- **Glass-morphism**: Heavy use of `BackdropFilter` and semi-transparent backgrounds for cards and docks.
- **Mesh Gradients**: A dynamic visual background that sets the "OS" feel.
- **Modular Accents**: Each module (Meals, Tasks, etc.) has its own accent color (Blue, Purple, Orange, etc.) defined in `OsColors`.
- **Dock-based Navigation**: A floating bottom dock for high-level navigation, mirroring modern mobile OS patterns.

---

## 4. The Memory Handoff Protocol
Since AI agents have finite context windows and sessions, the `memory/` directory acts as the "Long-Term Memory" of the project.

| File | Purpose |
|---|---|
| `README.md` | General context and entry point for new agents. |
| `progress.md` | Chronological log of what has been built and verified. |
| `plan.md` | The roadmap of future tasks and implementation phases. |
| `open-questions.md` | Trackers for blockers, ambiguities, or decisions needed from the user. |

**Every agent MUST:**
1. Read `memory/README.md` and `memory/progress.md` at the start.
2. Update `memory/progress.md` with specific changes made.
3. Advance `memory/plan.md` by marking items as completed.

---

## 5. Implementation Flow: Web Design to Mobile Flutter
The primary goal is recreating the **mobile view** of a source React/Vite web application.

### Workflow Steps
1. **Source Analysis**: Inspect the React source code (`/Users/danfordchris/projects/ipf_apps/OS/...`).
   - Identify the React component tree.
   - Extract mock data from `mockData.ts`.
   - Identify Tailwind classes used for styling.
2. **Component Mapping**: Translate React/Tailwind patterns to Flutter widgets.
   - `Flex` + `gap` -> `Column`/`Row` + `SizedBox`.
   - `glass-morphism` -> `BackdropFilter` + `Opacity`.
   - `Zustand store` -> `Flutter Provider`.
3. **Feature Scaffolding**: Use the `scaffold-feature.md` skill to create the folder structure.
4. **Data Modeling**: Create Dart models that mirror the web app's JSON structures.
5. **UI Implementation**: Build the screens using `ModuleShell` to maintain navigation consistency.
6. **Verification**: Run `flutter analyze` and `flutter test` to ensure no regressions.

---

## 6. Architecture Contract
We strictly follow this path for data and UI:

**Standard Path:**
`Widget/Screen` (UI) -> `Provider` (State) -> `Service` (Business Logic) -> `APIManager` (Network) -> `Model` (Data)

**Persistence Path:**
`Service` -> `Model` -> `Repository/Database Manager`

### Starter Pack Skills
We leverage `.claude/skills/` to automate common tasks:
- `ipf-api.md`: For network calls.
- `ipf-state.md`: For state management.
- `ipf-codegen.md`: For generating models and repositories.

---

## 7. Guidelines for Handoff
When handing over to another agent or person:
- Ensure the `memory/` directory is 100% up to date.
- Document any "Magic Strings" or specific design decisions that aren't obvious from the code.
- If a feature is "In Progress", clearly state what is missing in `memory/plan.md`.
- Ensure `lib/main.dart` is clean and delegates to `AppRoot`.

---

## 8. How to Wind Up with This Output (Implementation Narrative)
1. **The Prototype Phase**: Initially, a monolithic `main.dart` was created to quickly prove the "IpfOS" concept (Login -> Launcher -> Modules).
2. **The Refactoring Phase**: Once the visual language was established (mesh gradients, glass-morphism), the code was split into the current modular structure using the `scaffold-feature` skill.
3. **The Polish Phase**: Individual modules (like Meals) were refined by comparing them side-by-side with the web mobile view, ensuring icons, spacing, and interactions (like tab switching) felt native yet faithful to the source.
