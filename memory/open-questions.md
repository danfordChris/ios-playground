# Open Questions

- Should the Flutter target preserve the existing stockbroker prototype
  in `lib/main.dart`, or replace it with the web app mobile template entirely?
- Should the new app package identity remain `ai_playground`/IpfOS, or should
  UI copy follow the source web app identity exactly?
- Is pixel-level visual matching expected from screenshots, or is component and
  interaction parity enough?
- Should mock data remain local-only like the React app, or should any flows be
  connected through this repo's `APIManager` pattern later?
- Should generated iPF model/repository infrastructure be used for local data,
  or should the template keep plain feature-local Dart models?
- Should `ai/workflow-contract` be adopted fully in this repo by replacing the
  existing `.claude/skills` directory with the workflow-contract symlink
  layout, or should the submodule stay present without running its init step?
