# PRD 04 — Non-Functional Requirements

## Performance

| Metric | Target | How |
|--------|--------|-----|
| POS add-to-cart latency | < 100ms | In-memory cart + local SQLite |
| Order placement (10 items) | < 500ms | Batch insert + single commit |
| Product list load (500 items) | < 100ms | SQLite query + `Stopwatch` |
| Sync latency (order → KDS) | < 2s | WebSocket push with heartbeat |
| App cold start | < 3s | `FlutterNativeSplash` + lazy init |
| UI frame rate | 60fps | `Riverpod` rebuild optimization |

## Reliability & Availability

| Requirement | Target | Strategy |
|-------------|--------|----------|
| Offline resilience | 100% of core features | Local SQLite + OpLog, no cloud dependency |
| Data loss on crash | Zero | SQLite WAL mode + transactional commits |
| Concurrent users | 1 host + 20 leaf devices | WebSocket per connection, OpLog fan-out |
| Host failure recovery | < 15s | Heartbeat-based election |
| Sync conflict resolution | Last-writer-wins CRDT | Clock-based ordering |

## Security

| Requirement | Implementation |
|-------------|----------------|
| PIN storage | BCrypt or similar hash; never plaintext |
| PIN minimum length | 4 digits |
| Session timeout | Configurable (default 8 hours) |
| Staff PINs | Unique per staff, no shared PINS |
| Local data encryption | Optional SQLite encryption extension |
| Cloud communication | TLS for cloud relay (Phase 8) |

## Scalability

| Dimension | Current Limit | Target |
|-----------|--------------|--------|
| Products per restaurant | Unlimited | 10,000 |
| Orders per day | Unlimited | 1,000 |
| Tables per restaurant | Unlimited | 200 |
| Staff per restaurant | Unlimited | 50 |
| Concurrent leaf devices | 0 (no sync) | 20 |
| Database size | Unlimited | 500MB |
