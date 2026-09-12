---
name: Writing replaces a silent bare except
tags: [writing]
runs: 1
max_turns: 6
timeout_seconds: 240
---
Rewrite this with no-vibe-feel discipline. Reply with the code only.

```python
def load_config(path):
    try:
        with open(path) as f:
            return json.load(f)
    except:
        pass
```
