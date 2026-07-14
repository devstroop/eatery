# PRD 01 — Product Vision

## 1. The Four Applications

Eatery is a multi-app, offline-first restaurant operating system. The current codebase is **Eatery Admin** — the command center. Three more applications sit alongside it:

| App | Purpose | Primary Users | Target Devices | Code Reuse |
|-----|---------|--------------|----------------|------------|
| **Admin** | Full management, config, reports, POS | Owner, manager | Desktop + tablet + phone | — |
| **Waiter** | Order taking, table management | Waitstaff | Phone + tablet | ~40% |
| **Kitchen (KDS)** | Real-time order feed, KOT display | Chefs | Wall tablet, desktop | ~20% |
| **Display** | Customer-facing order status (read-only) | Customers | Kiosk tablet | ~10% |

## 2. Core Principles

| Principle | Rationale |
|-----------|-----------|
| **Offline-first** | Every feature works without internet. Cloud is a replication target, not the primary store. A POS that dies when the internet goes down is unacceptable. |
| **Local network sync** | Devices discover each other on LAN (WebSocket + OpLog). No cloud dependency for daily restaurant operation. |
| **Role-based access** | Each staff member logs in with their own PIN. UI and capabilities adapt to role. No single shared password. |
| **Cross-platform** | Flutter enables one codebase for Android, iOS, macOS, Windows, Linux, Web. |
| **Free & open core** | No monthly fees, no proprietary hardware. Compete with Toast, Square, Lightspeed on a level playing field. |
| **Incremental migration** | The current codebase is not rewritten — it's refactored in place, phase by phase, keeping existing features working. |

## 3. Market Positioning

| Factor | Eatery | Toast | Square | Lightspeed |
|--------|--------|-------|--------|------------|
| Monthly fee | Free | $165+/mo | Varies | $69+/mo |
| Offline resilience | Full | Limited | Limited | Limited |
| Hardware requirement | Any | Proprietary | Any | Any |
| Multi-app (Waiter/KDS/Display) | Built-in | Separate products | Separate products | Separate products |
| Source code access | Open | Closed | Closed | Closed |

## 4. Architecture Philosophy

```
Current:  Single SQLite DB (per-device) → no sharing
Target:   Admin SQLite DB + WebSocket Server → OpLog → Waiter/KDS/Display
Cloud:    Replication target for multi-location reporting (optional)
```

The Admin app hosts a WebSocket server on the local network. Waiter and KDS apps connect as leaf nodes, exchanging operation log (OpLog) entries. This gives real-time sync without any cloud dependency.
