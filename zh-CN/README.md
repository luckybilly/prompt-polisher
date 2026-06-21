# Prompt Polisher

[![CI](https://github.com/luckybilly/prompt-polisher/actions/workflows/ci.yml/badge.svg)](https://github.com/luckybilly/prompt-polisher/actions/workflows/ci.yml)

**一个让 AI 先理解再动手的 `CLAUDE.md`。** 每次输入都会先被润色并展示给你确认，让误解在第一时间被发现——而不是在 AI 做错之后。

[English](../README.md) | 简体中文

## 问题

你说"修一下那个东西"——AI 自信地改错了地方。你说"优化这个 API"——它随便挑个理解就动手。你只有在它做完之后才发现理解有偏差。

Andrej Karpathy 在大量使用 LLM 辅助编程后，[总结了核心痛点](https://x.com/karpathy/status/2015883857489522876)：

> *"The most common category is that the models make wrong assumptions on your behalf and just run along with them without checking."*
>
> （最常见的问题是，模型替你做假设，然后不加验证就一路跑下去。）
>
> *"They also don't manage their confusion, they don't seek clarifications, they don't surface inconsistencies, they don't present tradeoffs, they don't push back when they should, and they are still a little too sycophantic."*
>
> （它们不处理自己的困惑，不寻求澄清，不暴露矛盾，不呈现权衡，不在该反对时反对——而且仍然太谄媚。）

**"用户说话"和"AI 动手"之间，没有人做对齐。** LLM 太急于讨好——它宁可自己假设，也不会开口问你。

## 解决方案

Prompt Polisher 在每次交互中插入一个**强制对齐步骤**。在 AI 碰任何代码、文件或操作之前，它必须：

1. 分析你真正想表达的意思
2. 展示它的理解
3. 仅在真正拿不准时等你确认

你在执行**开始前**就能看到润色后的提示词——而不是在损害已经造成之后。

| 没有 Prompt Polisher | 有 Prompt Polisher |
|---|---|
| AI 默默误解模糊输入 | 误解在执行前就被**捕获并展示** |
| "修一下 OrderSvc 的空指针" → 乱改一通 | → "修复 OrderService.calculateTotal() 中的 NullPointerException" |
| "优化这个 API" → 随便挑个理解就动手 | → 在真拿不准时主动问你哪个 API、什么算"优化" |
| "写一首诗" → 来一首通用诗 | → 从上下文推断风格、主题、体裁，展示推导过程 |
| 简单问题收到 10 步计划 | 输出轻重自动匹配输入复杂度 |

## 工作原理

```text
理解 → 对齐 → 执行
```

每次收到输入，Prompt Polisher：

1. **纠正** 错别字、缩写、不完整的描述
2. **具体化** 把泛泛的目标变成可执行指令
3. **推断** 从上下文和项目状态还原完整意图
4. **展示润色后的提示词** 在动手之前给你看
5. **仅在必要时阻塞** 意图真正拿不准、且选择会改变结果时才停下来确认

绝大多数输入润色后直接执行，不会打断你——无需额外工具或 API 调用。

### 示例

**你输入：** `OrderSvc 里 calcTotal 有个 npe 修一下`

**Prompt Polisher 展示：**

```markdown
## 润色后的提示词

修复 OrderService.calculateTotal() 中的 NullPointerException —— 定位
空指针访问点，添加防御性空值检查，验证修复。

### 推导过程
纠正：
  - "npe" → "NullPointerException"
  - "OrderSvc" → "OrderService"
  - "calcTotal" → "calculateTotal()"
推断：
  - 计算方法中的 NullPointerException → 大概率是对可空对象的
    未检查字段访问（如 item.getPrice()，而 item 为 null）
```

更多示例 → [EXAMPLES.md](./EXAMPLES.md)

## 安装

### 方式 A：Claude Code 插件（推荐）

```text
/plugin marketplace add luckybilly/prompt-polisher
/plugin install prompt-polisher@prompt-polisher
```

### 方式 B：按项目安装 CLAUDE.md

```bash
# 新项目
curl -o CLAUDE.md https://raw.githubusercontent.com/luckybilly/prompt-polisher/main/zh-CN/CLAUDE.md

# 已有项目（追加）
echo "" >> CLAUDE.md && curl https://raw.githubusercontent.com/luckybilly/prompt-polisher/main/zh-CN/CLAUDE.md >> CLAUDE.md
```

### 方式 C：Cursor

详见 [CURSOR.md](../CURSOR.md)。通过已提交的 [Cursor 项目规则](../.cursor/rules/prompt-polisher.mdc) 即可使用同一套框架。

## 如何知道它在起作用

- **可见的纠正** — 你能看到 AI 修正了什么（错别字、缩写、命名）
- **泛 → 具体** — "修一下那个 bug" 变成了一条具体、可执行的指令
- **轻重得当** — 简单问题简短输出，复杂问题深入分析
- **没有静默执行** — 你总是在 AI 动手前看到润色后的提示词
- **智能阻塞** — 只在解读真正影响结果时才停下来问你

## 与 andrej-karpathy-skills 互补

> **[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)** 打磨*执行质量*。**Prompt Polisher** 打磨*沟通质量*。两者搭配效果最佳。

```text
用户输入（模糊 / 自然语言）
        │
        ▼
┌─────────────────────────────┐
│   Prompt Polisher           │  ← 沟通质量：
│   理解 → 对齐               │     确保"做什么"是对的
│   → 展示润色后的提示词      │     用户在这里介入
└─────────┬───────────────────┘
          │ 精确的指令
          ▼
┌─────────────────────────────┐
│   andrej-karpathy-skills    │  ← 执行质量：
│   声明式 / 测试先行         │     确保"怎么做"是对的
│   / 循环直到满足标准        │     用户验证结果
└─────────────────────────────┘
```

**核心区别：** 单用 andrej-karpathy-skills，用户的控制点在**末端**——看结果对不对。加上 Prompt Polisher，控制点前移到**前端**——动手前先确认意图。两者叠加 = 前端对齐意图 + 后端保证执行，形成完整管线。

## 设计分析：Karpathy 的观察 → Prompt Polisher 的设计

Karpathy [对 LLM 编程行为的观察](https://x.com/karpathy/status/2015883857489522876)描述了具体的失败模式，每一条都对应 Prompt Polisher 的一个刻意设计：

| Karpathy 的观察 | Prompt Polisher 的应对 |
|---|---|
| 模型替你做假设，不加验证就执行 | **Understand 管线** — 在行动前进行 5 个维度的分析 |
| 模型不寻求澄清 | **Ambiguity Detection** — 意图真正分叉时阻塞确认 |
| 模型不暴露矛盾 | **"推导过程"** — 透明展示推理逻辑 |
| 模型太谄媚 | **强制 Align 步骤** — 要求模型展示理解，而非一味迎合 |
| 需要轻量级内联计划模式 | **理解 → 对齐 → 执行** — 每次输入都执行的内联计划模式 |

## 许可证

MIT
