# Evals

Behavioural checks for the skills, run with Claude Code's plugin evaluator.
Each case gives the agent a small piece of flawed code and grades the answer.

```bash
claude plugin eval . --max-cost-usd 2
claude plugin eval . --case 'writing-*'
```

Every case starts a real agent session on your own credentials, so the suite
is not part of CI. Run it locally before changing a skill's rules, and compare
the score against the no-plugin baseline the evaluator reports.
