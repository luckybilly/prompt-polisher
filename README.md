# Prompt Polisher

**A `CLAUDE.md` that makes AI understand before it acts.** Every input gets refined and shown to you before execution — catching misinterpretations before they cost you.

English | [简体中文](./zh-CN/README.md)

## The Problem

You say "fix that thing" — the AI confidently changes the wrong thing. You say "optimize this API" — it picks a random interpretation and runs with it. You discover the misalignment **after** it's done the wrong work.

Andrej Karpathy, after weeks of intensive LLM-assisted coding, [summarized the core frustration](https://x.com/karpathy/status/2015883857489522876):

> *"The most common category is that the models make wrong assumptions on your behalf and just run along with them without checking."*

> *"They also don't manage their confusion, they don't seek clarifications, they don't surface inconsistencies, they don't present tradeoffs, they don't push back when they should, and they are still a little too sycophantic."*

There's no checkpoint between "user speaks" and "AI acts." The LLM is eager to please — it will make assumptions rather than ask for clarification.

## The Solution

Prompt Polisher inserts a **mandatory alignment step** into every interaction. Before the AI touches any code, file, or action, it must:

1. Analyze what you actually meant
2. Show you what it understood
3. Wait for your go-ahead (only when genuinely ambiguous)

You see the refined prompt **before** execution starts — not after the damage is done.

| Without Prompt Polisher | With Prompt Polisher |
|---|---|
| AI silently misinterprets vague inputs | Misinterpretations are caught and shown **before** execution |
| "fix npe in OrderSvc" → rewrites random code | → "Fix the NullPointerException in OrderService.calculateTotal()" |
| "optimize this API" → picks a random meaning | → Asks you which API and what "optimize" means when it genuinely can't tell |
| "write a poem" → writes a generic poem | → Infers style, theme, and form from context, shows reasoning |
| Simple question gets a 10-step plan | Output weight matches input complexity automatically |

## How It Works

```
Understand → Align → Execute
```

On every input, Prompt Polisher:

1. **Corrects** typos, abbreviations, and incomplete descriptions
2. **Concretizes** vague goals into executable specs
3. **Infers** intent from context and project state
4. **Shows you the polished prompt** before executing
5. **Blocks only** when the intent is genuinely ambiguous and the choice changes the outcome

Most inputs get polished and executed without interruption — no extra tool or API call needed.

### Example

**You type:** `fix npe in OrderSvc#calcTotal`

**Prompt Polisher shows:**

```
## Polished Prompt

Fix the NullPointerException in OrderService.calculateTotal() — locate the
null-access point, add defensive null checks, and verify the fix.

### How this was derived
Corrections:
  - "npe" → "NullPointerException"
  - "OrderSvc" → "OrderService"
  - "#calcTotal" → "calculateTotal()"
Inferences:
  - NPE in a calculation method → likely an unchecked field access
    on a nullable object (e.g., item.getPrice() where item is null)
```

More examples → [EXAMPLES.md](EXAMPLES.md)

## Install

**Option A: Claude Code Plugin (recommended)**

```
/plugin marketplace add luckybilly/prompt-polisher
/plugin install prompt-polisher@prompt-polisher
```

**Option B: CLAUDE.md (per-project)**

```bash
# New project
curl -o CLAUDE.md https://raw.githubusercontent.com/luckybilly/prompt-polisher/main/CLAUDE.md

# Existing project (append)
echo "" >> CLAUDE.md && curl https://raw.githubusercontent.com/luckybilly/prompt-polisher/main/CLAUDE.md >> CLAUDE.md
```

**Option C: Cursor**

See [CURSOR.md](CURSOR.md) for setup instructions. The same framework applies via a committed [Cursor project rule](.cursor/rules/prompt-polisher.mdc).

## How to Know It's Working

- **Visible corrections** — You see what the AI fixed in your input (typos, abbreviations, naming)
- **Vague → concrete** — "fix the bug" becomes a specific, actionable instruction
- **Appropriate weight** — Simple questions get brief output, complex ones get thorough analysis
- **No silent execution** — You always see the polished prompt before the AI acts
- **Smart blocking** — The AI asks before acting only when the interpretation genuinely matters

## Complementary to andrej-karpathy-skills

> **[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)** sharpens *execution quality*. **Prompt Polisher** sharpens *communication quality*. Use both for best results.

```
User input (vague / natural language)
        │
        ▼
┌─────────────────────────────┐
│   Prompt Polisher           │  ← Communication quality:
│   Understand → Align        │     get "what to do" right
│   → Show Polished Prompt    │     User intervenes HERE
└─────────┬───────────────────┘
          │ Refined instruction
          ▼
┌─────────────────────────────┐
│   andrej-karpathy-skills    │  ← Execution quality:
│   Declarative / Test-first  │     get "how to do it" right
│   / Loop until criteria met │     User validates the result
└─────────────────────────────┘
```

**The key difference:** With andrej-karpathy-skills alone, the user's control point is at the **end** — you watch the result and judge if it's right. With Prompt Polisher, the control point moves to the **front** — you confirm the intent before any work begins. Together, they form a complete pipeline: intent aligned upfront, execution disciplined throughout.

## Design Analysis: Karpathy's Observations → Prompt Polisher's Design

Karpathy's [observations on LLM coding behavior](https://x.com/karpathy/status/2015883857489522876) describe specific failure modes. Each one maps to a deliberate design choice in Prompt Polisher:

| Karpathy's Observation | Prompt Polisher's Response |
|---|---|
| Models make wrong assumptions without checking | **Understand pipeline** — 5 dimensions of analysis before any action |
| They don't seek clarifications | **Ambiguity Detection** — blocks for confirmation when intent genuinely forks |
| They don't surface inconsistencies | **"How this was derived"** — shows the reasoning transparently |
| They are too sycophantic | **Mandatory Align step** — forces the model to show its understanding, not just agree |
| Need for a lightweight inline plan mode | **Understand → Align → Execute** — an inline plan mode on every input |

## License

MIT
