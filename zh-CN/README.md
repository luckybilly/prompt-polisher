# Prompt Polisher

[![CI](https://github.com/luckybilly/prompt-polisher/actions/workflows/ci.yml/badge.svg)](https://github.com/luckybilly/prompt-polisher/actions/workflows/ci.yml)

**Prompt Polisher**（提示词润色器）是一款轻量级 AI 意图对齐工具，自动把你的提示词润色到专家水准——解决 AI 误解需求、盲目执行、过度讨好的问题。无需配置，让每次 AI 交互先确认意图、再执行操作，从源头避免做错、改偏、理解偏差。

[English](../README.md) | 简体中文

## 问题：原生 AI 交互的固有缺陷

日常使用 AI 时，我们经常遇到这类问题：

- **擅自假设** — 面对模糊指令，AI 主动脑补需求，无验证直接执行
- **不会澄清** — 遇到歧义场景不主动提问，默认选一种方案就落地
- **隐藏逻辑** — 推理过程不透明，用户无法知晓 AI 的理解思路
- **过度讨好** — 一味迎合用户输入，不识别不合理需求、不纠正表述问题
- **轻重失衡** — 简单问题冗余输出，复杂问题浅层敷衍

**"用户说话"和"AI 动手"之间，没有人做对齐。**

Andrej Karpathy（前 Tesla AI 负责人）在大量使用 LLM 辅助编程后，[总结了核心痛点](https://x.com/karpathy/status/2015883857489522876)：

> *"The most common category is that the models make wrong assumptions on your behalf and just run along with them without checking."*
>
> （最常见的问题是，模型替你做假设，然后不加验证就一路跑下去。）
>
> *"They also don't manage their confusion, they don't seek clarifications, they don't surface inconsistencies, they don't present tradeoffs, they don't push back when they should, and they are still a little too sycophantic."*
>
> （它们不处理自己的困惑，不寻求澄清，不暴露矛盾，不呈现权衡，不在该反对时反对——而且仍然太谄媚。）

简言之：**用户表达模糊 ≠ 需求可以被随意解读。** 原生 LLM 缺少一道关键的意图对齐工序。

## 解决方案：Prompt Polisher 核心能力

Prompt Polisher 在每次交互中插入一个强制对齐流程。在 AI 碰任何代码、文件或操作之前，它必须完成以下步骤：

- **纠错标准化** — 自动修正错别字、口语化缩写、不规范命名、残缺描述
- **指令具体化** — 将模糊、宽泛的需求，转化为精准、可执行的指令
- **意图深度推断** — 结合上下文与项目状态，还原用户真实需求
- **推理透明化** — 执行前展示完整推导过程，让每一处修改和推断都有据可依
- **智能确认** — 仅在需求有歧义、可能导致不同结果时暂停确认；无歧义场景自动执行，不影响效率

你在执行**开始前**就能看到润色后的提示词——而不是在损害已经造成之后。

### 效果对比

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

全程无需额外 API、无需独立服务，轻量化嵌入每一次交互：

1. **理解解析** — 拆解用户输入，识别残缺信息、错别字、歧义点、口语化表述
2. **优化润色** — 标准化术语、补全需求信息、明确执行目标
3. **意图对齐** — 展示润色后的正式指令 + 完整推导过程
4. **智能确认** — 高歧义场景暂停等待用户确认，无歧义场景直接执行

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

## 与 andrej-karpathy-skills 互补

两款工具前后配合，覆盖 AI 协作全流程：

- **Prompt Polisher（前置）** — 打磨**沟通质量**，解决「做什么」的问题，确保意图无偏差
- **[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)（后置）** — 打磨**执行质量**，解决「怎么做」的问题，确保落地高标准

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

**核心区别：** 单用 andrej-karpathy-skills，用户的控制点在**末端**——看结果对不对。加上 Prompt Polisher，控制点前移到**前端**——动手前先确认意图。

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

安装完成后，输入测试指令验证：

> **测试指令：** 修一下代码里的空指针 bug

**生效标准：** AI 不会直接修改代码，而是先输出**润色后的指令** + **推导过程**。

日常使用中，你会看到：

- **可见的纠正** — 你能看到 AI 修正了什么（错别字、缩写、命名）
- **泛 → 具体** — "修一下那个 bug" 变成了一条具体、可执行的指令
- **轻重得当** — 简单问题简短输出，复杂问题深入分析
- **没有静默执行** — 你总是在 AI 动手前看到润色后的提示词
- **智能确认** — 只在解读真正影响结果时才停下来问你

## 不适用场景

- 极简无歧义指令（"今天星期几"、简单计算）
- 纯闲聊、无精度要求的场景

这些场景下 Prompt Polisher 几乎不产生额外输出，但也不会干扰你。

## FAQ

**安装后没有润色效果？**
检查插件是否启用（`/plugin list`）或 CLAUDE.md 是否在项目根目录。重启 Claude Code / Cursor 后再试。

**会不会拖慢效率？**
不会。只有模糊、歧义、高风险需求才会暂停确认；明确简单的指令润色后直接执行，无多余交互。

**支持其他 AI 工具吗？**
目前原生适配 Claude Code 和 Cursor。CLAUDE.md 的规则本质上是给 LLM 的指令，理论上任何支持系统提示词的工具都可以使用。

## 许可证

MIT
