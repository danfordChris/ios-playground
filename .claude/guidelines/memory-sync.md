# Memory Synchronization Guidelines

To ensure seamless handoff between different AI agents, this project uses a mandatory memory synchronization protocol.

## Protocol

1. **Read First**: Before starting any task, read the files in the `memory/` directory:
   - `memory/README.md`: Handoff overview and rules.
   - `memory/progress.md`: Detailed log of completed and pending items.
   - `memory/plan.md`: The current implementation roadmap.
   - `memory/source-map.md`: Mapping between source web app and Flutter target.

2. **Update Often**: After every significant change or before finishing your session, update:
   - `memory/progress.md`: Add your completed steps and update the current status.
   - `memory/plan.md`: Update the status of plan phases (e.g., mark as Completed or In Progress).
   - `memory/open-questions.md`: Document any new blockers or ambiguities.

3. **Consistency**: Ensure the memory files always reflect the actual state of the codebase. If you refactor or change the architecture, update `memory/README.md` and `memory/source-map.md` accordingly.

4. **Self-Correction**: If you find that the memory is out of sync with the codebase, your first priority should be to synchronize it.
