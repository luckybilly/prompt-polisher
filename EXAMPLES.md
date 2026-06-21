# Examples

---

## 1. Danger Interception — "clear the test data"

**User Input:** "clear the test data in the db"

```markdown
## Polished Prompt

Clear test data from the PostgreSQL database — use TRUNCATE, not DROP; preserve
seed data (user_roles, config); target only transaction-related tables; wrap in
a transaction for rollback safety.

Constraints:
  - Must NOT use DROP TABLE
  - Must preserve seed data defined in migrations
Steps:
  1. Identify which tables hold test data vs seed data
  2. Generate TRUNCATE statements for test tables only
  3. Execute within a transaction
Output: List of truncated tables and row counts

### How this was derived

Inferences:
  - "clear" → DELETE or TRUNCATE, not DROP TABLE (DROP is irreversible)
  - Project uses PostgreSQL with seed data in migrations → must preserve it
Constraints:
  - Destructive operation → added rollback safety and scope limits
```

---

## 2. From 3 Words to a Security Spec — "add auth"

**User Input:** "add auth to the app"

```markdown
## Polished Prompt

Add authentication to the application — implement JWT-based auth with token
expiry strategy, password hashing (bcrypt), CSRF protection, and session
management. *(pending: auth method — see Ambiguities)*

Constraints:
  - Must NOT implement custom crypto algorithms
  - Tokens must not appear in URLs
  - Passwords must not be stored in plaintext
Steps:
  1. Identify the app's tech stack and existing auth dependencies
  2. Choose auth method (confirm with user)
  3. Implement registration + login + token refresh flow
  4. Add CSRF protection and rate limiting for login endpoints
Output: Working auth flow, security configuration, edge case coverage

### How this was derived

Concretion: "auth" → authentication system with token strategy, password
hashing standard, CSRF protection, and session lifecycle
Inferences:
  - A modern app most likely needs JWT-based auth (could be OAuth or
    session-based — flagged as ambiguity)
  - "custom crypto" is a common AI coding pitfall → added as explicit prohibition
Ambiguities:
  - JWT vs OAuth vs session-based auth → different architecture → confirm before building
```

---

## 3. One Word Reveals the Debug Direction — "broken again"

**User Input:** "the export is broken again"

```markdown
## Polished Prompt

Fix the regressed export feature — reproduce the failure, find the root cause
in recent git history, and patch with a regression test.

Perspective: Debugging engineer, focusing on root cause and regression prevention
Constraints:
  - Fix must include a regression test to prevent recurrence
Steps:
  1. Check recent commits for export-related changes
  2. Confirm which export feature and error symptoms
  3. Reproduce the failure, identify root cause
  4. Implement fix with regression test
Output: Root cause, fix description, regression test added

### How this was derived

Corrections:
  - "broken again" → "regressed" — "again" signals this was previously fixed,
    so recent git history is the first place to look
Inferences:
  - "the export" → data export (CSV/Excel download), not JavaScript module exports
  - "broken" → runtime error or incorrect output (symptoms to confirm)
```

---

## 4. Guardrails Against Scope Creep — "refactor this"

**User Input:** "refactor this function"

```markdown
## Polished Prompt

Refactor this function — improve internal structure while preserving external
behavior and all existing tests. *(pending: refactor direction — see Ambiguities)*

Constraints:
  - Must NOT change the external API signature
  - Must NOT modify existing test cases
  - Must NOT touch unrelated files
Steps:
  1. Analyze the function's responsibilities
  2. Identify split or extraction candidates
  3. Execute refactor incrementally, verify tests after each step
Output: Refactored code, change summary, test results

### How this was derived

Concretion: "refactor" — change internal structure without changing external
behavior. Three prohibitions added: no API signature changes, no test
modifications, no unrelated file edits.
Ambiguities:
  - Split into smaller functions vs extract an interface vs rewrite implementation
    → different approach → confirm before touching code
```

---

## 5. Abbreviation Cascade — "fix the npe"

**User Input:** "fix npe in OrderSvc#calcTotal"

```markdown
## Polished Prompt

Fix the NullPointerException in OrderService.calculateTotal() — locate the
null-access point, add defensive null checks, and verify the fix.

### How this was derived

Corrections:
  - "npe" → NullPointerException (standard Java abbreviation)
  - "OrderSvc" → OrderService (standard class naming convention)
  - "#calcTotal" → calculateTotal() (method name abbreviation expanded)
Inferences:
  - NullPointerException in a calculation method → likely an unchecked
    field access on a nullable object (e.g., item.getPrice() where item is null)
```

---

## 6. Not Just for Code — "summarize the meeting"

**User Input:** "summarize the meeting notes"

```markdown
## Polished Prompt

Summarize the meeting notes into a structured record.

Perspective: Project lead, focusing on accountability and follow-through
Steps:
  1. Extract the meeting topic and date
  2. List key decisions and conclusions
  3. Create action item table: task / owner / deadline
Constraints:
  - Must NOT add decisions not in the original notes
  - Must NOT merge different topics into one
  - Must preserve the original context of each decision
Output: Topic / Decisions / Action Items (with owners and deadlines) / Key Disagreements

### How this was derived

Concretion: "summarize" → structured by Topic / Decisions / Action Items / Key
Disagreements, with explicit owners and deadlines — not a freeform paragraph
```

---

## 7. The Email You Don't Know How to Reply To — "help me reply"

**User Input:** "help me reply to this email"

```markdown
## Polished Prompt

Draft a reply to this email — match the sender's relationship and context,
maintain appropriate tone, and address each point raised. *(pending:
relationship and tone — see Ambiguities)*

Constraints:
  - Must NOT commit to deadlines or deliverables without explicit user approval
Steps:
  1. Identify the sender, relationship, and context
  2. List the points that need a response
  3. Draft reply matching the appropriate tone
Output: Draft reply text, list of points addressed, any commitments flagged

### How this was derived

Inferences:
  - "reply" implies the email expects a response with specific action items
  - Tone depends on who the sender is — flagged as ambiguity
Ambiguities:
  - Client (formal) vs colleague (casual) vs superior (deferential) → different tone → confirm
```

---

## 8. Vague Feedback Made Actionable — "make it more concise"

**User Input:** "this draft is too long, make it more concise"

```markdown
## Polished Prompt

Review the draft for conciseness — identify redundant paragraphs, tighten
wordy sentences, and propose a shorter version while preserving all key
arguments. *(pending: how much to cut — see Ambiguities)*

Constraints:
  - Must preserve the core arguments and conclusions
  - Must NOT remove content the user didn't flag — only propose cuts with reasoning
Steps:
  1. Count current word count, propose a target length
  2. Identify paragraphs that repeat or add little value
  3. Tighten wordy sentences
  4. Show original vs revised with change rationale
Output: Revised draft, list of cuts with reasons, before/after word count

### How this was derived

Concretion: "more concise" → specific operations (remove redundancy, tighten
sentences) with a measurable target (word count reduction)
Ambiguities:
  - 10% trim vs 50% rewrite → very different scope → confirm target length
```
