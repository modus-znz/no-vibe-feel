---
type: llm
---
The rewrite catches only specific exceptions (for example FileNotFoundError or
json.JSONDecodeError) and either re-raises them as a meaningful error or
returns an explicit, documented default. No failure path is silently ignored.
