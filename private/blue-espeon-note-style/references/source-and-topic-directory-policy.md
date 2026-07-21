# Source-Oriented And Topic-Oriented Directory Policy

Use this policy whenever deciding whether a durable note should remain under a book, course, lab, or project source tree, or move into a reusable subject tree.

## Directory Roles

### Source-oriented directories

Source-oriented directories preserve the context in which knowledge was acquired.

Typical examples:

- book reading notes;
- course lecture notes;
- course or book labs;
- source-code reading records tied to one repository;
- project-specific study records.

Examples include `CSAPP-books` and `CSAPP-Lab`.

A source note stays in its source-oriented directory even when part of its content overlaps a reusable topic. Do not move it merely because a topic directory also exists.

### Topic-oriented directories

Topic-oriented directories hold reusable knowledge that remains useful independently of one book, course, lab, or repository.

A topic note must:

- have one stable central thesis;
- be understandable without reopening the original source;
- use the best existing subject directory;
- link back to the source notes that motivated or support it.

## Creation Threshold

1. Prefer an existing topic directory.
2. Do not create an empty topic tree in advance.
3. Do not create a new directory for only one tentative note.
4. Within a confirmed subject root, keep a lone reusable note at the nearest suitable existing level until the same stable topic contains roughly two or three independent notes.
5. Create a topic directory only after the topic has become a durable cluster rather than a temporary question.
6. Do not create a new directory merely to avoid making a placement decision.

The two-to-three-note threshold is a default judgment rule, not a mechanical quota. A clearly established long-term subject may justify a directory earlier, while several tightly source-bound notes may still belong in their source tree.

## No Duplication

Do not copy the same note into both directory systems.

Use this relationship instead:

```text
source note
    ↕ wikilink
reusable topic note
```

The source note preserves reading context. The topic note preserves reusable understanding. Add links near the relevant source section and include source backlinks in the topic note.

## Subject README Responsibility

The global Skill defines the decision rule. Each subject root `readme.md` records the directories that actually exist or are intentionally reserved for near-term creation.

When adding, renaming, or removing a top-level source or topic directory, update the subject `readme.md` in the same change when practical.

Do not make the global Skill carry a complete, permanently synchronized map of every vault directory.

## Computer Architecture Example

For `Atlas/100-Computer Science/120-Architecture`:

### Source-oriented directories

- `CSAPP-books`: CSAPP chapter reading notes;
- `CSAPP-Lab`: CSAPP experiment archives.

### Reusable topic directory candidates

Create these only when actual notes justify them:

- `ISA-指令集与汇编`;
- `CPU-处理器微架构`;
- `Memory-存储系统`;
- `Binary-二进制与程序执行`;
- `Performance-性能工程`.

### Architecture boundaries

- `ISA-指令集与汇编`: registers, instructions, addressing, instruction encoding, ISA-level calling conventions, CSR, privilege mechanisms, and architecture-specific assembly.
- `CPU-处理器微架构`: pipelines, hazards, branch prediction, superscalar execution, out-of-order execution, and instruction-level parallelism.
- `Memory-存储系统`: cache organization, locality, prefetching, TLB hardware behavior, cache coherence, memory hierarchy, and NUMA.
- `Binary-二进制与程序执行`: ABI, ELF, object files, symbol tables, static and dynamic linking, loading, relocation, disassembly, and binary debugging.
- `Performance-性能工程`: benchmarks, CPI and IPC analysis, profiling, flame graphs, cache-miss analysis, and assembly-level performance investigation.

When a note crosses architecture and operating-system boundaries, classify it by its durable center:

- how an instruction set or hardware mechanism works → Architecture;
- how an operating system uses that mechanism to implement processes, traps, scheduling, or memory management → Operating System.
