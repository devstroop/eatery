# Eatery MVP Docs

> Concise developer reference for the Eatery restaurant OS.
> Single Flutter binary → role-specific UIs (Admin/Waiter, KDS, Display).
> 3 device roles (admin, kds, display) + 1 sub-role (waiter) for RBAC.

## Categories

| Category | Path | Contents |
|----------|------|----------|
| **Overview** | [`overview/`](overview/) | Quickstart, architecture diagram, key concepts |
| **Development** | [`development/`](development/) | Setup, conventions, patterns, testing |
| **Design** | [`design/`](design/) | Design tokens, component library, theming |
| **Data** | [`data/`](data/) | Models, providers, database, sync protocol |
| **Routing** | [`routing/`](routing/) | RBAC system, route table, navigation |
| **UX** | [`ux/`](ux/) | UI/UX audit findings, standardization tracker |

## Quick Links

| Need | Go to |
|------|-------|
| Run the app in 5 minutes | [`overview/quickstart.md`](overview/quickstart.md) |
| Understand the architecture | [`overview/architecture.md`](overview/architecture.md) |
| Write code that fits conventions | [`development/conventions.md`](development/conventions.md) |
| Use the design system | [`design/tokens.md`](design/tokens.md) → [`design/components.md`](design/components.md) |
| Understand data flow | [`data/models.md`](data/models.md) → [`data/providers.md`](data/providers.md) |
| Add a new route | [`routing/rbac.md`](routing/rbac.md) |
| See known UX issues | [`ux/findings.md`](ux/findings.md) |

## Project Stats

| Dimension | Value |
|-----------|-------|
| Framework | Flutter 3.41 / Dart 3.8 |
| State | Riverpod |
| DB | SQLite via Zig FFI (`libeaterystore`) |
| Platforms | Android, iOS, macOS, Windows, Linux |
| Pages | ~93 Dart files |
| Routes | ~76 (single `GoRouter`) |
| Models | ~40 (freezed + json_serializable) |
| Roles | 3 device roles (admin, kds, display) + 1 sub-role (waiter) |
