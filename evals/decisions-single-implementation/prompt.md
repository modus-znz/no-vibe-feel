---
name: Decisions rejects a one-implementation abstraction
tags: [decisions]
runs: 1
max_turns: 6
timeout_seconds: 240
---
Using no-vibe-feel, should I keep this structure for a small internal tool
that only ever reads users from one Postgres table?

```ts
interface UserRepository { findById(id: string): Promise<User | null> }
class PostgresUserRepository implements UserRepository { /* ... */ }
class UserRepositoryFactory {
  static create(): UserRepository { return new PostgresUserRepository() }
}
```
