---
name: Audit flags a swallowed error and an unexplained any
tags: [audit]
runs: 1
max_turns: 6
timeout_seconds: 240
---
Review this TypeScript with no-vibe-feel and report findings.

```ts
export const handleChange = async (data: any) => {
  try {
    const result = await fetch(`/api/invoices/${data.id}`).then((r) => r.json())
    setResult(result)
  } catch (e) {
    console.log(e)
  }
}
```
